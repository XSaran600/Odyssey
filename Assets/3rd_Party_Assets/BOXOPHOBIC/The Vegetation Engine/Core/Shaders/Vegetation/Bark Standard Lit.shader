// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BOXOPHOBIC/The Vegetation Engine/Vegetation/Bark Standard Lit"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[StyledBanner(Bark Standard Lit)]_Banner("Banner", Float) = 0
		[StyledCategory(Render Settings)]_RenderingCat("[ Rendering Cat ]", Float) = 0
		[Enum(Opaque,0,Transparent,1)]_render_mode("Render Mode", Float) = 0
		[Enum(Both,0,Back,1,Front,2)]_render_cull("Render Faces", Float) = 0
		[Enum(Flip,0,Mirror,1,None,2)]_render_normals("Render Normals", Float) = 0
		[StyledInteractive(_render_mode, 1)]_RenderMode_TransparentInteractive("# RenderMode_TransparentInteractive", Float) = 0
		[Enum(Alpha,0,Premultiply,1)]_render_blend("Render Blending", Float) = 0
		[Enum(Off,0,On,1)]_render_zw("Render ZWrite", Float) = 1
		[StyledInteractive(ON)]_RenderMode_ResetInteractive("# RenderMode_ResetInteractive", Float) = 0
		[Toggle][Space(10)]_render_clip("Alpha Clipping", Float) = 0
		[StyledInteractive(_render_clip, 1)]_AlphaClipInteractive("# AlphaClipInteractive", Float) = 0
		_Cutoff("Alpha Treshold", Range( 0 , 1)) = 0.5
		[StyledCategory(Global Settings)]_GlobalSettingsCat("[ Global Settings Cat ]", Float) = 0
		_GlobalOverlay("Global Overlay", Range( 0 , 1)) = 1
		_GlobalWetness("Global Wetness", Range( 0 , 1)) = 1
		_GlobalSize("Global Size", Range( 0 , 1)) = 1
		_GlobalSizeFade("Global Size Fade", Range( 0 , 1)) = 0
		[StyledCategory(Material Shading)]_MaterialShadingCat("[ Material Shading Cat ]", Float) = 0
		[HideInInspector][ASEDiffusionProfile(_SubsurfaceDiffusion)]_SubsurfaceDiffusion_asset("Subsurface Diffusion", Vector) = (0,0,0,0)
		_ObjectOcclusionValue("Object Occlusion", Range( 0 , 8)) = 0
		[Space(10)]_OverlayContrast("Overlay Contrast", Range( 0 , 10)) = 1
		_OverlayUVTilling("Overlay Tilling", Range( 0 , 10)) = 1
		[StyledCategory(Main Shading)]_MainShadingCat("[ Main Shading Cat ]", Float) = 0
		_MainColor("Main Color", Color) = (1,1,1,1)
		[NoScaleOffset]_MainAlbedoTex("Main Albedo", 2D) = "white" {}
		[NoScaleOffset]_MainNormalTex("Main Normal", 2D) = "gray" {}
		[NoScaleOffset]_MainMaskTex("Main Mask", 2D) = "white" {}
		[Space(10)]_MainUVs("Main UVs", Vector) = (1,1,0,0)
		_MainNormalValue("Main Normal", Range( -8 , 8)) = 1
		_MainOcclusionValue("Main Occlusion (G)", Range( 0 , 1)) = 1
		_MainSmoothnessValue("Main Smoothness (A)", Range( 0 , 1)) = 1
		[StyledCategory(Detail Shading)]_DetailShadingCat("[ Detail Shading Cat ]", Float) = 0
		[Enum(Off,0,Overlay,1,Height,2)]_DetailMode("Detail Mode", Float) = 0
		[Enum(Main Mask,0,Detail Mask,1)]_MaskMode("Detail Mask", Float) = 0
		[Space(10)]_SecondColor("Detail Color", Color) = (1,1,1,1)
		[NoScaleOffset]_SecondAlbedoTex("Detail Albedo", 2D) = "white" {}
		[NoScaleOffset]_SecondNormalTex("Detail Normal", 2D) = "gray" {}
		[NoScaleOffset]_SecondMaskTex("Detail Mask", 2D) = "white" {}
		[Space(10)]_SecondUVs("Detail UVs", Vector) = (1,1,0,0)
		_SecondNormalValue("Detail Normal", Range( -8 , 8)) = 1
		_SecondOcclusionValue("Detail Occlusion (G)", Range( 0 , 1)) = 1
		_SecondSmoothnessValue("Detail Smoothness (A)", Range( 0 , 1)) = 1
		[Space(10)]_DetailMeshValue("Detail Mask Offset", Range( -1 , 1)) = 0
		_DetailMaskValue("Detail Mask Power", Range( -1 , 1)) = 0
		_DetailMaskContrast("Detail Mask Contrast", Range( 0 , 1)) = 0.25
		[StyledCategory(Motion Settings)]_MotionCat("[ Motion Cat ]", Float) = 0
		_Motion_10("Motion Bending", Range( 0 , 1)) = 1
		_Motion_20("Motion Rolling", Range( 0 , 1)) = 1
		[HideInInspector][Space(10)]_MotionAmplitude_10("Primary Bending", Float) = 0
		[HideInInspector][IntRange]_MotionSpeed_10("Primary Speed", Float) = 2
		[HideInInspector]_MotionScale_10("Primary Elasticity", Float) = 0
		[HideInInspector]_MotionVariation_10("Primary Variation", Float) = 0
		[HideInInspector][Space(10)]_MotionAmplitude_20("Secundary Rolling", Float) = 0
		[HideInInspector]_MotionVertical_20("Secundary Vertical", Float) = 0
		[HideInInspector][IntRange]_MotionSpeed_20("Secundary Speed", Float) = 5
		[HideInInspector]_MotionScale_20("Secundary Elasticity", Float) = 0
		[HideInInspector]_MotionVariation_20("Secundary Variation", Range( 0 , 5)) = 0
		[HideInInspector][Space(10)]_MotionAmplitude_30("Leaves Amplitude", Float) = 0
		[HideInInspector][Space(10)]_MotionAmplitude_32("Flutter Amplitude", Float) = 0
		[HideInInspector][IntRange]_MotionSpeed_30("Leaves Speed", Float) = 15
		[HideInInspector][IntRange]_MotionSpeed_32("Flutter Speed", Float) = 30
		[HideInInspector]_MotionScale_32("Flutter Elasticity", Float) = 30
		[HideInInspector]_MotionScale_30("Leaves Scale", Float) = 30
		[HideInInspector]_MotionVariation_32("Flutter Variation", Float) = 30
		[HideInInspector]_MotionVariation_30("Leaves Variation", Float) = 30
		[HideInInspector]_InteractionAmplitude("Interaction Bending", Float) = 0
		[StyledCategory(Advanced)]_AdvancedCat("[ Advanced Cat]", Float) = 0
		[IntRange]_render_priority("Priority", Range( -50 , 50)) = 0
		[HideInInspector]_render_src("render_src", Float) = 1
		[HideInInspector]_render_dst("render_dst", Float) = 0
		[HideInInspector]_IsTVEShader("_IsTVEShader", Float) = 1
		[HideInInspector]_Color("_Color", Color) = (0,0,0,0)
		[HideInInspector]_MainTex("_MainTex", 2D) = "white" {}
		[HideInInspector][Enum(Both,0,Back,1,Front,2)]__cull("__cull", Float) = 0
		[HideInInspector][Enum(Opaque,0,Transparent,1)]__surface("__surface", Float) = 0
		[HideInInspector][Enum(Off,0,On,1)]__zw("__zw", Float) = 1
		[HideInInspector][Enum(Flip,0,Mirror,1,None,2)]__normals("__normals", Float) = 0
		[HideInInspector][Enum(Alpha,0,Premultiply,1)]__blend("__blend", Float) = 0
		[HideInInspector][Toggle][Space(10)]__clip("__clip", Float) = 0
		[HideInInspector][IntRange]__priority("__priority", Float) = 0
		[HideInInspector]__src("__src", Float) = 1
		[HideInInspector]__dst("__dst", Float) = 0
		[HideInInspector]__premul("__premul", Float) = 0
		[HideInInspector]_VertexOcclusion("_VertexOcclusion", Float) = 0
		[HideInInspector]_MainMaskValue("_MainMaskValue", Float) = 0
		[HideInInspector][Enum(Translucency,0,Thickness,1)]_SubsurfaceMode("_SubsurfaceMode", Float) = 0
		[HideInInspector]_ObjectThicknessValue("_ObjectThicknessValue", Float) = 0
		[HideInInspector][Enum(Constant,0,Variation,1)]_MainColorMode("_MainColorMode", Float) = 1
		[HideInInspector]_MaxBoundsInfo("_MaxBoundsInfo", Vector) = (1,1,1,1)
		[HideInInspector]_render_normals_options("_render_normals_options", Vector) = (1,1,1,0)
		[HideInInspector]_Cutoff("_Cutoff", Float) = 0
		[HideInInspector]_IsVersion("_IsVersion", Float) = 141
		[HideInInspector]_IsHDPipeline("_IsHDPipeline", Float) = 1
		[StyledMessage(Warning, When batching is enabled the object position data is lost and some features will not work properly. Use this feature for small plants or grass only. Check the documentation for more information., _material_batching, 1 , 10,0)]_BatchingMessage("Batching Message", Float) = 0
		[Toggle][Space(10)]_material_batching("Enable Batching Support", Float) = 0
		[HideInInspector]_IsBarkShader("_IsBarkShader", Float) = 1
		[HideInInspector]_IsAnyPathShader("_IsAnyPathShader", Float) = 1
		[HideInInspector]_IsLitShader("_IsLitShader", Float) = 1
		[HideInInspector]_IsStandardShader("_IsStandardShader", Float) = 1
		[HideInInspector]_Cutoff("_Cutoff", Float) = 0.5
		[HideInInspector][Enum(Both,0,Back,1,Front,2)]_render_cull("_render_cull", Float) = 0
		[HideInInspector]_render_src("_render_src", Float) = 1
		[HideInInspector]_render_dst("_render_dst", Float) = 0
		[HideInInspector]_render_zw("_render_zw", Float) = 1

		[HideInInspector] _RenderQueueType("Render Queue Type", Float) = 1
		//[HideInInspector] [ToggleUI] _AddPrecomputedVelocity("Add Precomputed Velocity", Float) = 1
		[HideInInspector] _StencilRef("Stencil Ref", Int) = 0
		[HideInInspector] _StencilWriteMask("Stencil Write Mask", Int) = 6
		[HideInInspector] _StencilRefDepth("Stencil Ref Depth", Int) = 8
		[HideInInspector] _StencilWriteMaskDepth("Stencil Write Mask Depth", Int) = 8
		[HideInInspector] _StencilRefMV("Stencil Ref MV", Int) = 40
		[HideInInspector] _StencilWriteMaskMV("Stencil Write Mask MV", Int) = 40
		[HideInInspector] _StencilRefDistortionVec("Stencil Ref Distortion Vec", Int) = 4
		[HideInInspector] _StencilWriteMaskDistortionVec("Stencil Write Mask Distortion Vec", Int) = 4
		[HideInInspector] _StencilWriteMaskGBuffer("Stencil Write Mask GBuffer", Int) = 14
		[HideInInspector] _StencilRefGBuffer("Stencil Ref GBuffer", Int) = 10
		[HideInInspector] _ZTestGBuffer("ZTest GBuffer", Int) = 4
		[HideInInspector] [ToggleUI] _RequireSplitLighting("Require Split Lighting", Float) = 0
		[HideInInspector] [ToggleUI] _ReceivesSSR("Receives SSR", Float) = 0
		[HideInInspector] _SurfaceType("Surface Type", Float) = 0
		[HideInInspector] _BlendMode("Blend Mode", Float) = 0
		[HideInInspector] _SrcBlend("Src Blend", Float) = 1
		[HideInInspector] _DstBlend("Dst Blend", Float) = 0
		[HideInInspector] _AlphaSrcBlend("Alpha Src Blend", Float) = 1
		[HideInInspector] _AlphaDstBlend("Alpha Dst Blend", Float) = 0
		[HideInInspector] [ToggleUI] _ZWrite("ZWrite", Float) = 1
		[HideInInspector] [ToggleUI] _TransparentZWrite("Transparent ZWrite", Float) = 1
		[HideInInspector] _CullMode("Cull Mode", Float) = 2
		[HideInInspector] _TransparentSortPriority("Transparent Sort Priority", Int) = 0
		[HideInInspector] [ToggleUI] _EnableFogOnTransparent("Enable Fog On Transparent", Float) = 1
		[HideInInspector] _CullModeForward("Cull Mode Forward", Float) = 2
		[HideInInspector] [Enum(Front, 1, Back, 2)] _TransparentCullMode("Transparent Cull Mode", Float) = 2
		[HideInInspector] _ZTestDepthEqualForOpaque("ZTest Depth Equal For Opaque", Int) = 4
		[HideInInspector] [Enum(UnityEngine.Rendering.CompareFunction)] _ZTestTransparent("ZTest Transparent", Float) = 4
		[HideInInspector] [ToggleUI] _TransparentBackfaceEnable("Transparent Backface Enable", Float) = 0
		[HideInInspector] [ToggleUI] _AlphaCutoffEnable("Alpha Cutoff Enable", Float) = 1
		[HideInInspector] [ToggleUI] _UseShadowThreshold("Use Shadow Threshold", Float) = 0
		[HideInInspector] [ToggleUI] _DoubleSidedEnable("Double Sided Enable", Float) = 1
		[HideInInspector] [Enum(Flip, 0, Mirror, 1, None, 2)] _DoubleSidedNormalMode("Double Sided Normal Mode", Float) = 2
		[HideInInspector] _DoubleSidedConstants("DoubleSidedConstants", Vector) = (1,1,-1,0)
		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="HDRenderPipeline" "RenderType"="Opaque" "Queue"="Geometry" }

		HLSLINCLUDE
		#pragma target 4.5
		#pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
		#pragma multi_compile_instancing
		#pragma instancing_options renderinglayer

		struct GlobalSurfaceDescription // GBuffer Forward META TransparentBackface
		{
			float3 Albedo;
			float3 Normal;
			float3 BentNormal;
			float3 Specular;
			float CoatMask;
			float Metallic;
			float3 Emission;
			float Smoothness;
			float Occlusion;
			float Alpha;
			float AlphaClipThreshold;
			float AlphaClipThresholdShadow;
			float AlphaClipThresholdDepthPrepass;
			float AlphaClipThresholdDepthPostpass;
			float SpecularAAScreenSpaceVariance;
			float SpecularAAThreshold;
			float SpecularOcclusion;
			float DepthOffset;
			//Refraction
			float RefractionIndex;
			float3 RefractionColor;
			float RefractionDistance;
			//SSS/Translucent
			float Thickness;
			float SubsurfaceMask;
			float DiffusionProfile;
			//Anisotropy
			float Anisotropy;
			float3 Tangent;
			//Iridescent
			float IridescenceMask;
			float IridescenceThickness;
			//BakedGI
			float3 BakedGI;
			float3 BakedBackGI;
		};

		struct AlphaSurfaceDescription // ShadowCaster
		{
			float Alpha;
			float AlphaClipThreshold;
			float AlphaClipThresholdShadow;
			float DepthOffset;
		};

		struct SceneSurfaceDescription // SceneSelection
		{
			float Alpha;
			float AlphaClipThreshold;
			float DepthOffset;
		};

		struct PrePassSurfaceDescription // DepthPrePass
		{
			float Alpha;
			float AlphaClipThresholdDepthPrepass;
			float DepthOffset;
		};

		struct PostPassSurfaceDescription //DepthPostPass
		{
			float Alpha;
			float AlphaClipThresholdDepthPostpass;
			float DepthOffset;
		};

		struct SmoothSurfaceDescription // MotionVectors DepthOnly
		{
			float3 Normal;
			float Smoothness;
			float Alpha;
			float AlphaClipThreshold;
			float DepthOffset;
		};

		struct DistortionSurfaceDescription //Distortion
		{
			float Alpha;
			float2 Distortion;
			float DistortionBlur;
			float AlphaClipThreshold;
		};

		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}
		
		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlaneASE (float3 pos, float4 plane)
		{
			return dot (float4(pos,1.0f), plane);
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlaneASE(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlaneASE(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlaneASE(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlaneASE(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlaneASE(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlaneASE(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlaneASE(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlaneASE(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlaneASE(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlaneASE(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlaneASE(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlaneASE(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		ENDHLSL
		
		Pass
		{
			
			Name "GBuffer"
			Tags { "LightMode"="GBuffer" }

			Cull [_CullMode]
			ZTest [_ZTestGBuffer]

			Stencil
			{
				Ref [_StencilRefGBuffer]
				WriteMask [_StencilWriteMaskGBuffer]
				Comp Always
				Pass Replace
				Fail Keep
				ZFail Keep
			}


			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define _DISABLE_DECALS 1
			#define _DISABLE_SSR 1
			#define _SPECULAR_OCCLUSION_FROM_AO 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _AMBIENT_OCCLUSION 1
			#define HAVE_MESH_MODIFICATION
			#define ASE_SRP_VERSION 70201
			#if !defined(ASE_NEED_CULLFACE)
			#define ASE_NEED_CULLFACE 1
			#endif //ASE_NEED_CULLFACE


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
			#pragma shader_feature_local _ENABLE_FOG_ON_TRANSPARENT
			#pragma shader_feature_local _ALPHATEST_ON

			#if !defined(DEBUG_DISPLAY) && defined(_ALPHATEST_ON)
			#define SHADERPASS_GBUFFER_BYPASS_ALPHA_TEST
			#endif

			#define SHADERPASS SHADERPASS_GBUFFER
			#pragma multi_compile _ DEBUG_DISPLAY
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile DECALS_OFF DECALS_3RT DECALS_4RT
			#pragma multi_compile _ LIGHT_LAYERS

			#pragma vertex Vert
			#pragma fragment Frag

			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
			#ifdef DEBUG_DISPLAY
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
			#endif
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_VFACE
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_TANGENT
			#define ASE_NEEDS_FRAG_RELATIVE_WORLD_POS
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature _ALPHATEST_ON
			#pragma shader_feature MATERIAL_USE_DETAIL_OFF MATERIAL_USE_DETAIL_OVERLAY MATERIAL_USE_DETAIL_HEIGHT
			  
			//SHADER INJECTION POINT BEGIN
			//SHADER INJECTION POINT END
			    
			#pragma shader_feature MATERIAL_USE_OBJECT_DATA MATERIAL_USE_WORLD_DATA


			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif

			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 positionCS : SV_Position;
				float3 interp00 : TEXCOORD0;
				float3 interp01 : TEXCOORD1;
				float4 interp02 : TEXCOORD2;
				float4 interp03 : TEXCOORD3;
				float4 interp04 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_color : COLOR;
				float4 ase_texcoord6 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			CBUFFER_START( UnityPerMaterial )
			half4 _MainUVs;
			float4 _Color;
			half4 _SecondColor;
			half4 _SecondUVs;
			float4 _MaxBoundsInfo;
			float4 _SubsurfaceDiffusion_asset;
			half4 _MainColor;
			half3 _render_normals_options;
			half _MotionVertical_20;
			half _MotionCat;
			half _Motion_10;
			half _InteractionAmplitude;
			float _MotionScale_10;
			half _MotionVariation_10;
			half _MotionAmplitude_10;
			float _MotionScale_20;
			half _MotionVariation_20;
			float _MotionSpeed_20;
			half _Motion_20;
			half _MotionAmplitude_20;
			half _IsStandardShader;
			half _material_batching;
			half _BatchingMessage;
			float _MotionSpeed_10;
			half _GlobalSizeFade;
			half _IsLitShader;
			half _IsHDPipeline;
			half _ObjectOcclusionValue;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half __premul;
			half _GlobalOverlay;
			half _OverlayContrast;
			half _SecondNormalValue;
			half _MainNormalValue;
			half _OverlayUVTilling;
			half _DetailShadingCat;
			half _DetailMode;
			half _DetailMaskContrast;
			half _DetailMaskValue;
			half _MaskMode;
			half _DetailMeshValue;
			half _IsVersion;
			half _GlobalSize;
			float _MotionScale_32;
			float _MotionVariation_32;
			float _MotionVariation_30;
			half __zw;
			half __blend;
			half _render_mode;
			half __clip;
			half _render_priority;
			half _render_dst;
			half _GlobalSettingsCat;
			half _render_clip;
			half _MaterialShadingCat;
			half _AdvancedCat;
			half _ObjectThicknessValue;
			half _RenderingCat;
			half _RenderMode_ResetInteractive;
			half _IsTVEShader;
			half _VertexOcclusion;
			half _IsBarkShader;
			half _IsAnyPathShader;
			half _Banner;
			half _MainMaskValue;
			half _render_blend;
			half _render_zw;
			half _Cutoff;
			half __surface;
			float _MotionSpeed_32;
			half _MotionAmplitude_30;
			float _MotionSpeed_30;
			float _MotionScale_30;
			half _MotionAmplitude_32;
			half _MainColorMode;
			half __dst;
			half _render_cull;
			half _AlphaClipInteractive;
			half _render_src;
			float _SubsurfaceMode;
			half __priority;
			half _MainShadingCat;
			half __src;
			half __normals;
			half __cull;
			half _render_normals;
			half _RenderMode_TransparentInteractive;
			half _MainOcclusionValue;
			half _SecondOcclusionValue;
			float4 _EmissionColor;
			float _RenderQueueType;
			#ifdef _ADD_PRECOMPUTED_VELOCITY
			float _AddPrecomputedVelocity;
			#endif
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _TransparentZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _EnableFogOnTransparent;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _AlphaCutoff;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _MainTex;
			half TVE_Amplitude2;
			sampler2D TVE_NoiseTex;
			half TVE_NoiseSpeed;
			half TVE_NoiseSize;
			half TVE_NoiseContrast;
			half TVE_Amplitude1;
			sampler2D TVE_MotionTex;
			half4 TVE_MotionCoord;
			half TVE_SizeFadeEnd;
			half TVE_SizeFadeStart;
			sampler2D TVE_ExtrasTex;
			half4 TVE_ExtrasCoord;
			sampler2D _MainAlbedoTex;
			sampler2D _SecondAlbedoTex;
			sampler2D _MainMaskTex;
			sampler2D _SecondMaskTex;
			half4 TVE_OverlayColor;
			sampler2D TVE_OverlayAlbedoTex;
			half TVE_OverlayUVTilling;
			sampler2D _MainNormalTex;
			sampler2D _SecondNormalTex;
			half TVE_OverlayIntensity;
			sampler2D TVE_OverlayNormalTex;
			half TVE_OverlayNormalValue;
			half TVE_OverlaySmoothness;
			float TVE_Wetness;


			float3 ObjectPosition_UNITY_MATRIX_M(  )
			{
				return float3(UNITY_MATRIX_M[0].w, UNITY_MATRIX_M[1].w, UNITY_MATRIX_M[2].w );
			}
			

			void BuildSurfaceData(FragInputs fragInputs, inout GlobalSurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);

				surfaceData.specularOcclusion = 1.0;

				// surface data
				surfaceData.baseColor =					surfaceDescription.Albedo;
				surfaceData.perceptualSmoothness =		surfaceDescription.Smoothness;
				surfaceData.ambientOcclusion =			surfaceDescription.Occlusion;
				surfaceData.metallic =					surfaceDescription.Metallic;
				surfaceData.coatMask =					surfaceDescription.CoatMask;

				#ifdef _SPECULAR_OCCLUSION_CUSTOM
				surfaceData.specularOcclusion =			surfaceDescription.SpecularOcclusion;
				#endif
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.subsurfaceMask =			surfaceDescription.SubsurfaceMask;
				#endif
				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceData.thickness =					surfaceDescription.Thickness;
				#endif
				#if defined( _MATERIAL_FEATURE_SUBSURFACE_SCATTERING ) || defined( _MATERIAL_FEATURE_TRANSMISSION )
				surfaceData.diffusionProfileHash =		asuint(surfaceDescription.DiffusionProfile);
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.specularColor =				surfaceDescription.Specular;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.anisotropy =				surfaceDescription.Anisotropy;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.iridescenceMask =			surfaceDescription.IridescenceMask;
				surfaceData.iridescenceThickness =		surfaceDescription.IridescenceThickness;
				#endif

				// refraction
				#ifdef _HAS_REFRACTION
				if( _EnableSSRefraction )
				{
					surfaceData.ior = surfaceDescription.RefractionIndex;
					surfaceData.transmittanceColor = surfaceDescription.RefractionColor;
					surfaceData.atDistance = surfaceDescription.RefractionDistance;

					surfaceData.transmittanceMask = ( 1.0 - surfaceDescription.Alpha );
					surfaceDescription.Alpha = 1.0;
				}
				else
				{
					surfaceData.ior = 1.0;
					surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
					surfaceData.atDistance = 1.0;
					surfaceData.transmittanceMask = 0.0;
					surfaceDescription.Alpha = 1.0;
				}
				#else
				surfaceData.ior = 1.0;
				surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
				surfaceData.atDistance = 1.0;
				surfaceData.transmittanceMask = 0.0;
				#endif


				// material features
				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif
				#ifdef ASE_LIT_CLEAR_COAT
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				// others
				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				// normals
				float3 normalTS = float3(0.0f, 0.0f, 1.0f);
				normalTS = surfaceDescription.Normal;
				GetNormalWS( fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants );

				surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];

				bentNormalWS = surfaceData.normalWS;
				#ifdef ASE_BENT_NORMAL
				GetNormalWS( fragInputs, surfaceDescription.BentNormal, bentNormalWS, doubleSidedConstants );
				#endif

				surfaceData.tangentWS = normalize( fragInputs.tangentToWorld[ 0 ].xyz );
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.tangentWS = TransformTangentToWorld( surfaceDescription.Tangent, fragInputs.tangentToWorld );
				#endif
				surfaceData.tangentWS = Orthonormalize( surfaceData.tangentWS, surfaceData.normalWS );

				// decals
				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#endif

				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceData.perceptualSmoothness = GeometricNormalFiltering( surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[ 2 ], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold );
				#endif

				// debug
				#if defined(DEBUG_DISPLAY)
				if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
				{
					surfaceData.metallic = 0;
				}
				ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
				#endif
			}

			void GetSurfaceAndBuiltinData(GlobalSurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				//#ifdef _ALPHATEST_ON
				//DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				//#endif

				#ifdef _DEPTHOFFSET_ON
				builtinData.depthOffset = surfaceDescription.DepthOffset;
				ApplyDepthOffsetPositionInput( V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS );

				InitBuiltinData( posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[ 2 ], fragInputs.texCoord1, fragInputs.texCoord2, builtinData );

				#ifdef _ASE_BAKEDGI
				builtinData.bakeDiffuseLighting = surfaceDescription.BakedGI;
				#endif
				#ifdef _ASE_BAKEDBACKGI
				builtinData.backBakeDiffuseLighting = surfaceDescription.BakedBackGI;
				#endif

				builtinData.emissiveColor = surfaceDescription.Emission;

				#if (SHADERPASS == SHADERPASS_DISTORTION)
				builtinData.distortion = surfaceDescription.Distortion;
				builtinData.distortionBlur = surfaceDescription.DistortionBlur;
				#else
				builtinData.distortion = float2(0.0, 0.0);
				builtinData.distortionBlur = 0.0;
				#endif

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			PackedVaryingsMeshToPS VertexFunction(AttributesMesh inputMesh )
			{
				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS;

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( outputPackedVaryingsMeshToPS );

				half3 VertexPos40_g18271 = inputMesh.positionOS;
				float3 appendResult74_g18271 = (float3(0.0 , VertexPos40_g18271.y , 0.0));
				float3 VertexPosRotationAxis50_g18271 = appendResult74_g18271;
				float3 break84_g18271 = VertexPos40_g18271;
				float3 appendResult81_g18271 = (float3(break84_g18271.x , 0.0 , break84_g18271.z));
				float3 VertexPosOtherAxis82_g18271 = appendResult81_g18271;
				float ObjectData20_g18308 = 3.14;
				float Bounds_Radius121_g18123 = _MaxBoundsInfo.x;
				float WorldData19_g18308 = Bounds_Radius121_g18123;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18308 = WorldData19_g18308;
				#else
				float staticSwitch14_g18308 = ObjectData20_g18308;
				#endif
				float Motion_Max_Rolling1137_g18123 = staticSwitch14_g18308;
				half Global_Amplitude_270_g18123 = TVE_Amplitude2;
				half Mesh_Motion_260_g18123 = inputMesh.ase_texcoord3.y;
				float temp_output_4_0_g18291 = 1.0;
				float temp_output_5_0_g18291 = ( temp_output_4_0_g18291 * _TimeParameters.x );
				float2 temp_cast_0 = (TVE_NoiseSpeed).xx;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18290 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18290 = ( localObjectPosition_UNITY_MATRIX_M14_g18290 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18290 = localObjectPosition_UNITY_MATRIX_M14_g18290;
				#endif
				half3 ObjectData20_g18292 = staticSwitch13_g18290;
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				half3 WorldData19_g18292 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18292 = WorldData19_g18292;
				#else
				float3 staticSwitch14_g18292 = ObjectData20_g18292;
				#endif
				float2 panner73_g18289 = ( temp_output_5_0_g18291 * temp_cast_0 + ( (staticSwitch14_g18292).xz * TVE_NoiseSize ));
				float4 temp_cast_1 = (TVE_NoiseContrast).xxxx;
				float4 break142_g18289 = pow( abs( tex2Dlod( TVE_NoiseTex, float4( panner73_g18289, 0, 0.0) ) ) , temp_cast_1 );
				half Global_NoiseTex_R34_g18123 = break142_g18289.r;
				half Global_NoiseTex_G38_g18123 = break142_g18289.g;
				half Motion_Use20162_g18123 = _Motion_20;
				half MotionSpeed265_g18123 = _MotionSpeed_20;
				half Input_Speed62_g18262 = MotionSpeed265_g18123;
				float temp_output_4_0_g18265 = Input_Speed62_g18262;
				float temp_output_5_0_g18265 = ( temp_output_4_0_g18265 * _TimeParameters.x );
				half MotionVariation264_g18123 = _MotionVariation_20;
				float temp_output_342_0_g18262 = ( MotionVariation264_g18123 * inputMesh.ase_color.r );
				float3 localObjectPosition_UNITY_MATRIX_M14_g18263 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18263 = ( localObjectPosition_UNITY_MATRIX_M14_g18263 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18263 = localObjectPosition_UNITY_MATRIX_M14_g18263;
				#endif
				float3 break9_g18263 = staticSwitch13_g18263;
				float ObjectData20_g18264 = ( temp_output_342_0_g18262 + ( break9_g18263.x + break9_g18263.z ) );
				float WorldData19_g18264 = temp_output_342_0_g18262;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18264 = WorldData19_g18264;
				#else
				float staticSwitch14_g18264 = ObjectData20_g18264;
				#endif
				float Motion_Variation284_g18262 = staticSwitch14_g18264;
				half MotionScale262_g18123 = _MotionScale_20;
				float Motion_Scale287_g18262 = ( MotionScale262_g18123 * ase_worldPos.x );
				half Motion_Rolling138_g18123 = ( ( _MotionAmplitude_20 * Motion_Max_Rolling1137_g18123 ) * Global_Amplitude_270_g18123 * Mesh_Motion_260_g18123 * ( Global_NoiseTex_R34_g18123 + Global_NoiseTex_G38_g18123 ) * Motion_Use20162_g18123 * sin( ( temp_output_5_0_g18265 + Motion_Variation284_g18262 + Motion_Scale287_g18262 ) ) );
				half Angle44_g18271 = Motion_Rolling138_g18123;
				half3 VertexPos40_g18273 = ( VertexPosRotationAxis50_g18271 + ( VertexPosOtherAxis82_g18271 * cos( Angle44_g18271 ) ) + ( cross( float3(0,1,0) , VertexPosOtherAxis82_g18271 ) * sin( Angle44_g18271 ) ) );
				float3 appendResult74_g18273 = (float3(VertexPos40_g18273.x , 0.0 , 0.0));
				half3 VertexPosRotationAxis50_g18273 = appendResult74_g18273;
				float3 break84_g18273 = VertexPos40_g18273;
				float3 appendResult81_g18273 = (float3(0.0 , break84_g18273.y , break84_g18273.z));
				half3 VertexPosOtherAxis82_g18273 = appendResult81_g18273;
				float ObjectData20_g18309 = 3.14;
				float Bounds_Height374_g18123 = _MaxBoundsInfo.y;
				float WorldData19_g18309 = ( Bounds_Height374_g18123 * 3.14 );
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18309 = WorldData19_g18309;
				#else
				float staticSwitch14_g18309 = ObjectData20_g18309;
				#endif
				float Motion_Max_Bending1133_g18123 = staticSwitch14_g18309;
				half Global_Amplitude_136_g18123 = TVE_Amplitude1;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18268 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18268 = ( localObjectPosition_UNITY_MATRIX_M14_g18268 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18268 = localObjectPosition_UNITY_MATRIX_M14_g18268;
				#endif
				half3 ObjectData20_g18267 = staticSwitch13_g18268;
				half3 WorldData19_g18267 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18267 = WorldData19_g18267;
				#else
				float3 staticSwitch14_g18267 = ObjectData20_g18267;
				#endif
				float3 break322_g18294 = (tex2Dlod( TVE_MotionTex, float4( ( (TVE_MotionCoord).xy + ( TVE_MotionCoord.z * (staticSwitch14_g18267).xz ) ), 0, 0.0) )).rgb;
				float3 appendResult323_g18294 = (float3(break322_g18294.x , 0.0 , break322_g18294.y));
				float3 temp_output_324_0_g18294 = (appendResult323_g18294*2.0 + -1.0);
				float3 ase_parentObjectScale = ( 1.0 / float3( length( GetWorldToObjectMatrix()[ 0 ].xyz ), length( GetWorldToObjectMatrix()[ 1 ].xyz ), length( GetWorldToObjectMatrix()[ 2 ].xyz ) ) );
				half3 ObjectData20_g18295 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_324_0_g18294 , 0.0 ) ).xyz * ase_parentObjectScale );
				half3 WorldData19_g18295 = temp_output_324_0_g18294;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18295 = WorldData19_g18295;
				#else
				float3 staticSwitch14_g18295 = ObjectData20_g18295;
				#endif
				float2 temp_output_1976_320_g18123 = (staticSwitch14_g18295).xz;
				half2 Motion_DirectionOS39_g18123 = temp_output_1976_320_g18123;
				half Input_Speed62_g18245 = _MotionSpeed_10;
				float temp_output_4_0_g18246 = Input_Speed62_g18245;
				float temp_output_5_0_g18246 = ( temp_output_4_0_g18246 * _TimeParameters.x );
				float temp_output_349_0_g18245 = ( _MotionVariation_10 * inputMesh.ase_color.r );
				float3 localObjectPosition_UNITY_MATRIX_M14_g18249 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18249 = ( localObjectPosition_UNITY_MATRIX_M14_g18249 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18249 = localObjectPosition_UNITY_MATRIX_M14_g18249;
				#endif
				float3 break9_g18249 = staticSwitch13_g18249;
				float ObjectData20_g18248 = ( temp_output_349_0_g18245 + ( break9_g18249.x + break9_g18249.z ) );
				float WorldData19_g18248 = temp_output_349_0_g18245;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18248 = WorldData19_g18248;
				#else
				float staticSwitch14_g18248 = ObjectData20_g18248;
				#endif
				half Motion_Variation284_g18245 = staticSwitch14_g18248;
				float2 appendResult344_g18245 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 Motion_Scale287_g18245 = ( _MotionScale_10 * appendResult344_g18245 );
				half2 Sine_MinusOneToOne281_g18245 = sin( ( temp_output_5_0_g18246 + Motion_Variation284_g18245 + Motion_Scale287_g18245 ) );
				float2 temp_cast_4 = (1.0).xx;
				half Input_Turbulence327_g18245 = Global_NoiseTex_R34_g18123;
				float2 lerpResult321_g18245 = lerp( Sine_MinusOneToOne281_g18245 , temp_cast_4 , Input_Turbulence327_g18245);
				float2 temp_output_84_0_g18123 = ( ( _MotionAmplitude_10 * Motion_Max_Bending1133_g18123 ) * Global_Amplitude_136_g18123 * Global_NoiseTex_R34_g18123 * Motion_DirectionOS39_g18123 * lerpResult321_g18245 );
				float temp_output_1976_333_g18123 = break322_g18294.z;
				half2 Motion_Interaction53_g18123 = ( _InteractionAmplitude * Motion_Max_Bending1133_g18123 * temp_output_1976_320_g18123 * temp_output_1976_333_g18123 * temp_output_1976_333_g18123 );
				half Motion_InteractionMask66_g18123 = temp_output_1976_333_g18123;
				float2 lerpResult109_g18123 = lerp( temp_output_84_0_g18123 , Motion_Interaction53_g18123 , Motion_InteractionMask66_g18123);
				half Mesh_Motion_182_g18123 = inputMesh.ase_texcoord3.x;
				half Motion_Use1056_g18123 = ( _Motion_10 + ( _MotionCat * 0.0 ) );
				float2 break143_g18123 = ( lerpResult109_g18123 * Mesh_Motion_182_g18123 * Motion_Use1056_g18123 );
				half Motion_Z190_g18123 = break143_g18123.y;
				half Angle44_g18273 = Motion_Z190_g18123;
				half3 VertexPos40_g18281 = ( VertexPosRotationAxis50_g18273 + ( VertexPosOtherAxis82_g18273 * cos( Angle44_g18273 ) ) + ( cross( float3(1,0,0) , VertexPosOtherAxis82_g18273 ) * sin( Angle44_g18273 ) ) );
				float3 appendResult74_g18281 = (float3(0.0 , 0.0 , VertexPos40_g18281.z));
				half3 VertexPosRotationAxis50_g18281 = appendResult74_g18281;
				float3 break84_g18281 = VertexPos40_g18281;
				float3 appendResult81_g18281 = (float3(break84_g18281.x , break84_g18281.y , 0.0));
				half3 VertexPosOtherAxis82_g18281 = appendResult81_g18281;
				half Motion_X216_g18123 = break143_g18123.x;
				half Angle44_g18281 = -Motion_X216_g18123;
				half Global_NoiseTex_B132_g18123 = break142_g18289.b;
				half Input_Speed62_g18302 = -MotionSpeed265_g18123;
				float temp_output_4_0_g18305 = Input_Speed62_g18302;
				float temp_output_5_0_g18305 = ( temp_output_4_0_g18305 * _TimeParameters.x );
				float temp_output_342_0_g18302 = ( -MotionVariation264_g18123 * inputMesh.ase_color.r );
				float3 localObjectPosition_UNITY_MATRIX_M14_g18303 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18303 = ( localObjectPosition_UNITY_MATRIX_M14_g18303 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18303 = localObjectPosition_UNITY_MATRIX_M14_g18303;
				#endif
				float3 break9_g18303 = staticSwitch13_g18303;
				float ObjectData20_g18304 = ( temp_output_342_0_g18302 + ( break9_g18303.x + break9_g18303.z ) );
				float WorldData19_g18304 = temp_output_342_0_g18302;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18304 = WorldData19_g18304;
				#else
				float staticSwitch14_g18304 = ObjectData20_g18304;
				#endif
				float Motion_Variation284_g18302 = staticSwitch14_g18304;
				float Motion_Scale287_g18302 = ( MotionScale262_g18123 * ase_worldPos.x );
				float3 appendResult2014_g18123 = (float3(0.0 , ( ( _MotionVertical_20 * Bounds_Radius121_g18123 ) * Global_Amplitude_270_g18123 * Mesh_Motion_260_g18123 * Motion_Use20162_g18123 * ( Global_NoiseTex_R34_g18123 + Global_NoiseTex_B132_g18123 ) * sin( ( temp_output_5_0_g18305 + Motion_Variation284_g18302 + Motion_Scale287_g18302 ) ) ) , 0.0));
				half3 Motion_Vertical223_g18123 = appendResult2014_g18123;
				float3 Vertex_Motion_Object833_g18123 = ( ( VertexPosRotationAxis50_g18281 + ( VertexPosOtherAxis82_g18281 * cos( Angle44_g18281 ) ) + ( cross( float3(0,0,1) , VertexPosOtherAxis82_g18281 ) * sin( Angle44_g18281 ) ) ) + Motion_Vertical223_g18123 );
				half3 ObjectData20_g18272 = Vertex_Motion_Object833_g18123;
				float3 appendResult2047_g18123 = (float3(Motion_Rolling138_g18123 , 0.0 , -Motion_Rolling138_g18123));
				float3 appendResult2043_g18123 = (float3(Motion_X216_g18123 , 0.0 , Motion_Z190_g18123));
				float3 Vertex_Motion_World1118_g18123 = ( ( ( inputMesh.positionOS + appendResult2047_g18123 ) + appendResult2043_g18123 ) + Motion_Vertical223_g18123 );
				half3 WorldData19_g18272 = Vertex_Motion_World1118_g18123;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18272 = WorldData19_g18272;
				#else
				float3 staticSwitch14_g18272 = ObjectData20_g18272;
				#endif
				float3 localObjectPosition_UNITY_MATRIX_M14_g18274 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18274 = ( localObjectPosition_UNITY_MATRIX_M14_g18274 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18274 = localObjectPosition_UNITY_MATRIX_M14_g18274;
				#endif
				half Global_SizeFadeEnd287_g18123 = TVE_SizeFadeEnd;
				float temp_output_7_0_g18269 = Global_SizeFadeEnd287_g18123;
				half Global_SizeFadeStart276_g18123 = TVE_SizeFadeStart;
				float lerpResult348_g18123 = lerp( 1.0 , saturate( ( ( distance( _WorldSpaceCameraPos , staticSwitch13_g18274 ) - temp_output_7_0_g18269 ) / ( Global_SizeFadeStart276_g18123 - temp_output_7_0_g18269 ) ) ) , _GlobalSizeFade);
				float ObjectData20_g18278 = lerpResult348_g18123;
				float WorldData19_g18278 = 1.0;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18278 = WorldData19_g18278;
				#else
				float staticSwitch14_g18278 = ObjectData20_g18278;
				#endif
				float Vertex_SizeFade1740_g18123 = staticSwitch14_g18278;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18298 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18298 = ( localObjectPosition_UNITY_MATRIX_M14_g18298 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18298 = localObjectPosition_UNITY_MATRIX_M14_g18298;
				#endif
				half3 ObjectData20_g18299 = staticSwitch13_g18298;
				half3 WorldData19_g18299 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18299 = WorldData19_g18299;
				#else
				float3 staticSwitch14_g18299 = ObjectData20_g18299;
				#endif
				float4 tex2DNode7_g18297 = tex2Dlod( TVE_ExtrasTex, float4( ( (TVE_ExtrasCoord).xy + ( TVE_ExtrasCoord.z * (staticSwitch14_g18299).xz ) ), 0, 0.0) );
				half Global_ExtrasTex_G305_g18123 = tex2DNode7_g18297.g;
				float lerpResult346_g18123 = lerp( 1.0 , Global_ExtrasTex_G305_g18123 , _GlobalSize);
				float ObjectData20_g18270 = lerpResult346_g18123;
				float WorldData19_g18270 = 1.0;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18270 = WorldData19_g18270;
				#else
				float staticSwitch14_g18270 = ObjectData20_g18270;
				#endif
				half Vertex_Size1741_g18123 = staticSwitch14_g18270;
				float3 Final_Vertex890_g18123 = ( ( staticSwitch14_g18272 * Vertex_SizeFade1740_g18123 * Vertex_Size1741_g18123 ) + ( _IsHDPipeline * 0.0 ) );
				
				float3 ase_worldNormal = TransformObjectToWorldNormal(inputMesh.normalOS);
				float3 ase_worldTangent = TransformObjectToWorldDir(inputMesh.tangentOS.xyz);
				float ase_vertexTangentSign = inputMesh.tangentOS.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				outputPackedVaryingsMeshToPS.ase_texcoord6.xyz = ase_worldBitangent;
				
				outputPackedVaryingsMeshToPS.ase_texcoord5 = inputMesh.ase_texcoord;
				outputPackedVaryingsMeshToPS.ase_color = inputMesh.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				outputPackedVaryingsMeshToPS.ase_texcoord6.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = Final_Vertex890_g18123;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif

				inputMesh.normalOS =  inputMesh.normalOS ;
				inputMesh.tangentOS =  inputMesh.tangentOS ;

				float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
				float3 normalWS = TransformObjectToWorldNormal(inputMesh.normalOS);
				float4 tangentWS = float4(TransformObjectToWorldDir(inputMesh.tangentOS.xyz), inputMesh.tangentOS.w);

				outputPackedVaryingsMeshToPS.positionCS = TransformWorldToHClip(positionRWS);
				outputPackedVaryingsMeshToPS.interp00.xyz = positionRWS;
				outputPackedVaryingsMeshToPS.interp01.xyz = normalWS;
				outputPackedVaryingsMeshToPS.interp02.xyzw = tangentWS;
				outputPackedVaryingsMeshToPS.interp03.xyzw = inputMesh.uv1;
				outputPackedVaryingsMeshToPS.interp04.xyzw = inputMesh.uv2;
				return outputPackedVaryingsMeshToPS;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float3 positionOS : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl Vert ( AttributesMesh v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.positionOS = v.positionOS;
				o.normalOS = v.normalOS;
				o.tangentOS = v.tangentOS;
				o.uv1 = v.uv1;
				o.uv2 = v.uv2;
				o.ase_texcoord3 = v.ase_texcoord3;
				o.ase_color = v.ase_color;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if (SHADEROPTIONS_CAMERA_RELATIVE_RENDERING != 0)
				float3 cameraPos = 0;
				#else
				float3 cameraPos = _WorldSpaceCameraPos;
				#endif
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), cameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, GetObjectToWorldMatrix(), cameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), cameraPos, _ScreenParams, _FrustumPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			PackedVaryingsMeshToPS DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				AttributesMesh o = (AttributesMesh) 0;
				o.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				o.uv1 = patch[0].uv1 * bary.x + patch[1].uv1 * bary.y + patch[2].uv1 * bary.z;
				o.uv2 = patch[0].uv2 * bary.x + patch[1].uv2 * bary.y + patch[2].uv2 * bary.z;
				o.ase_texcoord3 = patch[0].ase_texcoord3 * bary.x + patch[1].ase_texcoord3 * bary.y + patch[2].ase_texcoord3 * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			PackedVaryingsMeshToPS Vert ( AttributesMesh v )
			{
				return VertexFunction( v );
			}
			#endif

			void Frag( PackedVaryingsMeshToPS packedInput,
						OUTPUT_GBUFFER(outGBuffer)
						#ifdef _DEPTHOFFSET_ON
						, out float outputDepth : SV_Depth
						#endif
						
						)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( packedInput );
				UNITY_SETUP_INSTANCE_ID( packedInput );
				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);
				input.tangentToWorld = k_identity3x3;
				float3 positionRWS = packedInput.interp00.xyz;
				float3 normalWS = packedInput.interp01.xyz;
				float4 tangentWS = packedInput.interp02.xyzw;

				input.positionSS = packedInput.positionCS;
				input.positionRWS = positionRWS;
				input.tangentToWorld = BuildTangentToWorld(tangentWS, normalWS);
				input.texCoord1 = packedInput.interp03.xyzw;
				input.texCoord2 = packedInput.interp04.xyzw;

				#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false);
				#elif SHADER_STAGE_FRAGMENT
				#if defined(ASE_NEED_CULLFACE)
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false );
				#endif
				#endif
				half isFrontFace = input.isFrontFace;

				PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);
				float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);
				SurfaceData surfaceData;
				BuiltinData builtinData;

				GlobalSurfaceDescription surfaceDescription = (GlobalSurfaceDescription)0;
				float2 Main_UVs15_g18123 = ( ( packedInput.ase_texcoord5.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				float4 tex2DNode29_g18123 = tex2D( _MainAlbedoTex, Main_UVs15_g18123 );
				float4 temp_output_51_0_g18123 = ( _MainColor * tex2DNode29_g18123 );
				half3 Main_AlbedoRaw99_g18123 = (temp_output_51_0_g18123).rgb;
				half3 Main_AlbedoColored863_g18123 = Main_AlbedoRaw99_g18123;
				float2 appendResult21_g18296 = (float2(packedInput.ase_texcoord5.z , packedInput.ase_texcoord5.w));
				float2 Mesh_DetailCoord3_g18123 = appendResult21_g18296;
				float2 Second_UVs17_g18123 = ( ( Mesh_DetailCoord3_g18123 * (_SecondUVs).xy ) + (_SecondUVs).zw );
				half3 Second_Albedo153_g18123 = (( _SecondColor * tex2D( _SecondAlbedoTex, Second_UVs17_g18123 ) )).rgb;
				half3 Second_AlbedoColored1963_g18123 = Second_Albedo153_g18123;
				half Mesh_DetailMask90_g18123 = packedInput.ase_color.b;
				float temp_output_989_0_g18123 = ( ( Mesh_DetailMask90_g18123 - 0.5 ) + _DetailMeshValue );
				half Blend_Source1540_g18123 = temp_output_989_0_g18123;
				float4 tex2DNode35_g18123 = tex2D( _MainMaskTex, Main_UVs15_g18123 );
				half Main_Mask57_g18123 = tex2DNode35_g18123.b;
				float4 tex2DNode33_g18123 = tex2D( _SecondMaskTex, Second_UVs17_g18123 );
				half Second_Mask81_g18123 = tex2DNode33_g18123.b;
				float lerpResult1327_g18123 = lerp( Main_Mask57_g18123 , Second_Mask81_g18123 , _MaskMode);
				float temp_output_7_0_g18284 = _DetailMaskContrast;
				half AutoRegister_DetailMode667_g18123 = ( 0.0 * _DetailMode * _DetailShadingCat );
				half Mask_Detail147_g18123 = ( saturate( ( ( saturate( ( Blend_Source1540_g18123 + ( Blend_Source1540_g18123 * ( ( ( 1.0 - lerpResult1327_g18123 ) - 0.5 ) + _DetailMaskValue ) ) ) ) - temp_output_7_0_g18284 ) / ( ( 1.0 - _DetailMaskContrast ) - temp_output_7_0_g18284 ) ) ) + AutoRegister_DetailMode667_g18123 );
				float3 lerpResult235_g18123 = lerp( Main_AlbedoColored863_g18123 , ( Main_AlbedoColored863_g18123 * Second_AlbedoColored1963_g18123 * 4.594794 ) , Mask_Detail147_g18123);
				float3 lerpResult208_g18123 = lerp( Main_AlbedoColored863_g18123 , Second_AlbedoColored1963_g18123 , Mask_Detail147_g18123);
				#if defined(MATERIAL_USE_DETAIL_OFF)
				float3 staticSwitch255_g18123 = Main_AlbedoColored863_g18123;
				#elif defined(MATERIAL_USE_DETAIL_OVERLAY)
				float3 staticSwitch255_g18123 = lerpResult235_g18123;
				#elif defined(MATERIAL_USE_DETAIL_HEIGHT)
				float3 staticSwitch255_g18123 = lerpResult208_g18123;
				#else
				float3 staticSwitch255_g18123 = Main_AlbedoColored863_g18123;
				#endif
				half3 Blend_Albedo265_g18123 = staticSwitch255_g18123;
				half3 Blend_AlbedoAndSubsurface149_g18123 = Blend_Albedo265_g18123;
				float3 temp_output_44_0_g18258 = (TVE_OverlayColor).rgb;
				half3 Global_OverlayColor1758_g18123 = temp_output_44_0_g18258;
				float2 temp_output_38_0_g18258 = ( _OverlayUVTilling * packedInput.ase_texcoord5.xy * TVE_OverlayUVTilling );
				float3 temp_output_34_0_g18258 = (tex2D( TVE_OverlayAlbedoTex, temp_output_38_0_g18258 )).rgb;
				half3 Global_OverlayAlbedo277_g18123 = temp_output_34_0_g18258;
				float4 tex2DNode117_g18123 = tex2D( _MainNormalTex, Main_UVs15_g18123 );
				float2 appendResult88_g18301 = (float2(tex2DNode117_g18123.a , tex2DNode117_g18123.g));
				float2 temp_output_90_0_g18301 = ( (appendResult88_g18301*2.0 + -1.0) * _MainNormalValue );
				float3 appendResult91_g18301 = (float3(temp_output_90_0_g18301 , 1.0));
				float3 Main_Normal137_g18123 = appendResult91_g18301;
				float4 tex2DNode145_g18123 = tex2D( _SecondNormalTex, Second_UVs17_g18123 );
				float2 appendResult88_g18256 = (float2(tex2DNode145_g18123.a , tex2DNode145_g18123.g));
				float2 temp_output_90_0_g18256 = ( (appendResult88_g18256*2.0 + -1.0) * _SecondNormalValue );
				float3 appendResult91_g18256 = (float3(temp_output_90_0_g18256 , 1.0));
				float3 Second_Normal179_g18123 = appendResult91_g18256;
				float3 lerpResult230_g18123 = lerp( float3( 0,0,1 ) , Second_Normal179_g18123 , Mask_Detail147_g18123);
				float3 lerpResult249_g18123 = lerp( Main_Normal137_g18123 , Second_Normal179_g18123 , Mask_Detail147_g18123);
				#if defined(MATERIAL_USE_DETAIL_OFF)
				float3 staticSwitch267_g18123 = Main_Normal137_g18123;
				#elif defined(MATERIAL_USE_DETAIL_OVERLAY)
				float3 staticSwitch267_g18123 = BlendNormal( Main_Normal137_g18123 , lerpResult230_g18123 );
				#elif defined(MATERIAL_USE_DETAIL_HEIGHT)
				float3 staticSwitch267_g18123 = lerpResult249_g18123;
				#else
				float3 staticSwitch267_g18123 = Main_Normal137_g18123;
				#endif
				float3 Blend_NormalRaw1051_g18123 = staticSwitch267_g18123;
				float3 switchResult1063_g18123 = (((isFrontFace>0)?(Blend_NormalRaw1051_g18123):(( Blend_NormalRaw1051_g18123 * float3(-1,-1,-1) ))));
				half Overlay_Contrast1405_g18123 = _OverlayContrast;
				float3 appendResult1439_g18123 = (float3(Overlay_Contrast1405_g18123 , Overlay_Contrast1405_g18123 , 1.0));
				float3 ase_worldBitangent = packedInput.ase_texcoord6.xyz;
				float3 tanToWorld0 = float3( tangentWS.xyz.x, ase_worldBitangent.x, normalWS.x );
				float3 tanToWorld1 = float3( tangentWS.xyz.y, ase_worldBitangent.y, normalWS.y );
				float3 tanToWorld2 = float3( tangentWS.xyz.z, ase_worldBitangent.z, normalWS.z );
				float3 tanNormal178_g18123 = ( switchResult1063_g18123 * appendResult1439_g18123 );
				float3 worldNormal178_g18123 = float3(dot(tanToWorld0,tanNormal178_g18123), dot(tanToWorld1,tanNormal178_g18123), dot(tanToWorld2,tanNormal178_g18123));
				half Global_OverlayIntensity154_g18123 = TVE_OverlayIntensity;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18298 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18298 = ( localObjectPosition_UNITY_MATRIX_M14_g18298 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18298 = localObjectPosition_UNITY_MATRIX_M14_g18298;
				#endif
				half3 ObjectData20_g18299 = staticSwitch13_g18298;
				float3 ase_worldPos = GetAbsolutePositionWS( positionRWS );
				half3 WorldData19_g18299 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18299 = WorldData19_g18299;
				#else
				float3 staticSwitch14_g18299 = ObjectData20_g18299;
				#endif
				float4 tex2DNode7_g18297 = tex2D( TVE_ExtrasTex, ( (TVE_ExtrasCoord).xy + ( TVE_ExtrasCoord.z * (staticSwitch14_g18299).xz ) ) );
				half Global_ExtrasTex_B156_g18123 = tex2DNode7_g18297.b;
				float temp_output_1025_0_g18123 = ( Global_OverlayIntensity154_g18123 * _GlobalOverlay * Global_ExtrasTex_B156_g18123 );
				half Overlay_Commons1365_g18123 = temp_output_1025_0_g18123;
				half Overlay_Mask269_g18123 = saturate( ( saturate( worldNormal178_g18123.y ) - ( 1.0 - Overlay_Commons1365_g18123 ) ) );
				float3 lerpResult336_g18123 = lerp( Blend_AlbedoAndSubsurface149_g18123 , ( Global_OverlayColor1758_g18123 * Global_OverlayAlbedo277_g18123 ) , Overlay_Mask269_g18123);
				half3 Final_Albedo359_g18123 = lerpResult336_g18123;
				half Main_Alpha316_g18123 = (temp_output_51_0_g18123).a;
				float lerpResult354_g18123 = lerp( 1.0 , Main_Alpha316_g18123 , __premul);
				half Final_Premultiply355_g18123 = lerpResult354_g18123;
				
				float3 temp_output_13_0_g18300 = staticSwitch267_g18123;
				float3 switchResult12_g18300 = (((isFrontFace>0)?(temp_output_13_0_g18300):(( temp_output_13_0_g18300 * _render_normals_options ))));
				half3 Blend_Normal312_g18123 = switchResult12_g18300;
				float4 tex2DNode33_g18258 = tex2D( TVE_OverlayNormalTex, temp_output_38_0_g18258 );
				float2 appendResult88_g18259 = (float2(tex2DNode33_g18258.a , tex2DNode33_g18258.g));
				float2 temp_output_90_0_g18259 = ( (appendResult88_g18259*2.0 + -1.0) * TVE_OverlayNormalValue );
				float3 appendResult91_g18259 = (float3(temp_output_90_0_g18259 , 1.0));
				float3 temp_output_84_19_g18258 = appendResult91_g18259;
				half3 Global_OverlayNormal313_g18123 = temp_output_84_19_g18258;
				float3 lerpResult349_g18123 = lerp( Blend_Normal312_g18123 , Global_OverlayNormal313_g18123 , Overlay_Mask269_g18123);
				half3 Final_Normal366_g18123 = lerpResult349_g18123;
				
				half Main_Smoothness227_g18123 = ( tex2DNode35_g18123.a * _MainSmoothnessValue );
				half Second_Smoothness236_g18123 = ( tex2DNode33_g18123.a * _SecondSmoothnessValue );
				float lerpResult266_g18123 = lerp( Main_Smoothness227_g18123 , Second_Smoothness236_g18123 , Mask_Detail147_g18123);
				#if defined(MATERIAL_USE_DETAIL_OFF)
				float staticSwitch297_g18123 = Main_Smoothness227_g18123;
				#elif defined(MATERIAL_USE_DETAIL_OVERLAY)
				float staticSwitch297_g18123 = Main_Smoothness227_g18123;
				#elif defined(MATERIAL_USE_DETAIL_HEIGHT)
				float staticSwitch297_g18123 = lerpResult266_g18123;
				#else
				float staticSwitch297_g18123 = Main_Smoothness227_g18123;
				#endif
				half Blend_Smoothness314_g18123 = staticSwitch297_g18123;
				half Global_OverlaySmoothness311_g18123 = TVE_OverlaySmoothness;
				float lerpResult343_g18123 = lerp( Blend_Smoothness314_g18123 , Global_OverlaySmoothness311_g18123 , Overlay_Mask269_g18123);
				half Final_Smoothness371_g18123 = lerpResult343_g18123;
				half Global_Wetness1016_g18123 = ( TVE_Wetness * _GlobalWetness );
				half Global_ExtrasTex_A1033_g18123 = tex2DNode7_g18297.a;
				float lerpResult1037_g18123 = lerp( Final_Smoothness371_g18123 , saturate( ( Final_Smoothness371_g18123 + Global_Wetness1016_g18123 ) ) , Global_ExtrasTex_A1033_g18123);
				
				half Mesh_Occlusion318_g18123 = packedInput.ase_color.g;
				float saferPower1201_g18123 = max( Mesh_Occlusion318_g18123 , 0.0001 );
				half Vertex_Occlusion648_g18123 = pow( saferPower1201_g18123 , _ObjectOcclusionValue );
				float lerpResult240_g18123 = lerp( 1.0 , tex2DNode35_g18123.g , _MainOcclusionValue);
				half Main_Occlusion247_g18123 = lerpResult240_g18123;
				float lerpResult239_g18123 = lerp( 1.0 , tex2DNode33_g18123.g , _SecondOcclusionValue);
				half Second_Occlusion251_g18123 = lerpResult239_g18123;
				float lerpResult294_g18123 = lerp( Main_Occlusion247_g18123 , Second_Occlusion251_g18123 , Mask_Detail147_g18123);
				#if defined(MATERIAL_USE_DETAIL_OFF)
				float staticSwitch310_g18123 = Main_Occlusion247_g18123;
				#elif defined(MATERIAL_USE_DETAIL_OVERLAY)
				float staticSwitch310_g18123 = ( Main_Occlusion247_g18123 * Second_Occlusion251_g18123 );
				#elif defined(MATERIAL_USE_DETAIL_HEIGHT)
				float staticSwitch310_g18123 = lerpResult294_g18123;
				#else
				float staticSwitch310_g18123 = Main_Occlusion247_g18123;
				#endif
				half Blend_Occlusion323_g18123 = staticSwitch310_g18123;
				
				float localCustomAlphaClip9_g18277 = ( 0.0 );
				half Main_AlphaRaw1203_g18123 = tex2DNode29_g18123.a;
				half Alpha5_g18277 = Main_AlphaRaw1203_g18123;
				float Alpha9_g18277 = Alpha5_g18277;
				float AlphaClipThreshold9_g18277 = _Cutoff;
				#if _ALPHATEST_ON
				clip(Alpha9_g18277 - AlphaClipThreshold9_g18277);
				#endif
				half Final_Clip914_g18123 = localCustomAlphaClip9_g18277;
				
				surfaceDescription.Albedo = ( Final_Albedo359_g18123 * Final_Premultiply355_g18123 );
				surfaceDescription.Normal = Final_Normal366_g18123;
				surfaceDescription.BentNormal = float3( 0, 0, 1 );
				surfaceDescription.CoatMask = 0;
				surfaceDescription.Metallic = 0;

				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceDescription.Specular = 0;
				#endif

				surfaceDescription.Emission = 0;
				surfaceDescription.Smoothness = lerpResult1037_g18123;
				surfaceDescription.Occlusion = ( Vertex_Occlusion648_g18123 * Blend_Occlusion323_g18123 );
				surfaceDescription.Alpha = Main_Alpha316_g18123;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = Final_Clip914_g18123;
				#endif

				#ifdef _ALPHATEST_SHADOW_ON
				surfaceDescription.AlphaClipThresholdShadow = 0.5;
				#endif

				surfaceDescription.AlphaClipThresholdDepthPrepass = 0.5;
				surfaceDescription.AlphaClipThresholdDepthPostpass = 0.5;

				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceDescription.SpecularAAScreenSpaceVariance = 0;
				surfaceDescription.SpecularAAThreshold = 0;
				#endif

				#ifdef _SPECULAR_OCCLUSION_CUSTOM
				surfaceDescription.SpecularOcclusion = 0;
				#endif

				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceDescription.Thickness = 1;
				#endif

				#ifdef _HAS_REFRACTION
				surfaceDescription.RefractionIndex = 1;
				surfaceDescription.RefractionColor = float3( 1, 1, 1 );
				surfaceDescription.RefractionDistance = 0;
				#endif

				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceDescription.SubsurfaceMask = 1;
				#endif

				#if defined( _MATERIAL_FEATURE_SUBSURFACE_SCATTERING ) || defined( _MATERIAL_FEATURE_TRANSMISSION )
				surfaceDescription.DiffusionProfile = 0;
				#endif

				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceDescription.Anisotropy = 1;
				surfaceDescription.Tangent = float3( 1, 0, 0 );
				#endif

				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceDescription.IridescenceMask = 0;
				surfaceDescription.IridescenceThickness = 0;
				#endif

				#ifdef _ASE_DISTORTION
				surfaceDescription.Distortion = float2 ( 2, -1 );
				surfaceDescription.DistortionBlur = 1;
				#endif

				#ifdef _ASE_BAKEDGI
				surfaceDescription.BakedGI = 0;
				#endif
				#ifdef _ASE_BAKEDBACKGI
				surfaceDescription.BakedBackGI = 0;
				#endif

				#ifdef _DEPTHOFFSET_ON
				surfaceDescription.DepthOffset = 0;
				#endif

				GetSurfaceAndBuiltinData( surfaceDescription, input, V, posInput, surfaceData, builtinData );
				ENCODE_INTO_GBUFFER( surfaceData, builtinData, posInput.positionSS, outGBuffer );
				#ifdef _DEPTHOFFSET_ON
				outputDepth = posInput.deviceDepth;
				#endif
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "META"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define _DISABLE_DECALS 1
			#define _DISABLE_SSR 1
			#define _SPECULAR_OCCLUSION_FROM_AO 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _AMBIENT_OCCLUSION 1
			#define HAVE_MESH_MODIFICATION
			#define ASE_SRP_VERSION 70201
			#if !defined(ASE_NEED_CULLFACE)
			#define ASE_NEED_CULLFACE 1
			#endif //ASE_NEED_CULLFACE


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
			#pragma shader_feature_local _ENABLE_FOG_ON_TRANSPARENT
			#pragma shader_feature_local _ALPHATEST_ON

			#define SHADERPASS SHADERPASS_LIGHT_TRANSPORT

			#pragma vertex Vert
			#pragma fragment Frag

			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
			#ifdef DEBUG_DISPLAY
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
			#endif
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_VFACE
			#define ASE_NEEDS_VERT_TANGENT
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature _ALPHATEST_ON
			#pragma shader_feature MATERIAL_USE_DETAIL_OFF MATERIAL_USE_DETAIL_OVERLAY MATERIAL_USE_DETAIL_HEIGHT
			  
			//SHADER INJECTION POINT BEGIN
			//SHADER INJECTION POINT END
			    
			#pragma shader_feature MATERIAL_USE_OBJECT_DATA MATERIAL_USE_WORLD_DATA


			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif

			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 positionCS : SV_Position;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			CBUFFER_START( UnityPerMaterial )
			half4 _MainUVs;
			float4 _Color;
			half4 _SecondColor;
			half4 _SecondUVs;
			float4 _MaxBoundsInfo;
			float4 _SubsurfaceDiffusion_asset;
			half4 _MainColor;
			half3 _render_normals_options;
			half _MotionVertical_20;
			half _MotionCat;
			half _Motion_10;
			half _InteractionAmplitude;
			float _MotionScale_10;
			half _MotionVariation_10;
			half _MotionAmplitude_10;
			float _MotionScale_20;
			half _MotionVariation_20;
			float _MotionSpeed_20;
			half _Motion_20;
			half _MotionAmplitude_20;
			half _IsStandardShader;
			half _material_batching;
			half _BatchingMessage;
			float _MotionSpeed_10;
			half _GlobalSizeFade;
			half _IsLitShader;
			half _IsHDPipeline;
			half _ObjectOcclusionValue;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half __premul;
			half _GlobalOverlay;
			half _OverlayContrast;
			half _SecondNormalValue;
			half _MainNormalValue;
			half _OverlayUVTilling;
			half _DetailShadingCat;
			half _DetailMode;
			half _DetailMaskContrast;
			half _DetailMaskValue;
			half _MaskMode;
			half _DetailMeshValue;
			half _IsVersion;
			half _GlobalSize;
			float _MotionScale_32;
			float _MotionVariation_32;
			float _MotionVariation_30;
			half __zw;
			half __blend;
			half _render_mode;
			half __clip;
			half _render_priority;
			half _render_dst;
			half _GlobalSettingsCat;
			half _render_clip;
			half _MaterialShadingCat;
			half _AdvancedCat;
			half _ObjectThicknessValue;
			half _RenderingCat;
			half _RenderMode_ResetInteractive;
			half _IsTVEShader;
			half _VertexOcclusion;
			half _IsBarkShader;
			half _IsAnyPathShader;
			half _Banner;
			half _MainMaskValue;
			half _render_blend;
			half _render_zw;
			half _Cutoff;
			half __surface;
			float _MotionSpeed_32;
			half _MotionAmplitude_30;
			float _MotionSpeed_30;
			float _MotionScale_30;
			half _MotionAmplitude_32;
			half _MainColorMode;
			half __dst;
			half _render_cull;
			half _AlphaClipInteractive;
			half _render_src;
			float _SubsurfaceMode;
			half __priority;
			half _MainShadingCat;
			half __src;
			half __normals;
			half __cull;
			half _render_normals;
			half _RenderMode_TransparentInteractive;
			half _MainOcclusionValue;
			half _SecondOcclusionValue;
			float4 _EmissionColor;
			float _RenderQueueType;
			#ifdef _ADD_PRECOMPUTED_VELOCITY
			float _AddPrecomputedVelocity;
			#endif
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _TransparentZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _EnableFogOnTransparent;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _AlphaCutoff;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _MainTex;
			half TVE_Amplitude2;
			sampler2D TVE_NoiseTex;
			half TVE_NoiseSpeed;
			half TVE_NoiseSize;
			half TVE_NoiseContrast;
			half TVE_Amplitude1;
			sampler2D TVE_MotionTex;
			half4 TVE_MotionCoord;
			half TVE_SizeFadeEnd;
			half TVE_SizeFadeStart;
			sampler2D TVE_ExtrasTex;
			half4 TVE_ExtrasCoord;
			sampler2D _MainAlbedoTex;
			sampler2D _SecondAlbedoTex;
			sampler2D _MainMaskTex;
			sampler2D _SecondMaskTex;
			half4 TVE_OverlayColor;
			sampler2D TVE_OverlayAlbedoTex;
			half TVE_OverlayUVTilling;
			sampler2D _MainNormalTex;
			sampler2D _SecondNormalTex;
			half TVE_OverlayIntensity;
			sampler2D TVE_OverlayNormalTex;
			half TVE_OverlayNormalValue;
			half TVE_OverlaySmoothness;
			float TVE_Wetness;


			float3 ObjectPosition_UNITY_MATRIX_M(  )
			{
				return float3(UNITY_MATRIX_M[0].w, UNITY_MATRIX_M[1].w, UNITY_MATRIX_M[2].w );
			}
			

			void BuildSurfaceData(FragInputs fragInputs, inout GlobalSurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);

				surfaceData.specularOcclusion = 1.0;

				// surface data
				surfaceData.baseColor =					surfaceDescription.Albedo;
				surfaceData.perceptualSmoothness =		surfaceDescription.Smoothness;
				surfaceData.ambientOcclusion =			surfaceDescription.Occlusion;
				surfaceData.metallic =					surfaceDescription.Metallic;
				surfaceData.coatMask =					surfaceDescription.CoatMask;

				#ifdef _SPECULAR_OCCLUSION_CUSTOM
				surfaceData.specularOcclusion =			surfaceDescription.SpecularOcclusion;
				#endif
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.subsurfaceMask =			surfaceDescription.SubsurfaceMask;
				#endif
				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceData.thickness =					surfaceDescription.Thickness;
				#endif
				#if defined( _MATERIAL_FEATURE_SUBSURFACE_SCATTERING ) || defined( _MATERIAL_FEATURE_TRANSMISSION )
				surfaceData.diffusionProfileHash =		asuint(surfaceDescription.DiffusionProfile);
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.specularColor =				surfaceDescription.Specular;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.anisotropy =				surfaceDescription.Anisotropy;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.iridescenceMask =			surfaceDescription.IridescenceMask;
				surfaceData.iridescenceThickness =		surfaceDescription.IridescenceThickness;
				#endif

				// refraction
				#ifdef _HAS_REFRACTION
				if( _EnableSSRefraction )
				{
					surfaceData.ior = surfaceDescription.RefractionIndex;
					surfaceData.transmittanceColor = surfaceDescription.RefractionColor;
					surfaceData.atDistance = surfaceDescription.RefractionDistance;

					surfaceData.transmittanceMask = ( 1.0 - surfaceDescription.Alpha );
					surfaceDescription.Alpha = 1.0;
				}
				else
				{
					surfaceData.ior = 1.0;
					surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
					surfaceData.atDistance = 1.0;
					surfaceData.transmittanceMask = 0.0;
					surfaceDescription.Alpha = 1.0;
				}
				#else
				surfaceData.ior = 1.0;
				surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
				surfaceData.atDistance = 1.0;
				surfaceData.transmittanceMask = 0.0;
				#endif


				// material features
				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif
				#ifdef ASE_LIT_CLEAR_COAT
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				// others
				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				// normals
				float3 normalTS = float3(0.0f, 0.0f, 1.0f);
				normalTS = surfaceDescription.Normal;
				GetNormalWS( fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants );

				surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];

				bentNormalWS = surfaceData.normalWS;
				#ifdef ASE_BENT_NORMAL
				GetNormalWS( fragInputs, surfaceDescription.BentNormal, bentNormalWS, doubleSidedConstants );
				#endif

				surfaceData.tangentWS = normalize( fragInputs.tangentToWorld[ 0 ].xyz );
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.tangentWS = TransformTangentToWorld( surfaceDescription.Tangent, fragInputs.tangentToWorld );
				#endif
				surfaceData.tangentWS = Orthonormalize( surfaceData.tangentWS, surfaceData.normalWS );

				// decals
				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#endif

				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceData.perceptualSmoothness = GeometricNormalFiltering( surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[ 2 ], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold );
				#endif

				// debug
				#if defined(DEBUG_DISPLAY)
				if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
				{
					surfaceData.metallic = 0;
				}
				ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
				#endif
			}

			void GetSurfaceAndBuiltinData(GlobalSurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				//#ifdef _ALPHATEST_ON
				//DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				//#endif

				#ifdef _DEPTHOFFSET_ON
				builtinData.depthOffset = surfaceDescription.DepthOffset;
				ApplyDepthOffsetPositionInput( V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS );

				InitBuiltinData( posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[ 2 ], fragInputs.texCoord1, fragInputs.texCoord2, builtinData );

				builtinData.emissiveColor = surfaceDescription.Emission;

				#if (SHADERPASS == SHADERPASS_DISTORTION)
				builtinData.distortion = surfaceDescription.Distortion;
				builtinData.distortionBlur = surfaceDescription.DistortionBlur;
				#else
				builtinData.distortion = float2(0.0, 0.0);
				builtinData.distortionBlur = 0.0;
				#endif

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			CBUFFER_START(UnityMetaPass)
			bool4 unity_MetaVertexControl;
			bool4 unity_MetaFragmentControl;
			CBUFFER_END

			float unity_OneOverOutputBoost;
			float unity_MaxOutputValue;

			PackedVaryingsMeshToPS VertexFunction(AttributesMesh inputMesh  )
			{
				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS;

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);

				half3 VertexPos40_g18271 = inputMesh.positionOS;
				float3 appendResult74_g18271 = (float3(0.0 , VertexPos40_g18271.y , 0.0));
				float3 VertexPosRotationAxis50_g18271 = appendResult74_g18271;
				float3 break84_g18271 = VertexPos40_g18271;
				float3 appendResult81_g18271 = (float3(break84_g18271.x , 0.0 , break84_g18271.z));
				float3 VertexPosOtherAxis82_g18271 = appendResult81_g18271;
				float ObjectData20_g18308 = 3.14;
				float Bounds_Radius121_g18123 = _MaxBoundsInfo.x;
				float WorldData19_g18308 = Bounds_Radius121_g18123;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18308 = WorldData19_g18308;
				#else
				float staticSwitch14_g18308 = ObjectData20_g18308;
				#endif
				float Motion_Max_Rolling1137_g18123 = staticSwitch14_g18308;
				half Global_Amplitude_270_g18123 = TVE_Amplitude2;
				half Mesh_Motion_260_g18123 = inputMesh.ase_texcoord3.y;
				float temp_output_4_0_g18291 = 1.0;
				float temp_output_5_0_g18291 = ( temp_output_4_0_g18291 * _TimeParameters.x );
				float2 temp_cast_0 = (TVE_NoiseSpeed).xx;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18290 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18290 = ( localObjectPosition_UNITY_MATRIX_M14_g18290 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18290 = localObjectPosition_UNITY_MATRIX_M14_g18290;
				#endif
				half3 ObjectData20_g18292 = staticSwitch13_g18290;
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				half3 WorldData19_g18292 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18292 = WorldData19_g18292;
				#else
				float3 staticSwitch14_g18292 = ObjectData20_g18292;
				#endif
				float2 panner73_g18289 = ( temp_output_5_0_g18291 * temp_cast_0 + ( (staticSwitch14_g18292).xz * TVE_NoiseSize ));
				float4 temp_cast_1 = (TVE_NoiseContrast).xxxx;
				float4 break142_g18289 = pow( abs( tex2Dlod( TVE_NoiseTex, float4( panner73_g18289, 0, 0.0) ) ) , temp_cast_1 );
				half Global_NoiseTex_R34_g18123 = break142_g18289.r;
				half Global_NoiseTex_G38_g18123 = break142_g18289.g;
				half Motion_Use20162_g18123 = _Motion_20;
				half MotionSpeed265_g18123 = _MotionSpeed_20;
				half Input_Speed62_g18262 = MotionSpeed265_g18123;
				float temp_output_4_0_g18265 = Input_Speed62_g18262;
				float temp_output_5_0_g18265 = ( temp_output_4_0_g18265 * _TimeParameters.x );
				half MotionVariation264_g18123 = _MotionVariation_20;
				float temp_output_342_0_g18262 = ( MotionVariation264_g18123 * inputMesh.ase_color.r );
				float3 localObjectPosition_UNITY_MATRIX_M14_g18263 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18263 = ( localObjectPosition_UNITY_MATRIX_M14_g18263 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18263 = localObjectPosition_UNITY_MATRIX_M14_g18263;
				#endif
				float3 break9_g18263 = staticSwitch13_g18263;
				float ObjectData20_g18264 = ( temp_output_342_0_g18262 + ( break9_g18263.x + break9_g18263.z ) );
				float WorldData19_g18264 = temp_output_342_0_g18262;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18264 = WorldData19_g18264;
				#else
				float staticSwitch14_g18264 = ObjectData20_g18264;
				#endif
				float Motion_Variation284_g18262 = staticSwitch14_g18264;
				half MotionScale262_g18123 = _MotionScale_20;
				float Motion_Scale287_g18262 = ( MotionScale262_g18123 * ase_worldPos.x );
				half Motion_Rolling138_g18123 = ( ( _MotionAmplitude_20 * Motion_Max_Rolling1137_g18123 ) * Global_Amplitude_270_g18123 * Mesh_Motion_260_g18123 * ( Global_NoiseTex_R34_g18123 + Global_NoiseTex_G38_g18123 ) * Motion_Use20162_g18123 * sin( ( temp_output_5_0_g18265 + Motion_Variation284_g18262 + Motion_Scale287_g18262 ) ) );
				half Angle44_g18271 = Motion_Rolling138_g18123;
				half3 VertexPos40_g18273 = ( VertexPosRotationAxis50_g18271 + ( VertexPosOtherAxis82_g18271 * cos( Angle44_g18271 ) ) + ( cross( float3(0,1,0) , VertexPosOtherAxis82_g18271 ) * sin( Angle44_g18271 ) ) );
				float3 appendResult74_g18273 = (float3(VertexPos40_g18273.x , 0.0 , 0.0));
				half3 VertexPosRotationAxis50_g18273 = appendResult74_g18273;
				float3 break84_g18273 = VertexPos40_g18273;
				float3 appendResult81_g18273 = (float3(0.0 , break84_g18273.y , break84_g18273.z));
				half3 VertexPosOtherAxis82_g18273 = appendResult81_g18273;
				float ObjectData20_g18309 = 3.14;
				float Bounds_Height374_g18123 = _MaxBoundsInfo.y;
				float WorldData19_g18309 = ( Bounds_Height374_g18123 * 3.14 );
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18309 = WorldData19_g18309;
				#else
				float staticSwitch14_g18309 = ObjectData20_g18309;
				#endif
				float Motion_Max_Bending1133_g18123 = staticSwitch14_g18309;
				half Global_Amplitude_136_g18123 = TVE_Amplitude1;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18268 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18268 = ( localObjectPosition_UNITY_MATRIX_M14_g18268 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18268 = localObjectPosition_UNITY_MATRIX_M14_g18268;
				#endif
				half3 ObjectData20_g18267 = staticSwitch13_g18268;
				half3 WorldData19_g18267 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18267 = WorldData19_g18267;
				#else
				float3 staticSwitch14_g18267 = ObjectData20_g18267;
				#endif
				float3 break322_g18294 = (tex2Dlod( TVE_MotionTex, float4( ( (TVE_MotionCoord).xy + ( TVE_MotionCoord.z * (staticSwitch14_g18267).xz ) ), 0, 0.0) )).rgb;
				float3 appendResult323_g18294 = (float3(break322_g18294.x , 0.0 , break322_g18294.y));
				float3 temp_output_324_0_g18294 = (appendResult323_g18294*2.0 + -1.0);
				float3 ase_parentObjectScale = ( 1.0 / float3( length( GetWorldToObjectMatrix()[ 0 ].xyz ), length( GetWorldToObjectMatrix()[ 1 ].xyz ), length( GetWorldToObjectMatrix()[ 2 ].xyz ) ) );
				half3 ObjectData20_g18295 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_324_0_g18294 , 0.0 ) ).xyz * ase_parentObjectScale );
				half3 WorldData19_g18295 = temp_output_324_0_g18294;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18295 = WorldData19_g18295;
				#else
				float3 staticSwitch14_g18295 = ObjectData20_g18295;
				#endif
				float2 temp_output_1976_320_g18123 = (staticSwitch14_g18295).xz;
				half2 Motion_DirectionOS39_g18123 = temp_output_1976_320_g18123;
				half Input_Speed62_g18245 = _MotionSpeed_10;
				float temp_output_4_0_g18246 = Input_Speed62_g18245;
				float temp_output_5_0_g18246 = ( temp_output_4_0_g18246 * _TimeParameters.x );
				float temp_output_349_0_g18245 = ( _MotionVariation_10 * inputMesh.ase_color.r );
				float3 localObjectPosition_UNITY_MATRIX_M14_g18249 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18249 = ( localObjectPosition_UNITY_MATRIX_M14_g18249 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18249 = localObjectPosition_UNITY_MATRIX_M14_g18249;
				#endif
				float3 break9_g18249 = staticSwitch13_g18249;
				float ObjectData20_g18248 = ( temp_output_349_0_g18245 + ( break9_g18249.x + break9_g18249.z ) );
				float WorldData19_g18248 = temp_output_349_0_g18245;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18248 = WorldData19_g18248;
				#else
				float staticSwitch14_g18248 = ObjectData20_g18248;
				#endif
				half Motion_Variation284_g18245 = staticSwitch14_g18248;
				float2 appendResult344_g18245 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 Motion_Scale287_g18245 = ( _MotionScale_10 * appendResult344_g18245 );
				half2 Sine_MinusOneToOne281_g18245 = sin( ( temp_output_5_0_g18246 + Motion_Variation284_g18245 + Motion_Scale287_g18245 ) );
				float2 temp_cast_4 = (1.0).xx;
				half Input_Turbulence327_g18245 = Global_NoiseTex_R34_g18123;
				float2 lerpResult321_g18245 = lerp( Sine_MinusOneToOne281_g18245 , temp_cast_4 , Input_Turbulence327_g18245);
				float2 temp_output_84_0_g18123 = ( ( _MotionAmplitude_10 * Motion_Max_Bending1133_g18123 ) * Global_Amplitude_136_g18123 * Global_NoiseTex_R34_g18123 * Motion_DirectionOS39_g18123 * lerpResult321_g18245 );
				float temp_output_1976_333_g18123 = break322_g18294.z;
				half2 Motion_Interaction53_g18123 = ( _InteractionAmplitude * Motion_Max_Bending1133_g18123 * temp_output_1976_320_g18123 * temp_output_1976_333_g18123 * temp_output_1976_333_g18123 );
				half Motion_InteractionMask66_g18123 = temp_output_1976_333_g18123;
				float2 lerpResult109_g18123 = lerp( temp_output_84_0_g18123 , Motion_Interaction53_g18123 , Motion_InteractionMask66_g18123);
				half Mesh_Motion_182_g18123 = inputMesh.ase_texcoord3.x;
				half Motion_Use1056_g18123 = ( _Motion_10 + ( _MotionCat * 0.0 ) );
				float2 break143_g18123 = ( lerpResult109_g18123 * Mesh_Motion_182_g18123 * Motion_Use1056_g18123 );
				half Motion_Z190_g18123 = break143_g18123.y;
				half Angle44_g18273 = Motion_Z190_g18123;
				half3 VertexPos40_g18281 = ( VertexPosRotationAxis50_g18273 + ( VertexPosOtherAxis82_g18273 * cos( Angle44_g18273 ) ) + ( cross( float3(1,0,0) , VertexPosOtherAxis82_g18273 ) * sin( Angle44_g18273 ) ) );
				float3 appendResult74_g18281 = (float3(0.0 , 0.0 , VertexPos40_g18281.z));
				half3 VertexPosRotationAxis50_g18281 = appendResult74_g18281;
				float3 break84_g18281 = VertexPos40_g18281;
				float3 appendResult81_g18281 = (float3(break84_g18281.x , break84_g18281.y , 0.0));
				half3 VertexPosOtherAxis82_g18281 = appendResult81_g18281;
				half Motion_X216_g18123 = break143_g18123.x;
				half Angle44_g18281 = -Motion_X216_g18123;
				half Global_NoiseTex_B132_g18123 = break142_g18289.b;
				half Input_Speed62_g18302 = -MotionSpeed265_g18123;
				float temp_output_4_0_g18305 = Input_Speed62_g18302;
				float temp_output_5_0_g18305 = ( temp_output_4_0_g18305 * _TimeParameters.x );
				float temp_output_342_0_g18302 = ( -MotionVariation264_g18123 * inputMesh.ase_color.r );
				float3 localObjectPosition_UNITY_MATRIX_M14_g18303 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18303 = ( localObjectPosition_UNITY_MATRIX_M14_g18303 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18303 = localObjectPosition_UNITY_MATRIX_M14_g18303;
				#endif
				float3 break9_g18303 = staticSwitch13_g18303;
				float ObjectData20_g18304 = ( temp_output_342_0_g18302 + ( break9_g18303.x + break9_g18303.z ) );
				float WorldData19_g18304 = temp_output_342_0_g18302;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18304 = WorldData19_g18304;
				#else
				float staticSwitch14_g18304 = ObjectData20_g18304;
				#endif
				float Motion_Variation284_g18302 = staticSwitch14_g18304;
				float Motion_Scale287_g18302 = ( MotionScale262_g18123 * ase_worldPos.x );
				float3 appendResult2014_g18123 = (float3(0.0 , ( ( _MotionVertical_20 * Bounds_Radius121_g18123 ) * Global_Amplitude_270_g18123 * Mesh_Motion_260_g18123 * Motion_Use20162_g18123 * ( Global_NoiseTex_R34_g18123 + Global_NoiseTex_B132_g18123 ) * sin( ( temp_output_5_0_g18305 + Motion_Variation284_g18302 + Motion_Scale287_g18302 ) ) ) , 0.0));
				half3 Motion_Vertical223_g18123 = appendResult2014_g18123;
				float3 Vertex_Motion_Object833_g18123 = ( ( VertexPosRotationAxis50_g18281 + ( VertexPosOtherAxis82_g18281 * cos( Angle44_g18281 ) ) + ( cross( float3(0,0,1) , VertexPosOtherAxis82_g18281 ) * sin( Angle44_g18281 ) ) ) + Motion_Vertical223_g18123 );
				half3 ObjectData20_g18272 = Vertex_Motion_Object833_g18123;
				float3 appendResult2047_g18123 = (float3(Motion_Rolling138_g18123 , 0.0 , -Motion_Rolling138_g18123));
				float3 appendResult2043_g18123 = (float3(Motion_X216_g18123 , 0.0 , Motion_Z190_g18123));
				float3 Vertex_Motion_World1118_g18123 = ( ( ( inputMesh.positionOS + appendResult2047_g18123 ) + appendResult2043_g18123 ) + Motion_Vertical223_g18123 );
				half3 WorldData19_g18272 = Vertex_Motion_World1118_g18123;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18272 = WorldData19_g18272;
				#else
				float3 staticSwitch14_g18272 = ObjectData20_g18272;
				#endif
				float3 localObjectPosition_UNITY_MATRIX_M14_g18274 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18274 = ( localObjectPosition_UNITY_MATRIX_M14_g18274 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18274 = localObjectPosition_UNITY_MATRIX_M14_g18274;
				#endif
				half Global_SizeFadeEnd287_g18123 = TVE_SizeFadeEnd;
				float temp_output_7_0_g18269 = Global_SizeFadeEnd287_g18123;
				half Global_SizeFadeStart276_g18123 = TVE_SizeFadeStart;
				float lerpResult348_g18123 = lerp( 1.0 , saturate( ( ( distance( _WorldSpaceCameraPos , staticSwitch13_g18274 ) - temp_output_7_0_g18269 ) / ( Global_SizeFadeStart276_g18123 - temp_output_7_0_g18269 ) ) ) , _GlobalSizeFade);
				float ObjectData20_g18278 = lerpResult348_g18123;
				float WorldData19_g18278 = 1.0;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18278 = WorldData19_g18278;
				#else
				float staticSwitch14_g18278 = ObjectData20_g18278;
				#endif
				float Vertex_SizeFade1740_g18123 = staticSwitch14_g18278;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18298 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18298 = ( localObjectPosition_UNITY_MATRIX_M14_g18298 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18298 = localObjectPosition_UNITY_MATRIX_M14_g18298;
				#endif
				half3 ObjectData20_g18299 = staticSwitch13_g18298;
				half3 WorldData19_g18299 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18299 = WorldData19_g18299;
				#else
				float3 staticSwitch14_g18299 = ObjectData20_g18299;
				#endif
				float4 tex2DNode7_g18297 = tex2Dlod( TVE_ExtrasTex, float4( ( (TVE_ExtrasCoord).xy + ( TVE_ExtrasCoord.z * (staticSwitch14_g18299).xz ) ), 0, 0.0) );
				half Global_ExtrasTex_G305_g18123 = tex2DNode7_g18297.g;
				float lerpResult346_g18123 = lerp( 1.0 , Global_ExtrasTex_G305_g18123 , _GlobalSize);
				float ObjectData20_g18270 = lerpResult346_g18123;
				float WorldData19_g18270 = 1.0;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18270 = WorldData19_g18270;
				#else
				float staticSwitch14_g18270 = ObjectData20_g18270;
				#endif
				half Vertex_Size1741_g18123 = staticSwitch14_g18270;
				float3 Final_Vertex890_g18123 = ( ( staticSwitch14_g18272 * Vertex_SizeFade1740_g18123 * Vertex_Size1741_g18123 ) + ( _IsHDPipeline * 0.0 ) );
				
				float3 ase_worldTangent = TransformObjectToWorldDir(inputMesh.tangentOS.xyz);
				outputPackedVaryingsMeshToPS.ase_texcoord1.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(inputMesh.normalOS);
				outputPackedVaryingsMeshToPS.ase_texcoord2.xyz = ase_worldNormal;
				float ase_vertexTangentSign = inputMesh.tangentOS.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				outputPackedVaryingsMeshToPS.ase_texcoord3.xyz = ase_worldBitangent;
				outputPackedVaryingsMeshToPS.ase_texcoord4.xyz = ase_worldPos;
				
				outputPackedVaryingsMeshToPS.ase_texcoord = inputMesh.uv0;
				outputPackedVaryingsMeshToPS.ase_color = inputMesh.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				outputPackedVaryingsMeshToPS.ase_texcoord1.w = 0;
				outputPackedVaryingsMeshToPS.ase_texcoord2.w = 0;
				outputPackedVaryingsMeshToPS.ase_texcoord3.w = 0;
				outputPackedVaryingsMeshToPS.ase_texcoord4.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = Final_Vertex890_g18123;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif

				inputMesh.normalOS =  inputMesh.normalOS ;
				inputMesh.tangentOS =  inputMesh.tangentOS ;

				float2 uv = float2(0.0, 0.0);
				if (unity_MetaVertexControl.x)
				{
					uv = inputMesh.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				}
				else if (unity_MetaVertexControl.y)
				{
					uv = inputMesh.uv2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				}

				outputPackedVaryingsMeshToPS.positionCS = float4(uv * 2.0 - 1.0, inputMesh.positionOS.z > 0 ? 1.0e-4 : 0.0, 1.0);
				return outputPackedVaryingsMeshToPS;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float3 positionOS : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl Vert ( AttributesMesh v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.positionOS = v.positionOS;
				o.normalOS = v.normalOS;
				o.tangentOS = v.tangentOS;
				o.uv0 = v.uv0;
				o.uv1 = v.uv1;
				o.uv2 = v.uv2;
				o.ase_texcoord3 = v.ase_texcoord3;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if (SHADEROPTIONS_CAMERA_RELATIVE_RENDERING != 0)
				float3 cameraPos = 0;
				#else
				float3 cameraPos = _WorldSpaceCameraPos;
				#endif
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), cameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, GetObjectToWorldMatrix(), cameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), cameraPos, _ScreenParams, _FrustumPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			PackedVaryingsMeshToPS DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				AttributesMesh o = (AttributesMesh) 0;
				o.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				o.uv0 = patch[0].uv0 * bary.x + patch[1].uv0 * bary.y + patch[2].uv0 * bary.z;
				o.uv1 = patch[0].uv1 * bary.x + patch[1].uv1 * bary.y + patch[2].uv1 * bary.z;
				o.uv2 = patch[0].uv2 * bary.x + patch[1].uv2 * bary.y + patch[2].uv2 * bary.z;
				o.ase_texcoord3 = patch[0].ase_texcoord3 * bary.x + patch[1].ase_texcoord3 * bary.y + patch[2].ase_texcoord3 * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			PackedVaryingsMeshToPS Vert ( AttributesMesh v )
			{
				return VertexFunction( v );
			}
			#endif

			float4 Frag(PackedVaryingsMeshToPS packedInput  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( packedInput );
				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);
				input.tangentToWorld = k_identity3x3;
				input.positionSS = packedInput.positionCS;

				#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false);
				#elif SHADER_STAGE_FRAGMENT
				#if defined(ASE_NEED_CULLFACE)
				input.isFrontFace = IS_FRONT_VFACE(packedInput.cullFace, true, false);
				#endif
				#endif
				half isFrontFace = input.isFrontFace;

				PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);
				float3 V = float3(1.0, 1.0, 1.0);

				SurfaceData surfaceData;
				BuiltinData builtinData;
				GlobalSurfaceDescription surfaceDescription = (GlobalSurfaceDescription)0;
				float2 Main_UVs15_g18123 = ( ( packedInput.ase_texcoord.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				float4 tex2DNode29_g18123 = tex2D( _MainAlbedoTex, Main_UVs15_g18123 );
				float4 temp_output_51_0_g18123 = ( _MainColor * tex2DNode29_g18123 );
				half3 Main_AlbedoRaw99_g18123 = (temp_output_51_0_g18123).rgb;
				half3 Main_AlbedoColored863_g18123 = Main_AlbedoRaw99_g18123;
				float2 appendResult21_g18296 = (float2(packedInput.ase_texcoord.z , packedInput.ase_texcoord.w));
				float2 Mesh_DetailCoord3_g18123 = appendResult21_g18296;
				float2 Second_UVs17_g18123 = ( ( Mesh_DetailCoord3_g18123 * (_SecondUVs).xy ) + (_SecondUVs).zw );
				half3 Second_Albedo153_g18123 = (( _SecondColor * tex2D( _SecondAlbedoTex, Second_UVs17_g18123 ) )).rgb;
				half3 Second_AlbedoColored1963_g18123 = Second_Albedo153_g18123;
				half Mesh_DetailMask90_g18123 = packedInput.ase_color.b;
				float temp_output_989_0_g18123 = ( ( Mesh_DetailMask90_g18123 - 0.5 ) + _DetailMeshValue );
				half Blend_Source1540_g18123 = temp_output_989_0_g18123;
				float4 tex2DNode35_g18123 = tex2D( _MainMaskTex, Main_UVs15_g18123 );
				half Main_Mask57_g18123 = tex2DNode35_g18123.b;
				float4 tex2DNode33_g18123 = tex2D( _SecondMaskTex, Second_UVs17_g18123 );
				half Second_Mask81_g18123 = tex2DNode33_g18123.b;
				float lerpResult1327_g18123 = lerp( Main_Mask57_g18123 , Second_Mask81_g18123 , _MaskMode);
				float temp_output_7_0_g18284 = _DetailMaskContrast;
				half AutoRegister_DetailMode667_g18123 = ( 0.0 * _DetailMode * _DetailShadingCat );
				half Mask_Detail147_g18123 = ( saturate( ( ( saturate( ( Blend_Source1540_g18123 + ( Blend_Source1540_g18123 * ( ( ( 1.0 - lerpResult1327_g18123 ) - 0.5 ) + _DetailMaskValue ) ) ) ) - temp_output_7_0_g18284 ) / ( ( 1.0 - _DetailMaskContrast ) - temp_output_7_0_g18284 ) ) ) + AutoRegister_DetailMode667_g18123 );
				float3 lerpResult235_g18123 = lerp( Main_AlbedoColored863_g18123 , ( Main_AlbedoColored863_g18123 * Second_AlbedoColored1963_g18123 * 4.594794 ) , Mask_Detail147_g18123);
				float3 lerpResult208_g18123 = lerp( Main_AlbedoColored863_g18123 , Second_AlbedoColored1963_g18123 , Mask_Detail147_g18123);
				#if defined(MATERIAL_USE_DETAIL_OFF)
				float3 staticSwitch255_g18123 = Main_AlbedoColored863_g18123;
				#elif defined(MATERIAL_USE_DETAIL_OVERLAY)
				float3 staticSwitch255_g18123 = lerpResult235_g18123;
				#elif defined(MATERIAL_USE_DETAIL_HEIGHT)
				float3 staticSwitch255_g18123 = lerpResult208_g18123;
				#else
				float3 staticSwitch255_g18123 = Main_AlbedoColored863_g18123;
				#endif
				half3 Blend_Albedo265_g18123 = staticSwitch255_g18123;
				half3 Blend_AlbedoAndSubsurface149_g18123 = Blend_Albedo265_g18123;
				float3 temp_output_44_0_g18258 = (TVE_OverlayColor).rgb;
				half3 Global_OverlayColor1758_g18123 = temp_output_44_0_g18258;
				float2 temp_output_38_0_g18258 = ( _OverlayUVTilling * packedInput.ase_texcoord.xy * TVE_OverlayUVTilling );
				float3 temp_output_34_0_g18258 = (tex2D( TVE_OverlayAlbedoTex, temp_output_38_0_g18258 )).rgb;
				half3 Global_OverlayAlbedo277_g18123 = temp_output_34_0_g18258;
				float4 tex2DNode117_g18123 = tex2D( _MainNormalTex, Main_UVs15_g18123 );
				float2 appendResult88_g18301 = (float2(tex2DNode117_g18123.a , tex2DNode117_g18123.g));
				float2 temp_output_90_0_g18301 = ( (appendResult88_g18301*2.0 + -1.0) * _MainNormalValue );
				float3 appendResult91_g18301 = (float3(temp_output_90_0_g18301 , 1.0));
				float3 Main_Normal137_g18123 = appendResult91_g18301;
				float4 tex2DNode145_g18123 = tex2D( _SecondNormalTex, Second_UVs17_g18123 );
				float2 appendResult88_g18256 = (float2(tex2DNode145_g18123.a , tex2DNode145_g18123.g));
				float2 temp_output_90_0_g18256 = ( (appendResult88_g18256*2.0 + -1.0) * _SecondNormalValue );
				float3 appendResult91_g18256 = (float3(temp_output_90_0_g18256 , 1.0));
				float3 Second_Normal179_g18123 = appendResult91_g18256;
				float3 lerpResult230_g18123 = lerp( float3( 0,0,1 ) , Second_Normal179_g18123 , Mask_Detail147_g18123);
				float3 lerpResult249_g18123 = lerp( Main_Normal137_g18123 , Second_Normal179_g18123 , Mask_Detail147_g18123);
				#if defined(MATERIAL_USE_DETAIL_OFF)
				float3 staticSwitch267_g18123 = Main_Normal137_g18123;
				#elif defined(MATERIAL_USE_DETAIL_OVERLAY)
				float3 staticSwitch267_g18123 = BlendNormal( Main_Normal137_g18123 , lerpResult230_g18123 );
				#elif defined(MATERIAL_USE_DETAIL_HEIGHT)
				float3 staticSwitch267_g18123 = lerpResult249_g18123;
				#else
				float3 staticSwitch267_g18123 = Main_Normal137_g18123;
				#endif
				float3 Blend_NormalRaw1051_g18123 = staticSwitch267_g18123;
				float3 switchResult1063_g18123 = (((isFrontFace>0)?(Blend_NormalRaw1051_g18123):(( Blend_NormalRaw1051_g18123 * float3(-1,-1,-1) ))));
				half Overlay_Contrast1405_g18123 = _OverlayContrast;
				float3 appendResult1439_g18123 = (float3(Overlay_Contrast1405_g18123 , Overlay_Contrast1405_g18123 , 1.0));
				float3 ase_worldTangent = packedInput.ase_texcoord1.xyz;
				float3 ase_worldNormal = packedInput.ase_texcoord2.xyz;
				float3 ase_worldBitangent = packedInput.ase_texcoord3.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal178_g18123 = ( switchResult1063_g18123 * appendResult1439_g18123 );
				float3 worldNormal178_g18123 = float3(dot(tanToWorld0,tanNormal178_g18123), dot(tanToWorld1,tanNormal178_g18123), dot(tanToWorld2,tanNormal178_g18123));
				half Global_OverlayIntensity154_g18123 = TVE_OverlayIntensity;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18298 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18298 = ( localObjectPosition_UNITY_MATRIX_M14_g18298 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18298 = localObjectPosition_UNITY_MATRIX_M14_g18298;
				#endif
				half3 ObjectData20_g18299 = staticSwitch13_g18298;
				float3 ase_worldPos = packedInput.ase_texcoord4.xyz;
				half3 WorldData19_g18299 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18299 = WorldData19_g18299;
				#else
				float3 staticSwitch14_g18299 = ObjectData20_g18299;
				#endif
				float4 tex2DNode7_g18297 = tex2D( TVE_ExtrasTex, ( (TVE_ExtrasCoord).xy + ( TVE_ExtrasCoord.z * (staticSwitch14_g18299).xz ) ) );
				half Global_ExtrasTex_B156_g18123 = tex2DNode7_g18297.b;
				float temp_output_1025_0_g18123 = ( Global_OverlayIntensity154_g18123 * _GlobalOverlay * Global_ExtrasTex_B156_g18123 );
				half Overlay_Commons1365_g18123 = temp_output_1025_0_g18123;
				half Overlay_Mask269_g18123 = saturate( ( saturate( worldNormal178_g18123.y ) - ( 1.0 - Overlay_Commons1365_g18123 ) ) );
				float3 lerpResult336_g18123 = lerp( Blend_AlbedoAndSubsurface149_g18123 , ( Global_OverlayColor1758_g18123 * Global_OverlayAlbedo277_g18123 ) , Overlay_Mask269_g18123);
				half3 Final_Albedo359_g18123 = lerpResult336_g18123;
				half Main_Alpha316_g18123 = (temp_output_51_0_g18123).a;
				float lerpResult354_g18123 = lerp( 1.0 , Main_Alpha316_g18123 , __premul);
				half Final_Premultiply355_g18123 = lerpResult354_g18123;
				
				float3 temp_output_13_0_g18300 = staticSwitch267_g18123;
				float3 switchResult12_g18300 = (((isFrontFace>0)?(temp_output_13_0_g18300):(( temp_output_13_0_g18300 * _render_normals_options ))));
				half3 Blend_Normal312_g18123 = switchResult12_g18300;
				float4 tex2DNode33_g18258 = tex2D( TVE_OverlayNormalTex, temp_output_38_0_g18258 );
				float2 appendResult88_g18259 = (float2(tex2DNode33_g18258.a , tex2DNode33_g18258.g));
				float2 temp_output_90_0_g18259 = ( (appendResult88_g18259*2.0 + -1.0) * TVE_OverlayNormalValue );
				float3 appendResult91_g18259 = (float3(temp_output_90_0_g18259 , 1.0));
				float3 temp_output_84_19_g18258 = appendResult91_g18259;
				half3 Global_OverlayNormal313_g18123 = temp_output_84_19_g18258;
				float3 lerpResult349_g18123 = lerp( Blend_Normal312_g18123 , Global_OverlayNormal313_g18123 , Overlay_Mask269_g18123);
				half3 Final_Normal366_g18123 = lerpResult349_g18123;
				
				half Main_Smoothness227_g18123 = ( tex2DNode35_g18123.a * _MainSmoothnessValue );
				half Second_Smoothness236_g18123 = ( tex2DNode33_g18123.a * _SecondSmoothnessValue );
				float lerpResult266_g18123 = lerp( Main_Smoothness227_g18123 , Second_Smoothness236_g18123 , Mask_Detail147_g18123);
				#if defined(MATERIAL_USE_DETAIL_OFF)
				float staticSwitch297_g18123 = Main_Smoothness227_g18123;
				#elif defined(MATERIAL_USE_DETAIL_OVERLAY)
				float staticSwitch297_g18123 = Main_Smoothness227_g18123;
				#elif defined(MATERIAL_USE_DETAIL_HEIGHT)
				float staticSwitch297_g18123 = lerpResult266_g18123;
				#else
				float staticSwitch297_g18123 = Main_Smoothness227_g18123;
				#endif
				half Blend_Smoothness314_g18123 = staticSwitch297_g18123;
				half Global_OverlaySmoothness311_g18123 = TVE_OverlaySmoothness;
				float lerpResult343_g18123 = lerp( Blend_Smoothness314_g18123 , Global_OverlaySmoothness311_g18123 , Overlay_Mask269_g18123);
				half Final_Smoothness371_g18123 = lerpResult343_g18123;
				half Global_Wetness1016_g18123 = ( TVE_Wetness * _GlobalWetness );
				half Global_ExtrasTex_A1033_g18123 = tex2DNode7_g18297.a;
				float lerpResult1037_g18123 = lerp( Final_Smoothness371_g18123 , saturate( ( Final_Smoothness371_g18123 + Global_Wetness1016_g18123 ) ) , Global_ExtrasTex_A1033_g18123);
				
				half Mesh_Occlusion318_g18123 = packedInput.ase_color.g;
				float saferPower1201_g18123 = max( Mesh_Occlusion318_g18123 , 0.0001 );
				half Vertex_Occlusion648_g18123 = pow( saferPower1201_g18123 , _ObjectOcclusionValue );
				float lerpResult240_g18123 = lerp( 1.0 , tex2DNode35_g18123.g , _MainOcclusionValue);
				half Main_Occlusion247_g18123 = lerpResult240_g18123;
				float lerpResult239_g18123 = lerp( 1.0 , tex2DNode33_g18123.g , _SecondOcclusionValue);
				half Second_Occlusion251_g18123 = lerpResult239_g18123;
				float lerpResult294_g18123 = lerp( Main_Occlusion247_g18123 , Second_Occlusion251_g18123 , Mask_Detail147_g18123);
				#if defined(MATERIAL_USE_DETAIL_OFF)
				float staticSwitch310_g18123 = Main_Occlusion247_g18123;
				#elif defined(MATERIAL_USE_DETAIL_OVERLAY)
				float staticSwitch310_g18123 = ( Main_Occlusion247_g18123 * Second_Occlusion251_g18123 );
				#elif defined(MATERIAL_USE_DETAIL_HEIGHT)
				float staticSwitch310_g18123 = lerpResult294_g18123;
				#else
				float staticSwitch310_g18123 = Main_Occlusion247_g18123;
				#endif
				half Blend_Occlusion323_g18123 = staticSwitch310_g18123;
				
				float localCustomAlphaClip9_g18277 = ( 0.0 );
				half Main_AlphaRaw1203_g18123 = tex2DNode29_g18123.a;
				half Alpha5_g18277 = Main_AlphaRaw1203_g18123;
				float Alpha9_g18277 = Alpha5_g18277;
				float AlphaClipThreshold9_g18277 = _Cutoff;
				#if _ALPHATEST_ON
				clip(Alpha9_g18277 - AlphaClipThreshold9_g18277);
				#endif
				half Final_Clip914_g18123 = localCustomAlphaClip9_g18277;
				
				surfaceDescription.Albedo = ( Final_Albedo359_g18123 * Final_Premultiply355_g18123 );
				surfaceDescription.Normal = Final_Normal366_g18123;
				surfaceDescription.BentNormal = float3( 0, 0, 1 );
				surfaceDescription.CoatMask = 0;
				surfaceDescription.Metallic = 0;

				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceDescription.Specular = 0;
				#endif

				surfaceDescription.Emission = 0;
				surfaceDescription.Smoothness = lerpResult1037_g18123;
				surfaceDescription.Occlusion = ( Vertex_Occlusion648_g18123 * Blend_Occlusion323_g18123 );
				surfaceDescription.Alpha = Main_Alpha316_g18123;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = Final_Clip914_g18123;
				#endif

				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceDescription.SpecularAAScreenSpaceVariance = 0;
				surfaceDescription.SpecularAAThreshold = 0;
				#endif

				#ifdef _SPECULAR_OCCLUSION_CUSTOM
				surfaceDescription.SpecularOcclusion = 0;
				#endif

				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceDescription.Thickness = 1;
				#endif

				#ifdef _HAS_REFRACTION
				surfaceDescription.RefractionIndex = 1;
				surfaceDescription.RefractionColor = float3( 1, 1, 1 );
				surfaceDescription.RefractionDistance = 0;
				#endif

				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceDescription.SubsurfaceMask = 1;
				#endif

				#if defined( _MATERIAL_FEATURE_SUBSURFACE_SCATTERING ) || defined( _MATERIAL_FEATURE_TRANSMISSION )
				surfaceDescription.DiffusionProfile = 0;
				#endif

				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceDescription.Anisotropy = 1;
				surfaceDescription.Tangent = float3( 1, 0, 0 );
				#endif

				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceDescription.IridescenceMask = 0;
				surfaceDescription.IridescenceThickness = 0;
				#endif

				GetSurfaceAndBuiltinData(surfaceDescription,input, V, posInput, surfaceData, builtinData);

				BSDFData bsdfData = ConvertSurfaceDataToBSDFData(input.positionSS.xy, surfaceData);
				LightTransportData lightTransportData = GetLightTransportData(surfaceData, builtinData, bsdfData);

				float4 res = float4(0.0, 0.0, 0.0, 1.0);
				if (unity_MetaFragmentControl.x)
				{
					res.rgb = clamp(pow(abs(lightTransportData.diffuseColor), saturate(unity_OneOverOutputBoost)), 0, unity_MaxOutputValue);
				}

				if (unity_MetaFragmentControl.y)
				{
					res.rgb = lightTransportData.emissiveColor;
				}

				return res;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			Cull [_CullMode]
			ZWrite On
			ZClip [_ZClip]
			ZTest LEqual
			ColorMask 0

			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define _DISABLE_DECALS 1
			#define _DISABLE_SSR 1
			#define _SPECULAR_OCCLUSION_FROM_AO 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _AMBIENT_OCCLUSION 1
			#define HAVE_MESH_MODIFICATION
			#define ASE_SRP_VERSION 70201


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
			#pragma shader_feature_local _ENABLE_FOG_ON_TRANSPARENT
			#pragma shader_feature_local _ALPHATEST_ON

			#define SHADERPASS SHADERPASS_SHADOWS

			#pragma vertex Vert
			#pragma fragment Frag

			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

			//#define USE_LEGACY_UNITY_MATRIX_VARIABLES

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
			#ifdef DEBUG_DISPLAY
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
			#endif
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature _ALPHATEST_ON
			  
			//SHADER INJECTION POINT BEGIN
			//SHADER INJECTION POINT END
			    
			#pragma shader_feature MATERIAL_USE_OBJECT_DATA MATERIAL_USE_WORLD_DATA


			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif

			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 positionCS : SV_Position;
				float3 interp00 : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			CBUFFER_START( UnityPerMaterial )
			half4 _MainUVs;
			float4 _Color;
			half4 _SecondColor;
			half4 _SecondUVs;
			float4 _MaxBoundsInfo;
			float4 _SubsurfaceDiffusion_asset;
			half4 _MainColor;
			half3 _render_normals_options;
			half _MotionVertical_20;
			half _MotionCat;
			half _Motion_10;
			half _InteractionAmplitude;
			float _MotionScale_10;
			half _MotionVariation_10;
			half _MotionAmplitude_10;
			float _MotionScale_20;
			half _MotionVariation_20;
			float _MotionSpeed_20;
			half _Motion_20;
			half _MotionAmplitude_20;
			half _IsStandardShader;
			half _material_batching;
			half _BatchingMessage;
			float _MotionSpeed_10;
			half _GlobalSizeFade;
			half _IsLitShader;
			half _IsHDPipeline;
			half _ObjectOcclusionValue;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half __premul;
			half _GlobalOverlay;
			half _OverlayContrast;
			half _SecondNormalValue;
			half _MainNormalValue;
			half _OverlayUVTilling;
			half _DetailShadingCat;
			half _DetailMode;
			half _DetailMaskContrast;
			half _DetailMaskValue;
			half _MaskMode;
			half _DetailMeshValue;
			half _IsVersion;
			half _GlobalSize;
			float _MotionScale_32;
			float _MotionVariation_32;
			float _MotionVariation_30;
			half __zw;
			half __blend;
			half _render_mode;
			half __clip;
			half _render_priority;
			half _render_dst;
			half _GlobalSettingsCat;
			half _render_clip;
			half _MaterialShadingCat;
			half _AdvancedCat;
			half _ObjectThicknessValue;
			half _RenderingCat;
			half _RenderMode_ResetInteractive;
			half _IsTVEShader;
			half _VertexOcclusion;
			half _IsBarkShader;
			half _IsAnyPathShader;
			half _Banner;
			half _MainMaskValue;
			half _render_blend;
			half _render_zw;
			half _Cutoff;
			half __surface;
			float _MotionSpeed_32;
			half _MotionAmplitude_30;
			float _MotionSpeed_30;
			float _MotionScale_30;
			half _MotionAmplitude_32;
			half _MainColorMode;
			half __dst;
			half _render_cull;
			half _AlphaClipInteractive;
			half _render_src;
			float _SubsurfaceMode;
			half __priority;
			half _MainShadingCat;
			half __src;
			half __normals;
			half __cull;
			half _render_normals;
			half _RenderMode_TransparentInteractive;
			half _MainOcclusionValue;
			half _SecondOcclusionValue;
			float4 _EmissionColor;
			float _RenderQueueType;
			#ifdef _ADD_PRECOMPUTED_VELOCITY
			float _AddPrecomputedVelocity;
			#endif
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _TransparentZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _EnableFogOnTransparent;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _AlphaCutoff;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _MainTex;
			half TVE_Amplitude2;
			sampler2D TVE_NoiseTex;
			half TVE_NoiseSpeed;
			half TVE_NoiseSize;
			half TVE_NoiseContrast;
			half TVE_Amplitude1;
			sampler2D TVE_MotionTex;
			half4 TVE_MotionCoord;
			half TVE_SizeFadeEnd;
			half TVE_SizeFadeStart;
			sampler2D TVE_ExtrasTex;
			half4 TVE_ExtrasCoord;
			sampler2D _MainAlbedoTex;


			float3 ObjectPosition_UNITY_MATRIX_M(  )
			{
				return float3(UNITY_MATRIX_M[0].w, UNITY_MATRIX_M[1].w, UNITY_MATRIX_M[2].w );
			}
			

			void BuildSurfaceData(FragInputs fragInputs, inout AlphaSurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);

				surfaceData.specularOcclusion = 1.0;

				// surface data

				// refraction
				#ifdef _HAS_REFRACTION
				if( _EnableSSRefraction )
				{
					surfaceData.transmittanceMask = ( 1.0 - surfaceDescription.Alpha );
					surfaceDescription.Alpha = 1.0;
				}
				else
				{
					surfaceData.ior = 1.0;
					surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
					surfaceData.atDistance = 1.0;
					surfaceData.transmittanceMask = 0.0;
					surfaceDescription.Alpha = 1.0;
				}
				#else
				surfaceData.ior = 1.0;
				surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
				surfaceData.atDistance = 1.0;
				surfaceData.transmittanceMask = 0.0;
				#endif


				// material features
				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif
				#ifdef ASE_LIT_CLEAR_COAT
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				// others
				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				// normals
				float3 normalTS = float3(0.0f, 0.0f, 1.0f);
				GetNormalWS( fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants );

				surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];

				bentNormalWS = surfaceData.normalWS;

				surfaceData.tangentWS = normalize( fragInputs.tangentToWorld[ 0 ].xyz );
				surfaceData.tangentWS = Orthonormalize( surfaceData.tangentWS, surfaceData.normalWS );

				// decals
				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#endif

				// debug
				#if defined(DEBUG_DISPLAY)
				if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
				{
					surfaceData.metallic = 0;
				}
				ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
				#endif
			}

			void GetSurfaceAndBuiltinData(AlphaSurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				//#ifdef _ALPHATEST_ON
				//#ifdef _ALPHATEST_SHADOW_ON
				//DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdShadow );
				//#else
				//DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				//#endif
				//#endif

				#ifdef _DEPTHOFFSET_ON
				builtinData.depthOffset = surfaceDescription.DepthOffset;
				ApplyDepthOffsetPositionInput( V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS );

				InitBuiltinData( posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[ 2 ], fragInputs.texCoord1, fragInputs.texCoord2, builtinData );

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			PackedVaryingsMeshToPS VertexFunction(AttributesMesh inputMesh )
			{
				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS;
				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( outputPackedVaryingsMeshToPS );

				half3 VertexPos40_g18271 = inputMesh.positionOS;
				float3 appendResult74_g18271 = (float3(0.0 , VertexPos40_g18271.y , 0.0));
				float3 VertexPosRotationAxis50_g18271 = appendResult74_g18271;
				float3 break84_g18271 = VertexPos40_g18271;
				float3 appendResult81_g18271 = (float3(break84_g18271.x , 0.0 , break84_g18271.z));
				float3 VertexPosOtherAxis82_g18271 = appendResult81_g18271;
				float ObjectData20_g18308 = 3.14;
				float Bounds_Radius121_g18123 = _MaxBoundsInfo.x;
				float WorldData19_g18308 = Bounds_Radius121_g18123;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18308 = WorldData19_g18308;
				#else
				float staticSwitch14_g18308 = ObjectData20_g18308;
				#endif
				float Motion_Max_Rolling1137_g18123 = staticSwitch14_g18308;
				half Global_Amplitude_270_g18123 = TVE_Amplitude2;
				half Mesh_Motion_260_g18123 = inputMesh.ase_texcoord3.y;
				float temp_output_4_0_g18291 = 1.0;
				float temp_output_5_0_g18291 = ( temp_output_4_0_g18291 * _TimeParameters.x );
				float2 temp_cast_0 = (TVE_NoiseSpeed).xx;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18290 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18290 = ( localObjectPosition_UNITY_MATRIX_M14_g18290 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18290 = localObjectPosition_UNITY_MATRIX_M14_g18290;
				#endif
				half3 ObjectData20_g18292 = staticSwitch13_g18290;
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				half3 WorldData19_g18292 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18292 = WorldData19_g18292;
				#else
				float3 staticSwitch14_g18292 = ObjectData20_g18292;
				#endif
				float2 panner73_g18289 = ( temp_output_5_0_g18291 * temp_cast_0 + ( (staticSwitch14_g18292).xz * TVE_NoiseSize ));
				float4 temp_cast_1 = (TVE_NoiseContrast).xxxx;
				float4 break142_g18289 = pow( abs( tex2Dlod( TVE_NoiseTex, float4( panner73_g18289, 0, 0.0) ) ) , temp_cast_1 );
				half Global_NoiseTex_R34_g18123 = break142_g18289.r;
				half Global_NoiseTex_G38_g18123 = break142_g18289.g;
				half Motion_Use20162_g18123 = _Motion_20;
				half MotionSpeed265_g18123 = _MotionSpeed_20;
				half Input_Speed62_g18262 = MotionSpeed265_g18123;
				float temp_output_4_0_g18265 = Input_Speed62_g18262;
				float temp_output_5_0_g18265 = ( temp_output_4_0_g18265 * _TimeParameters.x );
				half MotionVariation264_g18123 = _MotionVariation_20;
				float temp_output_342_0_g18262 = ( MotionVariation264_g18123 * inputMesh.ase_color.r );
				float3 localObjectPosition_UNITY_MATRIX_M14_g18263 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18263 = ( localObjectPosition_UNITY_MATRIX_M14_g18263 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18263 = localObjectPosition_UNITY_MATRIX_M14_g18263;
				#endif
				float3 break9_g18263 = staticSwitch13_g18263;
				float ObjectData20_g18264 = ( temp_output_342_0_g18262 + ( break9_g18263.x + break9_g18263.z ) );
				float WorldData19_g18264 = temp_output_342_0_g18262;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18264 = WorldData19_g18264;
				#else
				float staticSwitch14_g18264 = ObjectData20_g18264;
				#endif
				float Motion_Variation284_g18262 = staticSwitch14_g18264;
				half MotionScale262_g18123 = _MotionScale_20;
				float Motion_Scale287_g18262 = ( MotionScale262_g18123 * ase_worldPos.x );
				half Motion_Rolling138_g18123 = ( ( _MotionAmplitude_20 * Motion_Max_Rolling1137_g18123 ) * Global_Amplitude_270_g18123 * Mesh_Motion_260_g18123 * ( Global_NoiseTex_R34_g18123 + Global_NoiseTex_G38_g18123 ) * Motion_Use20162_g18123 * sin( ( temp_output_5_0_g18265 + Motion_Variation284_g18262 + Motion_Scale287_g18262 ) ) );
				half Angle44_g18271 = Motion_Rolling138_g18123;
				half3 VertexPos40_g18273 = ( VertexPosRotationAxis50_g18271 + ( VertexPosOtherAxis82_g18271 * cos( Angle44_g18271 ) ) + ( cross( float3(0,1,0) , VertexPosOtherAxis82_g18271 ) * sin( Angle44_g18271 ) ) );
				float3 appendResult74_g18273 = (float3(VertexPos40_g18273.x , 0.0 , 0.0));
				half3 VertexPosRotationAxis50_g18273 = appendResult74_g18273;
				float3 break84_g18273 = VertexPos40_g18273;
				float3 appendResult81_g18273 = (float3(0.0 , break84_g18273.y , break84_g18273.z));
				half3 VertexPosOtherAxis82_g18273 = appendResult81_g18273;
				float ObjectData20_g18309 = 3.14;
				float Bounds_Height374_g18123 = _MaxBoundsInfo.y;
				float WorldData19_g18309 = ( Bounds_Height374_g18123 * 3.14 );
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18309 = WorldData19_g18309;
				#else
				float staticSwitch14_g18309 = ObjectData20_g18309;
				#endif
				float Motion_Max_Bending1133_g18123 = staticSwitch14_g18309;
				half Global_Amplitude_136_g18123 = TVE_Amplitude1;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18268 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18268 = ( localObjectPosition_UNITY_MATRIX_M14_g18268 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18268 = localObjectPosition_UNITY_MATRIX_M14_g18268;
				#endif
				half3 ObjectData20_g18267 = staticSwitch13_g18268;
				half3 WorldData19_g18267 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18267 = WorldData19_g18267;
				#else
				float3 staticSwitch14_g18267 = ObjectData20_g18267;
				#endif
				float3 break322_g18294 = (tex2Dlod( TVE_MotionTex, float4( ( (TVE_MotionCoord).xy + ( TVE_MotionCoord.z * (staticSwitch14_g18267).xz ) ), 0, 0.0) )).rgb;
				float3 appendResult323_g18294 = (float3(break322_g18294.x , 0.0 , break322_g18294.y));
				float3 temp_output_324_0_g18294 = (appendResult323_g18294*2.0 + -1.0);
				float3 ase_parentObjectScale = ( 1.0 / float3( length( GetWorldToObjectMatrix()[ 0 ].xyz ), length( GetWorldToObjectMatrix()[ 1 ].xyz ), length( GetWorldToObjectMatrix()[ 2 ].xyz ) ) );
				half3 ObjectData20_g18295 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_324_0_g18294 , 0.0 ) ).xyz * ase_parentObjectScale );
				half3 WorldData19_g18295 = temp_output_324_0_g18294;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18295 = WorldData19_g18295;
				#else
				float3 staticSwitch14_g18295 = ObjectData20_g18295;
				#endif
				float2 temp_output_1976_320_g18123 = (staticSwitch14_g18295).xz;
				half2 Motion_DirectionOS39_g18123 = temp_output_1976_320_g18123;
				half Input_Speed62_g18245 = _MotionSpeed_10;
				float temp_output_4_0_g18246 = Input_Speed62_g18245;
				float temp_output_5_0_g18246 = ( temp_output_4_0_g18246 * _TimeParameters.x );
				float temp_output_349_0_g18245 = ( _MotionVariation_10 * inputMesh.ase_color.r );
				float3 localObjectPosition_UNITY_MATRIX_M14_g18249 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18249 = ( localObjectPosition_UNITY_MATRIX_M14_g18249 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18249 = localObjectPosition_UNITY_MATRIX_M14_g18249;
				#endif
				float3 break9_g18249 = staticSwitch13_g18249;
				float ObjectData20_g18248 = ( temp_output_349_0_g18245 + ( break9_g18249.x + break9_g18249.z ) );
				float WorldData19_g18248 = temp_output_349_0_g18245;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18248 = WorldData19_g18248;
				#else
				float staticSwitch14_g18248 = ObjectData20_g18248;
				#endif
				half Motion_Variation284_g18245 = staticSwitch14_g18248;
				float2 appendResult344_g18245 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 Motion_Scale287_g18245 = ( _MotionScale_10 * appendResult344_g18245 );
				half2 Sine_MinusOneToOne281_g18245 = sin( ( temp_output_5_0_g18246 + Motion_Variation284_g18245 + Motion_Scale287_g18245 ) );
				float2 temp_cast_4 = (1.0).xx;
				half Input_Turbulence327_g18245 = Global_NoiseTex_R34_g18123;
				float2 lerpResult321_g18245 = lerp( Sine_MinusOneToOne281_g18245 , temp_cast_4 , Input_Turbulence327_g18245);
				float2 temp_output_84_0_g18123 = ( ( _MotionAmplitude_10 * Motion_Max_Bending1133_g18123 ) * Global_Amplitude_136_g18123 * Global_NoiseTex_R34_g18123 * Motion_DirectionOS39_g18123 * lerpResult321_g18245 );
				float temp_output_1976_333_g18123 = break322_g18294.z;
				half2 Motion_Interaction53_g18123 = ( _InteractionAmplitude * Motion_Max_Bending1133_g18123 * temp_output_1976_320_g18123 * temp_output_1976_333_g18123 * temp_output_1976_333_g18123 );
				half Motion_InteractionMask66_g18123 = temp_output_1976_333_g18123;
				float2 lerpResult109_g18123 = lerp( temp_output_84_0_g18123 , Motion_Interaction53_g18123 , Motion_InteractionMask66_g18123);
				half Mesh_Motion_182_g18123 = inputMesh.ase_texcoord3.x;
				half Motion_Use1056_g18123 = ( _Motion_10 + ( _MotionCat * 0.0 ) );
				float2 break143_g18123 = ( lerpResult109_g18123 * Mesh_Motion_182_g18123 * Motion_Use1056_g18123 );
				half Motion_Z190_g18123 = break143_g18123.y;
				half Angle44_g18273 = Motion_Z190_g18123;
				half3 VertexPos40_g18281 = ( VertexPosRotationAxis50_g18273 + ( VertexPosOtherAxis82_g18273 * cos( Angle44_g18273 ) ) + ( cross( float3(1,0,0) , VertexPosOtherAxis82_g18273 ) * sin( Angle44_g18273 ) ) );
				float3 appendResult74_g18281 = (float3(0.0 , 0.0 , VertexPos40_g18281.z));
				half3 VertexPosRotationAxis50_g18281 = appendResult74_g18281;
				float3 break84_g18281 = VertexPos40_g18281;
				float3 appendResult81_g18281 = (float3(break84_g18281.x , break84_g18281.y , 0.0));
				half3 VertexPosOtherAxis82_g18281 = appendResult81_g18281;
				half Motion_X216_g18123 = break143_g18123.x;
				half Angle44_g18281 = -Motion_X216_g18123;
				half Global_NoiseTex_B132_g18123 = break142_g18289.b;
				half Input_Speed62_g18302 = -MotionSpeed265_g18123;
				float temp_output_4_0_g18305 = Input_Speed62_g18302;
				float temp_output_5_0_g18305 = ( temp_output_4_0_g18305 * _TimeParameters.x );
				float temp_output_342_0_g18302 = ( -MotionVariation264_g18123 * inputMesh.ase_color.r );
				float3 localObjectPosition_UNITY_MATRIX_M14_g18303 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18303 = ( localObjectPosition_UNITY_MATRIX_M14_g18303 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18303 = localObjectPosition_UNITY_MATRIX_M14_g18303;
				#endif
				float3 break9_g18303 = staticSwitch13_g18303;
				float ObjectData20_g18304 = ( temp_output_342_0_g18302 + ( break9_g18303.x + break9_g18303.z ) );
				float WorldData19_g18304 = temp_output_342_0_g18302;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18304 = WorldData19_g18304;
				#else
				float staticSwitch14_g18304 = ObjectData20_g18304;
				#endif
				float Motion_Variation284_g18302 = staticSwitch14_g18304;
				float Motion_Scale287_g18302 = ( MotionScale262_g18123 * ase_worldPos.x );
				float3 appendResult2014_g18123 = (float3(0.0 , ( ( _MotionVertical_20 * Bounds_Radius121_g18123 ) * Global_Amplitude_270_g18123 * Mesh_Motion_260_g18123 * Motion_Use20162_g18123 * ( Global_NoiseTex_R34_g18123 + Global_NoiseTex_B132_g18123 ) * sin( ( temp_output_5_0_g18305 + Motion_Variation284_g18302 + Motion_Scale287_g18302 ) ) ) , 0.0));
				half3 Motion_Vertical223_g18123 = appendResult2014_g18123;
				float3 Vertex_Motion_Object833_g18123 = ( ( VertexPosRotationAxis50_g18281 + ( VertexPosOtherAxis82_g18281 * cos( Angle44_g18281 ) ) + ( cross( float3(0,0,1) , VertexPosOtherAxis82_g18281 ) * sin( Angle44_g18281 ) ) ) + Motion_Vertical223_g18123 );
				half3 ObjectData20_g18272 = Vertex_Motion_Object833_g18123;
				float3 appendResult2047_g18123 = (float3(Motion_Rolling138_g18123 , 0.0 , -Motion_Rolling138_g18123));
				float3 appendResult2043_g18123 = (float3(Motion_X216_g18123 , 0.0 , Motion_Z190_g18123));
				float3 Vertex_Motion_World1118_g18123 = ( ( ( inputMesh.positionOS + appendResult2047_g18123 ) + appendResult2043_g18123 ) + Motion_Vertical223_g18123 );
				half3 WorldData19_g18272 = Vertex_Motion_World1118_g18123;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18272 = WorldData19_g18272;
				#else
				float3 staticSwitch14_g18272 = ObjectData20_g18272;
				#endif
				float3 localObjectPosition_UNITY_MATRIX_M14_g18274 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18274 = ( localObjectPosition_UNITY_MATRIX_M14_g18274 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18274 = localObjectPosition_UNITY_MATRIX_M14_g18274;
				#endif
				half Global_SizeFadeEnd287_g18123 = TVE_SizeFadeEnd;
				float temp_output_7_0_g18269 = Global_SizeFadeEnd287_g18123;
				half Global_SizeFadeStart276_g18123 = TVE_SizeFadeStart;
				float lerpResult348_g18123 = lerp( 1.0 , saturate( ( ( distance( _WorldSpaceCameraPos , staticSwitch13_g18274 ) - temp_output_7_0_g18269 ) / ( Global_SizeFadeStart276_g18123 - temp_output_7_0_g18269 ) ) ) , _GlobalSizeFade);
				float ObjectData20_g18278 = lerpResult348_g18123;
				float WorldData19_g18278 = 1.0;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18278 = WorldData19_g18278;
				#else
				float staticSwitch14_g18278 = ObjectData20_g18278;
				#endif
				float Vertex_SizeFade1740_g18123 = staticSwitch14_g18278;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18298 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18298 = ( localObjectPosition_UNITY_MATRIX_M14_g18298 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18298 = localObjectPosition_UNITY_MATRIX_M14_g18298;
				#endif
				half3 ObjectData20_g18299 = staticSwitch13_g18298;
				half3 WorldData19_g18299 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18299 = WorldData19_g18299;
				#else
				float3 staticSwitch14_g18299 = ObjectData20_g18299;
				#endif
				float4 tex2DNode7_g18297 = tex2Dlod( TVE_ExtrasTex, float4( ( (TVE_ExtrasCoord).xy + ( TVE_ExtrasCoord.z * (staticSwitch14_g18299).xz ) ), 0, 0.0) );
				half Global_ExtrasTex_G305_g18123 = tex2DNode7_g18297.g;
				float lerpResult346_g18123 = lerp( 1.0 , Global_ExtrasTex_G305_g18123 , _GlobalSize);
				float ObjectData20_g18270 = lerpResult346_g18123;
				float WorldData19_g18270 = 1.0;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18270 = WorldData19_g18270;
				#else
				float staticSwitch14_g18270 = ObjectData20_g18270;
				#endif
				half Vertex_Size1741_g18123 = staticSwitch14_g18270;
				float3 Final_Vertex890_g18123 = ( ( staticSwitch14_g18272 * Vertex_SizeFade1740_g18123 * Vertex_Size1741_g18123 ) + ( _IsHDPipeline * 0.0 ) );
				
				outputPackedVaryingsMeshToPS.ase_texcoord1 = inputMesh.ase_texcoord;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = Final_Vertex890_g18123;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif

				inputMesh.normalOS =  inputMesh.normalOS ;

				float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
				outputPackedVaryingsMeshToPS.positionCS = TransformWorldToHClip(positionRWS);
				outputPackedVaryingsMeshToPS.interp00.xyz = positionRWS;
				return outputPackedVaryingsMeshToPS;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float3 positionOS : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl Vert ( AttributesMesh v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.positionOS = v.positionOS;
				o.normalOS = v.normalOS;
				o.ase_texcoord3 = v.ase_texcoord3;
				o.ase_color = v.ase_color;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if (SHADEROPTIONS_CAMERA_RELATIVE_RENDERING != 0)
				float3 cameraPos = 0;
				#else
				float3 cameraPos = _WorldSpaceCameraPos;
				#endif
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), cameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, GetObjectToWorldMatrix(), cameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), cameraPos, _ScreenParams, _FrustumPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			PackedVaryingsMeshToPS DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				AttributesMesh o = (AttributesMesh) 0;
				o.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.ase_texcoord3 = patch[0].ase_texcoord3 * bary.x + patch[1].ase_texcoord3 * bary.y + patch[2].ase_texcoord3 * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			PackedVaryingsMeshToPS Vert ( AttributesMesh v )
			{
				return VertexFunction( v );
			}
			#endif
			
			void Frag( PackedVaryingsMeshToPS packedInput
						#ifdef WRITE_NORMAL_BUFFER
						, out float4 outNormalBuffer : SV_Target0
							#ifdef WRITE_MSAA_DEPTH
							, out float1 depthColor : SV_Target1
							#endif
						#elif defined(WRITE_MSAA_DEPTH)
						, out float4 outNormalBuffer : SV_Target0
						, out float1 depthColor : SV_Target1
						#elif defined(SCENESELECTIONPASS)
						, out float4 outColor : SV_Target0
						#endif
						#ifdef _DEPTHOFFSET_ON
						, out float outputDepth : SV_Depth
						#endif
						
					)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( packedInput );
				UNITY_SETUP_INSTANCE_ID( packedInput );

				float3 positionRWS = packedInput.interp00.xyz;

				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);

				input.tangentToWorld = k_identity3x3;
				input.positionSS = packedInput.positionCS;

				input.positionRWS = positionRWS;

				#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false);
				#elif SHADER_STAGE_FRAGMENT
				#if defined(ASE_NEED_CULLFACE)
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false );
				#endif
				#endif
				half isFrontFace = input.isFrontFace;

				PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

				float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);

				AlphaSurfaceDescription surfaceDescription = (AlphaSurfaceDescription)0;
				float2 Main_UVs15_g18123 = ( ( packedInput.ase_texcoord1.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				float4 tex2DNode29_g18123 = tex2D( _MainAlbedoTex, Main_UVs15_g18123 );
				float4 temp_output_51_0_g18123 = ( _MainColor * tex2DNode29_g18123 );
				half Main_Alpha316_g18123 = (temp_output_51_0_g18123).a;
				
				float localCustomAlphaClip9_g18277 = ( 0.0 );
				half Main_AlphaRaw1203_g18123 = tex2DNode29_g18123.a;
				half Alpha5_g18277 = Main_AlphaRaw1203_g18123;
				float Alpha9_g18277 = Alpha5_g18277;
				float AlphaClipThreshold9_g18277 = _Cutoff;
				#if _ALPHATEST_ON
				clip(Alpha9_g18277 - AlphaClipThreshold9_g18277);
				#endif
				half Final_Clip914_g18123 = localCustomAlphaClip9_g18277;
				
				surfaceDescription.Alpha = Main_Alpha316_g18123;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = Final_Clip914_g18123;
				#endif

				#ifdef _ALPHATEST_SHADOW_ON
				surfaceDescription.AlphaClipThresholdShadow = 0.5;
				#endif

				#ifdef _DEPTHOFFSET_ON
				surfaceDescription.DepthOffset = 0;
				#endif

				SurfaceData surfaceData;
				BuiltinData builtinData;
				GetSurfaceAndBuiltinData(surfaceDescription, input, V, posInput, surfaceData, builtinData);

				#ifdef _DEPTHOFFSET_ON
				outputDepth = posInput.deviceDepth;
				#endif

				#ifdef WRITE_NORMAL_BUFFER
				EncodeIntoNormalBuffer( ConvertSurfaceDataToNormalData( surfaceData ), posInput.positionSS, outNormalBuffer );
				#ifdef WRITE_MSAA_DEPTH
				depthColor = packedInput.positionCS.z;
				#endif
				#elif defined(WRITE_MSAA_DEPTH)
				outNormalBuffer = float4( 0.0, 0.0, 0.0, 1.0 );
				depthColor = packedInput.positionCS.z;
				#elif defined(SCENESELECTIONPASS)
				outColor = float4( _ObjectId, _PassValue, 1.0, 1.0 );
				#endif
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "SceneSelectionPass"
			Tags { "LightMode"="SceneSelectionPass" }
			ColorMask 0

			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define _DISABLE_DECALS 1
			#define _DISABLE_SSR 1
			#define _SPECULAR_OCCLUSION_FROM_AO 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _AMBIENT_OCCLUSION 1
			#define HAVE_MESH_MODIFICATION
			#define ASE_SRP_VERSION 70201


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
			#pragma shader_feature_local _ENABLE_FOG_ON_TRANSPARENT
			#pragma shader_feature_local _ALPHATEST_ON

			#define SHADERPASS SHADERPASS_DEPTH_ONLY
			#define SCENESELECTIONPASS
			#pragma editor_sync_compilation

			#pragma vertex Vert
			#pragma fragment Frag

			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
			#ifdef DEBUG_DISPLAY
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
			#endif
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature _ALPHATEST_ON
			  
			//SHADER INJECTION POINT BEGIN
			//SHADER INJECTION POINT END
			    
			#pragma shader_feature MATERIAL_USE_OBJECT_DATA MATERIAL_USE_WORLD_DATA


			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif

			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 positionCS : SV_Position;
				float3 interp00 : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			int _ObjectId;
			int _PassValue;

			CBUFFER_START( UnityPerMaterial )
			half4 _MainUVs;
			float4 _Color;
			half4 _SecondColor;
			half4 _SecondUVs;
			float4 _MaxBoundsInfo;
			float4 _SubsurfaceDiffusion_asset;
			half4 _MainColor;
			half3 _render_normals_options;
			half _MotionVertical_20;
			half _MotionCat;
			half _Motion_10;
			half _InteractionAmplitude;
			float _MotionScale_10;
			half _MotionVariation_10;
			half _MotionAmplitude_10;
			float _MotionScale_20;
			half _MotionVariation_20;
			float _MotionSpeed_20;
			half _Motion_20;
			half _MotionAmplitude_20;
			half _IsStandardShader;
			half _material_batching;
			half _BatchingMessage;
			float _MotionSpeed_10;
			half _GlobalSizeFade;
			half _IsLitShader;
			half _IsHDPipeline;
			half _ObjectOcclusionValue;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half __premul;
			half _GlobalOverlay;
			half _OverlayContrast;
			half _SecondNormalValue;
			half _MainNormalValue;
			half _OverlayUVTilling;
			half _DetailShadingCat;
			half _DetailMode;
			half _DetailMaskContrast;
			half _DetailMaskValue;
			half _MaskMode;
			half _DetailMeshValue;
			half _IsVersion;
			half _GlobalSize;
			float _MotionScale_32;
			float _MotionVariation_32;
			float _MotionVariation_30;
			half __zw;
			half __blend;
			half _render_mode;
			half __clip;
			half _render_priority;
			half _render_dst;
			half _GlobalSettingsCat;
			half _render_clip;
			half _MaterialShadingCat;
			half _AdvancedCat;
			half _ObjectThicknessValue;
			half _RenderingCat;
			half _RenderMode_ResetInteractive;
			half _IsTVEShader;
			half _VertexOcclusion;
			half _IsBarkShader;
			half _IsAnyPathShader;
			half _Banner;
			half _MainMaskValue;
			half _render_blend;
			half _render_zw;
			half _Cutoff;
			half __surface;
			float _MotionSpeed_32;
			half _MotionAmplitude_30;
			float _MotionSpeed_30;
			float _MotionScale_30;
			half _MotionAmplitude_32;
			half _MainColorMode;
			half __dst;
			half _render_cull;
			half _AlphaClipInteractive;
			half _render_src;
			float _SubsurfaceMode;
			half __priority;
			half _MainShadingCat;
			half __src;
			half __normals;
			half __cull;
			half _render_normals;
			half _RenderMode_TransparentInteractive;
			half _MainOcclusionValue;
			half _SecondOcclusionValue;
			float4 _EmissionColor;
			float _RenderQueueType;
			#ifdef _ADD_PRECOMPUTED_VELOCITY
			float _AddPrecomputedVelocity;
			#endif
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _TransparentZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _EnableFogOnTransparent;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _AlphaCutoff;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			sampler2D _MainTex;
			half TVE_Amplitude2;
			sampler2D TVE_NoiseTex;
			half TVE_NoiseSpeed;
			half TVE_NoiseSize;
			half TVE_NoiseContrast;
			half TVE_Amplitude1;
			sampler2D TVE_MotionTex;
			half4 TVE_MotionCoord;
			half TVE_SizeFadeEnd;
			half TVE_SizeFadeStart;
			sampler2D TVE_ExtrasTex;
			half4 TVE_ExtrasCoord;
			sampler2D _MainAlbedoTex;


			float3 ObjectPosition_UNITY_MATRIX_M(  )
			{
				return float3(UNITY_MATRIX_M[0].w, UNITY_MATRIX_M[1].w, UNITY_MATRIX_M[2].w );
			}
			

			void BuildSurfaceData(FragInputs fragInputs, inout SceneSurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);

				surfaceData.specularOcclusion = 1.0;

				// surface data

				// refraction
				#ifdef _HAS_REFRACTION
				if( _EnableSSRefraction )
				{
					surfaceData.transmittanceMask = ( 1.0 - surfaceDescription.Alpha );
					surfaceDescription.Alpha = 1.0;
				}
				else
				{
					surfaceData.ior = 1.0;
					surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
					surfaceData.atDistance = 1.0;
					surfaceData.transmittanceMask = 0.0;
					surfaceDescription.Alpha = 1.0;
				}
				#else
				surfaceData.ior = 1.0;
				surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
				surfaceData.atDistance = 1.0;
				surfaceData.transmittanceMask = 0.0;
				#endif


				// material features
				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif
				#ifdef ASE_LIT_CLEAR_COAT
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				// others
				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				// normals
				float3 normalTS = float3(0.0f, 0.0f, 1.0f);
				GetNormalWS( fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants );

				surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];

				bentNormalWS = surfaceData.normalWS;

				surfaceData.tangentWS = normalize( fragInputs.tangentToWorld[ 0 ].xyz );
				surfaceData.tangentWS = Orthonormalize( surfaceData.tangentWS, surfaceData.normalWS );

				// decals
				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#endif

				// debug
				#if defined(DEBUG_DISPLAY)
				if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
				{
					surfaceData.metallic = 0;
				}
				ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
				#endif
			}

			void GetSurfaceAndBuiltinData(SceneSurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				//#ifdef _ALPHATEST_ON
				//DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				//#endif

				#ifdef _DEPTHOFFSET_ON
				builtinData.depthOffset = surfaceDescription.DepthOffset;
				ApplyDepthOffsetPositionInput( V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS );

				InitBuiltinData( posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[ 2 ], fragInputs.texCoord1, fragInputs.texCoord2, builtinData );

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			PackedVaryingsMeshToPS VertexFunction(AttributesMesh inputMesh )
			{
				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS;
				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( outputPackedVaryingsMeshToPS );

				half3 VertexPos40_g18271 = inputMesh.positionOS;
				float3 appendResult74_g18271 = (float3(0.0 , VertexPos40_g18271.y , 0.0));
				float3 VertexPosRotationAxis50_g18271 = appendResult74_g18271;
				float3 break84_g18271 = VertexPos40_g18271;
				float3 appendResult81_g18271 = (float3(break84_g18271.x , 0.0 , break84_g18271.z));
				float3 VertexPosOtherAxis82_g18271 = appendResult81_g18271;
				float ObjectData20_g18308 = 3.14;
				float Bounds_Radius121_g18123 = _MaxBoundsInfo.x;
				float WorldData19_g18308 = Bounds_Radius121_g18123;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18308 = WorldData19_g18308;
				#else
				float staticSwitch14_g18308 = ObjectData20_g18308;
				#endif
				float Motion_Max_Rolling1137_g18123 = staticSwitch14_g18308;
				half Global_Amplitude_270_g18123 = TVE_Amplitude2;
				half Mesh_Motion_260_g18123 = inputMesh.ase_texcoord3.y;
				float temp_output_4_0_g18291 = 1.0;
				float temp_output_5_0_g18291 = ( temp_output_4_0_g18291 * _TimeParameters.x );
				float2 temp_cast_0 = (TVE_NoiseSpeed).xx;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18290 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18290 = ( localObjectPosition_UNITY_MATRIX_M14_g18290 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18290 = localObjectPosition_UNITY_MATRIX_M14_g18290;
				#endif
				half3 ObjectData20_g18292 = staticSwitch13_g18290;
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				half3 WorldData19_g18292 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18292 = WorldData19_g18292;
				#else
				float3 staticSwitch14_g18292 = ObjectData20_g18292;
				#endif
				float2 panner73_g18289 = ( temp_output_5_0_g18291 * temp_cast_0 + ( (staticSwitch14_g18292).xz * TVE_NoiseSize ));
				float4 temp_cast_1 = (TVE_NoiseContrast).xxxx;
				float4 break142_g18289 = pow( abs( tex2Dlod( TVE_NoiseTex, float4( panner73_g18289, 0, 0.0) ) ) , temp_cast_1 );
				half Global_NoiseTex_R34_g18123 = break142_g18289.r;
				half Global_NoiseTex_G38_g18123 = break142_g18289.g;
				half Motion_Use20162_g18123 = _Motion_20;
				half MotionSpeed265_g18123 = _MotionSpeed_20;
				half Input_Speed62_g18262 = MotionSpeed265_g18123;
				float temp_output_4_0_g18265 = Input_Speed62_g18262;
				float temp_output_5_0_g18265 = ( temp_output_4_0_g18265 * _TimeParameters.x );
				half MotionVariation264_g18123 = _MotionVariation_20;
				float temp_output_342_0_g18262 = ( MotionVariation264_g18123 * inputMesh.ase_color.r );
				float3 localObjectPosition_UNITY_MATRIX_M14_g18263 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18263 = ( localObjectPosition_UNITY_MATRIX_M14_g18263 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18263 = localObjectPosition_UNITY_MATRIX_M14_g18263;
				#endif
				float3 break9_g18263 = staticSwitch13_g18263;
				float ObjectData20_g18264 = ( temp_output_342_0_g18262 + ( break9_g18263.x + break9_g18263.z ) );
				float WorldData19_g18264 = temp_output_342_0_g18262;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18264 = WorldData19_g18264;
				#else
				float staticSwitch14_g18264 = ObjectData20_g18264;
				#endif
				float Motion_Variation284_g18262 = staticSwitch14_g18264;
				half MotionScale262_g18123 = _MotionScale_20;
				float Motion_Scale287_g18262 = ( MotionScale262_g18123 * ase_worldPos.x );
				half Motion_Rolling138_g18123 = ( ( _MotionAmplitude_20 * Motion_Max_Rolling1137_g18123 ) * Global_Amplitude_270_g18123 * Mesh_Motion_260_g18123 * ( Global_NoiseTex_R34_g18123 + Global_NoiseTex_G38_g18123 ) * Motion_Use20162_g18123 * sin( ( temp_output_5_0_g18265 + Motion_Variation284_g18262 + Motion_Scale287_g18262 ) ) );
				half Angle44_g18271 = Motion_Rolling138_g18123;
				half3 VertexPos40_g18273 = ( VertexPosRotationAxis50_g18271 + ( VertexPosOtherAxis82_g18271 * cos( Angle44_g18271 ) ) + ( cross( float3(0,1,0) , VertexPosOtherAxis82_g18271 ) * sin( Angle44_g18271 ) ) );
				float3 appendResult74_g18273 = (float3(VertexPos40_g18273.x , 0.0 , 0.0));
				half3 VertexPosRotationAxis50_g18273 = appendResult74_g18273;
				float3 break84_g18273 = VertexPos40_g18273;
				float3 appendResult81_g18273 = (float3(0.0 , break84_g18273.y , break84_g18273.z));
				half3 VertexPosOtherAxis82_g18273 = appendResult81_g18273;
				float ObjectData20_g18309 = 3.14;
				float Bounds_Height374_g18123 = _MaxBoundsInfo.y;
				float WorldData19_g18309 = ( Bounds_Height374_g18123 * 3.14 );
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18309 = WorldData19_g18309;
				#else
				float staticSwitch14_g18309 = ObjectData20_g18309;
				#endif
				float Motion_Max_Bending1133_g18123 = staticSwitch14_g18309;
				half Global_Amplitude_136_g18123 = TVE_Amplitude1;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18268 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18268 = ( localObjectPosition_UNITY_MATRIX_M14_g18268 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18268 = localObjectPosition_UNITY_MATRIX_M14_g18268;
				#endif
				half3 ObjectData20_g18267 = staticSwitch13_g18268;
				half3 WorldData19_g18267 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18267 = WorldData19_g18267;
				#else
				float3 staticSwitch14_g18267 = ObjectData20_g18267;
				#endif
				float3 break322_g18294 = (tex2Dlod( TVE_MotionTex, float4( ( (TVE_MotionCoord).xy + ( TVE_MotionCoord.z * (staticSwitch14_g18267).xz ) ), 0, 0.0) )).rgb;
				float3 appendResult323_g18294 = (float3(break322_g18294.x , 0.0 , break322_g18294.y));
				float3 temp_output_324_0_g18294 = (appendResult323_g18294*2.0 + -1.0);
				float3 ase_parentObjectScale = ( 1.0 / float3( length( GetWorldToObjectMatrix()[ 0 ].xyz ), length( GetWorldToObjectMatrix()[ 1 ].xyz ), length( GetWorldToObjectMatrix()[ 2 ].xyz ) ) );
				half3 ObjectData20_g18295 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_324_0_g18294 , 0.0 ) ).xyz * ase_parentObjectScale );
				half3 WorldData19_g18295 = temp_output_324_0_g18294;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18295 = WorldData19_g18295;
				#else
				float3 staticSwitch14_g18295 = ObjectData20_g18295;
				#endif
				float2 temp_output_1976_320_g18123 = (staticSwitch14_g18295).xz;
				half2 Motion_DirectionOS39_g18123 = temp_output_1976_320_g18123;
				half Input_Speed62_g18245 = _MotionSpeed_10;
				float temp_output_4_0_g18246 = Input_Speed62_g18245;
				float temp_output_5_0_g18246 = ( temp_output_4_0_g18246 * _TimeParameters.x );
				float temp_output_349_0_g18245 = ( _MotionVariation_10 * inputMesh.ase_color.r );
				float3 localObjectPosition_UNITY_MATRIX_M14_g18249 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18249 = ( localObjectPosition_UNITY_MATRIX_M14_g18249 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18249 = localObjectPosition_UNITY_MATRIX_M14_g18249;
				#endif
				float3 break9_g18249 = staticSwitch13_g18249;
				float ObjectData20_g18248 = ( temp_output_349_0_g18245 + ( break9_g18249.x + break9_g18249.z ) );
				float WorldData19_g18248 = temp_output_349_0_g18245;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18248 = WorldData19_g18248;
				#else
				float staticSwitch14_g18248 = ObjectData20_g18248;
				#endif
				half Motion_Variation284_g18245 = staticSwitch14_g18248;
				float2 appendResult344_g18245 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 Motion_Scale287_g18245 = ( _MotionScale_10 * appendResult344_g18245 );
				half2 Sine_MinusOneToOne281_g18245 = sin( ( temp_output_5_0_g18246 + Motion_Variation284_g18245 + Motion_Scale287_g18245 ) );
				float2 temp_cast_4 = (1.0).xx;
				half Input_Turbulence327_g18245 = Global_NoiseTex_R34_g18123;
				float2 lerpResult321_g18245 = lerp( Sine_MinusOneToOne281_g18245 , temp_cast_4 , Input_Turbulence327_g18245);
				float2 temp_output_84_0_g18123 = ( ( _MotionAmplitude_10 * Motion_Max_Bending1133_g18123 ) * Global_Amplitude_136_g18123 * Global_NoiseTex_R34_g18123 * Motion_DirectionOS39_g18123 * lerpResult321_g18245 );
				float temp_output_1976_333_g18123 = break322_g18294.z;
				half2 Motion_Interaction53_g18123 = ( _InteractionAmplitude * Motion_Max_Bending1133_g18123 * temp_output_1976_320_g18123 * temp_output_1976_333_g18123 * temp_output_1976_333_g18123 );
				half Motion_InteractionMask66_g18123 = temp_output_1976_333_g18123;
				float2 lerpResult109_g18123 = lerp( temp_output_84_0_g18123 , Motion_Interaction53_g18123 , Motion_InteractionMask66_g18123);
				half Mesh_Motion_182_g18123 = inputMesh.ase_texcoord3.x;
				half Motion_Use1056_g18123 = ( _Motion_10 + ( _MotionCat * 0.0 ) );
				float2 break143_g18123 = ( lerpResult109_g18123 * Mesh_Motion_182_g18123 * Motion_Use1056_g18123 );
				half Motion_Z190_g18123 = break143_g18123.y;
				half Angle44_g18273 = Motion_Z190_g18123;
				half3 VertexPos40_g18281 = ( VertexPosRotationAxis50_g18273 + ( VertexPosOtherAxis82_g18273 * cos( Angle44_g18273 ) ) + ( cross( float3(1,0,0) , VertexPosOtherAxis82_g18273 ) * sin( Angle44_g18273 ) ) );
				float3 appendResult74_g18281 = (float3(0.0 , 0.0 , VertexPos40_g18281.z));
				half3 VertexPosRotationAxis50_g18281 = appendResult74_g18281;
				float3 break84_g18281 = VertexPos40_g18281;
				float3 appendResult81_g18281 = (float3(break84_g18281.x , break84_g18281.y , 0.0));
				half3 VertexPosOtherAxis82_g18281 = appendResult81_g18281;
				half Motion_X216_g18123 = break143_g18123.x;
				half Angle44_g18281 = -Motion_X216_g18123;
				half Global_NoiseTex_B132_g18123 = break142_g18289.b;
				half Input_Speed62_g18302 = -MotionSpeed265_g18123;
				float temp_output_4_0_g18305 = Input_Speed62_g18302;
				float temp_output_5_0_g18305 = ( temp_output_4_0_g18305 * _TimeParameters.x );
				float temp_output_342_0_g18302 = ( -MotionVariation264_g18123 * inputMesh.ase_color.r );
				float3 localObjectPosition_UNITY_MATRIX_M14_g18303 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18303 = ( localObjectPosition_UNITY_MATRIX_M14_g18303 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18303 = localObjectPosition_UNITY_MATRIX_M14_g18303;
				#endif
				float3 break9_g18303 = staticSwitch13_g18303;
				float ObjectData20_g18304 = ( temp_output_342_0_g18302 + ( break9_g18303.x + break9_g18303.z ) );
				float WorldData19_g18304 = temp_output_342_0_g18302;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18304 = WorldData19_g18304;
				#else
				float staticSwitch14_g18304 = ObjectData20_g18304;
				#endif
				float Motion_Variation284_g18302 = staticSwitch14_g18304;
				float Motion_Scale287_g18302 = ( MotionScale262_g18123 * ase_worldPos.x );
				float3 appendResult2014_g18123 = (float3(0.0 , ( ( _MotionVertical_20 * Bounds_Radius121_g18123 ) * Global_Amplitude_270_g18123 * Mesh_Motion_260_g18123 * Motion_Use20162_g18123 * ( Global_NoiseTex_R34_g18123 + Global_NoiseTex_B132_g18123 ) * sin( ( temp_output_5_0_g18305 + Motion_Variation284_g18302 + Motion_Scale287_g18302 ) ) ) , 0.0));
				half3 Motion_Vertical223_g18123 = appendResult2014_g18123;
				float3 Vertex_Motion_Object833_g18123 = ( ( VertexPosRotationAxis50_g18281 + ( VertexPosOtherAxis82_g18281 * cos( Angle44_g18281 ) ) + ( cross( float3(0,0,1) , VertexPosOtherAxis82_g18281 ) * sin( Angle44_g18281 ) ) ) + Motion_Vertical223_g18123 );
				half3 ObjectData20_g18272 = Vertex_Motion_Object833_g18123;
				float3 appendResult2047_g18123 = (float3(Motion_Rolling138_g18123 , 0.0 , -Motion_Rolling138_g18123));
				float3 appendResult2043_g18123 = (float3(Motion_X216_g18123 , 0.0 , Motion_Z190_g18123));
				float3 Vertex_Motion_World1118_g18123 = ( ( ( inputMesh.positionOS + appendResult2047_g18123 ) + appendResult2043_g18123 ) + Motion_Vertical223_g18123 );
				half3 WorldData19_g18272 = Vertex_Motion_World1118_g18123;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18272 = WorldData19_g18272;
				#else
				float3 staticSwitch14_g18272 = ObjectData20_g18272;
				#endif
				float3 localObjectPosition_UNITY_MATRIX_M14_g18274 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18274 = ( localObjectPosition_UNITY_MATRIX_M14_g18274 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18274 = localObjectPosition_UNITY_MATRIX_M14_g18274;
				#endif
				half Global_SizeFadeEnd287_g18123 = TVE_SizeFadeEnd;
				float temp_output_7_0_g18269 = Global_SizeFadeEnd287_g18123;
				half Global_SizeFadeStart276_g18123 = TVE_SizeFadeStart;
				float lerpResult348_g18123 = lerp( 1.0 , saturate( ( ( distance( _WorldSpaceCameraPos , staticSwitch13_g18274 ) - temp_output_7_0_g18269 ) / ( Global_SizeFadeStart276_g18123 - temp_output_7_0_g18269 ) ) ) , _GlobalSizeFade);
				float ObjectData20_g18278 = lerpResult348_g18123;
				float WorldData19_g18278 = 1.0;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18278 = WorldData19_g18278;
				#else
				float staticSwitch14_g18278 = ObjectData20_g18278;
				#endif
				float Vertex_SizeFade1740_g18123 = staticSwitch14_g18278;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18298 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18298 = ( localObjectPosition_UNITY_MATRIX_M14_g18298 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18298 = localObjectPosition_UNITY_MATRIX_M14_g18298;
				#endif
				half3 ObjectData20_g18299 = staticSwitch13_g18298;
				half3 WorldData19_g18299 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18299 = WorldData19_g18299;
				#else
				float3 staticSwitch14_g18299 = ObjectData20_g18299;
				#endif
				float4 tex2DNode7_g18297 = tex2Dlod( TVE_ExtrasTex, float4( ( (TVE_ExtrasCoord).xy + ( TVE_ExtrasCoord.z * (staticSwitch14_g18299).xz ) ), 0, 0.0) );
				half Global_ExtrasTex_G305_g18123 = tex2DNode7_g18297.g;
				float lerpResult346_g18123 = lerp( 1.0 , Global_ExtrasTex_G305_g18123 , _GlobalSize);
				float ObjectData20_g18270 = lerpResult346_g18123;
				float WorldData19_g18270 = 1.0;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18270 = WorldData19_g18270;
				#else
				float staticSwitch14_g18270 = ObjectData20_g18270;
				#endif
				half Vertex_Size1741_g18123 = staticSwitch14_g18270;
				float3 Final_Vertex890_g18123 = ( ( staticSwitch14_g18272 * Vertex_SizeFade1740_g18123 * Vertex_Size1741_g18123 ) + ( _IsHDPipeline * 0.0 ) );
				
				outputPackedVaryingsMeshToPS.ase_texcoord1 = inputMesh.ase_texcoord;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = Final_Vertex890_g18123;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif

				inputMesh.normalOS =  inputMesh.normalOS ;

				float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
				outputPackedVaryingsMeshToPS.positionCS = TransformWorldToHClip(positionRWS);
				outputPackedVaryingsMeshToPS.interp00.xyz = positionRWS;
				return outputPackedVaryingsMeshToPS;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float3 positionOS : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl Vert ( AttributesMesh v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.positionOS = v.positionOS;
				o.normalOS = v.normalOS;
				o.ase_texcoord3 = v.ase_texcoord3;
				o.ase_color = v.ase_color;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if (SHADEROPTIONS_CAMERA_RELATIVE_RENDERING != 0)
				float3 cameraPos = 0;
				#else
				float3 cameraPos = _WorldSpaceCameraPos;
				#endif
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), cameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, GetObjectToWorldMatrix(), cameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), cameraPos, _ScreenParams, _FrustumPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			PackedVaryingsMeshToPS DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				AttributesMesh o = (AttributesMesh) 0;
				o.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.ase_texcoord3 = patch[0].ase_texcoord3 * bary.x + patch[1].ase_texcoord3 * bary.y + patch[2].ase_texcoord3 * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			PackedVaryingsMeshToPS Vert ( AttributesMesh v )
			{
				return VertexFunction( v );
			}
			#endif

			void Frag( PackedVaryingsMeshToPS packedInput
						#ifdef WRITE_NORMAL_BUFFER
						, out float4 outNormalBuffer : SV_Target0
							#ifdef WRITE_MSAA_DEPTH
							, out float1 depthColor : SV_Target1
							#endif
						#elif defined(WRITE_MSAA_DEPTH)
						, out float4 outNormalBuffer : SV_Target0
						, out float1 depthColor : SV_Target1
						#elif defined(SCENESELECTIONPASS)
						, out float4 outColor : SV_Target0
						#endif
						#ifdef _DEPTHOFFSET_ON
						, out float outputDepth : SV_Depth
						#endif
						
					)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( packedInput );
				UNITY_SETUP_INSTANCE_ID( packedInput );

				float3 positionRWS = packedInput.interp00.xyz;

				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);

				input.tangentToWorld = k_identity3x3;
				input.positionSS = packedInput.positionCS;

				input.positionRWS = positionRWS;

				#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false);
				#elif SHADER_STAGE_FRAGMENT
				#if defined(ASE_NEED_CULLFACE)
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false );
				#endif
				#endif
				half isFrontFace = input.isFrontFace;

				PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

				float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);

				SceneSurfaceDescription surfaceDescription = (SceneSurfaceDescription)0;
				float2 Main_UVs15_g18123 = ( ( packedInput.ase_texcoord1.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				float4 tex2DNode29_g18123 = tex2D( _MainAlbedoTex, Main_UVs15_g18123 );
				float4 temp_output_51_0_g18123 = ( _MainColor * tex2DNode29_g18123 );
				half Main_Alpha316_g18123 = (temp_output_51_0_g18123).a;
				
				float localCustomAlphaClip9_g18277 = ( 0.0 );
				half Main_AlphaRaw1203_g18123 = tex2DNode29_g18123.a;
				half Alpha5_g18277 = Main_AlphaRaw1203_g18123;
				float Alpha9_g18277 = Alpha5_g18277;
				float AlphaClipThreshold9_g18277 = _Cutoff;
				#if _ALPHATEST_ON
				clip(Alpha9_g18277 - AlphaClipThreshold9_g18277);
				#endif
				half Final_Clip914_g18123 = localCustomAlphaClip9_g18277;
				
				surfaceDescription.Alpha = Main_Alpha316_g18123;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = Final_Clip914_g18123;
				#endif

				#ifdef _DEPTHOFFSET_ON
				surfaceDescription.DepthOffset = 0;
				#endif

				SurfaceData surfaceData;
				BuiltinData builtinData;
				GetSurfaceAndBuiltinData(surfaceDescription, input, V, posInput, surfaceData, builtinData);

				#ifdef _DEPTHOFFSET_ON
				outputDepth = posInput.deviceDepth;
				#endif

				#ifdef WRITE_NORMAL_BUFFER
				EncodeIntoNormalBuffer( ConvertSurfaceDataToNormalData( surfaceData ), posInput.positionSS, outNormalBuffer );
				#ifdef WRITE_MSAA_DEPTH
				depthColor = packedInput.positionCS.z;
				#endif
				#elif defined(WRITE_MSAA_DEPTH)
				outNormalBuffer = float4( 0.0, 0.0, 0.0, 1.0 );
				depthColor = packedInput.positionCS.z;
				#elif defined(SCENESELECTIONPASS)
				outColor = float4( _ObjectId, _PassValue, 1.0, 1.0 );
				#endif
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			Cull [_CullMode]

			ZWrite On

			Stencil
			{
				Ref [_StencilRefDepth]
				WriteMask [_StencilWriteMaskDepth]
				Comp Always
				Pass Replace
				Fail Keep
				ZFail Keep
			}


			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define _DISABLE_DECALS 1
			#define _DISABLE_SSR 1
			#define _SPECULAR_OCCLUSION_FROM_AO 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _AMBIENT_OCCLUSION 1
			#define HAVE_MESH_MODIFICATION
			#define ASE_SRP_VERSION 70201
			#if !defined(ASE_NEED_CULLFACE)
			#define ASE_NEED_CULLFACE 1
			#endif //ASE_NEED_CULLFACE


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
			#pragma shader_feature_local _ENABLE_FOG_ON_TRANSPARENT
			#pragma shader_feature_local _ALPHATEST_ON

			#define SHADERPASS SHADERPASS_DEPTH_ONLY
			#pragma multi_compile _ WRITE_NORMAL_BUFFER
			#pragma multi_compile _ WRITE_MSAA_DEPTH

			#pragma vertex Vert
			#pragma fragment Frag

			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
			#ifdef DEBUG_DISPLAY
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
			#endif
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_VFACE
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_TANGENT
			#define ASE_NEEDS_FRAG_RELATIVE_WORLD_POS
			#pragma shader_feature _ALPHATEST_ON
			#pragma shader_feature MATERIAL_USE_DETAIL_OFF MATERIAL_USE_DETAIL_OVERLAY MATERIAL_USE_DETAIL_HEIGHT
			  
			//SHADER INJECTION POINT BEGIN
			//SHADER INJECTION POINT END
			    
			#pragma shader_feature MATERIAL_USE_OBJECT_DATA MATERIAL_USE_WORLD_DATA


			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif

			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 positionCS : SV_Position;
				float3 interp00 : TEXCOORD0;
				float3 interp01 : TEXCOORD1;
				float4 interp02 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			CBUFFER_START( UnityPerMaterial )
			half4 _MainUVs;
			float4 _Color;
			half4 _SecondColor;
			half4 _SecondUVs;
			float4 _MaxBoundsInfo;
			float4 _SubsurfaceDiffusion_asset;
			half4 _MainColor;
			half3 _render_normals_options;
			half _MotionVertical_20;
			half _MotionCat;
			half _Motion_10;
			half _InteractionAmplitude;
			float _MotionScale_10;
			half _MotionVariation_10;
			half _MotionAmplitude_10;
			float _MotionScale_20;
			half _MotionVariation_20;
			float _MotionSpeed_20;
			half _Motion_20;
			half _MotionAmplitude_20;
			half _IsStandardShader;
			half _material_batching;
			half _BatchingMessage;
			float _MotionSpeed_10;
			half _GlobalSizeFade;
			half _IsLitShader;
			half _IsHDPipeline;
			half _ObjectOcclusionValue;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half __premul;
			half _GlobalOverlay;
			half _OverlayContrast;
			half _SecondNormalValue;
			half _MainNormalValue;
			half _OverlayUVTilling;
			half _DetailShadingCat;
			half _DetailMode;
			half _DetailMaskContrast;
			half _DetailMaskValue;
			half _MaskMode;
			half _DetailMeshValue;
			half _IsVersion;
			half _GlobalSize;
			float _MotionScale_32;
			float _MotionVariation_32;
			float _MotionVariation_30;
			half __zw;
			half __blend;
			half _render_mode;
			half __clip;
			half _render_priority;
			half _render_dst;
			half _GlobalSettingsCat;
			half _render_clip;
			half _MaterialShadingCat;
			half _AdvancedCat;
			half _ObjectThicknessValue;
			half _RenderingCat;
			half _RenderMode_ResetInteractive;
			half _IsTVEShader;
			half _VertexOcclusion;
			half _IsBarkShader;
			half _IsAnyPathShader;
			half _Banner;
			half _MainMaskValue;
			half _render_blend;
			half _render_zw;
			half _Cutoff;
			half __surface;
			float _MotionSpeed_32;
			half _MotionAmplitude_30;
			float _MotionSpeed_30;
			float _MotionScale_30;
			half _MotionAmplitude_32;
			half _MainColorMode;
			half __dst;
			half _render_cull;
			half _AlphaClipInteractive;
			half _render_src;
			float _SubsurfaceMode;
			half __priority;
			half _MainShadingCat;
			half __src;
			half __normals;
			half __cull;
			half _render_normals;
			half _RenderMode_TransparentInteractive;
			half _MainOcclusionValue;
			half _SecondOcclusionValue;
			float4 _EmissionColor;
			float _RenderQueueType;
			#ifdef _ADD_PRECOMPUTED_VELOCITY
			float _AddPrecomputedVelocity;
			#endif
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _AlphaCutoff;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _MainTex;
			half TVE_Amplitude2;
			sampler2D TVE_NoiseTex;
			half TVE_NoiseSpeed;
			half TVE_NoiseSize;
			half TVE_NoiseContrast;
			half TVE_Amplitude1;
			sampler2D TVE_MotionTex;
			half4 TVE_MotionCoord;
			half TVE_SizeFadeEnd;
			half TVE_SizeFadeStart;
			sampler2D TVE_ExtrasTex;
			half4 TVE_ExtrasCoord;
			sampler2D _MainNormalTex;
			sampler2D _SecondNormalTex;
			sampler2D _MainMaskTex;
			sampler2D _SecondMaskTex;
			sampler2D TVE_OverlayNormalTex;
			half TVE_OverlayUVTilling;
			half TVE_OverlayNormalValue;
			half TVE_OverlayIntensity;
			half TVE_OverlaySmoothness;
			float TVE_Wetness;
			sampler2D _MainAlbedoTex;


			float3 ObjectPosition_UNITY_MATRIX_M(  )
			{
				return float3(UNITY_MATRIX_M[0].w, UNITY_MATRIX_M[1].w, UNITY_MATRIX_M[2].w );
			}
			

			void BuildSurfaceData(FragInputs fragInputs, inout SmoothSurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);

				surfaceData.specularOcclusion = 1.0;

				// surface data
				surfaceData.perceptualSmoothness =		surfaceDescription.Smoothness;

				// refraction
				#ifdef _HAS_REFRACTION
				if( _EnableSSRefraction )
				{
					surfaceData.transmittanceMask = ( 1.0 - surfaceDescription.Alpha );
					surfaceDescription.Alpha = 1.0;
				}
				else
				{
					surfaceData.ior = 1.0;
					surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
					surfaceData.atDistance = 1.0;
					surfaceData.transmittanceMask = 0.0;
					surfaceDescription.Alpha = 1.0;
				}
				#else
				surfaceData.ior = 1.0;
				surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
				surfaceData.atDistance = 1.0;
				surfaceData.transmittanceMask = 0.0;
				#endif


				// material features
				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif
				#ifdef ASE_LIT_CLEAR_COAT
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				// others
				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				// normals
				float3 normalTS = float3(0.0f, 0.0f, 1.0f);
				normalTS = surfaceDescription.Normal;
				GetNormalWS( fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants );

				surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];

				bentNormalWS = surfaceData.normalWS;

				surfaceData.tangentWS = normalize( fragInputs.tangentToWorld[ 0 ].xyz );
				surfaceData.tangentWS = Orthonormalize( surfaceData.tangentWS, surfaceData.normalWS );

				// decals
				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#endif

				// debug
				#if defined(DEBUG_DISPLAY)
				if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
				{
					surfaceData.metallic = 0;
				}
				ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
				#endif
			}

			void GetSurfaceAndBuiltinData(SmoothSurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				//#ifdef _ALPHATEST_ON
				//DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				//#endif

				#ifdef _DEPTHOFFSET_ON
				builtinData.depthOffset = surfaceDescription.DepthOffset;
				ApplyDepthOffsetPositionInput( V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS );

				InitBuiltinData( posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[ 2 ], fragInputs.texCoord1, fragInputs.texCoord2, builtinData );

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			PackedVaryingsMeshToPS VertexFunction(AttributesMesh inputMesh )
			{
				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS;

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( outputPackedVaryingsMeshToPS );

				half3 VertexPos40_g18271 = inputMesh.positionOS;
				float3 appendResult74_g18271 = (float3(0.0 , VertexPos40_g18271.y , 0.0));
				float3 VertexPosRotationAxis50_g18271 = appendResult74_g18271;
				float3 break84_g18271 = VertexPos40_g18271;
				float3 appendResult81_g18271 = (float3(break84_g18271.x , 0.0 , break84_g18271.z));
				float3 VertexPosOtherAxis82_g18271 = appendResult81_g18271;
				float ObjectData20_g18308 = 3.14;
				float Bounds_Radius121_g18123 = _MaxBoundsInfo.x;
				float WorldData19_g18308 = Bounds_Radius121_g18123;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18308 = WorldData19_g18308;
				#else
				float staticSwitch14_g18308 = ObjectData20_g18308;
				#endif
				float Motion_Max_Rolling1137_g18123 = staticSwitch14_g18308;
				half Global_Amplitude_270_g18123 = TVE_Amplitude2;
				half Mesh_Motion_260_g18123 = inputMesh.ase_texcoord3.y;
				float temp_output_4_0_g18291 = 1.0;
				float temp_output_5_0_g18291 = ( temp_output_4_0_g18291 * _TimeParameters.x );
				float2 temp_cast_0 = (TVE_NoiseSpeed).xx;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18290 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18290 = ( localObjectPosition_UNITY_MATRIX_M14_g18290 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18290 = localObjectPosition_UNITY_MATRIX_M14_g18290;
				#endif
				half3 ObjectData20_g18292 = staticSwitch13_g18290;
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				half3 WorldData19_g18292 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18292 = WorldData19_g18292;
				#else
				float3 staticSwitch14_g18292 = ObjectData20_g18292;
				#endif
				float2 panner73_g18289 = ( temp_output_5_0_g18291 * temp_cast_0 + ( (staticSwitch14_g18292).xz * TVE_NoiseSize ));
				float4 temp_cast_1 = (TVE_NoiseContrast).xxxx;
				float4 break142_g18289 = pow( abs( tex2Dlod( TVE_NoiseTex, float4( panner73_g18289, 0, 0.0) ) ) , temp_cast_1 );
				half Global_NoiseTex_R34_g18123 = break142_g18289.r;
				half Global_NoiseTex_G38_g18123 = break142_g18289.g;
				half Motion_Use20162_g18123 = _Motion_20;
				half MotionSpeed265_g18123 = _MotionSpeed_20;
				half Input_Speed62_g18262 = MotionSpeed265_g18123;
				float temp_output_4_0_g18265 = Input_Speed62_g18262;
				float temp_output_5_0_g18265 = ( temp_output_4_0_g18265 * _TimeParameters.x );
				half MotionVariation264_g18123 = _MotionVariation_20;
				float temp_output_342_0_g18262 = ( MotionVariation264_g18123 * inputMesh.ase_color.r );
				float3 localObjectPosition_UNITY_MATRIX_M14_g18263 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18263 = ( localObjectPosition_UNITY_MATRIX_M14_g18263 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18263 = localObjectPosition_UNITY_MATRIX_M14_g18263;
				#endif
				float3 break9_g18263 = staticSwitch13_g18263;
				float ObjectData20_g18264 = ( temp_output_342_0_g18262 + ( break9_g18263.x + break9_g18263.z ) );
				float WorldData19_g18264 = temp_output_342_0_g18262;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18264 = WorldData19_g18264;
				#else
				float staticSwitch14_g18264 = ObjectData20_g18264;
				#endif
				float Motion_Variation284_g18262 = staticSwitch14_g18264;
				half MotionScale262_g18123 = _MotionScale_20;
				float Motion_Scale287_g18262 = ( MotionScale262_g18123 * ase_worldPos.x );
				half Motion_Rolling138_g18123 = ( ( _MotionAmplitude_20 * Motion_Max_Rolling1137_g18123 ) * Global_Amplitude_270_g18123 * Mesh_Motion_260_g18123 * ( Global_NoiseTex_R34_g18123 + Global_NoiseTex_G38_g18123 ) * Motion_Use20162_g18123 * sin( ( temp_output_5_0_g18265 + Motion_Variation284_g18262 + Motion_Scale287_g18262 ) ) );
				half Angle44_g18271 = Motion_Rolling138_g18123;
				half3 VertexPos40_g18273 = ( VertexPosRotationAxis50_g18271 + ( VertexPosOtherAxis82_g18271 * cos( Angle44_g18271 ) ) + ( cross( float3(0,1,0) , VertexPosOtherAxis82_g18271 ) * sin( Angle44_g18271 ) ) );
				float3 appendResult74_g18273 = (float3(VertexPos40_g18273.x , 0.0 , 0.0));
				half3 VertexPosRotationAxis50_g18273 = appendResult74_g18273;
				float3 break84_g18273 = VertexPos40_g18273;
				float3 appendResult81_g18273 = (float3(0.0 , break84_g18273.y , break84_g18273.z));
				half3 VertexPosOtherAxis82_g18273 = appendResult81_g18273;
				float ObjectData20_g18309 = 3.14;
				float Bounds_Height374_g18123 = _MaxBoundsInfo.y;
				float WorldData19_g18309 = ( Bounds_Height374_g18123 * 3.14 );
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18309 = WorldData19_g18309;
				#else
				float staticSwitch14_g18309 = ObjectData20_g18309;
				#endif
				float Motion_Max_Bending1133_g18123 = staticSwitch14_g18309;
				half Global_Amplitude_136_g18123 = TVE_Amplitude1;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18268 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18268 = ( localObjectPosition_UNITY_MATRIX_M14_g18268 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18268 = localObjectPosition_UNITY_MATRIX_M14_g18268;
				#endif
				half3 ObjectData20_g18267 = staticSwitch13_g18268;
				half3 WorldData19_g18267 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18267 = WorldData19_g18267;
				#else
				float3 staticSwitch14_g18267 = ObjectData20_g18267;
				#endif
				float3 break322_g18294 = (tex2Dlod( TVE_MotionTex, float4( ( (TVE_MotionCoord).xy + ( TVE_MotionCoord.z * (staticSwitch14_g18267).xz ) ), 0, 0.0) )).rgb;
				float3 appendResult323_g18294 = (float3(break322_g18294.x , 0.0 , break322_g18294.y));
				float3 temp_output_324_0_g18294 = (appendResult323_g18294*2.0 + -1.0);
				float3 ase_parentObjectScale = ( 1.0 / float3( length( GetWorldToObjectMatrix()[ 0 ].xyz ), length( GetWorldToObjectMatrix()[ 1 ].xyz ), length( GetWorldToObjectMatrix()[ 2 ].xyz ) ) );
				half3 ObjectData20_g18295 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_324_0_g18294 , 0.0 ) ).xyz * ase_parentObjectScale );
				half3 WorldData19_g18295 = temp_output_324_0_g18294;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18295 = WorldData19_g18295;
				#else
				float3 staticSwitch14_g18295 = ObjectData20_g18295;
				#endif
				float2 temp_output_1976_320_g18123 = (staticSwitch14_g18295).xz;
				half2 Motion_DirectionOS39_g18123 = temp_output_1976_320_g18123;
				half Input_Speed62_g18245 = _MotionSpeed_10;
				float temp_output_4_0_g18246 = Input_Speed62_g18245;
				float temp_output_5_0_g18246 = ( temp_output_4_0_g18246 * _TimeParameters.x );
				float temp_output_349_0_g18245 = ( _MotionVariation_10 * inputMesh.ase_color.r );
				float3 localObjectPosition_UNITY_MATRIX_M14_g18249 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18249 = ( localObjectPosition_UNITY_MATRIX_M14_g18249 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18249 = localObjectPosition_UNITY_MATRIX_M14_g18249;
				#endif
				float3 break9_g18249 = staticSwitch13_g18249;
				float ObjectData20_g18248 = ( temp_output_349_0_g18245 + ( break9_g18249.x + break9_g18249.z ) );
				float WorldData19_g18248 = temp_output_349_0_g18245;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18248 = WorldData19_g18248;
				#else
				float staticSwitch14_g18248 = ObjectData20_g18248;
				#endif
				half Motion_Variation284_g18245 = staticSwitch14_g18248;
				float2 appendResult344_g18245 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 Motion_Scale287_g18245 = ( _MotionScale_10 * appendResult344_g18245 );
				half2 Sine_MinusOneToOne281_g18245 = sin( ( temp_output_5_0_g18246 + Motion_Variation284_g18245 + Motion_Scale287_g18245 ) );
				float2 temp_cast_4 = (1.0).xx;
				half Input_Turbulence327_g18245 = Global_NoiseTex_R34_g18123;
				float2 lerpResult321_g18245 = lerp( Sine_MinusOneToOne281_g18245 , temp_cast_4 , Input_Turbulence327_g18245);
				float2 temp_output_84_0_g18123 = ( ( _MotionAmplitude_10 * Motion_Max_Bending1133_g18123 ) * Global_Amplitude_136_g18123 * Global_NoiseTex_R34_g18123 * Motion_DirectionOS39_g18123 * lerpResult321_g18245 );
				float temp_output_1976_333_g18123 = break322_g18294.z;
				half2 Motion_Interaction53_g18123 = ( _InteractionAmplitude * Motion_Max_Bending1133_g18123 * temp_output_1976_320_g18123 * temp_output_1976_333_g18123 * temp_output_1976_333_g18123 );
				half Motion_InteractionMask66_g18123 = temp_output_1976_333_g18123;
				float2 lerpResult109_g18123 = lerp( temp_output_84_0_g18123 , Motion_Interaction53_g18123 , Motion_InteractionMask66_g18123);
				half Mesh_Motion_182_g18123 = inputMesh.ase_texcoord3.x;
				half Motion_Use1056_g18123 = ( _Motion_10 + ( _MotionCat * 0.0 ) );
				float2 break143_g18123 = ( lerpResult109_g18123 * Mesh_Motion_182_g18123 * Motion_Use1056_g18123 );
				half Motion_Z190_g18123 = break143_g18123.y;
				half Angle44_g18273 = Motion_Z190_g18123;
				half3 VertexPos40_g18281 = ( VertexPosRotationAxis50_g18273 + ( VertexPosOtherAxis82_g18273 * cos( Angle44_g18273 ) ) + ( cross( float3(1,0,0) , VertexPosOtherAxis82_g18273 ) * sin( Angle44_g18273 ) ) );
				float3 appendResult74_g18281 = (float3(0.0 , 0.0 , VertexPos40_g18281.z));
				half3 VertexPosRotationAxis50_g18281 = appendResult74_g18281;
				float3 break84_g18281 = VertexPos40_g18281;
				float3 appendResult81_g18281 = (float3(break84_g18281.x , break84_g18281.y , 0.0));
				half3 VertexPosOtherAxis82_g18281 = appendResult81_g18281;
				half Motion_X216_g18123 = break143_g18123.x;
				half Angle44_g18281 = -Motion_X216_g18123;
				half Global_NoiseTex_B132_g18123 = break142_g18289.b;
				half Input_Speed62_g18302 = -MotionSpeed265_g18123;
				float temp_output_4_0_g18305 = Input_Speed62_g18302;
				float temp_output_5_0_g18305 = ( temp_output_4_0_g18305 * _TimeParameters.x );
				float temp_output_342_0_g18302 = ( -MotionVariation264_g18123 * inputMesh.ase_color.r );
				float3 localObjectPosition_UNITY_MATRIX_M14_g18303 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18303 = ( localObjectPosition_UNITY_MATRIX_M14_g18303 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18303 = localObjectPosition_UNITY_MATRIX_M14_g18303;
				#endif
				float3 break9_g18303 = staticSwitch13_g18303;
				float ObjectData20_g18304 = ( temp_output_342_0_g18302 + ( break9_g18303.x + break9_g18303.z ) );
				float WorldData19_g18304 = temp_output_342_0_g18302;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18304 = WorldData19_g18304;
				#else
				float staticSwitch14_g18304 = ObjectData20_g18304;
				#endif
				float Motion_Variation284_g18302 = staticSwitch14_g18304;
				float Motion_Scale287_g18302 = ( MotionScale262_g18123 * ase_worldPos.x );
				float3 appendResult2014_g18123 = (float3(0.0 , ( ( _MotionVertical_20 * Bounds_Radius121_g18123 ) * Global_Amplitude_270_g18123 * Mesh_Motion_260_g18123 * Motion_Use20162_g18123 * ( Global_NoiseTex_R34_g18123 + Global_NoiseTex_B132_g18123 ) * sin( ( temp_output_5_0_g18305 + Motion_Variation284_g18302 + Motion_Scale287_g18302 ) ) ) , 0.0));
				half3 Motion_Vertical223_g18123 = appendResult2014_g18123;
				float3 Vertex_Motion_Object833_g18123 = ( ( VertexPosRotationAxis50_g18281 + ( VertexPosOtherAxis82_g18281 * cos( Angle44_g18281 ) ) + ( cross( float3(0,0,1) , VertexPosOtherAxis82_g18281 ) * sin( Angle44_g18281 ) ) ) + Motion_Vertical223_g18123 );
				half3 ObjectData20_g18272 = Vertex_Motion_Object833_g18123;
				float3 appendResult2047_g18123 = (float3(Motion_Rolling138_g18123 , 0.0 , -Motion_Rolling138_g18123));
				float3 appendResult2043_g18123 = (float3(Motion_X216_g18123 , 0.0 , Motion_Z190_g18123));
				float3 Vertex_Motion_World1118_g18123 = ( ( ( inputMesh.positionOS + appendResult2047_g18123 ) + appendResult2043_g18123 ) + Motion_Vertical223_g18123 );
				half3 WorldData19_g18272 = Vertex_Motion_World1118_g18123;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18272 = WorldData19_g18272;
				#else
				float3 staticSwitch14_g18272 = ObjectData20_g18272;
				#endif
				float3 localObjectPosition_UNITY_MATRIX_M14_g18274 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18274 = ( localObjectPosition_UNITY_MATRIX_M14_g18274 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18274 = localObjectPosition_UNITY_MATRIX_M14_g18274;
				#endif
				half Global_SizeFadeEnd287_g18123 = TVE_SizeFadeEnd;
				float temp_output_7_0_g18269 = Global_SizeFadeEnd287_g18123;
				half Global_SizeFadeStart276_g18123 = TVE_SizeFadeStart;
				float lerpResult348_g18123 = lerp( 1.0 , saturate( ( ( distance( _WorldSpaceCameraPos , staticSwitch13_g18274 ) - temp_output_7_0_g18269 ) / ( Global_SizeFadeStart276_g18123 - temp_output_7_0_g18269 ) ) ) , _GlobalSizeFade);
				float ObjectData20_g18278 = lerpResult348_g18123;
				float WorldData19_g18278 = 1.0;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18278 = WorldData19_g18278;
				#else
				float staticSwitch14_g18278 = ObjectData20_g18278;
				#endif
				float Vertex_SizeFade1740_g18123 = staticSwitch14_g18278;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18298 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18298 = ( localObjectPosition_UNITY_MATRIX_M14_g18298 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18298 = localObjectPosition_UNITY_MATRIX_M14_g18298;
				#endif
				half3 ObjectData20_g18299 = staticSwitch13_g18298;
				half3 WorldData19_g18299 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18299 = WorldData19_g18299;
				#else
				float3 staticSwitch14_g18299 = ObjectData20_g18299;
				#endif
				float4 tex2DNode7_g18297 = tex2Dlod( TVE_ExtrasTex, float4( ( (TVE_ExtrasCoord).xy + ( TVE_ExtrasCoord.z * (staticSwitch14_g18299).xz ) ), 0, 0.0) );
				half Global_ExtrasTex_G305_g18123 = tex2DNode7_g18297.g;
				float lerpResult346_g18123 = lerp( 1.0 , Global_ExtrasTex_G305_g18123 , _GlobalSize);
				float ObjectData20_g18270 = lerpResult346_g18123;
				float WorldData19_g18270 = 1.0;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18270 = WorldData19_g18270;
				#else
				float staticSwitch14_g18270 = ObjectData20_g18270;
				#endif
				half Vertex_Size1741_g18123 = staticSwitch14_g18270;
				float3 Final_Vertex890_g18123 = ( ( staticSwitch14_g18272 * Vertex_SizeFade1740_g18123 * Vertex_Size1741_g18123 ) + ( _IsHDPipeline * 0.0 ) );
				
				float3 ase_worldNormal = TransformObjectToWorldNormal(inputMesh.normalOS);
				float3 ase_worldTangent = TransformObjectToWorldDir(inputMesh.tangentOS.xyz);
				float ase_vertexTangentSign = inputMesh.tangentOS.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				outputPackedVaryingsMeshToPS.ase_texcoord4.xyz = ase_worldBitangent;
				
				outputPackedVaryingsMeshToPS.ase_texcoord3 = inputMesh.ase_texcoord;
				outputPackedVaryingsMeshToPS.ase_color = inputMesh.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				outputPackedVaryingsMeshToPS.ase_texcoord4.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = Final_Vertex890_g18123;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif

				inputMesh.normalOS =  inputMesh.normalOS ;
				inputMesh.tangentOS =  inputMesh.tangentOS ;

				float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
				float3 normalWS = TransformObjectToWorldNormal(inputMesh.normalOS);
				float4 tangentWS = float4(TransformObjectToWorldDir(inputMesh.tangentOS.xyz), inputMesh.tangentOS.w);

				outputPackedVaryingsMeshToPS.positionCS = TransformWorldToHClip(positionRWS);
				outputPackedVaryingsMeshToPS.interp00.xyz = positionRWS;
				outputPackedVaryingsMeshToPS.interp01.xyz = normalWS;
				outputPackedVaryingsMeshToPS.interp02.xyzw = tangentWS;
				return outputPackedVaryingsMeshToPS;
			}
			
			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float3 positionOS : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl Vert ( AttributesMesh v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.positionOS = v.positionOS;
				o.normalOS = v.normalOS;
				o.tangentOS = v.tangentOS;
				o.ase_texcoord3 = v.ase_texcoord3;
				o.ase_color = v.ase_color;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if (SHADEROPTIONS_CAMERA_RELATIVE_RENDERING != 0)
				float3 cameraPos = 0;
				#else
				float3 cameraPos = _WorldSpaceCameraPos;
				#endif
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), cameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, GetObjectToWorldMatrix(), cameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), cameraPos, _ScreenParams, _FrustumPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			PackedVaryingsMeshToPS DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				AttributesMesh o = (AttributesMesh) 0;
				o.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				o.ase_texcoord3 = patch[0].ase_texcoord3 * bary.x + patch[1].ase_texcoord3 * bary.y + patch[2].ase_texcoord3 * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			PackedVaryingsMeshToPS Vert ( AttributesMesh v )
			{
				return VertexFunction( v );
			}
			#endif

			void Frag( PackedVaryingsMeshToPS packedInput
						#ifdef WRITE_NORMAL_BUFFER
						, out float4 outNormalBuffer : SV_Target0
							#ifdef WRITE_MSAA_DEPTH
							, out float1 depthColor : SV_Target1
							#endif
						#elif defined(WRITE_MSAA_DEPTH)
						, out float4 outNormalBuffer : SV_Target0
						, out float1 depthColor : SV_Target1
						#elif defined(SCENESELECTIONPASS)
						, out float4 outColor : SV_Target0
						#endif
						#ifdef _DEPTHOFFSET_ON
						, out float outputDepth : SV_Depth
						#endif
						
					)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( packedInput );
				UNITY_SETUP_INSTANCE_ID( packedInput );

				float3 positionRWS = packedInput.interp00.xyz;
				float3 normalWS = packedInput.interp01.xyz;
				float4 tangentWS = packedInput.interp02.xyzw;

				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);

				input.tangentToWorld = k_identity3x3;
				input.positionSS = packedInput.positionCS;

				input.positionRWS = positionRWS;
				input.tangentToWorld = BuildTangentToWorld(tangentWS, normalWS);

				#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false);
				#elif SHADER_STAGE_FRAGMENT
				#if defined(ASE_NEED_CULLFACE)
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false );
				#endif
				#endif
				half isFrontFace = input.isFrontFace;

				PositionInputs posInput = GetPositionInput(input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS);

				float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);

				SmoothSurfaceDescription surfaceDescription = (SmoothSurfaceDescription)0;
				float2 Main_UVs15_g18123 = ( ( packedInput.ase_texcoord3.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				float4 tex2DNode117_g18123 = tex2D( _MainNormalTex, Main_UVs15_g18123 );
				float2 appendResult88_g18301 = (float2(tex2DNode117_g18123.a , tex2DNode117_g18123.g));
				float2 temp_output_90_0_g18301 = ( (appendResult88_g18301*2.0 + -1.0) * _MainNormalValue );
				float3 appendResult91_g18301 = (float3(temp_output_90_0_g18301 , 1.0));
				float3 Main_Normal137_g18123 = appendResult91_g18301;
				float2 appendResult21_g18296 = (float2(packedInput.ase_texcoord3.z , packedInput.ase_texcoord3.w));
				float2 Mesh_DetailCoord3_g18123 = appendResult21_g18296;
				float2 Second_UVs17_g18123 = ( ( Mesh_DetailCoord3_g18123 * (_SecondUVs).xy ) + (_SecondUVs).zw );
				float4 tex2DNode145_g18123 = tex2D( _SecondNormalTex, Second_UVs17_g18123 );
				float2 appendResult88_g18256 = (float2(tex2DNode145_g18123.a , tex2DNode145_g18123.g));
				float2 temp_output_90_0_g18256 = ( (appendResult88_g18256*2.0 + -1.0) * _SecondNormalValue );
				float3 appendResult91_g18256 = (float3(temp_output_90_0_g18256 , 1.0));
				float3 Second_Normal179_g18123 = appendResult91_g18256;
				half Mesh_DetailMask90_g18123 = packedInput.ase_color.b;
				float temp_output_989_0_g18123 = ( ( Mesh_DetailMask90_g18123 - 0.5 ) + _DetailMeshValue );
				half Blend_Source1540_g18123 = temp_output_989_0_g18123;
				float4 tex2DNode35_g18123 = tex2D( _MainMaskTex, Main_UVs15_g18123 );
				half Main_Mask57_g18123 = tex2DNode35_g18123.b;
				float4 tex2DNode33_g18123 = tex2D( _SecondMaskTex, Second_UVs17_g18123 );
				half Second_Mask81_g18123 = tex2DNode33_g18123.b;
				float lerpResult1327_g18123 = lerp( Main_Mask57_g18123 , Second_Mask81_g18123 , _MaskMode);
				float temp_output_7_0_g18284 = _DetailMaskContrast;
				half AutoRegister_DetailMode667_g18123 = ( 0.0 * _DetailMode * _DetailShadingCat );
				half Mask_Detail147_g18123 = ( saturate( ( ( saturate( ( Blend_Source1540_g18123 + ( Blend_Source1540_g18123 * ( ( ( 1.0 - lerpResult1327_g18123 ) - 0.5 ) + _DetailMaskValue ) ) ) ) - temp_output_7_0_g18284 ) / ( ( 1.0 - _DetailMaskContrast ) - temp_output_7_0_g18284 ) ) ) + AutoRegister_DetailMode667_g18123 );
				float3 lerpResult230_g18123 = lerp( float3( 0,0,1 ) , Second_Normal179_g18123 , Mask_Detail147_g18123);
				float3 lerpResult249_g18123 = lerp( Main_Normal137_g18123 , Second_Normal179_g18123 , Mask_Detail147_g18123);
				#if defined(MATERIAL_USE_DETAIL_OFF)
				float3 staticSwitch267_g18123 = Main_Normal137_g18123;
				#elif defined(MATERIAL_USE_DETAIL_OVERLAY)
				float3 staticSwitch267_g18123 = BlendNormal( Main_Normal137_g18123 , lerpResult230_g18123 );
				#elif defined(MATERIAL_USE_DETAIL_HEIGHT)
				float3 staticSwitch267_g18123 = lerpResult249_g18123;
				#else
				float3 staticSwitch267_g18123 = Main_Normal137_g18123;
				#endif
				float3 temp_output_13_0_g18300 = staticSwitch267_g18123;
				float3 switchResult12_g18300 = (((isFrontFace>0)?(temp_output_13_0_g18300):(( temp_output_13_0_g18300 * _render_normals_options ))));
				half3 Blend_Normal312_g18123 = switchResult12_g18300;
				float2 temp_output_38_0_g18258 = ( _OverlayUVTilling * packedInput.ase_texcoord3.xy * TVE_OverlayUVTilling );
				float4 tex2DNode33_g18258 = tex2D( TVE_OverlayNormalTex, temp_output_38_0_g18258 );
				float2 appendResult88_g18259 = (float2(tex2DNode33_g18258.a , tex2DNode33_g18258.g));
				float2 temp_output_90_0_g18259 = ( (appendResult88_g18259*2.0 + -1.0) * TVE_OverlayNormalValue );
				float3 appendResult91_g18259 = (float3(temp_output_90_0_g18259 , 1.0));
				float3 temp_output_84_19_g18258 = appendResult91_g18259;
				half3 Global_OverlayNormal313_g18123 = temp_output_84_19_g18258;
				float3 Blend_NormalRaw1051_g18123 = staticSwitch267_g18123;
				float3 switchResult1063_g18123 = (((isFrontFace>0)?(Blend_NormalRaw1051_g18123):(( Blend_NormalRaw1051_g18123 * float3(-1,-1,-1) ))));
				half Overlay_Contrast1405_g18123 = _OverlayContrast;
				float3 appendResult1439_g18123 = (float3(Overlay_Contrast1405_g18123 , Overlay_Contrast1405_g18123 , 1.0));
				float3 ase_worldBitangent = packedInput.ase_texcoord4.xyz;
				float3 tanToWorld0 = float3( tangentWS.xyz.x, ase_worldBitangent.x, normalWS.x );
				float3 tanToWorld1 = float3( tangentWS.xyz.y, ase_worldBitangent.y, normalWS.y );
				float3 tanToWorld2 = float3( tangentWS.xyz.z, ase_worldBitangent.z, normalWS.z );
				float3 tanNormal178_g18123 = ( switchResult1063_g18123 * appendResult1439_g18123 );
				float3 worldNormal178_g18123 = float3(dot(tanToWorld0,tanNormal178_g18123), dot(tanToWorld1,tanNormal178_g18123), dot(tanToWorld2,tanNormal178_g18123));
				half Global_OverlayIntensity154_g18123 = TVE_OverlayIntensity;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18298 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18298 = ( localObjectPosition_UNITY_MATRIX_M14_g18298 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18298 = localObjectPosition_UNITY_MATRIX_M14_g18298;
				#endif
				half3 ObjectData20_g18299 = staticSwitch13_g18298;
				float3 ase_worldPos = GetAbsolutePositionWS( positionRWS );
				half3 WorldData19_g18299 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18299 = WorldData19_g18299;
				#else
				float3 staticSwitch14_g18299 = ObjectData20_g18299;
				#endif
				float4 tex2DNode7_g18297 = tex2D( TVE_ExtrasTex, ( (TVE_ExtrasCoord).xy + ( TVE_ExtrasCoord.z * (staticSwitch14_g18299).xz ) ) );
				half Global_ExtrasTex_B156_g18123 = tex2DNode7_g18297.b;
				float temp_output_1025_0_g18123 = ( Global_OverlayIntensity154_g18123 * _GlobalOverlay * Global_ExtrasTex_B156_g18123 );
				half Overlay_Commons1365_g18123 = temp_output_1025_0_g18123;
				half Overlay_Mask269_g18123 = saturate( ( saturate( worldNormal178_g18123.y ) - ( 1.0 - Overlay_Commons1365_g18123 ) ) );
				float3 lerpResult349_g18123 = lerp( Blend_Normal312_g18123 , Global_OverlayNormal313_g18123 , Overlay_Mask269_g18123);
				half3 Final_Normal366_g18123 = lerpResult349_g18123;
				
				half Main_Smoothness227_g18123 = ( tex2DNode35_g18123.a * _MainSmoothnessValue );
				half Second_Smoothness236_g18123 = ( tex2DNode33_g18123.a * _SecondSmoothnessValue );
				float lerpResult266_g18123 = lerp( Main_Smoothness227_g18123 , Second_Smoothness236_g18123 , Mask_Detail147_g18123);
				#if defined(MATERIAL_USE_DETAIL_OFF)
				float staticSwitch297_g18123 = Main_Smoothness227_g18123;
				#elif defined(MATERIAL_USE_DETAIL_OVERLAY)
				float staticSwitch297_g18123 = Main_Smoothness227_g18123;
				#elif defined(MATERIAL_USE_DETAIL_HEIGHT)
				float staticSwitch297_g18123 = lerpResult266_g18123;
				#else
				float staticSwitch297_g18123 = Main_Smoothness227_g18123;
				#endif
				half Blend_Smoothness314_g18123 = staticSwitch297_g18123;
				half Global_OverlaySmoothness311_g18123 = TVE_OverlaySmoothness;
				float lerpResult343_g18123 = lerp( Blend_Smoothness314_g18123 , Global_OverlaySmoothness311_g18123 , Overlay_Mask269_g18123);
				half Final_Smoothness371_g18123 = lerpResult343_g18123;
				half Global_Wetness1016_g18123 = ( TVE_Wetness * _GlobalWetness );
				half Global_ExtrasTex_A1033_g18123 = tex2DNode7_g18297.a;
				float lerpResult1037_g18123 = lerp( Final_Smoothness371_g18123 , saturate( ( Final_Smoothness371_g18123 + Global_Wetness1016_g18123 ) ) , Global_ExtrasTex_A1033_g18123);
				
				float4 tex2DNode29_g18123 = tex2D( _MainAlbedoTex, Main_UVs15_g18123 );
				float4 temp_output_51_0_g18123 = ( _MainColor * tex2DNode29_g18123 );
				half Main_Alpha316_g18123 = (temp_output_51_0_g18123).a;
				
				float localCustomAlphaClip9_g18277 = ( 0.0 );
				half Main_AlphaRaw1203_g18123 = tex2DNode29_g18123.a;
				half Alpha5_g18277 = Main_AlphaRaw1203_g18123;
				float Alpha9_g18277 = Alpha5_g18277;
				float AlphaClipThreshold9_g18277 = _Cutoff;
				#if _ALPHATEST_ON
				clip(Alpha9_g18277 - AlphaClipThreshold9_g18277);
				#endif
				half Final_Clip914_g18123 = localCustomAlphaClip9_g18277;
				
				surfaceDescription.Normal = Final_Normal366_g18123;
				surfaceDescription.Smoothness = lerpResult1037_g18123;
				surfaceDescription.Alpha = Main_Alpha316_g18123;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = Final_Clip914_g18123;
				#endif

				#ifdef _DEPTHOFFSET_ON
				surfaceDescription.DepthOffset = 0;
				#endif

				SurfaceData surfaceData;
				BuiltinData builtinData;
				GetSurfaceAndBuiltinData(surfaceDescription, input, V, posInput, surfaceData, builtinData);

				#ifdef _DEPTHOFFSET_ON
				outputDepth = posInput.deviceDepth;
				#endif

				#ifdef WRITE_NORMAL_BUFFER
				EncodeIntoNormalBuffer( ConvertSurfaceDataToNormalData( surfaceData ), posInput.positionSS, outNormalBuffer );
				#ifdef WRITE_MSAA_DEPTH
				depthColor = packedInput.positionCS.z;
				#endif
				#elif defined(WRITE_MSAA_DEPTH)
				outNormalBuffer = float4( 0.0, 0.0, 0.0, 1.0 );
				depthColor = packedInput.positionCS.z;
				#elif defined(SCENESELECTIONPASS)
				outColor = float4( _ObjectId, _PassValue, 1.0, 1.0 );
				#endif
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="Forward" }

			Blend [_SrcBlend] [_DstBlend] , [_AlphaSrcBlend] [_AlphaDstBlend]
			Cull [_CullModeForward]
			ZTest [_ZTestDepthEqualForOpaque]
			ZWrite [_ZWrite]

			Stencil
			{
				Ref [_StencilRef]
				WriteMask [_StencilWriteMask]
				Comp Always
				Pass Replace
				Fail Keep
				ZFail Keep
			}


			ColorMask [_ColorMaskTransparentVel] 1

			HLSLPROGRAM

			#define ASE_NEED_CULLFACE 1
			#define _DISABLE_DECALS 1
			#define _DISABLE_SSR 1
			#define _SPECULAR_OCCLUSION_FROM_AO 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _AMBIENT_OCCLUSION 1
			#define HAVE_MESH_MODIFICATION
			#define ASE_SRP_VERSION 70201
			#if !defined(ASE_NEED_CULLFACE)
			#define ASE_NEED_CULLFACE 1
			#endif //ASE_NEED_CULLFACE


			#pragma shader_feature _SURFACE_TYPE_TRANSPARENT
			#pragma shader_feature_local _DOUBLESIDED_ON
			#pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
			#pragma shader_feature_local _ENABLE_FOG_ON_TRANSPARENT
			#pragma shader_feature_local _ALPHATEST_ON

			#if !defined(DEBUG_DISPLAY) && defined(_ALPHATEST_ON)
			#define SHADERPASS_FORWARD_BYPASS_ALPHA_TEST
			#endif

			#define SHADERPASS SHADERPASS_FORWARD
			#pragma multi_compile _ DEBUG_DISPLAY
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile DECALS_OFF DECALS_3RT DECALS_4RT
			#pragma multi_compile USE_FPTL_LIGHTLIST USE_CLUSTERED_LIGHTLIST
			#pragma multi_compile SHADOW_LOW SHADOW_MEDIUM SHADOW_HIGH

			#pragma vertex Vert
			#pragma fragment Frag

			//#define UNITY_MATERIAL_LIT

			#if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
			#define OUTPUT_SPLIT_LIGHTING
			#endif

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
			#ifdef DEBUG_DISPLAY
				#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
			#endif
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
			#define HAS_LIGHTLOOP
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_VFACE
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_TANGENT
			#define ASE_NEEDS_FRAG_RELATIVE_WORLD_POS
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature _ALPHATEST_ON
			#pragma shader_feature MATERIAL_USE_DETAIL_OFF MATERIAL_USE_DETAIL_OVERLAY MATERIAL_USE_DETAIL_HEIGHT
			  
			//SHADER INJECTION POINT BEGIN
			//SHADER INJECTION POINT END
			    
			#pragma shader_feature MATERIAL_USE_OBJECT_DATA MATERIAL_USE_WORLD_DATA


			#if defined(_DOUBLESIDED_ON) && !defined(ASE_NEED_CULLFACE)
				#define ASE_NEED_CULLFACE 1
			#endif

			struct AttributesMesh
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
					float3 previousPositionOS : TEXCOORD4;
					#if defined (_ADD_PRECOMPUTED_VELOCITY)
						float3 precomputedVelocity : TEXCOORD5;
					#endif
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryingsMeshToPS
			{
				float4 positionCS : SV_Position;
				float3 interp00 : TEXCOORD0;
				float3 interp01 : TEXCOORD1;
				float4 interp02 : TEXCOORD2;
				float4 interp03 : TEXCOORD3;
				float4 interp04 : TEXCOORD4;
				#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
					float3 vpassPositionCS : TEXCOORD5;
					float3 vpassPreviousPositionCS : TEXCOORD6;
				#endif
				float4 ase_texcoord7 : TEXCOORD7;
				float4 ase_color : COLOR;
				float4 ase_texcoord8 : TEXCOORD8;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				#if defined(SHADER_STAGE_FRAGMENT) && defined(ASE_NEED_CULLFACE)
				FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
				#endif
			};

			CBUFFER_START( UnityPerMaterial )
			half4 _MainUVs;
			float4 _Color;
			half4 _SecondColor;
			half4 _SecondUVs;
			float4 _MaxBoundsInfo;
			float4 _SubsurfaceDiffusion_asset;
			half4 _MainColor;
			half3 _render_normals_options;
			half _MotionVertical_20;
			half _MotionCat;
			half _Motion_10;
			half _InteractionAmplitude;
			float _MotionScale_10;
			half _MotionVariation_10;
			half _MotionAmplitude_10;
			float _MotionScale_20;
			half _MotionVariation_20;
			float _MotionSpeed_20;
			half _Motion_20;
			half _MotionAmplitude_20;
			half _IsStandardShader;
			half _material_batching;
			half _BatchingMessage;
			float _MotionSpeed_10;
			half _GlobalSizeFade;
			half _IsLitShader;
			half _IsHDPipeline;
			half _ObjectOcclusionValue;
			half _GlobalWetness;
			half _SecondSmoothnessValue;
			half _MainSmoothnessValue;
			half __premul;
			half _GlobalOverlay;
			half _OverlayContrast;
			half _SecondNormalValue;
			half _MainNormalValue;
			half _OverlayUVTilling;
			half _DetailShadingCat;
			half _DetailMode;
			half _DetailMaskContrast;
			half _DetailMaskValue;
			half _MaskMode;
			half _DetailMeshValue;
			half _IsVersion;
			half _GlobalSize;
			float _MotionScale_32;
			float _MotionVariation_32;
			float _MotionVariation_30;
			half __zw;
			half __blend;
			half _render_mode;
			half __clip;
			half _render_priority;
			half _render_dst;
			half _GlobalSettingsCat;
			half _render_clip;
			half _MaterialShadingCat;
			half _AdvancedCat;
			half _ObjectThicknessValue;
			half _RenderingCat;
			half _RenderMode_ResetInteractive;
			half _IsTVEShader;
			half _VertexOcclusion;
			half _IsBarkShader;
			half _IsAnyPathShader;
			half _Banner;
			half _MainMaskValue;
			half _render_blend;
			half _render_zw;
			half _Cutoff;
			half __surface;
			float _MotionSpeed_32;
			half _MotionAmplitude_30;
			float _MotionSpeed_30;
			float _MotionScale_30;
			half _MotionAmplitude_32;
			half _MainColorMode;
			half __dst;
			half _render_cull;
			half _AlphaClipInteractive;
			half _render_src;
			float _SubsurfaceMode;
			half __priority;
			half _MainShadingCat;
			half __src;
			half __normals;
			half __cull;
			half _render_normals;
			half _RenderMode_TransparentInteractive;
			half _MainOcclusionValue;
			half _SecondOcclusionValue;
			float4 _EmissionColor;
			float _RenderQueueType;
			#ifdef _ADD_PRECOMPUTED_VELOCITY
			float _AddPrecomputedVelocity;
			#endif
			float _StencilRef;
			float _StencilWriteMask;
			float _StencilRefDepth;
			float _StencilWriteMaskDepth;
			float _StencilRefMV;
			float _StencilWriteMaskMV;
			float _StencilRefDistortionVec;
			float _StencilWriteMaskDistortionVec;
			float _StencilWriteMaskGBuffer;
			float _StencilRefGBuffer;
			float _ZTestGBuffer;
			float _RequireSplitLighting;
			float _ReceivesSSR;
			float _SurfaceType;
			float _BlendMode;
			float _SrcBlend;
			float _DstBlend;
			float _AlphaSrcBlend;
			float _AlphaDstBlend;
			float _ZWrite;
			float _TransparentZWrite;
			float _CullMode;
			float _TransparentSortPriority;
			float _EnableFogOnTransparent;
			float _CullModeForward;
			float _TransparentCullMode;
			float _ZTestDepthEqualForOpaque;
			float _ZTestTransparent;
			float _TransparentBackfaceEnable;
			float _AlphaCutoffEnable;
			float _AlphaCutoff;
			float _UseShadowThreshold;
			float _DoubleSidedEnable;
			float _DoubleSidedNormalMode;
			float4 _DoubleSidedConstants;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _MainTex;
			half TVE_Amplitude2;
			sampler2D TVE_NoiseTex;
			half TVE_NoiseSpeed;
			half TVE_NoiseSize;
			half TVE_NoiseContrast;
			half TVE_Amplitude1;
			sampler2D TVE_MotionTex;
			half4 TVE_MotionCoord;
			half TVE_SizeFadeEnd;
			half TVE_SizeFadeStart;
			sampler2D TVE_ExtrasTex;
			half4 TVE_ExtrasCoord;
			sampler2D _MainAlbedoTex;
			sampler2D _SecondAlbedoTex;
			sampler2D _MainMaskTex;
			sampler2D _SecondMaskTex;
			half4 TVE_OverlayColor;
			sampler2D TVE_OverlayAlbedoTex;
			half TVE_OverlayUVTilling;
			sampler2D _MainNormalTex;
			sampler2D _SecondNormalTex;
			half TVE_OverlayIntensity;
			sampler2D TVE_OverlayNormalTex;
			half TVE_OverlayNormalValue;
			half TVE_OverlaySmoothness;
			float TVE_Wetness;


			float3 ObjectPosition_UNITY_MATRIX_M(  )
			{
				return float3(UNITY_MATRIX_M[0].w, UNITY_MATRIX_M[1].w, UNITY_MATRIX_M[2].w );
			}
			

			void BuildSurfaceData(FragInputs fragInputs, inout GlobalSurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
			{
				ZERO_INITIALIZE(SurfaceData, surfaceData);

				surfaceData.specularOcclusion = 1.0;

				// surface data
				surfaceData.baseColor =					surfaceDescription.Albedo;
				surfaceData.perceptualSmoothness =		surfaceDescription.Smoothness;
				surfaceData.ambientOcclusion =			surfaceDescription.Occlusion;
				surfaceData.metallic =					surfaceDescription.Metallic;
				surfaceData.coatMask =					surfaceDescription.CoatMask;

				#ifdef _SPECULAR_OCCLUSION_CUSTOM
				surfaceData.specularOcclusion =			surfaceDescription.SpecularOcclusion;
				#endif
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.subsurfaceMask =			surfaceDescription.SubsurfaceMask;
				#endif
				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceData.thickness =					surfaceDescription.Thickness;
				#endif
				#if defined( _MATERIAL_FEATURE_SUBSURFACE_SCATTERING ) || defined( _MATERIAL_FEATURE_TRANSMISSION )
				surfaceData.diffusionProfileHash =		asuint(surfaceDescription.DiffusionProfile);
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.specularColor =				surfaceDescription.Specular;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.anisotropy =				surfaceDescription.Anisotropy;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.iridescenceMask =			surfaceDescription.IridescenceMask;
				surfaceData.iridescenceThickness =		surfaceDescription.IridescenceThickness;
				#endif

				// refraction
				#ifdef _HAS_REFRACTION
				if( _EnableSSRefraction )
				{
					surfaceData.ior = surfaceDescription.RefractionIndex;
					surfaceData.transmittanceColor = surfaceDescription.RefractionColor;
					surfaceData.atDistance = surfaceDescription.RefractionDistance;

					surfaceData.transmittanceMask = ( 1.0 - surfaceDescription.Alpha );
					surfaceDescription.Alpha = 1.0;
				}
				else
				{
					surfaceData.ior = 1.0;
					surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
					surfaceData.atDistance = 1.0;
					surfaceData.transmittanceMask = 0.0;
					surfaceDescription.Alpha = 1.0;
				}
				#else
				surfaceData.ior = 1.0;
				surfaceData.transmittanceColor = float3( 1.0, 1.0, 1.0 );
				surfaceData.atDistance = 1.0;
				surfaceData.transmittanceMask = 0.0;
				#endif


				// material features
				surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
				#endif
				#ifdef _MATERIAL_FEATURE_TRANSMISSION
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
				#endif
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
				#endif
				#ifdef ASE_LIT_CLEAR_COAT
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
				#endif
				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
				#endif
				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
				#endif

				// others
				#if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
				surfaceData.baseColor *= ( 1.0 - Max3( surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b ) );
				#endif
				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				// normals
				float3 normalTS = float3(0.0f, 0.0f, 1.0f);
				normalTS = surfaceDescription.Normal;
				GetNormalWS( fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants );

				surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];

				bentNormalWS = surfaceData.normalWS;
				#ifdef ASE_BENT_NORMAL
				GetNormalWS( fragInputs, surfaceDescription.BentNormal, bentNormalWS, doubleSidedConstants );
				#endif

				surfaceData.tangentWS = normalize( fragInputs.tangentToWorld[ 0 ].xyz );
				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceData.tangentWS = TransformTangentToWorld( surfaceDescription.Tangent, fragInputs.tangentToWorld );
				#endif
				surfaceData.tangentWS = Orthonormalize( surfaceData.tangentWS, surfaceData.normalWS );

				// decals
				#if HAVE_DECALS
				if( _EnableDecals )
				{
					DecalSurfaceData decalSurfaceData = GetDecalSurfaceData( posInput, surfaceDescription.Alpha );
					ApplyDecalToSurfaceData( decalSurfaceData, surfaceData );
				}
				#endif

				#if defined(_SPECULAR_OCCLUSION_CUSTOM)
				#elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO( V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness( surfaceData.perceptualSmoothness ) );
				#elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
				surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion( ClampNdotV( dot( surfaceData.normalWS, V ) ), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness( surfaceData.perceptualSmoothness ) );
				#endif

				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceData.perceptualSmoothness = GeometricNormalFiltering( surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[ 2 ], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold );
				#endif

				// debug
				#if defined(DEBUG_DISPLAY)
				if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
				{
					surfaceData.metallic = 0;
				}
				ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
				#endif
			}

			void GetSurfaceAndBuiltinData(GlobalSurfaceDescription surfaceDescription, FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
			{
				#ifdef LOD_FADE_CROSSFADE
				LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
				#endif

				#ifdef _DOUBLESIDED_ON
				float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
				#else
				float3 doubleSidedConstants = float3( 1.0, 1.0, 1.0 );
				#endif

				ApplyDoubleSidedFlipOrMirror( fragInputs, doubleSidedConstants );

				//#ifdef _ALPHATEST_ON
				//DoAlphaTest( surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold );
				//#endif

				#ifdef _DEPTHOFFSET_ON
				builtinData.depthOffset = surfaceDescription.DepthOffset;
				ApplyDepthOffsetPositionInput( V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput );
				#endif

				float3 bentNormalWS;
				BuildSurfaceData( fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS );

				InitBuiltinData( posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[ 2 ], fragInputs.texCoord1, fragInputs.texCoord2, builtinData );

				#ifdef _ASE_BAKEDGI
				builtinData.bakeDiffuseLighting = surfaceDescription.BakedGI;
				#endif
				#ifdef _ASE_BAKEDBACKGI
				builtinData.backBakeDiffuseLighting = surfaceDescription.BakedBackGI;
				#endif

				builtinData.emissiveColor = surfaceDescription.Emission;

				PostInitBuiltinData(V, posInput, surfaceData, builtinData);
			}

			AttributesMesh ApplyMeshModification(AttributesMesh inputMesh, float3 timeParameters, inout PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS )
			{
				_TimeParameters.xyz = timeParameters;
				half3 VertexPos40_g18271 = inputMesh.positionOS;
				float3 appendResult74_g18271 = (float3(0.0 , VertexPos40_g18271.y , 0.0));
				float3 VertexPosRotationAxis50_g18271 = appendResult74_g18271;
				float3 break84_g18271 = VertexPos40_g18271;
				float3 appendResult81_g18271 = (float3(break84_g18271.x , 0.0 , break84_g18271.z));
				float3 VertexPosOtherAxis82_g18271 = appendResult81_g18271;
				float ObjectData20_g18308 = 3.14;
				float Bounds_Radius121_g18123 = _MaxBoundsInfo.x;
				float WorldData19_g18308 = Bounds_Radius121_g18123;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18308 = WorldData19_g18308;
				#else
				float staticSwitch14_g18308 = ObjectData20_g18308;
				#endif
				float Motion_Max_Rolling1137_g18123 = staticSwitch14_g18308;
				half Global_Amplitude_270_g18123 = TVE_Amplitude2;
				half Mesh_Motion_260_g18123 = inputMesh.ase_texcoord3.y;
				float temp_output_4_0_g18291 = 1.0;
				float temp_output_5_0_g18291 = ( temp_output_4_0_g18291 * _TimeParameters.x );
				float2 temp_cast_0 = (TVE_NoiseSpeed).xx;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18290 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18290 = ( localObjectPosition_UNITY_MATRIX_M14_g18290 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18290 = localObjectPosition_UNITY_MATRIX_M14_g18290;
				#endif
				half3 ObjectData20_g18292 = staticSwitch13_g18290;
				float3 ase_worldPos = GetAbsolutePositionWS( TransformObjectToWorld( (inputMesh.positionOS).xyz ) );
				half3 WorldData19_g18292 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18292 = WorldData19_g18292;
				#else
				float3 staticSwitch14_g18292 = ObjectData20_g18292;
				#endif
				float2 panner73_g18289 = ( temp_output_5_0_g18291 * temp_cast_0 + ( (staticSwitch14_g18292).xz * TVE_NoiseSize ));
				float4 temp_cast_1 = (TVE_NoiseContrast).xxxx;
				float4 break142_g18289 = pow( abs( tex2Dlod( TVE_NoiseTex, float4( panner73_g18289, 0, 0.0) ) ) , temp_cast_1 );
				half Global_NoiseTex_R34_g18123 = break142_g18289.r;
				half Global_NoiseTex_G38_g18123 = break142_g18289.g;
				half Motion_Use20162_g18123 = _Motion_20;
				half MotionSpeed265_g18123 = _MotionSpeed_20;
				half Input_Speed62_g18262 = MotionSpeed265_g18123;
				float temp_output_4_0_g18265 = Input_Speed62_g18262;
				float temp_output_5_0_g18265 = ( temp_output_4_0_g18265 * _TimeParameters.x );
				half MotionVariation264_g18123 = _MotionVariation_20;
				float temp_output_342_0_g18262 = ( MotionVariation264_g18123 * inputMesh.ase_color.r );
				float3 localObjectPosition_UNITY_MATRIX_M14_g18263 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18263 = ( localObjectPosition_UNITY_MATRIX_M14_g18263 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18263 = localObjectPosition_UNITY_MATRIX_M14_g18263;
				#endif
				float3 break9_g18263 = staticSwitch13_g18263;
				float ObjectData20_g18264 = ( temp_output_342_0_g18262 + ( break9_g18263.x + break9_g18263.z ) );
				float WorldData19_g18264 = temp_output_342_0_g18262;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18264 = WorldData19_g18264;
				#else
				float staticSwitch14_g18264 = ObjectData20_g18264;
				#endif
				float Motion_Variation284_g18262 = staticSwitch14_g18264;
				half MotionScale262_g18123 = _MotionScale_20;
				float Motion_Scale287_g18262 = ( MotionScale262_g18123 * ase_worldPos.x );
				half Motion_Rolling138_g18123 = ( ( _MotionAmplitude_20 * Motion_Max_Rolling1137_g18123 ) * Global_Amplitude_270_g18123 * Mesh_Motion_260_g18123 * ( Global_NoiseTex_R34_g18123 + Global_NoiseTex_G38_g18123 ) * Motion_Use20162_g18123 * sin( ( temp_output_5_0_g18265 + Motion_Variation284_g18262 + Motion_Scale287_g18262 ) ) );
				half Angle44_g18271 = Motion_Rolling138_g18123;
				half3 VertexPos40_g18273 = ( VertexPosRotationAxis50_g18271 + ( VertexPosOtherAxis82_g18271 * cos( Angle44_g18271 ) ) + ( cross( float3(0,1,0) , VertexPosOtherAxis82_g18271 ) * sin( Angle44_g18271 ) ) );
				float3 appendResult74_g18273 = (float3(VertexPos40_g18273.x , 0.0 , 0.0));
				half3 VertexPosRotationAxis50_g18273 = appendResult74_g18273;
				float3 break84_g18273 = VertexPos40_g18273;
				float3 appendResult81_g18273 = (float3(0.0 , break84_g18273.y , break84_g18273.z));
				half3 VertexPosOtherAxis82_g18273 = appendResult81_g18273;
				float ObjectData20_g18309 = 3.14;
				float Bounds_Height374_g18123 = _MaxBoundsInfo.y;
				float WorldData19_g18309 = ( Bounds_Height374_g18123 * 3.14 );
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18309 = WorldData19_g18309;
				#else
				float staticSwitch14_g18309 = ObjectData20_g18309;
				#endif
				float Motion_Max_Bending1133_g18123 = staticSwitch14_g18309;
				half Global_Amplitude_136_g18123 = TVE_Amplitude1;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18268 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18268 = ( localObjectPosition_UNITY_MATRIX_M14_g18268 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18268 = localObjectPosition_UNITY_MATRIX_M14_g18268;
				#endif
				half3 ObjectData20_g18267 = staticSwitch13_g18268;
				half3 WorldData19_g18267 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18267 = WorldData19_g18267;
				#else
				float3 staticSwitch14_g18267 = ObjectData20_g18267;
				#endif
				float3 break322_g18294 = (tex2Dlod( TVE_MotionTex, float4( ( (TVE_MotionCoord).xy + ( TVE_MotionCoord.z * (staticSwitch14_g18267).xz ) ), 0, 0.0) )).rgb;
				float3 appendResult323_g18294 = (float3(break322_g18294.x , 0.0 , break322_g18294.y));
				float3 temp_output_324_0_g18294 = (appendResult323_g18294*2.0 + -1.0);
				float3 ase_parentObjectScale = ( 1.0 / float3( length( GetWorldToObjectMatrix()[ 0 ].xyz ), length( GetWorldToObjectMatrix()[ 1 ].xyz ), length( GetWorldToObjectMatrix()[ 2 ].xyz ) ) );
				half3 ObjectData20_g18295 = ( mul( GetWorldToObjectMatrix(), float4( temp_output_324_0_g18294 , 0.0 ) ).xyz * ase_parentObjectScale );
				half3 WorldData19_g18295 = temp_output_324_0_g18294;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18295 = WorldData19_g18295;
				#else
				float3 staticSwitch14_g18295 = ObjectData20_g18295;
				#endif
				float2 temp_output_1976_320_g18123 = (staticSwitch14_g18295).xz;
				half2 Motion_DirectionOS39_g18123 = temp_output_1976_320_g18123;
				half Input_Speed62_g18245 = _MotionSpeed_10;
				float temp_output_4_0_g18246 = Input_Speed62_g18245;
				float temp_output_5_0_g18246 = ( temp_output_4_0_g18246 * _TimeParameters.x );
				float temp_output_349_0_g18245 = ( _MotionVariation_10 * inputMesh.ase_color.r );
				float3 localObjectPosition_UNITY_MATRIX_M14_g18249 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18249 = ( localObjectPosition_UNITY_MATRIX_M14_g18249 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18249 = localObjectPosition_UNITY_MATRIX_M14_g18249;
				#endif
				float3 break9_g18249 = staticSwitch13_g18249;
				float ObjectData20_g18248 = ( temp_output_349_0_g18245 + ( break9_g18249.x + break9_g18249.z ) );
				float WorldData19_g18248 = temp_output_349_0_g18245;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18248 = WorldData19_g18248;
				#else
				float staticSwitch14_g18248 = ObjectData20_g18248;
				#endif
				half Motion_Variation284_g18245 = staticSwitch14_g18248;
				float2 appendResult344_g18245 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 Motion_Scale287_g18245 = ( _MotionScale_10 * appendResult344_g18245 );
				half2 Sine_MinusOneToOne281_g18245 = sin( ( temp_output_5_0_g18246 + Motion_Variation284_g18245 + Motion_Scale287_g18245 ) );
				float2 temp_cast_4 = (1.0).xx;
				half Input_Turbulence327_g18245 = Global_NoiseTex_R34_g18123;
				float2 lerpResult321_g18245 = lerp( Sine_MinusOneToOne281_g18245 , temp_cast_4 , Input_Turbulence327_g18245);
				float2 temp_output_84_0_g18123 = ( ( _MotionAmplitude_10 * Motion_Max_Bending1133_g18123 ) * Global_Amplitude_136_g18123 * Global_NoiseTex_R34_g18123 * Motion_DirectionOS39_g18123 * lerpResult321_g18245 );
				float temp_output_1976_333_g18123 = break322_g18294.z;
				half2 Motion_Interaction53_g18123 = ( _InteractionAmplitude * Motion_Max_Bending1133_g18123 * temp_output_1976_320_g18123 * temp_output_1976_333_g18123 * temp_output_1976_333_g18123 );
				half Motion_InteractionMask66_g18123 = temp_output_1976_333_g18123;
				float2 lerpResult109_g18123 = lerp( temp_output_84_0_g18123 , Motion_Interaction53_g18123 , Motion_InteractionMask66_g18123);
				half Mesh_Motion_182_g18123 = inputMesh.ase_texcoord3.x;
				half Motion_Use1056_g18123 = ( _Motion_10 + ( _MotionCat * 0.0 ) );
				float2 break143_g18123 = ( lerpResult109_g18123 * Mesh_Motion_182_g18123 * Motion_Use1056_g18123 );
				half Motion_Z190_g18123 = break143_g18123.y;
				half Angle44_g18273 = Motion_Z190_g18123;
				half3 VertexPos40_g18281 = ( VertexPosRotationAxis50_g18273 + ( VertexPosOtherAxis82_g18273 * cos( Angle44_g18273 ) ) + ( cross( float3(1,0,0) , VertexPosOtherAxis82_g18273 ) * sin( Angle44_g18273 ) ) );
				float3 appendResult74_g18281 = (float3(0.0 , 0.0 , VertexPos40_g18281.z));
				half3 VertexPosRotationAxis50_g18281 = appendResult74_g18281;
				float3 break84_g18281 = VertexPos40_g18281;
				float3 appendResult81_g18281 = (float3(break84_g18281.x , break84_g18281.y , 0.0));
				half3 VertexPosOtherAxis82_g18281 = appendResult81_g18281;
				half Motion_X216_g18123 = break143_g18123.x;
				half Angle44_g18281 = -Motion_X216_g18123;
				half Global_NoiseTex_B132_g18123 = break142_g18289.b;
				half Input_Speed62_g18302 = -MotionSpeed265_g18123;
				float temp_output_4_0_g18305 = Input_Speed62_g18302;
				float temp_output_5_0_g18305 = ( temp_output_4_0_g18305 * _TimeParameters.x );
				float temp_output_342_0_g18302 = ( -MotionVariation264_g18123 * inputMesh.ase_color.r );
				float3 localObjectPosition_UNITY_MATRIX_M14_g18303 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18303 = ( localObjectPosition_UNITY_MATRIX_M14_g18303 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18303 = localObjectPosition_UNITY_MATRIX_M14_g18303;
				#endif
				float3 break9_g18303 = staticSwitch13_g18303;
				float ObjectData20_g18304 = ( temp_output_342_0_g18302 + ( break9_g18303.x + break9_g18303.z ) );
				float WorldData19_g18304 = temp_output_342_0_g18302;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18304 = WorldData19_g18304;
				#else
				float staticSwitch14_g18304 = ObjectData20_g18304;
				#endif
				float Motion_Variation284_g18302 = staticSwitch14_g18304;
				float Motion_Scale287_g18302 = ( MotionScale262_g18123 * ase_worldPos.x );
				float3 appendResult2014_g18123 = (float3(0.0 , ( ( _MotionVertical_20 * Bounds_Radius121_g18123 ) * Global_Amplitude_270_g18123 * Mesh_Motion_260_g18123 * Motion_Use20162_g18123 * ( Global_NoiseTex_R34_g18123 + Global_NoiseTex_B132_g18123 ) * sin( ( temp_output_5_0_g18305 + Motion_Variation284_g18302 + Motion_Scale287_g18302 ) ) ) , 0.0));
				half3 Motion_Vertical223_g18123 = appendResult2014_g18123;
				float3 Vertex_Motion_Object833_g18123 = ( ( VertexPosRotationAxis50_g18281 + ( VertexPosOtherAxis82_g18281 * cos( Angle44_g18281 ) ) + ( cross( float3(0,0,1) , VertexPosOtherAxis82_g18281 ) * sin( Angle44_g18281 ) ) ) + Motion_Vertical223_g18123 );
				half3 ObjectData20_g18272 = Vertex_Motion_Object833_g18123;
				float3 appendResult2047_g18123 = (float3(Motion_Rolling138_g18123 , 0.0 , -Motion_Rolling138_g18123));
				float3 appendResult2043_g18123 = (float3(Motion_X216_g18123 , 0.0 , Motion_Z190_g18123));
				float3 Vertex_Motion_World1118_g18123 = ( ( ( inputMesh.positionOS + appendResult2047_g18123 ) + appendResult2043_g18123 ) + Motion_Vertical223_g18123 );
				half3 WorldData19_g18272 = Vertex_Motion_World1118_g18123;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18272 = WorldData19_g18272;
				#else
				float3 staticSwitch14_g18272 = ObjectData20_g18272;
				#endif
				float3 localObjectPosition_UNITY_MATRIX_M14_g18274 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18274 = ( localObjectPosition_UNITY_MATRIX_M14_g18274 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18274 = localObjectPosition_UNITY_MATRIX_M14_g18274;
				#endif
				half Global_SizeFadeEnd287_g18123 = TVE_SizeFadeEnd;
				float temp_output_7_0_g18269 = Global_SizeFadeEnd287_g18123;
				half Global_SizeFadeStart276_g18123 = TVE_SizeFadeStart;
				float lerpResult348_g18123 = lerp( 1.0 , saturate( ( ( distance( _WorldSpaceCameraPos , staticSwitch13_g18274 ) - temp_output_7_0_g18269 ) / ( Global_SizeFadeStart276_g18123 - temp_output_7_0_g18269 ) ) ) , _GlobalSizeFade);
				float ObjectData20_g18278 = lerpResult348_g18123;
				float WorldData19_g18278 = 1.0;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18278 = WorldData19_g18278;
				#else
				float staticSwitch14_g18278 = ObjectData20_g18278;
				#endif
				float Vertex_SizeFade1740_g18123 = staticSwitch14_g18278;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18298 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18298 = ( localObjectPosition_UNITY_MATRIX_M14_g18298 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18298 = localObjectPosition_UNITY_MATRIX_M14_g18298;
				#endif
				half3 ObjectData20_g18299 = staticSwitch13_g18298;
				half3 WorldData19_g18299 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18299 = WorldData19_g18299;
				#else
				float3 staticSwitch14_g18299 = ObjectData20_g18299;
				#endif
				float4 tex2DNode7_g18297 = tex2Dlod( TVE_ExtrasTex, float4( ( (TVE_ExtrasCoord).xy + ( TVE_ExtrasCoord.z * (staticSwitch14_g18299).xz ) ), 0, 0.0) );
				half Global_ExtrasTex_G305_g18123 = tex2DNode7_g18297.g;
				float lerpResult346_g18123 = lerp( 1.0 , Global_ExtrasTex_G305_g18123 , _GlobalSize);
				float ObjectData20_g18270 = lerpResult346_g18123;
				float WorldData19_g18270 = 1.0;
				#ifdef MATERIAL_USE_WORLD_DATA
				float staticSwitch14_g18270 = WorldData19_g18270;
				#else
				float staticSwitch14_g18270 = ObjectData20_g18270;
				#endif
				half Vertex_Size1741_g18123 = staticSwitch14_g18270;
				float3 Final_Vertex890_g18123 = ( ( staticSwitch14_g18272 * Vertex_SizeFade1740_g18123 * Vertex_Size1741_g18123 ) + ( _IsHDPipeline * 0.0 ) );
				
				float3 ase_worldNormal = TransformObjectToWorldNormal(inputMesh.normalOS);
				float3 ase_worldTangent = TransformObjectToWorldDir(inputMesh.tangentOS.xyz);
				float ase_vertexTangentSign = inputMesh.tangentOS.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				outputPackedVaryingsMeshToPS.ase_texcoord8.xyz = ase_worldBitangent;
				
				outputPackedVaryingsMeshToPS.ase_texcoord7 = inputMesh.ase_texcoord;
				outputPackedVaryingsMeshToPS.ase_color = inputMesh.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				outputPackedVaryingsMeshToPS.ase_texcoord8.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = inputMesh.positionOS.xyz;
				#else
				float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = Final_Vertex890_g18123;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
				inputMesh.positionOS.xyz = vertexValue;
				#else
				inputMesh.positionOS.xyz += vertexValue;
				#endif
				inputMesh.normalOS = inputMesh.normalOS;
				inputMesh.tangentOS = inputMesh.tangentOS;
				return inputMesh;
			}

			PackedVaryingsMeshToPS VertexFunction(AttributesMesh inputMesh)
			{
				PackedVaryingsMeshToPS outputPackedVaryingsMeshToPS = (PackedVaryingsMeshToPS)0;
				AttributesMesh defaultMesh = inputMesh;

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, outputPackedVaryingsMeshToPS);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( outputPackedVaryingsMeshToPS );

				inputMesh = ApplyMeshModification( inputMesh, _TimeParameters.xyz, outputPackedVaryingsMeshToPS);

				float3 positionRWS = TransformObjectToWorld(inputMesh.positionOS);
				float3 normalWS = TransformObjectToWorldNormal(inputMesh.normalOS);
				float4 tangentWS = float4(TransformObjectToWorldDir(inputMesh.tangentOS.xyz), inputMesh.tangentOS.w);

				#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
				float4 VPASSpreviousPositionCS;
				float4 VPASSpositionCS = mul(UNITY_MATRIX_UNJITTERED_VP, float4(positionRWS, 1.0));

				bool forceNoMotion = unity_MotionVectorsParams.y == 0.0;
				if (forceNoMotion)
				{
					VPASSpreviousPositionCS = float4(0.0, 0.0, 0.0, 1.0);
				}
				else
				{
					bool hasDeformation = unity_MotionVectorsParams.x > 0.0;
					float3 effectivePositionOS = (hasDeformation ? inputMesh.previousPositionOS : defaultMesh.positionOS);
					#if defined(_ADD_PRECOMPUTED_VELOCITY)
					effectivePositionOS -= inputMesh.precomputedVelocity;
					#endif

					#if defined(HAVE_MESH_MODIFICATION)
						AttributesMesh previousMesh = defaultMesh;
						previousMesh.positionOS = effectivePositionOS ;
						PackedVaryingsMeshToPS test = (PackedVaryingsMeshToPS)0;
						float3 curTime = _TimeParameters.xyz;
						previousMesh = ApplyMeshModification(previousMesh, _LastTimeParameters.xyz, test);
						_TimeParameters.xyz = curTime;
						float3 previousPositionRWS = TransformPreviousObjectToWorld(previousMesh.positionOS);
					#else
						float3 previousPositionRWS = TransformPreviousObjectToWorld(effectivePositionOS);
					#endif

					#ifdef ATTRIBUTES_NEED_NORMAL
						float3 normalWS = TransformPreviousObjectToWorldNormal(defaultMesh.normalOS);
					#else
						float3 normalWS = float3(0.0, 0.0, 0.0);
					#endif

					#if defined(HAVE_VERTEX_MODIFICATION)
						//ApplyVertexModification(inputMesh, normalWS, previousPositionRWS, _LastTimeParameters.xyz);
					#endif

					VPASSpreviousPositionCS = mul(UNITY_MATRIX_PREV_VP, float4(previousPositionRWS, 1.0));
				}
				#endif

				outputPackedVaryingsMeshToPS.positionCS = TransformWorldToHClip(positionRWS);
				outputPackedVaryingsMeshToPS.interp00.xyz = positionRWS;
				outputPackedVaryingsMeshToPS.interp01.xyz = normalWS;
				outputPackedVaryingsMeshToPS.interp02.xyzw = tangentWS;
				outputPackedVaryingsMeshToPS.interp03.xyzw = inputMesh.uv1;
				outputPackedVaryingsMeshToPS.interp04.xyzw = inputMesh.uv2;

				#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
					outputPackedVaryingsMeshToPS.vpassPositionCS = float3(VPASSpositionCS.xyw);
					outputPackedVaryingsMeshToPS.vpassPreviousPositionCS = float3(VPASSpreviousPositionCS.xyw);
				#endif
				return outputPackedVaryingsMeshToPS;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float3 positionOS : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
					float3 previousPositionOS : TEXCOORD4;
					#if defined (_ADD_PRECOMPUTED_VELOCITY)
						float3 precomputedVelocity : TEXCOORD5;
					#endif
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl Vert ( AttributesMesh v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.positionOS = v.positionOS;
				o.normalOS = v.normalOS;
				o.tangentOS = v.tangentOS;
				o.uv1 = v.uv1;
				o.uv2 = v.uv2;
				#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
					o.previousPositionOS = v.previousPositionOS;
					#if defined (_ADD_PRECOMPUTED_VELOCITY)
						o.precomputedVelocity = v.precomputedVelocity;
					#endif
				#endif
				o.ase_texcoord3 = v.ase_texcoord3;
				o.ase_color = v.ase_color;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if (SHADEROPTIONS_CAMERA_RELATIVE_RENDERING != 0)
				float3 cameraPos = 0;
				#else
				float3 cameraPos = _WorldSpaceCameraPos;
				#endif
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), cameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, GetObjectToWorldMatrix(), cameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(float4(v[0].positionOS,1), float4(v[1].positionOS,1), float4(v[2].positionOS,1), edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), cameraPos, _ScreenParams, _FrustumPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			PackedVaryingsMeshToPS DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				AttributesMesh o = (AttributesMesh) 0;
				o.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				o.uv1 = patch[0].uv1 * bary.x + patch[1].uv1 * bary.y + patch[2].uv1 * bary.z;
				o.uv2 = patch[0].uv2 * bary.x + patch[1].uv2 * bary.y + patch[2].uv2 * bary.z;
				#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
					o.previousPositionOS = patch[0].previousPositionOS * bary.x + patch[1].previousPositionOS * bary.y + patch[2].previousPositionOS * bary.z;
					#if defined (_ADD_PRECOMPUTED_VELOCITY)
						o.precomputedVelocity = patch[0].precomputedVelocity * bary.x + patch[1].precomputedVelocity * bary.y + patch[2].precomputedVelocity * bary.z;
					#endif
				#endif
				o.ase_texcoord3 = patch[0].ase_texcoord3 * bary.x + patch[1].ase_texcoord3 * bary.y + patch[2].ase_texcoord3 * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			PackedVaryingsMeshToPS Vert ( AttributesMesh v )
			{
				return VertexFunction( v );
			}
			#endif

			void Frag(PackedVaryingsMeshToPS packedInput,
					#ifdef OUTPUT_SPLIT_LIGHTING
						out float4 outColor : SV_Target0,
						out float4 outDiffuseLighting : SV_Target1,
						OUTPUT_SSSBUFFER(outSSSBuffer)
					#else
						out float4 outColor : SV_Target0
					#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
						, out float4 outMotionVec : SV_Target1
					#endif
					#endif
					#ifdef _DEPTHOFFSET_ON
						, out float outputDepth : SV_Depth
					#endif
					
						)
			{
				#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
					outMotionVec = float4(2.0, 0.0, 0.0, 0.0);
				#endif

				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( packedInput );
				UNITY_SETUP_INSTANCE_ID( packedInput );
				float3 positionRWS = packedInput.interp00.xyz;
				float3 normalWS = packedInput.interp01.xyz;
				float4 tangentWS = packedInput.interp02.xyzw;

				FragInputs input;
				ZERO_INITIALIZE(FragInputs, input);
				input.tangentToWorld = k_identity3x3;
				input.positionSS = packedInput.positionCS;
				input.positionRWS = positionRWS;
				input.tangentToWorld = BuildTangentToWorld(tangentWS, normalWS);
				input.texCoord1 = packedInput.interp03.xyzw;
				input.texCoord2 = packedInput.interp04.xyzw;

				#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
				input.isFrontFace = IS_FRONT_VFACE( packedInput.cullFace, true, false);
				#elif SHADER_STAGE_FRAGMENT
				#if defined(ASE_NEED_CULLFACE)
				input.isFrontFace = IS_FRONT_VFACE(packedInput.cullFace, true, false);
				#endif
				#endif
				half isFrontFace = input.isFrontFace;

				input.positionSS.xy = _OffScreenRendering > 0 ? (input.positionSS.xy * _OffScreenDownsampleFactor) : input.positionSS.xy;
				uint2 tileIndex = uint2(input.positionSS.xy) / GetTileSize ();

				PositionInputs posInput = GetPositionInput( input.positionSS.xy, _ScreenSize.zw, input.positionSS.z, input.positionSS.w, input.positionRWS.xyz, tileIndex );

				float3 V = GetWorldSpaceNormalizeViewDir(input.positionRWS);

				GlobalSurfaceDescription surfaceDescription = (GlobalSurfaceDescription)0;
				float2 Main_UVs15_g18123 = ( ( packedInput.ase_texcoord7.xy * (_MainUVs).xy ) + (_MainUVs).zw );
				float4 tex2DNode29_g18123 = tex2D( _MainAlbedoTex, Main_UVs15_g18123 );
				float4 temp_output_51_0_g18123 = ( _MainColor * tex2DNode29_g18123 );
				half3 Main_AlbedoRaw99_g18123 = (temp_output_51_0_g18123).rgb;
				half3 Main_AlbedoColored863_g18123 = Main_AlbedoRaw99_g18123;
				float2 appendResult21_g18296 = (float2(packedInput.ase_texcoord7.z , packedInput.ase_texcoord7.w));
				float2 Mesh_DetailCoord3_g18123 = appendResult21_g18296;
				float2 Second_UVs17_g18123 = ( ( Mesh_DetailCoord3_g18123 * (_SecondUVs).xy ) + (_SecondUVs).zw );
				half3 Second_Albedo153_g18123 = (( _SecondColor * tex2D( _SecondAlbedoTex, Second_UVs17_g18123 ) )).rgb;
				half3 Second_AlbedoColored1963_g18123 = Second_Albedo153_g18123;
				half Mesh_DetailMask90_g18123 = packedInput.ase_color.b;
				float temp_output_989_0_g18123 = ( ( Mesh_DetailMask90_g18123 - 0.5 ) + _DetailMeshValue );
				half Blend_Source1540_g18123 = temp_output_989_0_g18123;
				float4 tex2DNode35_g18123 = tex2D( _MainMaskTex, Main_UVs15_g18123 );
				half Main_Mask57_g18123 = tex2DNode35_g18123.b;
				float4 tex2DNode33_g18123 = tex2D( _SecondMaskTex, Second_UVs17_g18123 );
				half Second_Mask81_g18123 = tex2DNode33_g18123.b;
				float lerpResult1327_g18123 = lerp( Main_Mask57_g18123 , Second_Mask81_g18123 , _MaskMode);
				float temp_output_7_0_g18284 = _DetailMaskContrast;
				half AutoRegister_DetailMode667_g18123 = ( 0.0 * _DetailMode * _DetailShadingCat );
				half Mask_Detail147_g18123 = ( saturate( ( ( saturate( ( Blend_Source1540_g18123 + ( Blend_Source1540_g18123 * ( ( ( 1.0 - lerpResult1327_g18123 ) - 0.5 ) + _DetailMaskValue ) ) ) ) - temp_output_7_0_g18284 ) / ( ( 1.0 - _DetailMaskContrast ) - temp_output_7_0_g18284 ) ) ) + AutoRegister_DetailMode667_g18123 );
				float3 lerpResult235_g18123 = lerp( Main_AlbedoColored863_g18123 , ( Main_AlbedoColored863_g18123 * Second_AlbedoColored1963_g18123 * 4.594794 ) , Mask_Detail147_g18123);
				float3 lerpResult208_g18123 = lerp( Main_AlbedoColored863_g18123 , Second_AlbedoColored1963_g18123 , Mask_Detail147_g18123);
				#if defined(MATERIAL_USE_DETAIL_OFF)
				float3 staticSwitch255_g18123 = Main_AlbedoColored863_g18123;
				#elif defined(MATERIAL_USE_DETAIL_OVERLAY)
				float3 staticSwitch255_g18123 = lerpResult235_g18123;
				#elif defined(MATERIAL_USE_DETAIL_HEIGHT)
				float3 staticSwitch255_g18123 = lerpResult208_g18123;
				#else
				float3 staticSwitch255_g18123 = Main_AlbedoColored863_g18123;
				#endif
				half3 Blend_Albedo265_g18123 = staticSwitch255_g18123;
				half3 Blend_AlbedoAndSubsurface149_g18123 = Blend_Albedo265_g18123;
				float3 temp_output_44_0_g18258 = (TVE_OverlayColor).rgb;
				half3 Global_OverlayColor1758_g18123 = temp_output_44_0_g18258;
				float2 temp_output_38_0_g18258 = ( _OverlayUVTilling * packedInput.ase_texcoord7.xy * TVE_OverlayUVTilling );
				float3 temp_output_34_0_g18258 = (tex2D( TVE_OverlayAlbedoTex, temp_output_38_0_g18258 )).rgb;
				half3 Global_OverlayAlbedo277_g18123 = temp_output_34_0_g18258;
				float4 tex2DNode117_g18123 = tex2D( _MainNormalTex, Main_UVs15_g18123 );
				float2 appendResult88_g18301 = (float2(tex2DNode117_g18123.a , tex2DNode117_g18123.g));
				float2 temp_output_90_0_g18301 = ( (appendResult88_g18301*2.0 + -1.0) * _MainNormalValue );
				float3 appendResult91_g18301 = (float3(temp_output_90_0_g18301 , 1.0));
				float3 Main_Normal137_g18123 = appendResult91_g18301;
				float4 tex2DNode145_g18123 = tex2D( _SecondNormalTex, Second_UVs17_g18123 );
				float2 appendResult88_g18256 = (float2(tex2DNode145_g18123.a , tex2DNode145_g18123.g));
				float2 temp_output_90_0_g18256 = ( (appendResult88_g18256*2.0 + -1.0) * _SecondNormalValue );
				float3 appendResult91_g18256 = (float3(temp_output_90_0_g18256 , 1.0));
				float3 Second_Normal179_g18123 = appendResult91_g18256;
				float3 lerpResult230_g18123 = lerp( float3( 0,0,1 ) , Second_Normal179_g18123 , Mask_Detail147_g18123);
				float3 lerpResult249_g18123 = lerp( Main_Normal137_g18123 , Second_Normal179_g18123 , Mask_Detail147_g18123);
				#if defined(MATERIAL_USE_DETAIL_OFF)
				float3 staticSwitch267_g18123 = Main_Normal137_g18123;
				#elif defined(MATERIAL_USE_DETAIL_OVERLAY)
				float3 staticSwitch267_g18123 = BlendNormal( Main_Normal137_g18123 , lerpResult230_g18123 );
				#elif defined(MATERIAL_USE_DETAIL_HEIGHT)
				float3 staticSwitch267_g18123 = lerpResult249_g18123;
				#else
				float3 staticSwitch267_g18123 = Main_Normal137_g18123;
				#endif
				float3 Blend_NormalRaw1051_g18123 = staticSwitch267_g18123;
				float3 switchResult1063_g18123 = (((isFrontFace>0)?(Blend_NormalRaw1051_g18123):(( Blend_NormalRaw1051_g18123 * float3(-1,-1,-1) ))));
				half Overlay_Contrast1405_g18123 = _OverlayContrast;
				float3 appendResult1439_g18123 = (float3(Overlay_Contrast1405_g18123 , Overlay_Contrast1405_g18123 , 1.0));
				float3 ase_worldBitangent = packedInput.ase_texcoord8.xyz;
				float3 tanToWorld0 = float3( tangentWS.xyz.x, ase_worldBitangent.x, normalWS.x );
				float3 tanToWorld1 = float3( tangentWS.xyz.y, ase_worldBitangent.y, normalWS.y );
				float3 tanToWorld2 = float3( tangentWS.xyz.z, ase_worldBitangent.z, normalWS.z );
				float3 tanNormal178_g18123 = ( switchResult1063_g18123 * appendResult1439_g18123 );
				float3 worldNormal178_g18123 = float3(dot(tanToWorld0,tanNormal178_g18123), dot(tanToWorld1,tanNormal178_g18123), dot(tanToWorld2,tanNormal178_g18123));
				half Global_OverlayIntensity154_g18123 = TVE_OverlayIntensity;
				float3 localObjectPosition_UNITY_MATRIX_M14_g18298 = ObjectPosition_UNITY_MATRIX_M();
				#ifdef SHADEROPTIONS_CAMERA_RELATIVE_RENDERING
				float3 staticSwitch13_g18298 = ( localObjectPosition_UNITY_MATRIX_M14_g18298 + _WorldSpaceCameraPos );
				#else
				float3 staticSwitch13_g18298 = localObjectPosition_UNITY_MATRIX_M14_g18298;
				#endif
				half3 ObjectData20_g18299 = staticSwitch13_g18298;
				float3 ase_worldPos = GetAbsolutePositionWS( positionRWS );
				half3 WorldData19_g18299 = ase_worldPos;
				#ifdef MATERIAL_USE_WORLD_DATA
				float3 staticSwitch14_g18299 = WorldData19_g18299;
				#else
				float3 staticSwitch14_g18299 = ObjectData20_g18299;
				#endif
				float4 tex2DNode7_g18297 = tex2D( TVE_ExtrasTex, ( (TVE_ExtrasCoord).xy + ( TVE_ExtrasCoord.z * (staticSwitch14_g18299).xz ) ) );
				half Global_ExtrasTex_B156_g18123 = tex2DNode7_g18297.b;
				float temp_output_1025_0_g18123 = ( Global_OverlayIntensity154_g18123 * _GlobalOverlay * Global_ExtrasTex_B156_g18123 );
				half Overlay_Commons1365_g18123 = temp_output_1025_0_g18123;
				half Overlay_Mask269_g18123 = saturate( ( saturate( worldNormal178_g18123.y ) - ( 1.0 - Overlay_Commons1365_g18123 ) ) );
				float3 lerpResult336_g18123 = lerp( Blend_AlbedoAndSubsurface149_g18123 , ( Global_OverlayColor1758_g18123 * Global_OverlayAlbedo277_g18123 ) , Overlay_Mask269_g18123);
				half3 Final_Albedo359_g18123 = lerpResult336_g18123;
				half Main_Alpha316_g18123 = (temp_output_51_0_g18123).a;
				float lerpResult354_g18123 = lerp( 1.0 , Main_Alpha316_g18123 , __premul);
				half Final_Premultiply355_g18123 = lerpResult354_g18123;
				
				float3 temp_output_13_0_g18300 = staticSwitch267_g18123;
				float3 switchResult12_g18300 = (((isFrontFace>0)?(temp_output_13_0_g18300):(( temp_output_13_0_g18300 * _render_normals_options ))));
				half3 Blend_Normal312_g18123 = switchResult12_g18300;
				float4 tex2DNode33_g18258 = tex2D( TVE_OverlayNormalTex, temp_output_38_0_g18258 );
				float2 appendResult88_g18259 = (float2(tex2DNode33_g18258.a , tex2DNode33_g18258.g));
				float2 temp_output_90_0_g18259 = ( (appendResult88_g18259*2.0 + -1.0) * TVE_OverlayNormalValue );
				float3 appendResult91_g18259 = (float3(temp_output_90_0_g18259 , 1.0));
				float3 temp_output_84_19_g18258 = appendResult91_g18259;
				half3 Global_OverlayNormal313_g18123 = temp_output_84_19_g18258;
				float3 lerpResult349_g18123 = lerp( Blend_Normal312_g18123 , Global_OverlayNormal313_g18123 , Overlay_Mask269_g18123);
				half3 Final_Normal366_g18123 = lerpResult349_g18123;
				
				half Main_Smoothness227_g18123 = ( tex2DNode35_g18123.a * _MainSmoothnessValue );
				half Second_Smoothness236_g18123 = ( tex2DNode33_g18123.a * _SecondSmoothnessValue );
				float lerpResult266_g18123 = lerp( Main_Smoothness227_g18123 , Second_Smoothness236_g18123 , Mask_Detail147_g18123);
				#if defined(MATERIAL_USE_DETAIL_OFF)
				float staticSwitch297_g18123 = Main_Smoothness227_g18123;
				#elif defined(MATERIAL_USE_DETAIL_OVERLAY)
				float staticSwitch297_g18123 = Main_Smoothness227_g18123;
				#elif defined(MATERIAL_USE_DETAIL_HEIGHT)
				float staticSwitch297_g18123 = lerpResult266_g18123;
				#else
				float staticSwitch297_g18123 = Main_Smoothness227_g18123;
				#endif
				half Blend_Smoothness314_g18123 = staticSwitch297_g18123;
				half Global_OverlaySmoothness311_g18123 = TVE_OverlaySmoothness;
				float lerpResult343_g18123 = lerp( Blend_Smoothness314_g18123 , Global_OverlaySmoothness311_g18123 , Overlay_Mask269_g18123);
				half Final_Smoothness371_g18123 = lerpResult343_g18123;
				half Global_Wetness1016_g18123 = ( TVE_Wetness * _GlobalWetness );
				half Global_ExtrasTex_A1033_g18123 = tex2DNode7_g18297.a;
				float lerpResult1037_g18123 = lerp( Final_Smoothness371_g18123 , saturate( ( Final_Smoothness371_g18123 + Global_Wetness1016_g18123 ) ) , Global_ExtrasTex_A1033_g18123);
				
				half Mesh_Occlusion318_g18123 = packedInput.ase_color.g;
				float saferPower1201_g18123 = max( Mesh_Occlusion318_g18123 , 0.0001 );
				half Vertex_Occlusion648_g18123 = pow( saferPower1201_g18123 , _ObjectOcclusionValue );
				float lerpResult240_g18123 = lerp( 1.0 , tex2DNode35_g18123.g , _MainOcclusionValue);
				half Main_Occlusion247_g18123 = lerpResult240_g18123;
				float lerpResult239_g18123 = lerp( 1.0 , tex2DNode33_g18123.g , _SecondOcclusionValue);
				half Second_Occlusion251_g18123 = lerpResult239_g18123;
				float lerpResult294_g18123 = lerp( Main_Occlusion247_g18123 , Second_Occlusion251_g18123 , Mask_Detail147_g18123);
				#if defined(MATERIAL_USE_DETAIL_OFF)
				float staticSwitch310_g18123 = Main_Occlusion247_g18123;
				#elif defined(MATERIAL_USE_DETAIL_OVERLAY)
				float staticSwitch310_g18123 = ( Main_Occlusion247_g18123 * Second_Occlusion251_g18123 );
				#elif defined(MATERIAL_USE_DETAIL_HEIGHT)
				float staticSwitch310_g18123 = lerpResult294_g18123;
				#else
				float staticSwitch310_g18123 = Main_Occlusion247_g18123;
				#endif
				half Blend_Occlusion323_g18123 = staticSwitch310_g18123;
				
				float localCustomAlphaClip9_g18277 = ( 0.0 );
				half Main_AlphaRaw1203_g18123 = tex2DNode29_g18123.a;
				half Alpha5_g18277 = Main_AlphaRaw1203_g18123;
				float Alpha9_g18277 = Alpha5_g18277;
				float AlphaClipThreshold9_g18277 = _Cutoff;
				#if _ALPHATEST_ON
				clip(Alpha9_g18277 - AlphaClipThreshold9_g18277);
				#endif
				half Final_Clip914_g18123 = localCustomAlphaClip9_g18277;
				
				surfaceDescription.Albedo = ( Final_Albedo359_g18123 * Final_Premultiply355_g18123 );
				surfaceDescription.Normal = Final_Normal366_g18123;
				surfaceDescription.BentNormal = float3( 0, 0, 1 );
				surfaceDescription.CoatMask = 0;
				surfaceDescription.Metallic = 0;

				#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
				surfaceDescription.Specular = 0;
				#endif

				surfaceDescription.Emission = 0;
				surfaceDescription.Smoothness = lerpResult1037_g18123;
				surfaceDescription.Occlusion = ( Vertex_Occlusion648_g18123 * Blend_Occlusion323_g18123 );
				surfaceDescription.Alpha = Main_Alpha316_g18123;

				#ifdef _ALPHATEST_ON
				surfaceDescription.AlphaClipThreshold = Final_Clip914_g18123;
				#endif

				#ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
				surfaceDescription.SpecularAAScreenSpaceVariance = 0;
				surfaceDescription.SpecularAAThreshold = 0;
				#endif

				#ifdef _SPECULAR_OCCLUSION_CUSTOM
				surfaceDescription.SpecularOcclusion = 0;
				#endif

				#if defined(_HAS_REFRACTION) || defined(_MATERIAL_FEATURE_TRANSMISSION)
				surfaceDescription.Thickness = 1;
				#endif

				#ifdef _HAS_REFRACTION
				surfaceDescription.RefractionIndex = 1;
				surfaceDescription.RefractionColor = float3( 1, 1, 1 );
				surfaceDescription.RefractionDistance = 0;
				#endif

				#ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
				surfaceDescription.SubsurfaceMask = 1;
				#endif

				#if defined( _MATERIAL_FEATURE_SUBSURFACE_SCATTERING ) || defined( _MATERIAL_FEATURE_TRANSMISSION )
				surfaceDescription.DiffusionProfile = 0;
				#endif

				#ifdef _MATERIAL_FEATURE_ANISOTROPY
				surfaceDescription.Anisotropy = 1;
				surfaceDescription.Tangent = float3( 1, 0, 0 );
				#endif

				#ifdef _MATERIAL_FEATURE_IRIDESCENCE
				surfaceDescription.IridescenceMask = 0;
				surfaceDescription.IridescenceThickness = 0;
				#endif

				#ifdef _ASE_BAKEDGI
				surfaceDescription.BakedGI = 0;
				#endif
				#ifdef _ASE_BAKEDBACKGI
				surfaceDescription.BakedBackGI = 0;
				#endif

				#ifdef _DEPTHOFFSET_ON
				surfaceDescription.DepthOffset = 0;
				#endif

				SurfaceData surfaceData;
				BuiltinData builtinData;
				GetSurfaceAndBuiltinData(surfaceDescription,input, V, posInput, surfaceData, builtinData);

				BSDFData bsdfData = ConvertSurfaceDataToBSDFData(input.positionSS.xy, surfaceData);

				PreLightData preLightData = GetPreLightData(V, posInput, bsdfData);

				outColor = float4(0.0, 0.0, 0.0, 0.0);
				#ifdef DEBUG_DISPLAY
				#ifdef OUTPUT_SPLIT_LIGHTING
					outDiffuseLighting = 0;
					ENCODE_INTO_SSSBUFFER(surfaceData, posInput.positionSS, outSSSBuffer);
				#endif

				bool viewMaterial = false;
				int bufferSize = int(_DebugViewMaterialArray[0]);
				if (bufferSize != 0)
				{
					bool needLinearToSRGB = false;
					float3 result = float3(1.0, 0.0, 1.0);

					for (int index = 1; index <= bufferSize; index++)
					{
						int indexMaterialProperty = int(_DebugViewMaterialArray[index]);

						if (indexMaterialProperty != 0)
						{
							viewMaterial = true;

							GetPropertiesDataDebug(indexMaterialProperty, result, needLinearToSRGB);
							GetVaryingsDataDebug(indexMaterialProperty, input, result, needLinearToSRGB);
							GetBuiltinDataDebug(indexMaterialProperty, builtinData, result, needLinearToSRGB);
							GetSurfaceDataDebug(indexMaterialProperty, surfaceData, result, needLinearToSRGB);
							GetBSDFDataDebug(indexMaterialProperty, bsdfData, result, needLinearToSRGB);
						}
					}

					if (!needLinearToSRGB)
						result = SRGBToLinear(max(0, result));

					outColor = float4(result, 1.0);
				}

				if (!viewMaterial)
				{
					if (_DebugFullScreenMode == FULLSCREENDEBUGMODE_VALIDATE_DIFFUSE_COLOR || _DebugFullScreenMode == FULLSCREENDEBUGMODE_VALIDATE_SPECULAR_COLOR)
					{
						float3 result = float3(0.0, 0.0, 0.0);

						GetPBRValidatorDebug(surfaceData, result);

						outColor = float4(result, 1.0f);
					}
					else if (_DebugFullScreenMode == FULLSCREENDEBUGMODE_TRANSPARENCY_OVERDRAW)
					{
						float4 result = _DebugTransparencyOverdrawWeight * float4(TRANSPARENCY_OVERDRAW_COST, TRANSPARENCY_OVERDRAW_COST, TRANSPARENCY_OVERDRAW_COST, TRANSPARENCY_OVERDRAW_A);
						outColor = result;
					}
					else
				#endif
					{
				#ifdef _SURFACE_TYPE_TRANSPARENT
						uint featureFlags = LIGHT_FEATURE_MASK_FLAGS_TRANSPARENT;
				#else
						uint featureFlags = LIGHT_FEATURE_MASK_FLAGS_OPAQUE;
				#endif
						float3 diffuseLighting;
						float3 specularLighting;

						LightLoop(V, posInput, preLightData, bsdfData, builtinData, featureFlags, diffuseLighting, specularLighting);

						diffuseLighting *= GetCurrentExposureMultiplier();
						specularLighting *= GetCurrentExposureMultiplier();

				#ifdef OUTPUT_SPLIT_LIGHTING
						if (_EnableSubsurfaceScattering != 0 && ShouldOutputSplitLighting(bsdfData))
						{
							outColor = float4(specularLighting, 1.0);
							outDiffuseLighting = float4(TagLightingForSSS(diffuseLighting), 1.0);
						}
						else
						{
							outColor = float4(diffuseLighting + specularLighting, 1.0);
							outDiffuseLighting = 0;
						}
						ENCODE_INTO_SSSBUFFER(surfaceData, posInput.positionSS, outSSSBuffer);
				#else
						outColor = ApplyBlendMode(diffuseLighting, specularLighting, builtinData.opacity);
						outColor = EvaluateAtmosphericScattering(posInput, V, outColor);
				#endif

				#ifdef _WRITE_TRANSPARENT_MOTION_VECTOR
						float4 VPASSpositionCS = float4(packedInput.vpassPositionCS.xy, 0.0, packedInput.vpassPositionCS.z);
						float4 VPASSpreviousPositionCS = float4(packedInput.vpassPreviousPositionCS.xy, 0.0, packedInput.vpassPreviousPositionCS.z);

						bool forceNoMotion = any(unity_MotionVectorsParams.yw == 0.0);
						if (!forceNoMotion)
						{
							float2 motionVec = CalculateMotionVector(VPASSpositionCS, VPASSpreviousPositionCS);
							EncodeMotionVector(motionVec * 0.5, outMotionVec);
							outMotionVec.zw = 1.0;
						}
				#endif
					}

				#ifdef DEBUG_DISPLAY
				}
				#endif

				#ifdef _DEPTHOFFSET_ON
				outputDepth = posInput.deviceDepth;
				#endif
			}
			ENDHLSL
		}
		
	}
	CustomEditor "TVEShaderCoreGUI"
	
	
}
/*ASEBEGIN
Version=18103
1927;1;1906;1021;2786.774;516.811;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;81;-1488,-896;Half;False;Property;_IsLitShader;_IsLitShader;149;1;[HideInInspector];Create;True;0;0;True;0;False;1;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1536,-768;Half;False;Property;_render_dst;_render_dst;154;1;[HideInInspector];Fetch;True;2;Opaque;0;Transparent;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-2176,-768;Half;False;Property;_Cutoff;_Cutoff;151;1;[HideInInspector];Fetch;False;4;Alpha;0;Premultiply;1;Additive;2;Multiply;3;0;True;0;False;0.5;0.719;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-1712,-896;Half;False;Property;_IsStandardShader;_IsStandardShader;150;1;[HideInInspector];Create;True;0;0;True;0;False;1;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;305;-2176,256;Inherit;False;Base Batching;144;;18311;d914b3a554b05ab4da8c1d2a8ce94c0a;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;304;-2176,-128;Inherit;False;Base Shader;1;;18123;856f7164d1c579d43a5cf4968a75ca43;51,1271,2,1300,1,1298,1,1962,0,1708,0,1712,1,1964,1,1969,1,1723,0,1719,0,893,0,1745,1,1742,1,1714,1,1718,1,1715,1,1717,1,1728,1,1732,1,916,1,1949,1,1762,1,1763,1,1776,0,1966,1,1736,1,1735,1,1734,1,1737,1,1968,1,1733,1,878,0,1550,0,1646,0,1690,0,1757,0,1669,0,1981,0,1759,0,860,1,2055,1,2031,1,2054,1,2032,1,2057,1,2033,1,2036,0,2060,0,2039,0,2062,0,1785,1;0;14;FLOAT3;0;FLOAT3;528;FLOAT;529;FLOAT;530;FLOAT;531;FLOAT;1235;FLOAT3;1230;FLOAT;1461;FLOAT;1290;FLOAT;721;FLOAT;532;FLOAT;653;FLOAT;629;FLOAT3;534
Node;AmplifyShaderEditor.RangedFloatNode;17;-1344,-768;Half;False;Property;_render_zw;_render_zw;155;1;[HideInInspector];Fetch;True;2;Opaque;0;Transparent;1;0;True;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;306;-1312,-896;Half;False;Property;_IsAnyPathShader;_IsAnyPathShader;148;1;[HideInInspector];Create;True;0;0;True;0;False;1;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1728,-768;Half;False;Property;_render_src;_render_src;153;1;[HideInInspector];Fetch;True;0;0;True;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1920,-768;Half;False;Property;_render_cull;_render_cull;152;2;[HideInInspector];[Enum];Fetch;True;3;Both;0;Back;1;Front;2;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2176,-896;Half;False;Property;_Banner;Banner;0;0;Create;True;0;0;True;1;StyledBanner(Bark Standard Lit);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-1920,-896;Half;False;Property;_IsBarkShader;_IsBarkShader;147;1;[HideInInspector];Create;True;0;0;True;0;False;1;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;311;-1376,-128;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;1;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;DepthOnly;0;4;DepthOnly;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;True;0;True;-25;False;True;True;0;True;-6;255;False;-1;255;True;-7;7;False;-1;3;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;313;-1376,-128;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;1;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;Distortion;0;6;Distortion;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;True;4;1;False;-1;1;False;-1;4;1;False;-1;1;False;-1;True;1;False;-1;1;False;-1;False;False;False;True;True;0;True;-10;255;False;-1;255;True;-11;7;False;-1;3;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;False;True;1;LightMode=DistortionVectors;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;312;-1376,-128;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;1;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;Motion Vectors;0;5;Motion Vectors;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;True;0;True;-25;False;True;True;0;True;-8;255;False;-1;255;True;-9;7;False;-1;3;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;False;False;True;1;LightMode=MotionVectors;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;309;-1376,-128;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;1;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;True;0;True;-25;True;False;False;False;False;0;False;-1;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;315;-1376,-128;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;1;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;TransparentDepthPrepass;0;8;TransparentDepthPrepass;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;True;0;True;-25;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=TransparentDepthPrepass;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;310;-1376,-128;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;1;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;SceneSelectionPass;0;3;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;307;-1376,-128;Float;False;True;-1;2;TVEShaderCoreGUI;0;2;BOXOPHOBIC/The Vegetation Engine/Vegetation/Bark Standard Lit;53b46d85872c5b24c8f4f0a1c3fe4c87;True;GBuffer;0;0;GBuffer;35;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;True;0;True;-25;False;True;True;0;True;-13;255;False;-1;255;True;-12;7;False;-1;3;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;0;True;-14;False;True;1;LightMode=GBuffer;False;0;;0;0;Standard;41;Surface Type;0;  Rendering Pass;1;  Refraction Model;0;    Blending Mode;0;    Blend Preserves Specular;1;  Receive Fog;1;  Back Then Front Rendering;0;  Transparent Depth Prepass;0;  Transparent Depth Postpass;0;  Transparent Writes Motion Vector;0;  Distortion;0;    Distortion Mode;0;    Distortion Depth Test;1;  ZWrite;0;  Z Test;4;Double-Sided;1;Alpha Clipping;1;  Use Shadow Threshold;0;Material Type,InvertActionOnDeselection;0;  Energy Conserving Specular;1;  Transmission;1;Receive Decals;0;Receives SSR;0;Motion Vectors;0;  Add Precomputed Velocity;0;Specular AA;0;Specular Occlusion Mode;1;Override Baked GI;0;Depth Offset;0;DOTS Instancing;1;LOD CrossFade;1;Tessellation;0;  Phong;0;  Strength;0.5,False,-1;  Type;0;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position;0;0;11;True;True;True;True;True;False;False;False;False;False;True;False;;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;316;-1376,-128;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;1;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;TransparentDepthPostpass;0;9;TransparentDepthPostpass;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;True;0;True;-25;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=TransparentDepthPostpass;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;314;-1376,-128;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;1;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;TransparentBackface;0;7;TransparentBackface;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;True;1;0;True;-19;0;True;-20;1;0;True;-21;0;True;-22;False;False;True;1;False;-1;False;False;True;0;True;-23;True;0;True;-31;False;True;1;LightMode=TransparentBackface;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;317;-1376,-128;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;1;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;Forward;0;10;Forward;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;True;1;0;True;-19;0;True;-20;1;0;True;-21;0;True;-22;False;False;True;0;True;-28;False;True;True;0;True;-4;255;False;-1;255;True;-5;7;False;-1;3;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;0;True;-23;True;0;True;-30;False;True;1;LightMode=Forward;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;308;-1376,-128;Float;False;False;-1;2;UnityEditor.Rendering.HighDefinition.HDLitGUI;0;1;New Amplify Shader;53b46d85872c5b24c8f4f0a1c3fe4c87;True;META;0;1;META;0;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=HDRenderPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;5;0;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;LightMode=Meta;False;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.CommentaryNode;37;-2176,-1024;Inherit;False;1026.438;100;Internal;0;;1,0.252,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;285;-2176,-640;Inherit;False;1026.438;100;Features;0;;1,0.252,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;33;-2176,-256;Inherit;False;1022.896;100;Final;0;;0.3439424,0.5960785,0,1;0;0
WireConnection;307;0;304;0
WireConnection;307;1;304;528
WireConnection;307;7;304;530
WireConnection;307;8;304;531
WireConnection;307;9;304;532
WireConnection;307;10;304;653
WireConnection;307;11;304;534
ASEEND*/
//CHKSM=A8BFC1A4EFCF16E45F9085F99B97984AE6F9B7B7