Shader "Hidden/Shader/Beautify"
{
    HLSLINCLUDE

    #pragma target 4.5
    #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch

    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
    #include "Packages/com.unity.render-pipelines.high-definition/Runtime/PostProcessing/Shaders/FXAA.hlsl"
    #include "Packages/com.unity.render-pipelines.high-definition/Runtime/PostProcessing/Shaders/RTUpscale.hlsl"

    struct Attributes
    {
        uint vertexID : SV_VertexID;
        UNITY_VERTEX_INPUT_INSTANCE_ID
    };

    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float2 texcoord   : TEXCOORD0;
        UNITY_VERTEX_OUTPUT_STEREO
    };

    Varyings Vert(Attributes input)
    {
        Varyings output;
        UNITY_SETUP_INSTANCE_ID(input);
        UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);
        output.positionCS = GetFullScreenTriangleVertexPosition(input.vertexID);
        output.texcoord = GetFullScreenTriangleTexCoord(input.vertexID);
        return output;
    }

    float4 _Sharpen;   // x = intensity, y = depth threshold, z = clamp, w = luma relaxation
	float4 _ColorBoost; // x = Brightness, y = Contrast, z = Saturate, w = Daltonize;
    float4 _DepthParams; // x = min/max threshold

    TEXTURE2D_X(_InputTexture);

	inline float getLuma(float3 rgb) {
		const float3 lum = float3(0.299, 0.587, 0.114);
		return dot(rgb, lum);
	}

    float4 FragBeautify(Varyings input) : SV_Target
    {
        UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

        uint2 positionSS = input.texcoord * _ScreenSize.xy;

		float  depthS     = Linear01Depth(LoadCameraDepth(positionSS - uint2(0, 1)), _ZBufferParams);
		float  depthW     = Linear01Depth(LoadCameraDepth(positionSS - uint2(1, 0)), _ZBufferParams);
		float  depthE     = Linear01Depth(LoadCameraDepth(positionSS + uint2(1, 0)), _ZBufferParams);
		float  depthN     = Linear01Depth(LoadCameraDepth(positionSS + uint2(0, 1)), _ZBufferParams);

		float  maxDepth   = max(depthN, depthS);
		       maxDepth   = max(maxDepth, depthW);
		       maxDepth   = max(maxDepth, depthE);
		float  minDepth   = min(depthN, depthS);
		       minDepth   = min(minDepth, depthW);
		       minDepth   = min(minDepth, depthE);
		float  dDepth     = maxDepth - minDepth + 0.00001;
		
		float  lumaDepth  = saturate(_Sharpen.y / dDepth);

        float3 rgbM       = LOAD_TEXTURE2D_X(_InputTexture, positionSS).xyz;

        const float3 magic = float3(0.06711056, 0.00583715, 52.9829189);
        float dither       = frac(magic.z * frac(dot(positionSS, magic.xy))) - 0.5;
               rgbM       += dither * _DepthParams.w;
               rgbM        = max(0.0.xxx, rgbM);

        float3 rgbS       = LOAD_TEXTURE2D_X(_InputTexture, positionSS - uint2(0, 1)).rgb;
	    float3 rgbW       = LOAD_TEXTURE2D_X(_InputTexture, positionSS - uint2(1, 0)).rgb;
	    float3 rgbE       = LOAD_TEXTURE2D_X(_InputTexture, positionSS + uint2(1, 0)).rgb;
	    float3 rgbN       = LOAD_TEXTURE2D_X(_InputTexture, positionSS + uint2(0, 1)).rgb;
	    
        float  lumaM      = getLuma(rgbM);

		float3 rgb0       = 1.0.xxx - saturate(rgbM);
		       rgbM.r    *= 1.0 + rgbM.r * rgb0.g * rgb0.b * _ColorBoost.w;
			   rgbM.g    *= 1.0 + rgbM.g * rgb0.r * rgb0.b * _ColorBoost.w;
			   rgbM.b    *= 1.0 + rgbM.b * rgb0.r * rgb0.g * _ColorBoost.w;	
			   rgbM      *= lumaM / (getLuma(rgbM) + 0.0001);

    	float  lumaN      = getLuma(rgbN);
    	float  lumaE      = getLuma(rgbE);
    	float  lumaW      = getLuma(rgbW);
    	float  lumaS      = getLuma(rgbS);

    	float  maxLuma    = max(lumaN,lumaS);
    	       maxLuma    = max(maxLuma, lumaW);
    	       maxLuma    = max(maxLuma, lumaE);
	    float  minLuma    = min(lumaN,lumaS);
	           minLuma    = min(minLuma, lumaW);
	           minLuma    = min(minLuma, lumaE) - 0.000001;
	    float  lumaPower  = 2.0 * lumaM - minLuma - maxLuma;
		float  lumaAtten  = saturate(_Sharpen.w / (maxLuma - minLuma));

        float  depthDist  = _DepthParams.z / abs(depthW - _DepthParams.y);
		float  depthClamp = depthDist > 1.0;
			   depthClamp = max(depthClamp, saturate(_DepthParams.x * depthDist));

		       rgbM      *= 1.0 + clamp(lumaPower * lumaAtten * lumaDepth * _Sharpen.x, -_Sharpen.z, _Sharpen.z) * depthClamp;

		float maxComponent = max(rgbM.r, max(rgbM.g, rgbM.b));
		float minComponent = min(rgbM.r, min(rgbM.g, rgbM.b));
		float sat          = saturate(maxComponent - minComponent);
		      rgbM        *= 1.0 + _ColorBoost.z * (1.0 - sat) * (rgbM - getLuma(rgbM));
		      rgbM         = (rgbM - 0.5.xxx) * _ColorBoost.y + 0.5.xxx;
	          rgbM        *= _ColorBoost.x;

        return float4(rgbM, 1);
    }

    ENDHLSL

    SubShader
    {
        Pass
        {
            Name "Beautify"

            ZWrite Off
            ZTest Always
            Blend Off
            Cull Off

            HLSLPROGRAM
                #pragma fragment FragBeautify
                #pragma vertex Vert
            ENDHLSL
        }
    }
    Fallback Off
}
