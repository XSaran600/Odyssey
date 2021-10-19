//////////////////////////////////////////////////////
// MicroSplat
// Copyright (c) Jason Booth
//
// Auto-generated shader code, don't hand edit!
//   Compiled with MicroSplat 3.4
//   Unity : 2019.3.13f1
//   Platform : WindowsEditor
//   RenderLoop : Unity HD
//////////////////////////////////////////////////////

Shader "MicroSplat/Example_AlphaHole" {
   Properties {
      [HideInInspector] _Control0 ("Control0", 2D) = "red" {}
      [HideInInspector] _Control1 ("Control1", 2D) = "black" {}
      [HideInInspector] _Control2 ("Control2", 2D) = "black" {}
      [HideInInspector] _Control3 ("Control3", 2D) = "black" {}
      

      // Splats
      [NoScaleOffset]_Diffuse ("Diffuse Array", 2DArray) = "white" {}
      [NoScaleOffset]_NormalSAO ("Normal Array", 2DArray) = "bump" {}
      [NoScaleOffset]_PerTexProps("Per Texture Properties", 2D) = "black" {}
      [NoScaleOffset]_PerPixelNormal("Per Pixel Normal", 2D) = "bump" {}
      [HideInInspector] _TerrainHolesTexture("Holes Map (RGB)", 2D) = "white" {}
      _Contrast("Blend Contrast", Range(0.01, 0.99)) = 0.4
      _UVScale("UV Scales", Vector) = (45, 45, 0, 0)




      _AlphaData("Alpha Params", Vector) = (0, 0, 0, 0)










[HideInInspector] _EmissionColor("Color", Color) = (1,1,1,1)
[HideInInspector] _RenderQueueType("Vector1 ", Float) = 1
[HideInInspector] _StencilRef("Vector1 ", Int) = 0
[HideInInspector] _StencilWriteMask("Vector1 ", Int) = 3
[HideInInspector] _StencilRefDepth("Vector1 ", Int) = 0
[HideInInspector] _StencilWriteMaskDepth("Vector1 ", Int) = 32
[HideInInspector] _StencilRefMV("Vector1 ", Int) = 128
[HideInInspector] _StencilWriteMaskMV("Vector1 ", Int) = 128
[HideInInspector] _StencilRefDistortionVec("Vector1 ", Int) = 64
[HideInInspector] _StencilWriteMaskDistortionVec("Vector1 ", Int) = 64
[HideInInspector] _StencilWriteMaskGBuffer("Vector1 ", Int) = 3
[HideInInspector] _StencilRefGBuffer("Vector1 ", Int) = 2
[HideInInspector] _ZTestGBuffer("Vector1 ", Int) = 4
[HideInInspector] [ToggleUI] _RequireSplitLighting("Boolean", Float) = 0
[HideInInspector] [ToggleUI] _ReceivesSSR("Boolean", Float) = 1
[HideInInspector] _SurfaceType("Vector1 ", Float) = 0
[HideInInspector] _BlendMode("Vector1 ", Float) = 0
[HideInInspector] _SrcBlend("Vector1 ", Float) = 1
[HideInInspector] _DstBlend("Vector1 ", Float) = 0
[HideInInspector] _AlphaSrcBlend("Vector1 ", Float) = 1
[HideInInspector] _AlphaDstBlend("Vector1 ", Float) = 0
[HideInInspector] [ToggleUI] _ZWrite("Boolean", Float) = 0
[HideInInspector] _CullMode("Vector1 ", Float) = 2
[HideInInspector] _TransparentSortPriority("Vector1 ", Int) = 0
[HideInInspector] _CullModeForward("Vector1 ", Float) = 2
[HideInInspector] [Enum(Front, 1, Back, 2)] _TransparentCullMode("Vector1", Float) = 2
[HideInInspector] _ZTestDepthEqualForOpaque("Vector1 ", Int) = 4
[HideInInspector] [Enum(UnityEngine.Rendering.CompareFunction)] _ZTestTransparent("Vector1", Float) = 4
[HideInInspector] [ToggleUI] _TransparentBackfaceEnable("Boolean", Float) = 0
[HideInInspector] [ToggleUI] _AlphaCutoffEnable("Boolean", Float) = 0
[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
[HideInInspector] [ToggleUI] _UseShadowThreshold("Boolean", Float) = 0
[HideInInspector] [ToggleUI] _DoubleSidedEnable("Boolean", Float) = 0
[HideInInspector] [Enum(Flip, 0, Mirror, 1, None, 2)] _DoubleSidedNormalMode("Vector1", Float) = 2
[HideInInspector] _DoubleSidedConstants("Vector4", Vector) = (1,1,-1,0)

   }
   SubShader {
      Tags{"RenderPipeline"="HDRenderPipeline" "RenderType" = "HDLitShader" "Queue" = "Geometry+100" "SplatCount" = "16"}



        Pass
        {
            // based on HDLitPass.template
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            
            Cull [_CullMode]
        
            
            ZWrite On
        
            ZClip [_ZClip]
        
            
            ColorMask 0
        
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            #pragma shader_feature_local _TERRAIN_INSTANCED_PERPIXEL_NORMAL
            #pragma multi_compile_instancing
            #pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap renderinglayer
        
            #pragma multi_compile_local _ _ALPHATEST_ON


            #pragma shader_feature _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _DOUBLESIDED_ON
            #pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
            // #define _MATERIAL_FEATURE_SUBSURFACE_SCATTERING 1
            // #define _MATERIAL_FEATURE_TRANSMISSION 1
            // #define _MATERIAL_FEATURE_ANISOTROPY 1
            // #define _MATERIAL_FEATURE_IRIDESCENCE 1
            // #define _MATERIAL_FEATURE_SPECULAR_COLOR 1
            // #define _ENABLE_FOG_ON_TRANSPARENT 1
            // #define _AMBIENT_OCCLUSION 1
            #define _SPECULAR_OCCLUSION_FROM_AO 1
            // #define _SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL 1
            // #define _SPECULAR_OCCLUSION_CUSTOM 1
            #define _ENERGY_CONSERVING_SPECULAR 1
            // #define _ENABLE_GEOMETRIC_SPECULAR_AA 1
            // #define _HAS_REFRACTION 1
            // #define _REFRACTION_PLANE 1
            // #define _REFRACTION_SPHERE 1
            // #define _DISABLE_DECALS 1
            // #define _DISABLE_SSR 1
            // #define _ADD_PRECOMPUTED_VELOCITY
            // #define _WRITE_TRANSPARENT_MOTION_VECTOR 1
            // #define _DEPTHOFFSET_ON 1
            // #define _BLENDMODE_PRESERVE_SPECULAR_LIGHTING 1
        
            
      #define _MICROSPLAT 1
      #define _ALPHABELOWHEIGHT 1
      #define _MSRENDERLOOP_UNITYHD 1



            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            // If we use subsurface scattering, enable output split lighting (for forward pass)
            #if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
            #define OUTPUT_SPLIT_LIGHTING
            #endif
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Defines
            //-------------------------------------------------------------------------------------
                    #define SHADERPASS SHADERPASS_SHADOWS
                #define RAYTRACING_SHADER_GRAPH_HIGH
                // ACTIVE FIELDS:
                //   Material.Standard
                //   Specular.EnergyConserving
                //   SpecularOcclusionFromAO
                //   SurfaceDescriptionInputs.TangentSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.ObjectSpacePosition
                //   SurfaceDescription.Alpha
                //   features.modifyMesh
                //   VertexDescription.VertexPosition
                //   VertexDescription.VertexNormal
                //   VertexDescription.VertexTangent
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.positionOS
                // Shared Graph Keywords
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            #define VARYINGS_NEED_TEXCOORD0
            // #define VARYINGS_NEED_TEXCOORD1
            // #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            //#define VARYINGS_NEED_COLOR
            // #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
        // We need isFontFace when using double sided
        #if defined(_DOUBLESIDED_ON) && !defined(VARYINGS_NEED_CULLFACE)
            #define VARYINGS_NEED_CULLFACE
        #endif
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
            
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
        #ifdef DEBUG_DISPLAY
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
        #if (SHADERPASS == SHADERPASS_FORWARD)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
        
            #define HAS_LIGHTLOOP
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL; // optional
                float4 tangentOS : TANGENT; // optional
                float4 uv0 : TEXCOORD0; // optional
                float4 uv1 : TEXCOORD1; // optional
                float4 uv2 : TEXCOORD2; // optional
                //float4 color : COLOR; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_Position;
                float3 positionRWS; // optional
                float3 normalWS; // optional
                float4 tangentWS; // optional
                float4 texCoord0; // optional
                //float4 color; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_Position; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
                float4 interp02 : TEXCOORD2; // auto-packed
                float4 interp03 : TEXCOORD3; // auto-packed
                //float4 interp04 : TEXCOORD4; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                output.interp03.xyzw = input.texCoord0;
                //output.interp04.xyzw = input.color;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                output.texCoord0 = input.interp03.xyzw;
                //output.color = input.interp04.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
        
      
      #define UNITY_DECLARE_TEX2D(name) TEXTURE2D(name); SAMPLER(sampler_##name);
      #define UNITY_DECLARE_TEX2D_NOSAMPLER(name) TEXTURE2D(name);
      #define UNITY_DECLARE_TEX2DARRAY(name) TEXTURE2D_ARRAY(name); SAMPLER(sampler_##name);
     
      #define UNITY_SAMPLE_TEX2DARRAY(tex,coord)            SAMPLE_TEXTURE2D_ARRAY(tex, sampler_##tex, coord.xy, coord.z)
      #define UNITY_SAMPLE_TEX2DARRAY_LOD(tex,coord,lod)    SAMPLE_TEXTURE2D_ARRAY_LOD(tex, sampler_##tex, coord.xy, coord.z, lod)
      #define UNITY_SAMPLE_TEX2D(tex, coord)                SAMPLE_TEXTURE2D(tex, sampler_##tex, coord)
      #define UNITY_SAMPLE_TEX2D_SAMPLER(tex, samp, coord)  SAMPLE_TEXTURE2D(tex, sampler_##samp, coord)

     
      #if defined(UNITY_COMPILER_HLSL)
         #define UNITY_INITIALIZE_OUTPUT(type,name) name = (type)0;
      #else
         #define UNITY_INITIALIZE_OUTPUT(type,name)
      #endif

      #define sampler2D_float sampler2D
      #define sampler2D_half sampler2D

      


   

            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 _EmissionColor;
                    float _RenderQueueType;
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
                    float _UseShadowThreshold;
                    float _DoubleSidedEnable;
                    float _DoubleSidedNormalMode;
                    float4 _DoubleSidedConstants;
                    

      #if _MESHSUBARRAY
         half4 _MeshSubArrayIndexes;
      #endif


      #if _USEEMISSIVEMETAL
         half _EmissiveMult;
      #endif

      float4 _UVScale; // scale and offset

      float2 _ToonTerrainSize;

      half _Contrast;
      
      float3 _gGlitterLightDir;
      float3 _gGlitterLightWorldPos;
      half3 _gGlitterLightColor;

       #if _VSSHADOWMAP
         float4 gVSSunDirection;
      #endif

      #if _FORCELOCALSPACE && _PLANETVECTORS
         float4x4 _PQSToLocal;
      #endif

      #if _ORIGINSHIFT
         float4x4 _GlobalOriginMTX;
      #endif

      float4 _Control0_TexelSize;
      float4 _CustomControl0_TexelSize;
      float4 _PerPixelNormal_TexelSize;

      #if _CONTROLNOISEUV || _GLOBALNOISEUV
         float2 _NoiseUVParams;
      #endif





      float2 _AlphaData;
      


                    CBUFFER_END
                

                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpaceNormal; // optional
                        float3 TangentSpaceNormal; // optional
                        float3 WorldSpaceTangent; // optional
                        float3 WorldSpaceBiTangent; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 TangentSpaceViewDirection; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float3 AbsoluteWorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                        float4 uv0; // optional
                        float4 VertexColor; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float Alpha;
                    };
                    
                    
#if defined(UNITY_INSTANCING_ENABLED) 
    #define ENABLE_TERRAIN_PERPIXEL_NORMAL
#endif 
 
#ifndef UNITY_TERRAIN_CB_VARS
    #define UNITY_TERRAIN_CB_VARS
#endif

#ifndef UNITY_TERRAIN_CB_DEBUG_VARS
    #define UNITY_TERRAIN_CB_DEBUG_VARS
#endif

CBUFFER_START(UnityTerrain)
    UNITY_TERRAIN_CB_VARS
#ifdef UNITY_INSTANCING_ENABLED 
    float4 _TerrainHeightmapRecipSize;  // float4(1.0f/width, 1.0f/height, 1.0f/(width-1), 1.0f/(height-1))
    float4 _TerrainHeightmapScale;      // float4(hmScale.x, hmScale.y / (float)(kMaxHeight), hmScale.z, 0.0f)
#endif
#ifdef DEBUG_DISPLAY
    UNITY_TERRAIN_CB_DEBUG_VARS
#endif
CBUFFER_END

#ifdef UNITY_INSTANCING_ENABLED
    TEXTURE2D(_TerrainHeightmapTexture);
    TEXTURE2D(_TerrainNormalmapTexture);
    #ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
        SAMPLER(sampler_TerrainNormalmapTexture);
    #endif
#endif

UNITY_INSTANCING_BUFFER_START(Terrain)
   UNITY_DEFINE_INSTANCED_PROP(float4, _TerrainPatchInstanceData)  // float4(xBase, yBase, skipScale, ~)
UNITY_INSTANCING_BUFFER_END(Terrain)

float4 ConstructTerrainTangent(float3 normal, float3 positiveZ)
{
    // Consider a flat terrain. It should have tangent be (1, 0, 0) and bitangent be (0, 0, 1) as the UV of the terrain grid mesh is a scale of the world XZ position.
    // In CreateTangentToWorld function (in SpaceTransform.hlsl), it is cross(normal, tangent) * sgn for the bitangent vector.
    // It is not true in a left-handed coordinate system for the terrain bitangent, if we provide 1 as the tangent.w. It would produce (0, 0, -1) instead of (0, 0, 1).
    // Also terrain's tangent calculation was wrong in a left handed system because cross((0,0,1), terrainNormalOS) points to the wrong direction as negative X.
    // Therefore all the 4 xyzw components of the tangent needs to be flipped to correct the tangent frame.
    // (See TerrainLitData.hlsl - GetSurfaceAndBuiltinData)
    float3 tangent = cross(normal, positiveZ);
    return float4(tangent, -1);
}


AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
{
#if defined(UNITY_INSTANCING_ENABLED) && !_MICROMESH && !_MICROMESHTERRAIN && !_MICROPOLARISMESH && !_MICRODIGGERMESH && !_MICROVERTEXMESH
    float2 patchVertex = input.positionOS.xy;
    float4 instanceData = UNITY_ACCESS_INSTANCED_PROP(Terrain, _TerrainPatchInstanceData);

    float2 sampleCoords = (patchVertex.xy + instanceData.xy) * instanceData.z; // (xy + float2(xBase,yBase)) * skipScale
    float height = UnpackHeightmap(_TerrainHeightmapTexture.Load(int3(sampleCoords, 0)));

    input.positionOS.xz = sampleCoords * _TerrainHeightmapScale.xz;
    input.positionOS.y = height * _TerrainHeightmapScale.y;
    
    #ifdef ATTRIBUTES_NEED_NORMAL
       input.normalOS = float3(0,1,0);
    #endif

    #if defined(VARYINGS_NEED_TEXCOORD0) || defined(VARYINGS_DS_NEED_TEXCOORD0)
       #ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
          input.uv0.xy = sampleCoords;
       #else
          input.uv0.xy = sampleCoords * _TerrainHeightmapRecipSize.zw;
       #endif
    #endif
#endif


    #ifdef ATTRIBUTES_NEED_TANGENT
       #if !_MICROMESH && !_MICROMESHTERRAIN && !_MICROVERTEXMESH && !_MICROPOLARISMESH
           input.tangentOS = ConstructTerrainTangent(input.normalOS, float3(0, 0, 1));
       #endif
    #endif

    return input;
}

        
                    

                    

      // dynamic branching helpers, for regular and aggressive branching
      // debug mode shows how many samples using branching will save us. 
      //
      // These macros are always used instead of the UNITY_BRANCH macro
      // to maintain debug displays and allow branching to be disabled
      // on as granular level as we want. 
      
      #if _BRANCHSAMPLES
         #if _DEBUG_BRANCHCOUNT_WEIGHT || _DEBUG_BRANCHCOUNT_TOTAL
            float _branchWeightCount;
            #define MSBRANCH(w) if (w > 0) _branchWeightCount++; if (w > 0)
         #else
            #define MSBRANCH(w) UNITY_BRANCH if (w > 0)
         #endif
      #else
         #if _DEBUG_BRANCHCOUNT_WEIGHT || _DEBUG_BRANCHCOUNT_TOTAL
            float _branchWeightCount;
            #define MSBRANCH(w) if (w > 0) _branchWeightCount++;
         #else
            #define MSBRANCH(w) 
         #endif
      #endif
      
      #if _BRANCHSAMPLESAGR
         #if _DEBUG_BRANCHCOUNT_TRIPLANAR || _DEBUG_BRANCHCOUNT_CLUSTER || _DEBUG_BRANCHCOUNT_OTHER ||_DEBUG_BRANCHCOUNT_TOTAL
            float _branchTriplanarCount;
            float _branchClusterCount;
            float _branchOtherCount;
            #define MSBRANCHTRIPLANAR(w) if (w > 0.001) _branchTriplanarCount++; if (w > 0.001)
            #define MSBRANCHCLUSTER(w) if (w > 0.001) _branchClusterCount++; if (w > 0.001)
            #define MSBRANCHOTHER(w) if (w > 0.001) _branchOtherCount++; if (w > 0.001)
         #else
            #define MSBRANCHTRIPLANAR(w) UNITY_BRANCH if (w > 0.001)
            #define MSBRANCHCLUSTER(w) UNITY_BRANCH if (w > 0.001)
            #define MSBRANCHOTHER(w) UNITY_BRANCH if (w > 0.001)
         #endif
      #else
         #if _DEBUG_BRANCHCOUNT_TRIPLANAR || _DEBUG_BRANCHCOUNT_CLUSTER || _DEBUG_BRANCHCOUNT_OTHER || _DEBUG_BRANCHCOUNT_TOTAL
            float _branchTriplanarCount;
            float _branchClusterCount;
            float _branchOtherCount;
            #define MSBRANCHTRIPLANAR(w) if (w > 0.001) _branchTriplanarCount++;
            #define MSBRANCHCLUSTER(w) if (w > 0.001) _branchClusterCount++;
            #define MSBRANCHOTHER(w) if (w > 0.001) _branchOtherCount++;
         #else
            #define MSBRANCHTRIPLANAR(w)
            #define MSBRANCHCLUSTER(w)
            #define MSBRANCHOTHER(w)
         #endif
      #endif

      #if _DEBUG_SAMPLECOUNT
         int _sampleCount;
         #define COUNTSAMPLE { _sampleCount++; }
      #else
         #define COUNTSAMPLE
      #endif

      #if _DEBUG_PROCLAYERS
         int _procLayerCount;
         #define COUNTPROCLAYER { _procLayerCount++; }
      #else
         #define COUNTPROCLAYER
      #endif


      #if _DEBUG_USE_TOPOLOGY
         UNITY_DECLARE_TEX2D_NOSAMPLER(_DebugWorldPos);
         UNITY_DECLARE_TEX2D_NOSAMPLER(_DebugWorldNormal);
      #endif
      

      // splat
      UNITY_DECLARE_TEX2DARRAY(_Diffuse);
      float4 _Diffuse_TexelSize;
      UNITY_DECLARE_TEX2DARRAY(_NormalSAO);
      float4 _NormalSAO_TexelSize;

      #if _CONTROLNOISEUV || _GLOBALNOISEUV
         UNITY_DECLARE_TEX2D_NOSAMPLER(_NoiseUV);
      #endif

      #if _PACKINGHQ
         UNITY_DECLARE_TEX2DARRAY(_SmoothAO);
         float4 _SmoothAO_TexelSize;
      #endif

      #if _USESPECULARWORKFLOW
         UNITY_DECLARE_TEX2DARRAY(_Specular);
         float4 _Specular_TexelSize;
      #endif

      #if _USEEMISSIVEMETAL
         UNITY_DECLARE_TEX2DARRAY(_EmissiveMetal);
         float4 _EmissiveMetal_TexelSize;
      #endif

      
      UNITY_DECLARE_TEX2D_NOSAMPLER(_PerPixelNormal);
      
      UNITY_DECLARE_TEX2D(_Control0);
      #if _CUSTOMSPLATTEXTURES
         UNITY_DECLARE_TEX2D(_CustomControl0);
         #if !_MAX4TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl1);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl2);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl3);
         #endif
         #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl4);
         #endif
         #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl5);
         #endif
         #if _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl6);
         #endif
         #if _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl7);
         #endif
      #else
         #if !_MAX4TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control1);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control2);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control3);
         #endif
         #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control4);
         #endif
         #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control5);
         #endif
         #if _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control6);
         #endif
         #if _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control7);
         #endif
      #endif

      sampler2D_float _PerTexProps;
   



      struct TriGradMipFormat
      {
         float4 d0;
         float4 d1;
         float4 d2;
      };

      half InverseLerp(half x, half y, half v) { return (v-x)/max(y-x, 0.001); }
      half2 InverseLerp(half2 x, half2 y, half2 v) { return (v-x)/max(y-x, half2(0.001, 0.001)); }
      half3 InverseLerp(half3 x, half3 y, half3 v) { return (v-x)/max(y-x, half3(0.001, 0.001, 0.001)); }
      half4 InverseLerp(half4 x, half4 y, half4 v) { return (v-x)/max(y-x, half4(0.001, 0.001, 0.001, 0.001)); }
      

      // 2019.3 holes
      #ifdef _ALPHATEST_ON
          UNITY_DECLARE_TEX2D(_TerrainHolesTexture);

          void ClipHoles(float2 uv)
          {
              float hole = UNITY_SAMPLE_TEX2D(_TerrainHolesTexture, uv).r;
              COUNTSAMPLE
              clip(hole < 0.5f ? -1 : 1);
          }
      #endif

      
      #if _TRIPLANAR
         #if _USEGRADMIP
            #define MIPFORMAT TriGradMipFormat
            #define INITMIPFORMAT (TriGradMipFormat)0;
            #define MIPFROMATRAW float4
         #else
            #define MIPFORMAT float3
            #define INITMIPFORMAT 0;
            #define MIPFROMATRAW float3
         #endif
      #else
         #if _USEGRADMIP
            #define MIPFORMAT float4
            #define INITMIPFORMAT 0;
            #define MIPFROMATRAW float4
         #else
            #define MIPFORMAT float
            #define INITMIPFORMAT 0;
            #define MIPFROMATRAW float
         #endif
      #endif

      float2 RotateUV(float2 uv, float amt)
      {
         uv -=0.5;
         float s = sin ( amt);
         float c = cos ( amt );
         float2x2 mtx = float2x2( c, -s, s, c);
         mtx *= 0.5;
         mtx += 0.5;
         mtx = mtx * 2-1;
         uv = mul ( uv, mtx );
         uv += 0.5;
         return uv;
      }

      float4 DecodeToFloat4(float v)
      {
         uint vi = (uint)(v * (256.0f * 256.0f * 256.0f * 256.0f));
         int ex = (int)(vi / (256 * 256 * 256) % 256);
         int ey = (int)((vi / (256 * 256)) % 256);
         int ez = (int)((vi / (256)) % 256);
         int ew = (int)(vi % 256);
         float4 e = float4(ex / 255.0, ey / 255.0, ez / 255.0, ew / 255.0);
         return e;
      }

      struct Input 
      {
         float2 uv_Control0;
         #if (_MICROMESH && _MESHUV2)
         float2 uv2_Diffuse;
         #endif

         float3 viewDir;
         float3 worldPos;
         float3 worldNormal;
         #if _TERRAINBLENDING
         float4 color : COLOR;
         #endif
         #if _MSRENDERLOOP_SURFACESHADER
         INTERNAL_DATA
         #else
         float3x3 TBN;
         #endif

         #if _MICRODIGGERMESH || _MICROVERTEXMESH
            half4 w0;
            #if !_MAX4TEXTURES
               half4 w1;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES
               half4 w2;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
               half4 w3;
            #endif
            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               half4 w4;
            #endif
            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               half4 w5;
            #endif
            #if (_MAX28TEXTURES || _MAX32TEXTURES) && !_STREAMS && !_LAVA && !_WETNESS && !_PUDDLES
               half4 w6;
            #endif

            #if _STEAMS || _WETNESS || _LAVA || _PUDDLES
               half4 s0;
            #endif

         #endif
      };
      
      struct TriplanarConfig
      {
         float3x3 uv0;
         float3x3 uv1;
         float3x3 uv2;
         float3x3 uv3;
         half3 pN;
         half3 pN0;
         half3 pN1;
         half3 pN2;
         half3 pN3;
         half3 axisSign;
         Input IN;
      };


      struct Config
      {
         float2 uv;
         float3 uv0;
         float3 uv1;
         float3 uv2;
         float3 uv3;

         half4 cluster0;
         half4 cluster1;
         half4 cluster2;
         half4 cluster3;

      };


      struct MicroSplatLayer
      {
         half3 Albedo;
         half3 Normal;
         half Smoothness;
         half Occlusion;
         half Metallic;
         half Height;
         half3 Emission;
         #if _USESPECULARWORKFLOW
         half3 Specular;
         #endif
         half Alpha;
         
      };


      struct appdata 
      {
         float4 vertex : POSITION;
         float4 tangent : TANGENT;
         float3 normal : NORMAL;
         float2 texcoord : TEXCOORD0;
         float4 texcoord1 : TEXCOORD1;
         float4 texcoord2 : TEXCOORD2;
         #if _TERRAINBLENDING || _MICRODIGGERMESH || _MICROVERTEXMESH
         half4 color : COLOR;
         #endif
         UNITY_VERTEX_INPUT_INSTANCE_ID
         UNITY_VERTEX_OUTPUT_STEREO
      };


      // raw, unblended samples from arrays
      struct RawSamples
      {
         half4 albedo0;
         half4 albedo1;
         half4 albedo2;
         half4 albedo3;
         half4 normSAO0;
         half4 normSAO1;
         half4 normSAO2;
         half4 normSAO3;
         #if _USEEMISSIVEMETAL || _GLOBALEMIS || _GLOBALSMOOTHAOMETAL || _PERTEXSSS
            half4 emisMetal0;
            half4 emisMetal1;
            half4 emisMetal2;
            half4 emisMetal3;
         #endif
         #if _USESPECULARWORKFLOW
            half3 specular0;
            half3 specular1;
            half3 specular2;
            half3 specular3;
         #endif
      };

      void InitRawSamples(inout RawSamples s)
      {
         s.normSAO0 = half4(0,0,0,1);
         s.normSAO1 = half4(0,0,0,1);
         s.normSAO2 = half4(0,0,0,1);
         s.normSAO3 = half4(0,0,0,1);
      }

       float3 GetGlobalLightDir(Input i)
      {
         float3 lightDir = float3(1,0,0);

         #if _MSRENDERLOOP_UNITYHD || PASS_DEFERRED
            lightDir = normalize(_gGlitterLightDir.xyz);
         #elif _MSRENDERLOOP_UNITYLD
            lightDir = GetMainLight().direction;
         #else
            #ifndef USING_DIRECTIONAL_LIGHT
               lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
            #else
               lightDir = normalize(_WorldSpaceLightPos0.xyz);
            #endif
         #endif
         return lightDir;
      }

      float3 GetGlobalLightDirTS(Input i)
      {
         float3 lightDirWS = GetGlobalLightDir(i);
        
         #if _MSRENDERLOOP_UNITYHD || _MSRENDERLOOP_UNITYLD
            return mul( i.TBN, lightDirWS).xyz;
         #else
            float3 t2w0 = WorldNormalVector(i, float3(1,0,0));
            float3 t2w1 = WorldNormalVector(i, float3(0,1,0));
            float3 t2w2 = WorldNormalVector(i, float3(0,0,1));
            float3x3 t2w = float3x3(t2w0, t2w1, t2w2);
            return mul( t2w, lightDirWS).xyz;
         #endif
      }
      
      half3 GetGlobalLightColor()
      {
         #if _MSRENDERLOOP_UNITYHD || PASS_DEFERRED
            return _gGlitterLightColor;
         #elif _MSRENDERLOOP_UNITYLD
            return normalize(GetMainLight().color);
         #else
            return _LightColor0.rgb;
         #endif
      }



      half3 FuzzyShade(half3 color, half3 normal, half coreMult, half edgeMult, half power, float3 viewDir)
      {
         half dt = saturate(dot(viewDir, normal));
         half dark = 1.0 - (coreMult * dt);
         half edge = pow(1-dt, power) * edgeMult;
         return color * (dark + edge);
      }

      half3 ComputeSSS(Input i, float3 V, float3 N, half3 tint, half thickness, half distortion, half scale, half power)
      {
         float3 L = GetGlobalLightDir(i);
         half3 lightColor = GetGlobalLightColor();
         float3 H = normalize(L + N * distortion);
         float VdotH = pow(saturate(dot(V, -H)), power) * scale;
         float3 I =  (VdotH) * thickness;
         return lightColor * I * tint;
      }


      #if _MAX2LAYER
         inline half BlendWeights(half s1, half s2, half s3, half s4, half4 w)      { return s1 * w.x + s2 * w.y; }
         inline half2 BlendWeights(half2 s1, half2 s2, half2 s3, half2 s4, half4 w) { return s1 * w.x + s2 * w.y; }
         inline half3 BlendWeights(half3 s1, half3 s2, half3 s3, half3 s4, half4 w) { return s1 * w.x + s2 * w.y; }
         inline half4 BlendWeights(half4 s1, half4 s2, half4 s3, half4 s4, half4 w) { return s1 * w.x + s2 * w.y; }
      #elif _MAX3LAYER
         inline half BlendWeights(half s1, half s2, half s3, half s4, half4 w)      { return s1 * w.x + s2 * w.y + s3 * w.z; }
         inline half2 BlendWeights(half2 s1, half2 s2, half2 s3, half2 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z; }
         inline half3 BlendWeights(half3 s1, half3 s2, half3 s3, half3 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z; }
         inline half4 BlendWeights(half4 s1, half4 s2, half4 s3, half4 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z; }
      #else
         inline half BlendWeights(half s1, half s2, half s3, half s4, half4 w)      { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
         inline half2 BlendWeights(half2 s1, half2 s2, half2 s3, half2 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
         inline half3 BlendWeights(half3 s1, half3 s2, half3 s3, half3 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
         inline half4 BlendWeights(half4 s1, half4 s2, half4 s3, half4 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
      #endif

      #if _MAX3LAYER
         #define SAMPLE_PER_TEX(varName, pixel, config, defVal) \
            half4 varName##0 = defVal; \
            half4 varName##1 = defVal; \
            half4 varName##2 = defVal; \
            half4 varName##3 = defVal; \
            varName##0 = tex2Dlod(_PerTexProps, float4(config.uv0.z/32, pixel/32, 0, 0)); \
            varName##1 = tex2Dlod(_PerTexProps, float4(config.uv1.z/32, pixel/32, 0, 0)); \
            varName##2 = tex2Dlod(_PerTexProps, float4(config.uv2.z/32, pixel/32, 0, 0)); \

      #elif _MAX2LAYER
         #define SAMPLE_PER_TEX(varName, pixel, config, defVal) \
            half4 varName##0 = defVal; \
            half4 varName##1 = defVal; \
            half4 varName##2 = defVal; \
            half4 varName##3 = defVal; \
            varName##0 = tex2Dlod(_PerTexProps, float4(config.uv0.z/32, pixel/32, 0, 0)); \
            varName##1 = tex2Dlod(_PerTexProps, float4(config.uv1.z/32, pixel/32, 0, 0)); \

      #else
         #define SAMPLE_PER_TEX(varName, pixel, config, defVal) \
            half4 varName##0 = tex2Dlod(_PerTexProps, float4(config.uv0.z/32, pixel/32, 0, 0)); \
            half4 varName##1 = tex2Dlod(_PerTexProps, float4(config.uv1.z/32, pixel/32, 0, 0)); \
            half4 varName##2 = tex2Dlod(_PerTexProps, float4(config.uv2.z/32, pixel/32, 0, 0)); \
            half4 varName##3 = tex2Dlod(_PerTexProps, float4(config.uv3.z/32, pixel/32, 0, 0)); \

      #endif
      
      half3 BlendNormal3(half3 n1, half3 n2)
      {
         n1.z += 1;
         n2.xy = -n2.xy;

         return n1 * dot(n1, n2) / n1.z - n2;
      }
      
      half2 TransformTriplanarNormal(Input IN, float3x3 t2w, half3 axisSign, half3 absVertNormal,
               half3 pN, half2 a0, half2 a1, half2 a2)
      {
         a0 = a0 * 2 - 1;
         a1 = a1 * 2 - 1;
         a2 = a2 * 2 - 1;
         
         a0.x *= axisSign.x;
         a1.x *= axisSign.y;
         a2.x *= axisSign.z;
         
         half3 n0 = half3(a0.xy, 1);
         half3 n1 = half3(a1.xy, 1);
         half3 n2 = half3(a2.xy, 1);
         
         n0 = BlendNormal3(half3(IN.worldNormal.zy, absVertNormal.x), n0);
         n1 = BlendNormal3(half3(IN.worldNormal.xz, absVertNormal.y), n1);
         n2 = BlendNormal3(half3(IN.worldNormal.xy, absVertNormal.z), n2);
  
         n0.z *= axisSign.x;
         n1.z *= axisSign.y;
         n2.z *= -axisSign.z;
  
         half3 worldNormal = (n0.zyx * pN.x + n1.xzy * pN.y + n2.xyz * pN.z );
         return mul(t2w, worldNormal).xy;
      }
      
      // funcs
      
      inline half MSLuminance(half3 rgb)
      {
         #ifdef UNITY_COLORSPACE_GAMMA
            return dot(rgb, half3(0.22, 0.707, 0.071));
         #else
            return dot(rgb, half3(0.0396819152, 0.458021790, 0.00609653955));
         #endif
      }
      
      
      float2 Hash2D( float2 x )
      {
          float2 k = float2( 0.3183099, 0.3678794 );
          x = x*k + k.yx;
          return -1.0 + 2.0*frac( 16.0 * k*frac( x.x*x.y*(x.x+x.y)) );
      }

      float Noise2D(float2 p )
      {
         float2 i = floor( p );
         float2 f = frac( p );
         
         float2 u = f*f*(3.0-2.0*f);

         return lerp( lerp( dot( Hash2D( i + float2(0.0,0.0) ), f - float2(0.0,0.0) ), 
                           dot( Hash2D( i + float2(1.0,0.0) ), f - float2(1.0,0.0) ), u.x),
                      lerp( dot( Hash2D( i + float2(0.0,1.0) ), f - float2(0.0,1.0) ), 
                           dot( Hash2D( i + float2(1.0,1.0) ), f - float2(1.0,1.0) ), u.x), u.y);
      }
      
      float FBM2D(float2 uv)
      {
         float f = 0.5000*Noise2D( uv ); uv *= 2.01;
         f += 0.2500*Noise2D( uv ); uv *= 1.96;
         f += 0.1250*Noise2D( uv ); 
         return f;
      }
      
      float3 Hash3D( float3 p )
      {
         p = float3( dot(p,float3(127.1,311.7, 74.7)),
                 dot(p,float3(269.5,183.3,246.1)),
                 dot(p,float3(113.5,271.9,124.6)));

         return -1.0 + 2.0*frac(sin(p)*437.5453123);
      }

      float Noise3D( float3 p )
      {
         float3 i = floor( p );
         float3 f = frac( p );
         
         float3 u = f*f*(3.0-2.0*f);

         return lerp( lerp( lerp( dot( Hash3D( i + float3(0.0,0.0,0.0) ), f - float3(0.0,0.0,0.0) ), 
                                dot( Hash3D( i + float3(1.0,0.0,0.0) ), f - float3(1.0,0.0,0.0) ), u.x),
                           lerp( dot( Hash3D( i + float3(0.0,1.0,0.0) ), f - float3(0.0,1.0,0.0) ), 
                                dot( Hash3D( i + float3(1.0,1.0,0.0) ), f - float3(1.0,1.0,0.0) ), u.x), u.y),
                      lerp( lerp( dot( Hash3D( i + float3(0.0,0.0,1.0) ), f - float3(0.0,0.0,1.0) ), 
                                dot( Hash3D( i + float3(1.0,0.0,1.0) ), f - float3(1.0,0.0,1.0) ), u.x),
                           lerp( dot( Hash3D( i + float3(0.0,1.0,1.0) ), f - float3(0.0,1.0,1.0) ), 
                                dot( Hash3D( i + float3(1.0,1.0,1.0) ), f - float3(1.0,1.0,1.0) ), u.x), u.y), u.z );
      }
      
      float FBM3D(float3 uv)
      {
         float f = 0.5000*Noise3D( uv ); uv *= 2.01;
         f += 0.2500*Noise3D( uv ); uv *= 1.96;
         f += 0.1250*Noise3D( uv ); 
         return f;
      }
      
      half2 BlendNormal2(half2 base, half2 blend) { return normalize(half3(base.xy + blend.xy, 1)).xy; } 
      half3 BlendOverlay(half3 base, half3 blend) { return (base < 0.5 ? (2.0 * base * blend) : (1.0 - 2.0 * (1.0 - base) * (1.0 - blend))); }
      half3 BlendMult2X(half3  base, half3 blend) { return (base * (blend * 2)); }
      half3 BlendLighterColor(half3 s, half3 d) { return (s.x + s.y + s.z > d.x + d.y + d.z) ? s : d; } 
      
      float GetSaturation(float3 c)
      {
         float mi = min(min(c.x, c.y), c.z);
         float ma = max(max(c.x, c.y), c.z);
         return (ma - mi)/(ma + 1e-7);
      }

      // Better Color Lerp, does not have darkening issue
      float3 BetterColorLerp(float3 a, float3 b, float x)
      {
         float3 ic = lerp(a, b, x) + float3(1e-6,0.0,0.0);
         float sd = abs(GetSaturation(ic) - lerp(GetSaturation(a), GetSaturation(b), x));
    
         float3 dir = normalize(float3(2.0 * ic.x - ic.y - ic.z, 2.0 * ic.y - ic.x - ic.z, 2.0 * ic.z - ic.y - ic.x));
         float lgt = dot(float3(1.0, 1.0, 1.0), ic);
    
         float ff = dot(dir, normalize(ic));
    
         const float dsp_str = 1.5;
         ic += dsp_str * dir * sd * ff * lgt;
         return saturate(ic);
      }
      
      
      half4 ComputeWeights(half4 iWeights, half h0, half h1, half h2, half h3, half contrast)
      {
          #if _DISABLEHEIGHTBLENDING
             return iWeights;
          #else
             // compute weight with height map
             //half4 weights = half4(iWeights.x * h0, iWeights.y * h1, iWeights.z * h2, iWeights.w * h3);
             half4 weights = half4(iWeights.x * max(h0,0.001), iWeights.y * max(h1,0.001), iWeights.z * max(h2,0.001), iWeights.w * max(h3,0.001));
             
             // Contrast weights
             half maxWeight = max(max(weights.x, max(weights.y, weights.z)), weights.w);
             half transition = max(contrast * maxWeight, 0.0001);
             half threshold = maxWeight - transition;
             half scale = 1.0 / transition;
             weights = saturate((weights - threshold) * scale);
             // Normalize weights.
             half weightScale = 1.0f / (weights.x + weights.y + weights.z + weights.w);
             weights *= weightScale;
             return weights;
          #endif
      }

      half HeightBlend(half h1, half h2, half slope, half contrast)
      {
         #if _DISABLEHEIGHTBLENDING
            return slope;
         #else
            h2 = 1 - h2;
            half tween = saturate((slope - min(h1, h2)) / max(abs(h1 - h2), 0.001)); 
            half blend = saturate( ( tween - (1-contrast) ) / max(contrast, 0.001));
            return blend;
         #endif
      }

      #if _MAX4TEXTURES
         #define TEXCOUNT 4
      #elif _MAX8TEXTURES
         #define TEXCOUNT 8
      #elif _MAX12TEXTURES
         #define TEXCOUNT 12
      #elif _MAX20TEXTURES
         #define TEXCOUNT 20
      #elif _MAX24TEXTURES
         #define TEXCOUNT 24
      #elif _MAX28TEXTURES
         #define TEXCOUNT 28
      #elif _MAX32TEXTURES
         #define TEXCOUNT 32
      #else
         #define TEXCOUNT 16
      #endif


      void Setup(out half4 weights, float2 uv, out Config config, half4 w0, half4 w1, half4 w2, half4 w3, half4 w4, half4 w5, half4 w6, half4 w7, float3 worldPos)
      {
         config = (Config)0;
         half4 indexes = 0;

         config.uv = uv;

         #if _WORLDUV
         uv = worldPos.xz;
         #endif

         #if _DISABLESPLATMAPS
            float2 scaledUV = uv;
         #else
            float2 scaledUV = uv * _UVScale.xy + _UVScale.zw;
         #endif

         // if only 4 textures, and blending 4 textures, skip this whole thing..
         // this saves about 25% of the ALU of the base shader on low end. However if
         // we rely on sorted texture weights (distance resampling) we have to sort..
         float4 defaultIndexes = float4(0,1,2,3);
         #if _MESHSUBARRAY
            defaultIndexes = _MeshSubArrayIndexes;
         #endif

         #if _MESHSUBARRAY || (_MAX4TEXTURES && !_MAX3LAYER && !_MAX2LAYER && !_DISTANCERESAMPLE && !_POM)
            weights = w0;
            config.uv0 = float3(scaledUV, defaultIndexes.x);
            config.uv1 = float3(scaledUV, defaultIndexes.y);
            config.uv2 = float3(scaledUV, defaultIndexes.z);
            config.uv3 = float3(scaledUV, defaultIndexes.w);
            return;
         #endif

         #if _DISABLESPLATMAPS
            weights = float4(1,0,0,0);
            return;
         #else
            half splats[TEXCOUNT];

            splats[0] = w0.x;
            splats[1] = w0.y;
            splats[2] = w0.z;
            splats[3] = w0.w;
            #if !_MAX4TEXTURES
               splats[4] = w1.x;
               splats[5] = w1.y;
               splats[6] = w1.z;
               splats[7] = w1.w;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES
               splats[8] = w2.x;
               splats[9] = w2.y;
               splats[10] = w2.z;
               splats[11] = w2.w;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
               splats[12] = w3.x;
               splats[13] = w3.y;
               splats[14] = w3.z;
               splats[15] = w3.w;
            #endif
            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               splats[16] = w4.x;
               splats[17] = w4.y;
               splats[18] = w4.z;
               splats[19] = w4.w;
            #endif
            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               splats[20] = w5.x;
               splats[21] = w5.y;
               splats[22] = w5.z;
               splats[23] = w5.w;
            #endif
            #if _MAX28TEXTURES || _MAX32TEXTURES
               splats[24] = w6.x;
               splats[25] = w6.y;
               splats[26] = w6.z;
               splats[27] = w6.w;
            #endif
            #if _MAX32TEXTURES
               splats[28] = w7.x;
               splats[29] = w7.y;
               splats[30] = w7.z;
               splats[31] = w7.w;
            #endif



            weights[0] = 0;
            weights[1] = 0;
            weights[2] = 0;
            weights[3] = 0;
            indexes[0] = 0;
            indexes[1] = 0;
            indexes[2] = 0;
            indexes[3] = 0;

            int i = 0;
            for (i = 0; i < TEXCOUNT; ++i)
            {
               half w = splats[i];
               if (w >= weights[0])
               {
                  weights[3] = weights[2];
                  indexes[3] = indexes[2];
                  weights[2] = weights[1];
                  indexes[2] = indexes[1];
                  weights[1] = weights[0];
                  indexes[1] = indexes[0];
                  weights[0] = w;
                  indexes[0] = i;
               }
               else if (w >= weights[1])
               {
                  weights[3] = weights[2];
                  indexes[3] = indexes[2];
                  weights[2] = weights[1];
                  indexes[2] = indexes[1];
                  weights[1] = w;
                  indexes[1] = i;
               }
               else if (w >= weights[2])
               {
                  weights[3] = weights[2];
                  indexes[3] = indexes[2];
                  weights[2] = w;
                  indexes[2] = i;
               }
               else if (w >= weights[3])
               {
                  weights[3] = w;
                  indexes[3] = i;
               }
            }

            // clamp and renormalize
            #if _MAX2LAYER
            weights.zw = 0;
            weights.xy *= (1.0 / (weights.x + weights.y));
            #elif _MAX3LAYER
            weights.w = 0;
            weights.xyz *= (1.0 / (weights.x + weights.y + weights.z));
            #elif !_DISABLEHEIGHTBLENDING || _NORMALIZEWEIGHTS // prevents black when painting, which the unity shader does not prevent.
            weights = normalize(weights);
            #endif

            config.uv0 = float3(scaledUV, indexes.x);
            config.uv1 = float3(scaledUV, indexes.y);
            config.uv2 = float3(scaledUV, indexes.z);
            config.uv3 = float3(scaledUV, indexes.w);


         #endif //_DISABLESPLATMAPS


      }
      
      float ComputeMipLevel(float2 uv, float2 textureSize)
      {
         uv *= textureSize;
         float2  dx_vtc        = ddx(uv);
         float2  dy_vtc        = ddy(uv);
         float delta_max_sqr   = max(dot(dx_vtc, dx_vtc), dot(dy_vtc, dy_vtc));
         return 0.5 * log2(delta_max_sqr);
      }

      inline half2 UnpackNormal2(half4 packednormal)
      {
          return packednormal.wy * 2 - 1;
         
      }

      half3 TriplanarHBlend(half h0, half h1, half h2, half3 pN, half contrast)
      {
         half3 blend = pN / dot(pN, half3(1,1,1));
         float3 heights = float3(h0, h1, h2) + (blend * 3.0);
         half height_start = max(max(heights.x, heights.y), heights.z) - contrast;
         half3 h = max(heights - height_start.xxx, half3(0,0,0));
         blend = h / dot(h, half3(1,1,1));
         return blend;
      }
      

      void ClearAllButAlbedo(inout MicroSplatLayer o, half3 display)
      {
         o.Albedo = display.rgb;
         o.Normal = half3(0, 0, 1);
         o.Smoothness = 0;
         o.Occlusion = 1;
         o.Emission = 0;
         o.Metallic = 0;
         o.Height = 0;
         #if _USESPECULARWORKFLOW
         o.Specular = 0;
         #endif

      }

      void ClearAllButAlbedo(inout MicroSplatLayer o, half display)
      {
         o.Albedo = half3(display, display, display);
         o.Normal = half3(0, 0, 1);
         o.Smoothness = 0;
         o.Occlusion = 1;
         o.Emission = 0;
         o.Metallic = 0;
         o.Height = 0;
         #if _USESPECULARWORKFLOW
         o.Specular = 0;
         #endif

      }

     

      half MicroShadow(float3 lightDir, half3 normal, half ao, half strength)
      {
         half shadow = saturate(abs(dot(normal, lightDir)) + (ao * ao * 2.0) - 1.0);
         return 1 - ((1-shadow) * strength);
      }
      

      void DoDebugOutput(inout MicroSplatLayer l)
      {
         #if _DEBUG_OUTPUT_ALBEDO
            ClearAllButAlbedo(l, l.Albedo);
         #elif _DEBUG_OUTPUT_NORMAL
            // oh unit shader compiler normal stripping, how I hate you so..
            // must multiply by albedo to stop the normal from being white. Why, fuck knows?
            ClearAllButAlbedo(l, float3(l.Normal.xy * 0.5 + 0.5, l.Normal.z * saturate(l.Albedo.z+1)));
         #elif _DEBUG_OUTPUT_SMOOTHNESS
            ClearAllButAlbedo(l, l.Smoothness.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_METAL
            ClearAllButAlbedo(l, l.Metallic.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_AO
            ClearAllButAlbedo(l, l.Occlusion.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_EMISSION
            ClearAllButAlbedo(l, l.Emission * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_HEIGHT
            ClearAllButAlbedo(l, l.Height.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_SPECULAR && _USESPECULARWORKFLOW
            ClearAllButAlbedo(l, l.Specular * saturate(l.Albedo.z+1));
         #elif _DEBUG_BRANCHCOUNT_WEIGHT
            ClearAllButAlbedo(l, _branchWeightCount / 12 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_TRIPLANAR
            ClearAllButAlbedo(l, _branchTriplanarCount / 24 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_CLUSTER
            ClearAllButAlbedo(l, _branchClusterCount / 12 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_OTHER
            ClearAllButAlbedo(l, _branchOtherCount / 8 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_TOTAL
            l.Albedo.r = _branchWeightCount / 12;
            l.Albedo.g = _branchTriplanarCount / 24;
            l.Albedo.b = _branchClusterCount / 12;
            ClearAllButAlbedo(l, (l.Albedo.r + l.Albedo.g + l.Albedo.b + (_branchOtherCount / 8)) / 4); 
         #elif _DEBUG_OUTPUT_MICROSHADOWS
            ClearAllButAlbedo(l,l.Albedo); 
         #elif _DEBUG_SAMPLECOUNT
            float sdisp = (float)_sampleCount / max(_SampleCountDiv, 1);
            half3 sdcolor = float3(sdisp, sdisp > 1 ? 1 : 0, 0);
            ClearAllButAlbedo(l, sdcolor * saturate(l.Albedo.z + 1));
         #elif _DEBUG_PROCLAYERS
            ClearAllButAlbedo(l, (float)_procLayerCount / (float)_PCLayerCount * saturate(l.Albedo.z + 1));
         #endif
      }


      // man I wish unity would wrap everything instead of only what they use. Just seems like a landmine for
      // people like myself.. especially as they keep changing things around and I have to figure out all the new defines
      // and handle changes across Unity versions, which would be automatically handled if they just wrapped these themselves without
      // as much complexity..

      #if (UNITY_VERSION >= 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (SHADER_TARGET_SURFACE_ANALYSIS && !SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))) || (UNITY_VERSION < 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL))) 
           #define MICROSPLAT_SAMPLE_TEX2D_LOD(tex,coord, lod) tex.SampleLevel (sampler##tex,coord, lod)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(tex,samplertex,coord, lod) tex.SampleLevel (sampler##samplertex,coord, lod)
        #else
           #define MICROSPLAT_SAMPLE_TEX2D_LOD(tex,coord,lod) tex2D (tex,coord,0,lod)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(tex,samplertex,coord,lod) tex2D (tex,coord,0,lod)
        #endif
     


        #if (UNITY_VERSION >= 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (SHADER_TARGET_SURFACE_ANALYSIS && !SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))) || (UNITY_VERSION < 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL))) 
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) tex.SampleGrad (sampler##tex,coord,dx,dy)
        #elif defined(SHADER_API_D3D9)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(0,1,0,0) 
        #elif defined(UNITY_COMPILER_HLSL2GLSL) || defined(SHADER_TARGET_SURFACE_ANALYSIS)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) texCUBEgrad (tex,coord,float3(dx.x,dx.y,0),float3(dy.x,dy.y,0))
        #elif defined(SHADER_API_GLES)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(1,1,0,0)
        #elif defined(SHADER_API_D3D11_9X)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(0,1,1,0) 
        #else
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(0,0,1,0) 
        #endif
        
        #if (UNITY_VERSION >= 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (SHADER_TARGET_SURFACE_ANALYSIS && !SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))) || (UNITY_VERSION < 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL))) 
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) tex.SampleGrad (sampler##samp,coord,dx,dy)
        #elif defined(SHADER_API_D3D9)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(0,1,0,0) 
        #elif defined(UNITY_COMPILER_HLSL2GLSL) || defined(SHADER_TARGET_SURFACE_ANALYSIS)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(1,0,1,0)
        #elif defined(SHADER_API_GLES)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(1,1,0,0)
        #elif defined(SHADER_API_D3D11_9X)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(0,1,1,0) 
        #else
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(0,0,1,0) 
        #endif
      

      #if _USELODMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY_LOD(tex, u, l.x)
      #elif _USEGRADMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex, u, l.xy, l.zw)
      #else
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY(tex, u)
      #endif

      #if _USELODMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY_LOD(tex, u, l.x)
      #elif _USEGRADMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex, u, l.xy, l.zw)
      #else
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY(tex, u)
      #endif


      #define MICROSPLAT_SAMPLE_DIFFUSE(u, cl, l) MICROSPLAT_SAMPLE(_Diffuse, u, l)
      #define MICROSPLAT_SAMPLE_EMIS(u, cl, l) MICROSPLAT_SAMPLE(_EmissiveMetal, u, l)
      #define MICROSPLAT_SAMPLE_DIFFUSE_LOD(u, cl, l) UNITY_SAMPLE_TEX2DARRAY_LOD(_Diffuse, u, l)
      

      #if _PACKINGHQ
         #define MICROSPLAT_SAMPLE_NORMAL(u, cl, l) half4(MICROSPLAT_SAMPLE(_NormalSAO, u, l).ga, MICROSPLAT_SAMPLE(_SmoothAO, u, l).ga).brag
      #else
         #define MICROSPLAT_SAMPLE_NORMAL(u, cl, l) MICROSPLAT_SAMPLE(_NormalSAO, u, l)
      #endif

      #if _USESPECULARWORKFLOW
         #define MICROSPLAT_SAMPLE_SPECULAR(u, cl, l) MICROSPLAT_SAMPLE(_Specular, u, l)
      #endif
      




                    
      #undef MICROSPLAT_SAMPLE_TEX2D_LOD
      #undef MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD
      #undef MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD
      #undef MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD

      #define MICROSPLAT_SAMPLE_TEX2D_LOD(tex,coord,lod)                    SAMPLE_TEXTURE2D_LOD(tex,sampler_##tex, coord, lod)
      #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy)                 SAMPLE_TEXTURE2D_GRAD(tex,sampler_##tex,coord,dx,dy)
      #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy)    SAMPLE_TEXTURE2D_GRAD(tex,sampler_##samp,coord,dx,dy)
      #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(tex, samp, coord, lod)    SAMPLE_TEXTURE2D_LOD(tex, sampler_##samp, coord, lod)

      inline half3 UnpackNormal(half4 packednormal)
      {
         half3 normal;
         normal.xy = packednormal.wy * 2 - 1;
         normal.z = sqrt(1 - normal.x*normal.x - normal.y * normal.y);
         return normal;
      }
      

      #undef WorldNormalVector
      #define WorldNormalVector(data, normal) mul(data.TBN, normal)





      #define UnityObjectToWorldNormal(normal) mul(GetObjectToWorldMatrix(), normal)
      
      


      Input DescToInput(SurfaceDescriptionInputs IN)
      {
        Input s = (Input)0;
        s.TBN = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        s.worldNormal = IN.WorldSpaceNormal;
        #if !_SRPTERRAINBLEND
           s.worldPos = GetAbsolutePositionWS(IN.WorldSpacePosition);
        #else
           s.worldPos = IN.WorldSpacePosition;
        #endif
        s.viewDir = IN.TangentSpaceViewDirection;
        s.uv_Control0 = IN.uv0.xy;
        

        #if _MICROMESH && _MESHUV2
            s.uv_Diffuse = IN.uv.xy1;
        #endif

        #if _SRPTERRAINBLEND
            s.color = IN.VertexColor;
        #endif
        return s;
     }

     #define TESSELLATION_INTERPOLATE_BARY(name, bary) output.name = input0.name * bary.x +  input1.name * bary.y +  input2.name * bary.z
     

     // Stochastic shared code

// Compute local triangle barycentric coordinates and vertex IDs
void TriangleGrid(float2 uv, float scale,
   out float w1, out float w2, out float w3,
   out int2 vertex1, out int2 vertex2, out int2 vertex3)
{
   // Scaling of the input
   uv *= 3.464 * scale; // 2 * sqrt(3)

   // Skew input space into simplex triangle grid
   const float2x2 gridToSkewedGrid = float2x2(1.0, 0.0, -0.57735027, 1.15470054);
   float2 skewedCoord = mul(gridToSkewedGrid, uv);

   // Compute local triangle vertex IDs and local barycentric coordinates
   int2 baseId = int2(floor(skewedCoord));
   float3 temp = float3(frac(skewedCoord), 0);
   temp.z = 1.0 - temp.x - temp.y;
   if (temp.z > 0.0)
   {
      w1 = temp.z;
      w2 = temp.y;
      w3 = temp.x;
      vertex1 = baseId;
      vertex2 = baseId + int2(0, 1);
      vertex3 = baseId + int2(1, 0);
   }
   else
   {
      w1 = -temp.z;
      w2 = 1.0 - temp.y;
      w3 = 1.0 - temp.x;
      vertex1 = baseId + int2(1, 1);
      vertex2 = baseId + int2(1, 0);
      vertex3 = baseId + int2(0, 1);
   }
}

// Fast random hash function
float2 SimpleHash2(float2 p)
{
   return frac(sin(mul(float2x2(127.1, 311.7, 269.5, 183.3), p)) * 43758.5453);
}


half3 BaryWeightBlend(half3 iWeights, half tex0, half tex1, half tex2, half contrast)
{
    // compute weight with height map
    const half epsilon = 1.0f / 1024.0f;
    half3 weights = half3(iWeights.x * (tex0 + epsilon), 
                             iWeights.y * (tex1 + epsilon),
                             iWeights.z * (tex2 + epsilon));

    // Contrast weights
    half maxWeight = max(weights.x, max(weights.y, weights.z));
    half transition = contrast * maxWeight;
    half threshold = maxWeight - transition;
    half scale = 1.0f / transition;
    weights = saturate((weights - threshold) * scale);
    // Normalize weights.
    half weightScale = 1.0f / (weights.x + weights.y + weights.z);
    weights *= weightScale;
    return weights;
}

void PrepareStochasticUVs(float scale, float3 uv, out float3 uv1, out float3 uv2, out float3 uv3, out half3 weights)
{
   // Get triangle info
   float w1, w2, w3;
   int2 vertex1, vertex2, vertex3;
   TriangleGrid(uv.xy, scale, w1, w2, w3, vertex1, vertex2, vertex3);

   // Assign random offset to each triangle vertex
   uv1 = uv;
   uv2 = uv;
   uv3 = uv;
   
   uv1.xy += SimpleHash2(vertex1);
   uv2.xy += SimpleHash2(vertex2);
   uv3.xy += SimpleHash2(vertex3);
   weights = half3(w1, w2, w3);
   
}

void PrepareStochasticUVs(float scale, float2 uv, out float2 uv1, out float2 uv2, out float2 uv3, out half3 weights)
{
   // Get triangle info
   float w1, w2, w3;
   int2 vertex1, vertex2, vertex3;
   TriangleGrid(uv, scale, w1, w2, w3, vertex1, vertex2, vertex3);

   // Assign random offset to each triangle vertex
   uv1 = uv;
   uv2 = uv;
   uv3 = uv;
   
   uv1.xy += SimpleHash2(vertex1);
   uv2.xy += SimpleHash2(vertex2);
   uv3.xy += SimpleHash2(vertex3);
   weights = half3(w1, w2, w3);
   
}


      #if _ALPHAHOLETEXTURE
         sampler2D _AlphaHoleTexture;   // must declare with a sampler or windows throws an error, which seems like a compiler bug
      #endif



      void ClipWaterLevel(float3 worldPos)
      {
         clip(worldPos.y - _AlphaData.y);
      }

      void ClipAlphaHole(inout Config c, inout half4 weights)
      {
      #if _ALPHAHOLETEXTURE
         clip(tex2D(_AlphaHoleTexture, c.uv).r - 0.5);
      #else
         if ((int)round(c.uv0.z ) == (int)round(_AlphaData.x))
         {
            clip(-1);
         }
         else if ((int)round(c.uv1.z ) == (int)round(_AlphaData.x) && weights.y > 0)
         {
            weights.y = 0;
            weights = normalize(weights);
         }
         else if ((int)round(c.uv2.z ) == (int)round(_AlphaData.x) && weights.z > 0)
         {
            weights.z = 0;
            weights = normalize(weights);
         }
         else if ((int)round(c.uv3.z ) == (int)round(_AlphaData.x) && weights.w > 0)
         {
            weights.w = 0;
            weights = normalize(weights);
         }
         
      #endif
      }





     
    




   

                    



      void SampleAlbedo(inout Config config, inout TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
         return;
         #endif
         #if _TRIPLANAR
            #if _USEGRADMIP
               float4 d0 = mipLevel.d0;
               float4 d1 = mipLevel.d1;
               float4 d2 = mipLevel.d2;
            #elif _USELODMIP
               float d0 = mipLevel.x;
               float d1 = mipLevel.y;
               float d2 = mipLevel.z;
            #else
               MIPFORMAT d0 = mipLevel;
               MIPFORMAT d1 = mipLevel;
               MIPFORMAT d2 = mipLevel;
            #endif
         
            half4 contrasts = _Contrast.xxxx;
            #if _PERTEXTRIPLANARCONTRAST
               SAMPLE_PER_TEX(ptc, 5.5, config, half4(1,0.5,0,0));
               contrasts = half4(ptc0.y, ptc1.y, ptc2.y, ptc3.y);
            #endif


            #if _PERTEXTRIPLANAR
               SAMPLE_PER_TEX(pttri, 9.5, config, half4(0,0,0,0));
            #endif

            {
               // For per-texture triplanar, we modify the view based blending factor of the triplanar
               // such that you get a pure blend of either top down projection, or with the top down projection
               // removed and renormalized. This causes dynamic flow control optimizations to kick in and avoid
               // the extra texture samples while keeping the code simple. Yay..

               // We also only have to do this in the Albedo, because the pN values will be adjusted after the
               // albedo is sampled, causing future samples to use this data. 
              
               #if _PERTEXTRIPLANAR
                  if (pttri0.x > 0.66)
                  {
                     tc.pN0 = half3(0,1,0);
                  }
                  else if (pttri0.x > 0.33)
                  {
                     tc.pN0.y = 0;
                     tc.pN0.xz = normalize(tc.pN0.xz);
                  }
               #endif


               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN0.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv0[0], config.cluster0, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN0.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv0[1], config.cluster0, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN0.z)
               {
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv0[2], config.cluster0, d2);
                  COUNTSAMPLE
               }

               half3 bf = tc.pN0;
               #if _TRIPLANARHEIGHTBLEND
                  bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN0, contrasts.x);
                  tc.pN0 = bf;
               #endif

               s.albedo0 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            MSBRANCH(weights.y)
            {
               #if _PERTEXTRIPLANAR
                  if (pttri1.x > 0.66)
                  {
                     tc.pN1 = half3(0,1,0);
                  }
                  else if (pttri1.x > 0.33)
                  {
                     tc.pN1.y = 0;
                     tc.pN1.xz = normalize(tc.pN1.xz);
                  }
               #endif

               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN1.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv1[0], config.cluster1, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv1[1], config.cluster1, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.z)
               {
                  COUNTSAMPLE
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv1[2], config.cluster1, d2);
               }
               half3 bf = tc.pN1;
               #if _TRIPLANARHEIGHTBLEND
                  bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN1, contrasts.x);
                  tc.pN1 = bf;
               #endif


               s.albedo1 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            #if !_MAX2LAYER
            MSBRANCH(weights.z)
            {
               #if _PERTEXTRIPLANAR
                  if (pttri2.x > 0.66)
                  {
                     tc.pN2 = half3(0,1,0);
                  }
                  else if (pttri2.x > 0.33)
                  {
                     tc.pN2.y = 0;
                     tc.pN2.xz = normalize(tc.pN2.xz);
                  }
               #endif

               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN2.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv2[0], config.cluster2, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv2[1], config.cluster2, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.z)
               {
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv2[2], config.cluster2, d2);
                  COUNTSAMPLE
               }

               half3 bf = tc.pN2;
               #if _TRIPLANARHEIGHTBLEND
                  bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN2, contrasts.x);
                  tc.pN2 = bf;
               #endif
               

               s.albedo2 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
            MSBRANCH(weights.w)
            {

               #if _PERTEXTRIPLANAR
                  if (pttri3.x > 0.66)
                  {
                     tc.pN3 = half3(0,1,0);
                  }
                  else if (pttri3.x > 0.33)
                  {
                     tc.pN3.y = 0;
                     tc.pN3.xz = normalize(tc.pN3.xz);
                  }
               #endif

               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN3.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv3[0], config.cluster3, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv3[1], config.cluster3, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.z)
               {
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv3[2], config.cluster3, d2);
                  COUNTSAMPLE
               }

               half3 bf = tc.pN3;
               #if _TRIPLANARHEIGHTBLEND
               bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN3, contrasts.x);
               tc.pN3 = bf;
               #endif

               s.albedo3 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            #endif

         #else
            s.albedo0 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv0, config.cluster0, mipLevel);
            COUNTSAMPLE

            MSBRANCH(weights.y)
            {
               s.albedo1 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv1, config.cluster1, mipLevel);
               COUNTSAMPLE
            }
            #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  s.albedo2 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv2, config.cluster2, mipLevel);
                  COUNTSAMPLE
               } 
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  s.albedo3 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv3, config.cluster3, mipLevel);
                  COUNTSAMPLE
               }
            #endif
         #endif

         #if _PERTEXHEIGHTOFFSET || _PERTEXHEIGHTCONTRAST
            SAMPLE_PER_TEX(ptHeight, 10.5, config, 1);

            #if _PERTEXHEIGHTOFFSET
               s.albedo0.a = saturate(s.albedo0.a + ptHeight0.b - 1);
               s.albedo1.a = saturate(s.albedo1.a + ptHeight1.b - 1);
               s.albedo2.a = saturate(s.albedo2.a + ptHeight2.b - 1);
               s.albedo3.a = saturate(s.albedo3.a + ptHeight3.b - 1);
            #endif
            #if _PERTEXHEIGHTCONTRAST
               s.albedo0.a = saturate(pow(s.albedo0.a + 0.5, abs(ptHeight0.a)) - 0.5);
               s.albedo1.a = saturate(pow(s.albedo1.a + 0.5, abs(ptHeight1.a)) - 0.5);
               s.albedo2.a = saturate(pow(s.albedo2.a + 0.5, abs(ptHeight2.a)) - 0.5);
               s.albedo3.a = saturate(pow(s.albedo3.a + 0.5, abs(ptHeight3.a)) - 0.5);
            #endif
         #endif
      }
      
      
      
      void SampleNormal(Config config, TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
         return;
         #endif

         #if _NONOMALMAP
            s.normSAO0 = half4(0,0, 0, 1);
            s.normSAO1 = half4(0,0, 0, 1);
            s.normSAO2 = half4(0,0, 0, 1);
            s.normSAO3 = half4(0,0, 0, 1);
            return;
         #endif
         
         #if _TRIPLANAR
            #if _USEGRADMIP
               float4 d0 = mipLevel.d0;
               float4 d1 = mipLevel.d1;
               float4 d2 = mipLevel.d2;
            #elif _USELODMIP
               float d0 = mipLevel.x;
               float d1 = mipLevel.y;
               float d2 = mipLevel.z;
            #else
               MIPFORMAT d0 = mipLevel;
               MIPFORMAT d1 = mipLevel;
               MIPFORMAT d2 = mipLevel;
            #endif
            
            half3 absVertNormal = abs(tc.IN.worldNormal);
            float3 t2w0 = WorldNormalVector(tc.IN, float3(1,0,0));
            float3 t2w1 = WorldNormalVector(tc.IN, float3(0,1,0));
            float3 t2w2 = WorldNormalVector(tc.IN, float3(0,0,1));
            float3x3 t2w = float3x3(t2w0, t2w1, t2w2);
            
            
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);
               MSBRANCHTRIPLANAR(tc.pN0.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv0[0], config.cluster0, d0).garb;
                  COUNTSAMPLE
               }            
               MSBRANCHTRIPLANAR(tc.pN0.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv0[1], config.cluster0, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN0.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv0[2], config.cluster0, d2).garb;
                  COUNTSAMPLE
               }
               

               s.normSAO0.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN0, a0.xy, a1.xy, a2.xy);
               s.normSAO0.zw = a0.zw * tc.pN0.x + a1.zw * tc.pN0.y + a2.zw * tc.pN0.z;
            }
            MSBRANCH(weights.y)
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);
               MSBRANCHTRIPLANAR(tc.pN1.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv1[0], config.cluster1, d0).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv1[1], config.cluster1, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv1[2], config.cluster1, d2).garb;
                  COUNTSAMPLE
               }
               

               s.normSAO1.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN1, a0.xy, a1.xy, a2.xy);
               s.normSAO1.zw = a0.zw * tc.pN1.x + a1.zw * tc.pN1.y + a2.zw * tc.pN1.z;
            }
            #if !_MAX2LAYER
            MSBRANCH(weights.z)
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);

               MSBRANCHTRIPLANAR(tc.pN2.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv2[0], config.cluster2, d0).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv2[1], config.cluster2, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv2[2], config.cluster2, d2).garb;
                  COUNTSAMPLE
               }
               

               s.normSAO2.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN2, a0.xy, a1.xy, a2.xy);
               s.normSAO2.zw = a0.zw * tc.pN2.x + a1.zw * tc.pN2.y + a2.zw * tc.pN2.z;
            }
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
            MSBRANCH(weights.w)
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);
               MSBRANCHTRIPLANAR(tc.pN3.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv3[0], config.cluster3, d0).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv3[1], config.cluster3, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv3[2], config.cluster3, d2).garb;
                  COUNTSAMPLE
               }

               s.normSAO3.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN3, a0.xy, a1.xy, a2.xy);
               s.normSAO3.zw = a0.zw * tc.pN3.x + a1.zw * tc.pN3.y + a2.zw * tc.pN3.z;
            }
            #endif

         #else
            s.normSAO0 = MICROSPLAT_SAMPLE_NORMAL(config.uv0, config.cluster0, mipLevel).garb;
            COUNTSAMPLE
            s.normSAO0.xy = s.normSAO0.xy * 2 - 1;
            MSBRANCH(weights.y)
            {
               s.normSAO1 = MICROSPLAT_SAMPLE_NORMAL(config.uv1, config.cluster1, mipLevel).garb;
               COUNTSAMPLE
               s.normSAO1.xy = s.normSAO1.xy * 2 - 1;
            }
            #if !_MAX2LAYER
            MSBRANCH(weights.z)
            {
               s.normSAO2 = MICROSPLAT_SAMPLE_NORMAL(config.uv2, config.cluster2, mipLevel).garb;
               COUNTSAMPLE
               s.normSAO2.xy = s.normSAO2.xy * 2 - 1;
            }
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
            MSBRANCH(weights.w)
            {
               s.normSAO3 = MICROSPLAT_SAMPLE_NORMAL(config.uv3, config.cluster3, mipLevel).garb;
               COUNTSAMPLE
               s.normSAO3.xy = s.normSAO3.xy * 2 - 1;
            }
            #endif
         #endif
      }

      void SampleEmis(Config config, TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
            return;
         #endif
         #if _USEEMISSIVEMETAL
            #if _TRIPLANAR
            
               #if _USEGRADMIP
                  float4 d0 = mipLevel.d0;
                  float4 d1 = mipLevel.d1;
                  float4 d2 = mipLevel.d2;
               #elif _USELODMIP
                  float d0 = mipLevel.x;
                  float d1 = mipLevel.y;
                  float d2 = mipLevel.z;
               #else
                  MIPFORMAT d0 = mipLevel;
                  MIPFORMAT d1 = mipLevel;
                  MIPFORMAT d2 = mipLevel;
               #endif
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN0.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv0[0], config.cluster0, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv0[1], config.cluster0, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv0[2], config.cluster0, d2);
                     COUNTSAMPLE
                  }
                  s.emisMetal0 = a0 * tc.pN0.x + a1 * tc.pN0.y + a2 * tc.pN0.z;
               }
               MSBRANCH(weights.y)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN1.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv1[0], config.cluster1, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv1[1], config.cluster1, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv1[2], config.cluster1, d2);
                     COUNTSAMPLE
                  }

                  s.emisMetal1 = a0 * tc.pN1.x + a1 * tc.pN1.y + a2 * tc.pN1.z;
               }
               #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN2.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv2[0], config.cluster2, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv2[1], config.cluster2, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv2[2], config.cluster2, d2);
                     COUNTSAMPLE
                  }
                  
                  s.emisMetal2 = a0 * tc.pN2.x + a1 * tc.pN2.y + a2 * tc.pN2.z;
               }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN3.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv3[0], config.cluster3, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv3[1], config.cluster3, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv3[2], config.cluster3, d2);
                     COUNTSAMPLE
                  }
                  
                  s.emisMetal3 = a0 * tc.pN3.x + a1 * tc.pN3.y + a2 * tc.pN3.z;
               }
               #endif

            #else
               s.emisMetal0 = MICROSPLAT_SAMPLE_EMIS(config.uv0, config.cluster0, mipLevel);
               COUNTSAMPLE

               MSBRANCH(weights.y)
               {
                  s.emisMetal1 = MICROSPLAT_SAMPLE_EMIS(config.uv1, config.cluster1, mipLevel);
                  COUNTSAMPLE
               }
               #if !_MAX2LAYER
                  MSBRANCH(weights.z)
                  {
                     s.emisMetal2 = MICROSPLAT_SAMPLE_EMIS(config.uv2, config.cluster2, mipLevel);
                     COUNTSAMPLE
                  }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  MSBRANCH(weights.w)
                  {
                     s.emisMetal3 = MICROSPLAT_SAMPLE_EMIS(config.uv3, config.cluster3, mipLevel);
                     COUNTSAMPLE
                  }
               #endif
            #endif
         #endif
      }
      
      void SampleSpecular(Config config, TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
            return;
         #endif
         #if _USESPECULARWORKFLOW
            #if _TRIPLANAR

               #if _USEGRADMIP
                  float4 d0 = mipLevel.d0;
                  float4 d1 = mipLevel.d1;
                  float4 d2 = mipLevel.d2;
               #elif _USELODMIP
                  float d0 = mipLevel.x;
                  float d1 = mipLevel.y;
                  float d2 = mipLevel.z;
               #else
                  MIPFORMAT d0 = mipLevel;
                  MIPFORMAT d1 = mipLevel;
                  MIPFORMAT d2 = mipLevel;
               #endif
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN0.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv0[0], config.cluster0, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv0[1], config.cluster0, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv0[2], config.cluster0, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular0 = a0 * tc.pN0.x + a1 * tc.pN0.y + a2 * tc.pN0.z;
               }
               MSBRANCH(weights.y)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN1.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv1[0], config.cluster1, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv1[1], config.cluster1, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv1[2], config.cluster1, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular1 = a0 * tc.pN1.x + a1 * tc.pN1.y + a2 * tc.pN1.z;
               }
               #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN2.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv2[0], config.cluster2, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv2[1], config.cluster2, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv2[2], config.cluster2, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular2 = a0 * tc.pN2.x + a1 * tc.pN2.y + a2 * tc.pN2.z;
               }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN3.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv3[0], config.cluster3, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv3[1], config.cluster3, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv3[2], config.cluster3, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular3 = a0 * tc.pN3.x + a1 * tc.pN3.y + a2 * tc.pN3.z;
               }
               #endif

            #else
               s.specular0 = MICROSPLAT_SAMPLE_SPECULAR(config.uv0, config.cluster0, mipLevel);
               COUNTSAMPLE

               MSBRANCH(weights.y)
               {
                  s.specular1 = MICROSPLAT_SAMPLE_SPECULAR(config.uv1, config.cluster1, mipLevel);
                  COUNTSAMPLE
               }
               #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  s.specular2 = MICROSPLAT_SAMPLE_SPECULAR(config.uv2, config.cluster2, mipLevel);
                  COUNTSAMPLE
               }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  s.specular3 = MICROSPLAT_SAMPLE_SPECULAR(config.uv3, config.cluster3, mipLevel);
                  COUNTSAMPLE
               }
               #endif
            #endif
         #endif
      }

      MicroSplatLayer Sample(Input i, half4 weights, inout Config config, float camDist, float3 worldNormalVertex)
      {
         MicroSplatLayer o = (MicroSplatLayer)0;
         UNITY_INITIALIZE_OUTPUT(MicroSplatLayer,o);

         RawSamples samples = (RawSamples)0;
         InitRawSamples(samples);

         half4 albedo = 0;
         half4 normSAO = half4(0,0,0,1);
         half4 emisMetal = 0;
         half3 specular = 0;
         
         float worldHeight = i.worldPos.y;
         float3 upVector = float3(0,1,0);

         #if _PLANETVECTORS
            upVector = worldNormalVertex;
            worldHeight = distance(i.worldPos, float3(0,0,0));
         #endif

         #if _GLOBALTINT || _GLOBALNORMALS || _GLOBALSMOOTHAOMETAL || _GLOBALEMIS || _GLOBALSPECULAR
            float globalSlopeFilter = 1;
            #if _GLOBALSLOPEFILTER
               float2 gfilterUV = float2(1 - saturate(dot(worldNormalVertex, upVector) * 0.5 + 0.49), 0.5);
               globalSlopeFilter = UNITY_SAMPLE_TEX2D_SAMPLER(_GlobalSlopeTex, _Diffuse, gfilterUV).a;
            #endif
         #endif

         // declare outside of branchy areas..
         half4 fxLevels = half4(0,0,0,0);
         half burnLevel = 0;
         half wetLevel = 0;
         half3 waterNormalFoam = half3(0, 0, 0);
         half porosity = 0.4;
         float streamFoam = 1.0f;
         half pud = 0;
         half snowCover = 0;
         half SSSThickness = 0;
         half3 SSSTint = half3(1,1,1);
         float traxBuffer = 0;
         float3 traxNormal = 0;
         float2 noiseUV = 0;
         
         

         #if _SPLATFADE
         MSBRANCHOTHER(1 - saturate(camDist - _SplatFade.y))
         {
         #endif

         #if _TRAXSINGLE || _TRAXARRAY || _TRAXNOTEXTURE || _SNOWFOOTSTEPS
            traxBuffer = SampleTraxBuffer(i.worldPos, traxNormal);
         #endif
         
         #if _WETNESS || _PUDDLES || _STREAMS || _LAVA
            #if _MICROMESH
               fxLevels = SampleFXLevels(InverseLerp(_UVMeshRange.xy, _UVMeshRange.zw, config.uv), wetLevel, burnLevel, traxBuffer);
            #elif _MICROVERTEXMESH || _MICRODIGGERMESH 
               fxLevels = ProcessFXLevels(i.s0, traxBuffer);
            #else
               fxLevels = SampleFXLevels(config.uv, wetLevel, burnLevel, traxBuffer);
            #endif
         #endif

         TriplanarConfig tc = (TriplanarConfig)0;
         UNITY_INITIALIZE_OUTPUT(TriplanarConfig,tc);
         

         MIPFORMAT albedoLOD = INITMIPFORMAT
         MIPFORMAT normalLOD = INITMIPFORMAT
         MIPFORMAT emisLOD = INITMIPFORMAT
         MIPFORMAT specLOD = INITMIPFORMAT

         #if _TRIPLANAR && !_DISABLESPLATMAPS
            PrepTriplanar(worldNormalVertex, i.worldPos, config, tc, weights, albedoLOD, normalLOD, emisLOD);
            tc.IN = i;
         #endif
         
         
         #if !_TRIPLANAR && !_DISABLESPLATMAPS
            #if _USELODMIP
               albedoLOD = ComputeMipLevel(config.uv0.xy, _Diffuse_TexelSize.zw);
               normalLOD = ComputeMipLevel(config.uv0.xy, _NormalSAO_TexelSize.zw);
               #if _USEEMISSIVEMETAL
                  emisLOD   = ComputeMipLevel(config.uv0.xy, _EmissiveMetal_TexelSize.zw);
               #endif
               #if _USESPECULARWORKFLOW
                  specLOD = ComputeMipLevel(config.uv0.xy, _Specular_TexelSize.zw);;
               #endif
            #elif _USEGRADMIP
               albedoLOD = float4(ddx(config.uv0.xy), ddy(config.uv0.xy));
               normalLOD = albedoLOD;
               #if _USESPECULARWORKFLOW
                  specLOD = albedoLOD;
               #endif
               #if _USEEMISSIVEMETAL
                  emisLOD = albedoLOD;
               #endif
            #endif
         #endif

         #if _PERTEXCURVEWEIGHT
           SAMPLE_PER_TEX(ptCurveWeight, 19.5, config, half4(0.5,1,1,1));
           weights.x = lerp(smoothstep(0.5 - ptCurveWeight0.r, 0.5 + ptCurveWeight0.r, weights.x), weights.x, ptCurveWeight0.r*2);
           weights.y = lerp(smoothstep(0.5 - ptCurveWeight1.r, 0.5 + ptCurveWeight1.r, weights.y), weights.y, ptCurveWeight1.r*2);
           weights.z = lerp(smoothstep(0.5 - ptCurveWeight2.r, 0.5 + ptCurveWeight2.r, weights.z), weights.z, ptCurveWeight2.r*2);
           weights.w = lerp(smoothstep(0.5 - ptCurveWeight3.r, 0.5 + ptCurveWeight3.r, weights.w), weights.w, ptCurveWeight3.r*2);
           weights = normalize(weights);
         #endif
         

         // uvScale before anything
         #if _PERTEXUVSCALEOFFSET && !_TRIPLANAR && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptUVScale, 0.5, config, half4(1,1,0,0));
            config.uv0.xy = config.uv0.xy * ptUVScale0.rg + ptUVScale0.ba;
            config.uv1.xy = config.uv1.xy * ptUVScale1.rg + ptUVScale1.ba;
            #if !_MAX2LAYER
               config.uv2.xy = config.uv2.xy * ptUVScale2.rg + ptUVScale2.ba;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               config.uv3.xy = config.uv3.xy * ptUVScale3.rg + ptUVScale3.ba;
            #endif

            // fix for pertex uv scale using gradient sampler and weight blended derivatives
            #if _USEGRADMIP
               albedoLOD = albedoLOD * ptUVScale0.rgrg * weights.x + 
                           albedoLOD * ptUVScale1.rgrg * weights.y + 
                           albedoLOD * ptUVScale2.rgrg * weights.z + 
                           albedoLOD * ptUVScale3.rgrg * weights.w;
               normalLOD = albedoLOD;
               #if _USEEMISSIVEMETAL
                  emisLOD = albedoLOD;
               #endif
               #if _USESPECULARWORKFLOW
                  specLOD = albedoLOD;
               #endif
            #endif
         #endif

         #if _PERTEXUVROTATION && !_TRIPLANAR && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptUVRot, 16.5, config, half4(0,0,0,0));
            config.uv0.xy = RotateUV(config.uv0.xy, ptUVRot0.x);
            config.uv1.xy = RotateUV(config.uv1.xy, ptUVRot1.x);
            #if !_MAX2LAYER
               config.uv2.xy = RotateUV(config.uv2.xy, ptUVRot2.x);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               config.uv3.xy = RotateUV(config.uv3.xy, ptUVRot0.x);
            #endif
         #endif

         
         o.Alpha = 1;

         
         #if _POM && !_DISABLESPLATMAPS
            DoPOM(i, config, tc, albedoLOD, weights, camDist, worldNormalVertex);
         #endif
         

         SampleAlbedo(config, tc, samples, albedoLOD, weights);

         #if _NOISEHEIGHT
            ApplyNoiseHeight(samples, config.uv, config, i.worldPos, worldNormalVertex);
         #endif
         
         #if _STREAMS || (_PARALLAX && !_DISABLESPLATMAPS)
         half earlyHeight = BlendWeights(samples.albedo0.w, samples.albedo1.w, samples.albedo2.w, samples.albedo3.w, weights);
         #endif

         
         #if _STREAMS
         waterNormalFoam = GetWaterNormal(i, config.uv, worldNormalVertex);
         DoStreamRefract(config, tc, waterNormalFoam, fxLevels.b, earlyHeight);
         #endif

         #if _PARALLAX && !_DISABLESPLATMAPS
            DoParallax(i, earlyHeight, config, tc, samples, weights, camDist);
         #endif


         // Blend results
         #if _PERTEXINTERPCONTRAST && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptContrasts, 1.5, config, 0.5);
            half4 contrast = 0.5;
            contrast.x = ptContrasts0.a;
            contrast.y = ptContrasts1.a;
            #if !_MAX2LAYER
               contrast.z = ptContrasts2.a;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               contrast.w = ptContrasts3.a;
            #endif
            contrast = clamp(contrast + _Contrast, 0.0001, 1.0); 
            half cnt = contrast.x * weights.x + contrast.y * weights.y + contrast.z * weights.z + contrast.w * weights.w;
            half4 heightWeights = ComputeWeights(weights, samples.albedo0.a, samples.albedo1.a, samples.albedo2.a, samples.albedo3.a, cnt);
         #else
            half4 heightWeights = ComputeWeights(weights, samples.albedo0.a, samples.albedo1.a, samples.albedo2.a, samples.albedo3.a, _Contrast);
         #endif


         #if _PARALLAX || _STREAMS
            SampleAlbedo(config, tc, samples, albedoLOD, heightWeights);
         #endif


         SampleNormal(config, tc, samples, normalLOD, heightWeights);

         #if _USEEMISSIVEMETAL
            SampleEmis(config, tc, samples, emisLOD, heightWeights);
         #endif

         #if _USESPECULARWORKFLOW
            SampleSpecular(config, tc, samples, specLOD, heightWeights);
         #endif

         #if _DISTANCERESAMPLE && !_DISABLESPLATMAPS
            DistanceResample(samples, config, tc, camDist, i.viewDir, fxLevels, albedoLOD, i.worldPos, heightWeights, worldNormalVertex);
         #endif

         // PerTexture sampling goes here, passing the samples structure
         
         #if _PERTEXMICROSHADOWS || _PERTEXFUZZYSHADE
            SAMPLE_PER_TEX(ptFuzz, 17.5, config, half4(0, 0, 1, 1));
         #endif

         #if _PERTEXMICROSHADOWS
            #if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_DEFERRED) || (defined(_MSRENDERLOOP_UNITYLD) && defined(_PASSFORWARD) || _MSRENDERLOOP_UNITYHD)
            {
               half3 lightDir = GetGlobalLightDirTS(i);
               half4 microShadows = half4(1,1,1,1);
               microShadows.x = MicroShadow(lightDir, half3(samples.normSAO0.xy, 1), samples.normSAO0.a, ptFuzz0.a);
               microShadows.y = MicroShadow(lightDir, half3(samples.normSAO1.xy, 1), samples.normSAO1.a, ptFuzz1.a);
               microShadows.z = MicroShadow(lightDir, half3(samples.normSAO2.xy, 1), samples.normSAO2.a, ptFuzz2.a);
               microShadows.w = MicroShadow(lightDir, half3(samples.normSAO3.xy, 1), samples.normSAO3.a, ptFuzz3.a);
               samples.normSAO0.a *= microShadows.x;
               samples.normSAO1.a *= microShadows.y;
               #if !_MAX2LAYER
                  samples.normSAO2.a *= microShadows.z;
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  samples.normSAO3.a *= microShadows.w;
               #endif

               
               #if _DEBUG_OUTPUT_MICROSHADOWS
               o.Albedo = BlendWeights(microShadows.x, microShadows.y, microShadows.z, microShadows.a, heightWeights);
               return o;
               #endif

            }
            #endif

         #endif // _PERTEXMICROSHADOWS


         #if _PERTEXFUZZYSHADE
            
            samples.albedo0.rgb = FuzzyShade(samples.albedo0.rgb, half3(samples.normSAO0.rg, 1), ptFuzz0.r, ptFuzz0.g, ptFuzz0.b, i.viewDir);
            samples.albedo1.rgb = FuzzyShade(samples.albedo1.rgb, half3(samples.normSAO1.rg, 1), ptFuzz1.r, ptFuzz1.g, ptFuzz1.b, i.viewDir);
            #if !_MAX2LAYER
               samples.albedo2.rgb = FuzzyShade(samples.albedo2.rgb, half3(samples.normSAO2.rg, 1), ptFuzz2.r, ptFuzz2.g, ptFuzz2.b, i.viewDir);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb = FuzzyShade(samples.albedo3.rgb, half3(samples.normSAO3.rg, 1), ptFuzz3.r, ptFuzz3.g, ptFuzz3.b, i.viewDir);
            #endif
         #endif

         #if _PERTEXSATURATION && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptSaturattion, 9.5, config, half4(1, 1, 1, 1));
            samples.albedo0.rgb = lerp(MSLuminance(samples.albedo0.rgb), samples.albedo0.rgb, ptSaturattion0.a);
            samples.albedo1.rgb = lerp(MSLuminance(samples.albedo1.rgb), samples.albedo1.rgb, ptSaturattion1.a);
            #if !_MAX2LAYER
               samples.albedo2.rgb = lerp(MSLuminance(samples.albedo2.rgb), samples.albedo2.rgb, ptSaturattion2.a);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb = lerp(MSLuminance(samples.albedo3.rgb), samples.albedo3.rgb, ptSaturattion3.a);
            #endif
         
         #endif
         
         #if _PERTEXTINT && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptTints, 1.5, config, half4(1, 1, 1, 1));
            samples.albedo0.rgb *= ptTints0.rgb;
            samples.albedo1.rgb *= ptTints1.rgb;
            #if !_MAX2LAYER
               samples.albedo2.rgb *= ptTints2.rgb;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb *= ptTints3.rgb;
            #endif
         #endif
         
         #if _PCHEIGHTGRADIENT || _PCHEIGHTHSV || _PCSLOPEGRADIENT || _PCSLOPEHSV
            ProceduralGradients(i, samples, config, worldHeight, worldNormalVertex);
         #endif

         
         

         #if _WETNESS || _PUDDLES || _STREAMS
         porosity = _GlobalPorosity;
         #endif


         #if _PERTEXCOLORINTENSITY
            SAMPLE_PER_TEX(ptCI, 23.5, config, half4(1, 1, 1, 1));
            samples.albedo0.rgb = saturate(samples.albedo0.rgb * (1 + ptCI0.rrr));
            samples.albedo1.rgb = saturate(samples.albedo1.rgb * (1 + ptCI1.rrr));
            #if !_MAX2LAYER
               samples.albedo2.rgb = saturate(samples.albedo2.rgb * (1 + ptCI2.rrr));
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb = saturate(samples.albedo3.rgb * (1 + ptCI3.rrr));
            #endif
         #endif

         #if (_PERTEXBRIGHTNESS || _PERTEXCONTRAST || _PERTEXPOROSITY || _PERTEXFOAM) && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptBC, 3.5, config, half4(1, 1, 1, 1));
            #if _PERTEXCONTRAST
               samples.albedo0.rgb = saturate(((samples.albedo0.rgb - 0.5) * ptBC0.g) + 0.5);
               samples.albedo1.rgb = saturate(((samples.albedo1.rgb - 0.5) * ptBC1.g) + 0.5);
               #if !_MAX2LAYER
                 samples.albedo2.rgb = saturate(((samples.albedo2.rgb - 0.5) * ptBC2.g) + 0.5);
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  samples.albedo3.rgb = saturate(((samples.albedo3.rgb - 0.5) * ptBC3.g) + 0.5);
               #endif
            #endif
            #if _PERTEXBRIGHTNESS
               samples.albedo0.rgb = saturate(samples.albedo0.rgb + ptBC0.rrr);
               samples.albedo1.rgb = saturate(samples.albedo1.rgb + ptBC1.rrr);
               #if !_MAX2LAYER
                  samples.albedo2.rgb = saturate(samples.albedo2.rgb + ptBC2.rrr);
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  samples.albedo3.rgb = saturate(samples.albedo3.rgb + ptBC3.rrr);
               #endif
            #endif
            #if _PERTEXPOROSITY
            porosity = BlendWeights(ptBC0.b, ptBC1.b, ptBC2.b, ptBC3.b, heightWeights);
            #endif

            #if _PERTEXFOAM
            streamFoam = BlendWeights(ptBC0.a, ptBC1.a, ptBC2.a, ptBC3.a, heightWeights);
            #endif

         #endif

         #if (_PERTEXNORMSTR || _PERTEXAOSTR || _PERTEXSMOOTHSTR || _PERTEXMETALLIC) && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(perTexMatSettings, 2.5, config, half4(1.0, 1.0, 1.0, 0.0));
         #endif

         #if _PERTEXNORMSTR && !_DISABLESPLATMAPS
            samples.normSAO0.xy *= perTexMatSettings0.r;
            samples.normSAO1.xy *= perTexMatSettings1.r;
            #if !_MAX2LAYER
               samples.normSAO2.xy *= perTexMatSettings2.r;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.normSAO3.xy *= perTexMatSettings3.r;
            #endif
         #endif

         #if _PERTEXAOSTR && !_DISABLESPLATMAPS
            samples.normSAO0.a = pow(samples.normSAO0.a, abs(perTexMatSettings0.b));
            samples.normSAO1.a = pow(samples.normSAO1.a, abs(perTexMatSettings1.b));
            #if !_MAX2LAYER
               samples.normSAO2.a = pow(samples.normSAO2.a, abs(perTexMatSettings2.b));
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.normSAO3.a = pow(samples.normSAO3.a, abs(perTexMatSettings3.b));
            #endif
         #endif

         #if _PERTEXSMOOTHSTR && !_DISABLESPLATMAPS
            samples.normSAO0.b += perTexMatSettings0.g;
            samples.normSAO1.b += perTexMatSettings1.g;
            samples.normSAO0.b = saturate(samples.normSAO0.b);
            samples.normSAO1.b = saturate(samples.normSAO1.b);
            #if !_MAX2LAYER
               samples.normSAO2.b += perTexMatSettings2.g;
               samples.normSAO2.b = saturate(samples.normSAO2.b);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.normSAO3.b += perTexMatSettings3.g;
               samples.normSAO3.b = saturate(samples.normSAO3.b);
            #endif
         #endif

         
         #if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_DEFERRED) || (defined(_MSRENDERLOOP_UNITYLD) && defined(_PASSFORWARD) || _MSRENDERLOOP_UNITYHD) 
          #if _PERTEXSSS
          {
            SAMPLE_PER_TEX(ptSSS, 18.5, config, half4(1, 1, 1, 1)); // tint, thickness
            
            half4 vals = ptSSS0 * heightWeights.x + ptSSS1 * heightWeights.y + ptSSS2 * heightWeights.z + ptSSS3 * heightWeights.w;
            SSSThickness = vals.a;
            SSSTint = vals.rgb;
          }
          #endif
         #endif

         #if (((_DETAILNOISE && _PERTEXDETAILNOISESTRENGTH) || (_DISTANCENOISE && _PERTEXDISTANCENOISESTRENGTH)) || (_NORMALNOISE && _PERTEXNORMALNOISESTRENGTH)) && !_DISABLESPLATMAPS
         ApplyDetailDistanceNoisePerTex(samples, config, camDist, i.worldPos, worldNormalVertex);
         #endif

         
         #if _GLOBALNOISEUV
            // noise defaults so that a value of 1, 1 is 4 pixels in size and moves the uvs by 1 pixel max.
            #if _CUSTOMSPLATTEXTURES
               noiseUV = (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, config.uv * _CustomControl0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _CustomControl0_TexelSize.xy * _NoiseUVParams.y;
            #else
               noiseUV = (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, config.uv * _Control0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _Control0_TexelSize.xy * _NoiseUVParams.y;
            #endif
         #endif

         
         #if _TRAXSINGLE || _TRAXARRAY || _TRAXNOTEXTURE
            ApplyTrax(samples, config, i.worldPos, traxBuffer, traxNormal);
         #endif

         #if (_ANTITILEARRAYDETAIL || _ANTITILEARRAYDISTANCE || _ANTITILEARRAYNORMAL) && !_DISABLESPLATMAPS
         ApplyAntiTilePerTex(samples, config, camDist, i.worldPos, worldNormalVertex, heightWeights);
         #endif

         #if _GEOMAP && !_DISABLESPLATMAPS
         GeoTexturePerTex(samples, i.worldPos, worldHeight, config, worldNormalVertex, upVector);
         #endif
         
         #if _GLOBALTINT && _PERTEXGLOBALTINTSTRENGTH && !_DISABLESPLATMAPS
         GlobalTintTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALNORMALS && _PERTEXGLOBALNORMALSTRENGTH && !_DISABLESPLATMAPS
         GlobalNormalTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALSMOOTHAOMETAL && _PERTEXGLOBALSAOMSTRENGTH && !_DISABLESPLATMAPS
         GlobalSAOMTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _GLOBALEMIS && _PERTEXGLOBALEMISSTRENGTH && !_DISABLESPLATMAPS
         GlobalEmisTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _GLOBALSPECULAR && _PERTEXGLOBALSPECULARSTRENGTH && !_DISABLESPLATMAPS && _USESPECULARWORKFLOW
         GlobalSpecularTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _PERTEXMETALLIC && !_DISABLESPLATMAPS
            half metallic = BlendWeights(perTexMatSettings0.a, perTexMatSettings1.a, perTexMatSettings2.a, perTexMatSettings3.a, heightWeights);
            o.Metallic = metallic;
         #endif

         #if _GLITTER && !_DISABLESPLATMAPS
            DoGlitter(i, samples, config, camDist, worldNormalVertex, i.worldPos);
         #endif
         
         // Blend em..
         #if _DISABLESPLATMAPS
            // If we don't sample from the _Diffuse, then the shader compiler will strip the sampler on
            // some platforms, which will cause everything to break. So we sample from the lowest mip
            // and saturate to 1 to keep the cost minimal. Annoying, but the compiler removes the texture
            // and sampler, even though the sampler is still used.
            albedo = saturate(UNITY_SAMPLE_TEX2DARRAY_LOD(_Diffuse, float3(0,0,0), 12) + 1);
            albedo.a = 0.5; // make height something we can blend with for the combined mesh mode, since it still height blends.
            normSAO = half4(0,0,0,1);
         #else
            albedo = BlendWeights(samples.albedo0, samples.albedo1, samples.albedo2, samples.albedo3, heightWeights);
            normSAO = BlendWeights(samples.normSAO0, samples.normSAO1, samples.normSAO2, samples.normSAO3, heightWeights);
            #if _USEEMISSIVEMETAL && !_DISABLESPLATMAPS
               emisMetal = BlendWeights(samples.emisMetal0, samples.emisMetal1, samples.emisMetal2, samples.emisMetal3, heightWeights);
            #endif

            #if _USESPECULARWORKFLOW && !_DISABLESPLATMAPS
               specular = BlendWeights(samples.specular0, samples.specular1, samples.specular2, samples.specular3, heightWeights);
            #endif
         #endif

         
         // ADVANCEDTERRAIN_ENTRYPOINT 


         #if _MESHOVERLAYSPLATS || _MESHCOMBINED
            o.Alpha = 1.0;
            if (config.uv0.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.x;
            else if (config.uv1.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.y;
            else if (config.uv2.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.z;
            else if (config.uv3.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.w;
         #endif



         // effects which don't require per texture adjustments and are part of the splats sample go here. 
         // Often, as an optimization, you can compute the non-per tex version of above effects here..


         #if ((_DETAILNOISE && !_PERTEXDETAILNOISESTRENGTH) || (_DISTANCENOISE && !_PERTEXDISTANCENOISESTRENGTH) || (_NORMALNOISE && !_PERTEXNORMALNOISESTRENGTH))
            ApplyDetailDistanceNoise(albedo.rgb, normSAO, config, camDist, i.worldPos, worldNormalVertex);
         #endif

         #if _SPLATFADE
         }
         #endif

         #if _SPLATFADE
            // blend in uniform texture over splat fade range
            // only for planets? Fine on terrain, but may want a switch for this..
            #if _TRIPLANAR && (_PLANETNORMAL || _PLANETNORMAL2)
               

               float3 pN = pow(abs(worldNormalVertex), 0.7);
               pN = pN / (pN.x + pN.y + pN.z);
            
               half3 axisSign = sign(worldNormalVertex);

               float2 uv0 = i.worldPos.zy * axisSign.x * _TriplanarUVScale.xy;
               float2 uv1 = i.worldPos.xz * axisSign.y * _TriplanarUVScale.xy;
               float2 uv2 = i.worldPos.xy * axisSign.z * _TriplanarUVScale.xy;

               float2 sfDX = ddx(uv0);
               float2 sfDY = ddy(uv0);

               MSBRANCHOTHER(camDist - _SplatFade.x)
               {
                  float falloff = saturate(InverseLerp(_SplatFade.x, _SplatFade.y, camDist));
                  half4 sfalb0 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(uv0, _SplatFade.z), sfDX, sfDY);
                  half4 sfalb1 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(uv1, _SplatFade.z), sfDX, sfDY);
                  half4 sfalb2 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(uv2, _SplatFade.z), sfDX, sfDY);
                  COUNTSAMPLE
                  COUNTSAMPLE
                  COUNTSAMPLE
                  albedo.rgb = lerp(albedo.rgb, sfalb0.rgb * pN.x + sfalb1 * pN.y + sfalb2 * pN.z, falloff);

                  #if !_NONOMALMAP
                     half4 sfnormSAO0 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(uv0, _SplatFade.z), sfDX, sfDY).garb;
                     half4 sfnormSAO1 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(uv1, _SplatFade.z), sfDX, sfDY).garb;
                     half4 sfnormSAO2 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(uv2, _SplatFade.z), sfDX, sfDY).garb;
                     COUNTSAMPLE
                     COUNTSAMPLE
                     COUNTSAMPLE
                     half4 sfnormSAO = sfnormSAO0 * pN.x + sfnormSAO1 * pN.y + sfnormSAO2 * pN.z;
                     sfnormSAO.xy = sfnormSAO.xy * 2 - 1;

                     normSAO = lerp(normSAO, sfnormSAO, falloff);
                  #endif
              
               }
            #else // _TRIPLANAR && (_PLANETNORMAL || _PLANETNORMAL2)
            float2 sfDX = ddx(config.uv * _UVScale);
            float2 sfDY = ddy(config.uv * _UVScale);

            MSBRANCHOTHER(camDist - _SplatFade.x)
            {
               float falloff = saturate(InverseLerp(_SplatFade.x, _SplatFade.y, camDist));
               half4 sfalb = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(config.uv * _UVScale, _SplatFade.z), sfDX, sfDY);
               COUNTSAMPLE
               albedo.rgb = lerp(albedo.rgb, sfalb.rgb, falloff);

               #if !_NONOMALMAP
                  half4 sfnormSAO = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(config.uv * _UVScale, _SplatFade.z), sfDX, sfDY).garb;
                  COUNTSAMPLE
                  sfnormSAO.xy = sfnormSAO.xy * 2 - 1;

                  normSAO = lerp(normSAO, sfnormSAO, falloff);
               #endif
              
            }
            #endif
         #endif


         #if _MESHCOMBINED
            SampleMeshCombined(albedo, normSAO, emisMetal, specular, o.Alpha, SSSThickness, SSSTint, config, heightWeights);
         #endif
         
         #if _SCATTER
            ApplyScatter(i, albedo, normSAO, config.uv, camDist);
         #endif

         #if _GEOMAP
            GeoTexture(albedo.rgb, normSAO, i.worldPos, worldHeight, config, worldNormalVertex, upVector);
         #endif

         #if _PLANETALBEDO || _PLANETNORMAL || _PLANETALBEDO2 || _PLANETNORMAL2
            ApplyPlanet(i, albedo, normSAO, config, camDist, i.worldPos, worldNormalVertex);
         #endif


         #if _GLOBALTINT && !_PERTEXGLOBALTINTSTRENGTH
            GlobalTintTexture(albedo.rgb, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _VSGRASSMAP
            VSGrassTexture(albedo.rgb, config, camDist);
         #endif

         #if _GLOBALNORMALS && !_PERTEXGLOBALNORMALSTRENGTH
            GlobalNormalTexture(normSAO, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALSMOOTHAOMETAL && !_PERTEXGLOBALSAOMSTRENGTH
            GlobalSAOMTexture(normSAO, emisMetal, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALEMIS && !_PERTEXGLOBALEMISSTRENGTH
            GlobalEmisTexture(emisMetal, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _GLOBALSPECULAR && !_PERTEXGLOBALSPECULARSTRENGTH && _USESPECULARWORKFLOW
            GlobalSpecularTexture(specular.rgb, config, camDist, globalSlopeFilter, noiseUV);
         #endif

        
         
         o.Albedo = albedo.rgb;
         o.Height = albedo.a;
         o.Normal = half3(normSAO.xy, 1);
         o.Smoothness = normSAO.b;
         o.Occlusion = normSAO.a;

         #if _USEEMISSIVEMETAL || _GLOBALSMOOTHAOMETAL || _GLOBALEMIS 
         o.Emission = emisMetal.rgb;
         o.Metallic = emisMetal.a;
	        #if _USEEMISSIVEMETAL
	        o.Emission *= _EmissiveMult;
	        #endif
         #endif

         #if _USESPECULARWORKFLOW
            o.Specular = specular;
         #endif


         


         #if _WETNESS || _PUDDLES || _STREAMS || _LAVA
         pud = DoStreams(i, o, fxLevels, config.uv, porosity, waterNormalFoam, worldNormalVertex, streamFoam, wetLevel, burnLevel, i.worldPos);
         #endif

         
         #if _SNOW
         snowCover = DoSnow(o, config.uv, WorldNormalVector(i, o.Normal), worldNormalVertex, i.worldPos, pud, porosity, camDist, 
            config, weights, SSSTint, SSSThickness, traxBuffer, traxNormal);
         #endif

         #if _PERTEXSSS || _MESHCOMBINEDUSESSS || (_SNOW && _SNOWSSS)
         {
            half3 worldView = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

            o.Emission += ComputeSSS(i, worldView, WorldNormalVector(i, half3(normSAO.xy, 1)),
               SSSTint, SSSThickness, _SSSDistance, _SSSScale, _SSSPower);
         }
         #endif
         
         #if _SNOWGLITTER
            DoSnowGlitter(i, config, o, camDist, worldNormalVertex, snowCover);
         #endif

         #if _WINDPARTICULATE || _SNOWPARTICULATE
         DoWindParticulate(i, o, config, weights, camDist, worldNormalVertex, snowCover);
         #endif

         o.Normal.z = sqrt(1 - saturate(dot(o.Normal.xy, o.Normal.xy)));

         #if _SPECULARFADE
         {
            float specFade = saturate((i.worldPos.y - _SpecularFades.x) / max(_SpecularFades.y - _SpecularFades.x, 0.0001));
            o.Metallic *= specFade;
            o.Smoothness *= specFade;
         }
         #endif

         #if _VSSHADOWMAP
         VSShadowTexture(o, i, config, camDist);
         #endif
         
         #if _TOONWIREFRAME
         ToonWireframe(config.uv, o.Albedo);
         #endif

         #if _DEBUG_TRAXBUFFER
            ClearAllButAlbedo(o, half3(traxBuffer, 0, 0) * saturate(o.Albedo.z+1));
         #elif _DEBUG_WORLDNORMALVERTEX
            ClearAllButAlbedo(o, worldNormalVertex * saturate(o.Albedo.z+1));
         #elif _DEBUG_WORLDNORMAL
            ClearAllButAlbedo(o,  WorldNormalVector(i, o.Normal) * saturate(o.Albedo.z+1));
         #endif

         return o;
      }
      
      void SampleSplats(float2 controlUV, inout half4 w0, inout half4 w1, inout half4 w2, inout half4 w3, inout half4 w4, inout half4 w5, inout half4 w6, inout half4 w7)
      {
         #if _CUSTOMSPLATTEXTURES
            #if !_MICROMESH
            controlUV = (controlUV * (_CustomControl0_TexelSize.zw - 1.0f) + 0.5f) * _CustomControl0_TexelSize.xy;
            #endif

            #if  _CONTROLNOISEUV
               controlUV += (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, controlUV * _CustomControl0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _CustomControl0_TexelSize.xy * _NoiseUVParams.y;
            #endif

            w0 = UNITY_SAMPLE_TEX2D(_CustomControl0, controlUV);
            COUNTSAMPLE

            #if !_MAX4TEXTURES
            w1 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl1, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES
            w2 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl2, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
            w3 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl3, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w4 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl4, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w5 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl5, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX28TEXTURES || _MAX32TEXTURES
            w6 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl6, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX32TEXTURES
            w7 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl7, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif
         #else
            #if !_MICROMESH
            controlUV = (controlUV * (_Control0_TexelSize.zw - 1.0f) + 0.5f) * _Control0_TexelSize.xy;
            #endif

            #if  _CONTROLNOISEUV
               controlUV += (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, controlUV * _Control0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _Control0_TexelSize.xy * _NoiseUVParams.y;
            #endif

            w0 = UNITY_SAMPLE_TEX2D(_Control0, controlUV);
            COUNTSAMPLE

            #if !_MAX4TEXTURES
            w1 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control1, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES
            w2 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control2, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
            w3 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control3, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w4 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control4, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w5 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control5, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX28TEXTURES || _MAX32TEXTURES
            w6 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control6, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX32TEXTURES
            w7 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control7, _Control0, controlUV);
            COUNTSAMPLE
            #endif
         #endif
      }   


      

      MicroSplatLayer SurfImpl(Input i, float3 worldNormalVertex)
      {
         // with DrawInstanced on, view dir is incorrect, so we compute it here. Thanks Obama..
         #if _MSRENDERLOOP_SURFACESHADER && !_DEBUG_USE_TOPOLOGY &&!_TERRAINBLENDABLESHADER && !_MICROMESH && !_MICROMESHTERRAIN && !_MICROPOLARISMESH &&!_MICRODIGGERMESH && !_MICROVERTEXMESH && defined(UNITY_INSTANCING_ENABLED)
            float3 t2w0 = WorldNormalVector(i, float3(1,0,0));
            float3 t2w1 = WorldNormalVector(i, float3(0,1,0));
            float3 t2w2 = WorldNormalVector(i, float3(0,0,1));
            float3x3 t2w = float3x3(t2w0, t2w1, t2w2);
            i.viewDir = normalize(mul(t2w, (_WorldSpaceCameraPos - i.worldPos)));
         #elif !_MSRENDERLOOP_SURFACESHADER
            // tangent space view dir is just not correct in URP
            i.viewDir = normalize( mul(i.TBN, (_WorldSpaceCameraPos - i.worldPos)) );
         #endif


         #if _TERRAINBLENDABLESHADER && _TRIPLANAR
            worldNormalVertex = WorldNormalVector(i, float3(0,0,1));
         #endif
         
         float camDist = distance(_WorldSpaceCameraPos, i.worldPos);
          
         #if _FORCELOCALSPACE
            #if _PLANETVECTORS
                worldNormalVertex = mul(_PQSToLocal, float4(worldNormalVertex, 1)).xyz;
                i.worldPos = i.worldPos + mul(_PQSToLocal, float4(0,0,0,1)).xyz;
             #else
                worldNormalVertex = mul((float3x3)GetWorldToObjectMatrix(), worldNormalVertex).xyz;
                i.worldPos = i.worldPos -  mul(GetObjectToWorldMatrix(), float4(0,0,0,1)).xyz;
             #endif
         #endif

         #if _ORIGINSHIFT
             //worldNormalVertex = mul(_GlobalOriginMTX, float4(worldNormalVertex, 1)).xyz;
             i.worldPos = i.worldPos + mul(_GlobalOriginMTX, float4(0,0,0,1)).xyz;
         #endif

         #if _DEBUG_USE_TOPOLOGY
            i.worldPos = UNITY_SAMPLE_TEX2D_SAMPLER(_DebugWorldPos, _Diffuse, i.uv_Control0);
            worldNormalVertex = UNITY_SAMPLE_TEX2D_SAMPLER(_DebugWorldNormal, _Diffuse, i.uv_Control0);
         #endif

         #if _ALPHABELOWHEIGHT && !_TBDISABLEALPHAHOLES
            ClipWaterLevel(i.worldPos);
         #endif

         #if !_TBDISABLEALPHAHOLES && defined(_ALPHATEST_ON)
            // UNITY 2019.3 holes
            ClipHoles(i.uv_Control0);
         #endif


         float2 origUV = i.uv_Control0;

         #if _MICROMESH && _MESHUV2
         float2 controlUV = i.uv2_Diffuse;
         #else
         float2 controlUV = i.uv_Control0;
         #endif


         #if _MICROMESH
            controlUV = InverseLerp(_UVMeshRange.xy, _UVMeshRange.zw, controlUV);
         #endif

         half4 weights = half4(1,0,0,0);

         Config config = (Config)0;
         UNITY_INITIALIZE_OUTPUT(Config,config);
         config.uv = origUV;

         #if _SPLATFADE
         MSBRANCHOTHER(_SplatFade.y - camDist)
         #endif // _SPLATFADE
         {
            #if !_DISABLESPLATMAPS

               // Sample the splat data, from textures or vertices, and setup the config..
               #if _MICRODIGGERMESH
                  DiggerSetup(i, weights, origUV, config, i.worldPos);
               #elif _MICROVERTEXMESH
                  VertexSetup(i, weights, origUV, config, i.worldPos);
               #elif !_PROCEDURALTEXTURE || _PROCEDURALBLENDSPLATS
                  half4 w0 = 0; half4 w1 = 0; half4 w2 = 0; half4 w3 = 0; half4 w4 = 0; half4 w5 = 0; half4 w6 = 0; half4 w7 = 0;
                  SampleSplats(controlUV, w0, w1, w2, w3, w4, w5, w6, w7);
                  Setup(weights, origUV, config, w0, w1, w2, w3, w4, w5, w6, w7, i.worldPos);
               #endif

               #if _PROCEDURALTEXTURE
                  float3 up = float3(0,1,0);
                  float3 procNormal = worldNormalVertex;
                  float height = i.worldPos.y;
                  ProceduralSetup(i, i.worldPos, height, procNormal, up, weights, origUV, config, ddx(origUV), ddy(origUV), ddx(i.worldPos), ddy(i.worldPos));

                  #if _PLANETNORMAL2 || _PLANETNORMAL
                     config.uv = origUV;
                     float2 pnorm = GetPlanetTangentNormal(i, config, camDist, worldNormalVertex);
                     procNormal.xy = pnorm;
                     procNormal.z = sqrt(1 - procNormal.x * procNormal.x - procNormal.y * procNormal.y);
                     procNormal = WorldNormalVector(i, procNormal);
                     up = worldNormalVertex;
                     float3 center = mul(GetWorldToObjectMatrix(), float3(0,0,0));
                     height = distance(i.worldPos, center); 
                  #endif
               #endif
            #else // _DISABLESPLATMAPS
                Setup(weights, origUV, config, half4(1,0,0,0), 0, 0, 0, 0, 0, 0, 0, i.worldPos);
            #endif
         } // _SPLATFADE else case

         
         #if _TOONFLATTEXTURE
            float2 quv = floor(origUV * _ToonTerrainSize);
            float2 fuv = frac(origUV * _ToonTerrainSize);
            #if !_TOONFLATTEXTUREQUAD
               quv = Hash2D((fuv.x > fuv.y) ? quv : quv * 0.333);
            #endif
            float2 uvq = quv / _ToonTerrainSize;
            config.uv0.xy = uvq;
            config.uv1.xy = uvq;
            config.uv2.xy = uvq;
            config.uv3.xy = uvq;
         #endif
         
         #if (_TEXTURECLUSTER2 || _TEXTURECLUSTER3) && !_DISABLESPLATMAPS
            PrepClusters(origUV, config, i.worldPos, worldNormalVertex);
         #endif

         #if (_ALPHAHOLE || _ALPHAHOLETEXTURE) && !_DISABLESPLATMAPS && !_TBDISABLEALPHAHOLES
         ClipAlphaHole(config, weights);
         #endif


 
         MicroSplatLayer l = Sample(i, weights, config, camDist, worldNormalVertex);

         
         // HI, this is the section where we hack around various Unity and compiler bugs..

         // Unity has a compiler bug with surface shaders where in some situations it will strip/fuckup
         // i.worldPos or i.viewDir thinking your not using them when you are inside a function. I have
         // fought with this bug so many times it's crazy, reported it and provided repros, and nothing has
         // been done about it. So, make sure these are used, and look like they could have an effect on the final
         // output so the compiler doesn't fuck them up.
         
         // Oh, nice, and it turns out that doing this in the base map shader breaks GI, so only do it in the main
         // shader, which is where we're using i.viewDir for parallax. Fucking hell..

         // AND if triplanar is on, this needs to be run otherwise the UV scale is fucked. I feel like I'm just
         // pushing compiler errors around at this point.. And this breaks render baking, so not then either.
         //
         // And sometimes VD is INF or NAN, so we copy it (make sure the compiler knows we are using) and
         // test for a value, and if it's not 1 we make it 1, so it doesn't make albedo black.
         //
         // Jusus fucking christ already..
         #if (!_MICROSPLATBASEMAP || _TRIPLANAR) && !_RENDERBAKE
            float3 vd = i.viewDir;
            if (vd.x != 1)
               vd = 1;
            l.Albedo *= saturate(vd + i.worldPos + 9999);
         #endif

         // Further, on windows, sometimes the diffuse sampler gets stripped, so we have to do this crap.
         // We sample from the lowest mip, so it shouldn't cost much, but still, I hate this, wtf..
         l.Albedo *= saturate(UNITY_SAMPLE_TEX2DARRAY_LOD(_Diffuse, config.uv0, 11).r + 2);
         // same for the control sampler.
         l.Albedo *= saturate(MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(_Control0, _Control0, config.uv, 11).r + 2);

         #if _PROCEDURALTEXTURE
            ProceduralTextureDebugOutput(l, weights, config);
         #endif
         


         return l;

      }



   


                    //MS_BLENDABLE

                    






    
    MicroSplatLayer DoMicroSplat(inout SurfaceDescriptionInputs IN)
    {
       SurfaceDescription surface = (SurfaceDescription)0;
       Input i = DescToInput(IN);
       float3 worldNormalVertex = IN.WorldSpaceNormal;

        #if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL) && !_MICROMESH && !_MICROMESHTERRAIN && !_MICROPOLARISMESH && !_MICRODIGGERMESH && !_MICROVERTEXMESH
            float2 terrainNormalMapUV = (i.uv_Control0.xy + 0.5f) * _TerrainHeightmapRecipSize.xy;
            i.uv_Control0.xy *= _TerrainHeightmapRecipSize.zw;
            

            #if _TOONHARDEDGENORMAL
               terrainNormalMapUV = ToonEdgeUV(terrainNormalMapUV);
            #endif
            float3 geomNormal = normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, terrainNormalMapUV).xyz * 2 - 1);

            worldNormalVertex = mul((float3x3)GetObjectToWorldMatrix(), geomNormal);
            IN.WorldSpaceNormal = worldNormalVertex;
            float4 tangentWS = ConstructTerrainTangent(IN.WorldSpaceNormal, GetObjectToWorldMatrix()._13_23_33);
            IN.WorldSpaceTangent = tangentWS.xyz;
            i.TBN = BuildTangentToWorld(tangentWS, IN.WorldSpaceNormal.xyz);
            IN.WorldSpaceBiTangent = i.TBN[1].xyz;
        #elif _PERPIXNORMAL
            float2 perPixUV = i.uv_Control0;
            #if _TOONHARDEDGENORMAL
               perPixUV = ToonEdgeUV(perPixUV);
            #endif
            float3 geomNormal = (UnpackNormal(UNITY_SAMPLE_TEX2D_SAMPLER(_PerPixelNormal, _Diffuse, perPixUV))).xzy;
            worldNormalVertex = geomNormal;
        #endif    
        
         
         #if _SRPTERRAINBLEND
            SurfaceOutputCustom soc = (SurfaceOutputCustom)0;
            soc.input = i;
            float3 sh = 0;
            BlendWithTerrainSRP(soc, IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);

            MicroSplatLayer l = (MicroSplatLayer)0;
            l.Albedo = soc.Albedo;
            l.Normal = mul(float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal), soc.Normal);
            l.Emission = soc.Emission;
            l.Metallic = soc.Metallic;
            l.Smoothness = soc.Smoothness;
            #if _USESPECULARWORKFLOW
               l.Specular = soc.Specular;
            #endif
            l.Occlusion = soc.Occlusion;
            l.Alpha = soc.Alpha;

         #else
            MicroSplatLayer l = SurfImpl(i, worldNormalVertex);
         #endif


       // per pixel normal
        #if ((defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)) && !_MICROMESHTERRAIN && !_MICROMESH && !_MICROVERTEXMESH && !_MICRODIGGERMESH && !_MICROPOLARISMESH) || (_MICROMESHTERRAIN && _PERPIXNORMAL)
            float3 geomTangent = normalize(cross(geomNormal, float3(0, 0, 1)));
            float3 geomBitangent = normalize(cross(geomTangent, geomNormal));
            l.Normal = l.Normal.x * geomTangent + l.Normal.y * geomBitangent + l.Normal.z * geomNormal;
            l.Normal = l.Normal.xzy;
        #endif

        DoDebugOutput(l);


        return l;
    }



        



                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        MicroSplatLayer l = DoMicroSplat(IN);

                        SurfaceDescription surface = (SurfaceDescription)0;
                        surface.Alpha = 1;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    output.texCoord0 = input.texCoord0;
                    // output.texCoord1 = input.texCoord1;
                    // output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    //output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    // output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    output.WorldSpaceNormal =            normalize(input.tangentToWorld[2].xyz);
                    // output.ObjectSpaceNormal =           mul(output.WorldSpaceNormal, (float3x3) GetObjectToWorldMatrix());           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    // output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // specularOcclusion need to be init ahead of decal to quiet the compiler that modify the SurfaceData struct
                // however specularOcclusion can come from the graph, so need to be init here so it can be override.
                surfaceData.specularOcclusion = 1.0;
        
                // copy across graph values, if defined
                // surfaceData.baseColor =                 surfaceDescription.Albedo;
                // surfaceData.perceptualSmoothness =      surfaceDescription.Smoothness;
                // surfaceData.ambientOcclusion =          surfaceDescription.Occlusion;
                // surfaceData.specularOcclusion =         surfaceDescription.SpecularOcclusion;
                // surfaceData.metallic =                  surfaceDescription.Metallic;
                // surfaceData.subsurfaceMask =            surfaceDescription.SubsurfaceMask;
                // surfaceData.thickness =                 surfaceDescription.Thickness;
                // surfaceData.diffusionProfileHash =      asuint(surfaceDescription.DiffusionProfileHash);
                // surfaceData.specularColor =             surfaceDescription.Specular;
                // surfaceData.coatMask =                  surfaceDescription.CoatMask;
                // surfaceData.anisotropy =                surfaceDescription.Anisotropy;
                // surfaceData.iridescenceMask =           surfaceDescription.IridescenceMask;
                // surfaceData.iridescenceThickness =      surfaceDescription.IridescenceThickness;
        
        #ifdef _HAS_REFRACTION
                if (_EnableSSRefraction)
                {
                    // surfaceData.ior =                       surfaceDescription.RefractionIndex;
                    // surfaceData.transmittanceColor =        surfaceDescription.RefractionColor;
                    // surfaceData.atDistance =                surfaceDescription.RefractionDistance;
        
                    surfaceData.transmittanceMask = (1.0 - surfaceDescription.Alpha);
                    surfaceDescription.Alpha = 1.0;
                }
                else
                {
                    surfaceData.ior = 1.0;
                    surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                    surfaceData.atDistance = 1.0;
                    surfaceData.transmittanceMask = 0.0;
                    surfaceDescription.Alpha = 1.0;
                }
        #else
                surfaceData.ior = 1.0;
                surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                surfaceData.atDistance = 1.0;
                surfaceData.transmittanceMask = 0.0;
        #endif
                
                // These static material feature allow compile time optimization
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
                // surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
        
        #ifdef _MATERIAL_FEATURE_IRIDESCENCE
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
        #endif
        #ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
        #endif
        
        #if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
                // Require to have setup baseColor
                // Reproduce the energy conservation done in legacy Unity. Not ideal but better for compatibility and users can unchek it
                surfaceData.baseColor *= (1.0 - Max3(surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b));
        #endif
        
        #ifdef _DOUBLESIDED_ON
            float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
        #else
            float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        #endif
        
                // tangent-space normal
                float3 normalTS = float3(0.0f, 0.0f, 1.0f);
                // normalTS = surfaceDescription.Normal;
        
                // compute world space normal
                GetNormalWS(fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants);
        
                surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];
        
                surfaceData.tangentWS = normalize(fragInputs.tangentToWorld[0].xyz);    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
                // surfaceData.tangentWS = TransformTangentToWorld(surfaceDescription.Tangent, fragInputs.tangentToWorld);
        
        #if HAVE_DECALS
                if (_EnableDecals)
                {
                    // Both uses and modifies 'surfaceData.normalWS'.
                    DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
                    ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
                }
        #endif
        
                bentNormalWS = surfaceData.normalWS;
                // GetNormalWS(fragInputs, surfaceDescription.BentNormal, bentNormalWS, doubleSidedConstants);
        
                surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);
        
        
                // By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion.
                // If user provide bent normal then we process a better term
        #if defined(_SPECULAR_OCCLUSION_CUSTOM)
                // Just use the value passed through via the slot (not active otherwise)
        #elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
                // If we have bent normal and ambient occlusion, process a specular occlusion
                surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO(V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness(surfaceData.perceptualSmoothness));
        #elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
                surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
        #endif
        
        #ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
                surfaceData.perceptualSmoothness = GeometricNormalFiltering(surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[2], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold);
        #endif
        
        #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO: need to update mip info
                    surfaceData.metallic = 0;
                }
        
                // We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
                // as it can modify attribute use for static lighting
                ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
        #ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
                uint3 fadeMaskSeed = asuint((int3)(V * _ScreenSize.xyx)); // Quantize V to _ScreenSize values
                LODDitheringTransition(fadeMaskSeed, unity_LODFade.x);
        #endif
        
        #ifdef _DOUBLESIDED_ON
            float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
        #else
            float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        #endif
        
                ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdDepthPrepass);
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdDepthPostpass);
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdShadow);
                
                // ApplyDepthOffsetPositionInput(V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput);
        
                float3 bentNormalWS;
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS);
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal 
                InitBuiltinData(posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[2], fragInputs.texCoord1, fragInputs.texCoord2, builtinData);
        
                // override sampleBakedGI:
                // builtinData.bakeDiffuseLighting = surfaceDescription.BakedGI;
                // builtinData.backBakeDiffuseLighting = surfaceDescription.BakedBackGI;
        
                // builtinData.emissiveColor = surfaceDescription.Emission;
        
                // builtinData.depthOffset = surfaceDescription.DepthOffset;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #else
                builtinData.distortion = float2(0.0, 0.0);
                builtinData.distortionBlur = 0.0;
        #endif
        
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassDepthOnly.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDLitPass.template
            Name "META"
            Tags { "LightMode" = "META" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            
            Cull Off
        
            
            
            
            
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            #pragma shader_feature_local _TERRAIN_INSTANCED_PERPIXEL_NORMAL
            #pragma multi_compile_instancing
            #pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap renderinglayer
        
            #pragma multi_compile_local _ _ALPHATEST_ON
        
            // #pragma multi_compile _ LOD_FADE_CROSSFADE
        
            #pragma shader_feature _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _DOUBLESIDED_ON
            #pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
            // #define _MATERIAL_FEATURE_SUBSURFACE_SCATTERING 1
            // #define _MATERIAL_FEATURE_TRANSMISSION 1
            // #define _MATERIAL_FEATURE_ANISOTROPY 1
            // #define _MATERIAL_FEATURE_IRIDESCENCE 1
            // #define _MATERIAL_FEATURE_SPECULAR_COLOR 1
            // #define _ENABLE_FOG_ON_TRANSPARENT 1
            #define _AMBIENT_OCCLUSION 1
            #define _SPECULAR_OCCLUSION_FROM_AO 1
            // #define _SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL 1
            // #define _SPECULAR_OCCLUSION_CUSTOM 1
            #define _ENERGY_CONSERVING_SPECULAR 1
            // #define _ENABLE_GEOMETRIC_SPECULAR_AA 1
            // #define _HAS_REFRACTION 1
            // #define _REFRACTION_PLANE 1
            // #define _REFRACTION_SPHERE 1
            // #define _DISABLE_DECALS 1
            // #define _DISABLE_SSR 1
            // #define _ADD_PRECOMPUTED_VELOCITY
            // #define _WRITE_TRANSPARENT_MOTION_VECTOR 1
            // #define _DEPTHOFFSET_ON 1
            // #define _BLENDMODE_PRESERVE_SPECULAR_LIGHTING 1

            
      #define _MICROSPLAT 1
      #define _ALPHABELOWHEIGHT 1
      #define _MSRENDERLOOP_UNITYHD 1


        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            // If we use subsurface scattering, enable output split lighting (for forward pass)
            #if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
            #define OUTPUT_SPLIT_LIGHTING
            #endif
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Defines
            //-------------------------------------------------------------------------------------
                    #define SHADERPASS SHADERPASS_LIGHT_TRANSPORT
                #define RAYTRACING_SHADER_GRAPH_HIGH
                #define REQUIRE_DEPTH_TEXTURE
                // ACTIVE FIELDS:
                //   Material.Standard
                //   Specular.EnergyConserving
                //   SpecularOcclusionFromAO
                //   AmbientOcclusion
                //   SurfaceDescriptionInputs.ScreenPosition
                //   SurfaceDescriptionInputs.VertexColor
                //   SurfaceDescriptionInputs.WorldSpaceNormal
                //   SurfaceDescriptionInputs.TangentSpaceNormal
                //   SurfaceDescriptionInputs.WorldSpaceTangent
                //   SurfaceDescriptionInputs.WorldSpaceBiTangent
                //   SurfaceDescriptionInputs.WorldSpaceViewDirection
                //   SurfaceDescriptionInputs.TangentSpaceViewDirection
                //   SurfaceDescriptionInputs.ObjectSpacePosition
                //   SurfaceDescriptionInputs.AbsoluteWorldSpacePosition
                //   SurfaceDescriptionInputs.uv0
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   SurfaceDescription.Albedo
                //   SurfaceDescription.Normal
                //   SurfaceDescription.BentNormal
                //   SurfaceDescription.CoatMask
                //   SurfaceDescription.Metallic
                //   SurfaceDescription.Emission
                //   SurfaceDescription.Smoothness
                //   SurfaceDescription.Occlusion
                //   SurfaceDescription.Alpha
                //   features.modifyMesh
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.uv0
                //   AttributesMesh.uv1
                //   AttributesMesh.color
                //   AttributesMesh.uv2
                //   SurfaceDescriptionInputs.WorldSpacePosition
                //   FragInputs.color
                //   FragInputs.tangentToWorld
                //   FragInputs.positionRWS
                //   FragInputs.texCoord0
                //   VaryingsMeshToPS.color
                //   VaryingsMeshToPS.tangentWS
                //   VaryingsMeshToPS.normalWS
                //   VaryingsMeshToPS.positionRWS
                //   VaryingsMeshToPS.texCoord0
                //   AttributesMesh.positionOS
                // Shared Graph Keywords
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            #define VARYINGS_NEED_TEXCOORD0
            // #define VARYINGS_NEED_TEXCOORD1
            // #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            //#define VARYINGS_NEED_COLOR
            // #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
        // We need isFontFace when using double sided
        #if defined(_DOUBLESIDED_ON) && !defined(VARYINGS_NEED_CULLFACE)
            #define VARYINGS_NEED_CULLFACE
        #endif
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
            
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
        #ifdef DEBUG_DISPLAY
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
        #if (SHADERPASS == SHADERPASS_FORWARD)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
        
            #define HAS_LIGHTLOOP
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL; // optional
                float4 tangentOS : TANGENT; // optional
                float4 uv0 : TEXCOORD0; // optional
                float4 uv1 : TEXCOORD1; // optional
                float4 uv2 : TEXCOORD2; // optional
                //float4 color : COLOR; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_Position;
                float3 positionRWS; // optional
                float3 normalWS; // optional
                float4 tangentWS; // optional
                float4 texCoord0; // optional
                //float4 color; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_Position; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
                float4 interp02 : TEXCOORD2; // auto-packed
                float4 interp03 : TEXCOORD3; // auto-packed
                //float4 interp04 : TEXCOORD4; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                output.interp03.xyzw = input.texCoord0;
                //output.interp04.xyzw = input.color;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                output.texCoord0 = input.interp03.xyzw;
                //output.color = input.interp04.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
        
      
      #define UNITY_DECLARE_TEX2D(name) TEXTURE2D(name); SAMPLER(sampler_##name);
      #define UNITY_DECLARE_TEX2D_NOSAMPLER(name) TEXTURE2D(name);
      #define UNITY_DECLARE_TEX2DARRAY(name) TEXTURE2D_ARRAY(name); SAMPLER(sampler_##name);
     
      #define UNITY_SAMPLE_TEX2DARRAY(tex,coord)            SAMPLE_TEXTURE2D_ARRAY(tex, sampler_##tex, coord.xy, coord.z)
      #define UNITY_SAMPLE_TEX2DARRAY_LOD(tex,coord,lod)    SAMPLE_TEXTURE2D_ARRAY_LOD(tex, sampler_##tex, coord.xy, coord.z, lod)
      #define UNITY_SAMPLE_TEX2D(tex, coord)                SAMPLE_TEXTURE2D(tex, sampler_##tex, coord)
      #define UNITY_SAMPLE_TEX2D_SAMPLER(tex, samp, coord)  SAMPLE_TEXTURE2D(tex, sampler_##samp, coord)

     
      #if defined(UNITY_COMPILER_HLSL)
         #define UNITY_INITIALIZE_OUTPUT(type,name) name = (type)0;
      #else
         #define UNITY_INITIALIZE_OUTPUT(type,name)
      #endif

      #define sampler2D_float sampler2D
      #define sampler2D_half sampler2D

      


   

            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 _EmissionColor;
                    float _RenderQueueType;
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
                    float _UseShadowThreshold;
                    float _DoubleSidedEnable;
                    float _DoubleSidedNormalMode;
                    float4 _DoubleSidedConstants;
                    

      #if _MESHSUBARRAY
         half4 _MeshSubArrayIndexes;
      #endif


      #if _USEEMISSIVEMETAL
         half _EmissiveMult;
      #endif

      float4 _UVScale; // scale and offset

      float2 _ToonTerrainSize;

      half _Contrast;
      
      float3 _gGlitterLightDir;
      float3 _gGlitterLightWorldPos;
      half3 _gGlitterLightColor;

       #if _VSSHADOWMAP
         float4 gVSSunDirection;
      #endif

      #if _FORCELOCALSPACE && _PLANETVECTORS
         float4x4 _PQSToLocal;
      #endif

      #if _ORIGINSHIFT
         float4x4 _GlobalOriginMTX;
      #endif

      float4 _Control0_TexelSize;
      float4 _CustomControl0_TexelSize;
      float4 _PerPixelNormal_TexelSize;

      #if _CONTROLNOISEUV || _GLOBALNOISEUV
         float2 _NoiseUVParams;
      #endif





      float2 _AlphaData;
      


                    CBUFFER_END
                    
                
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpaceNormal; // optional
                        float3 TangentSpaceNormal; // optional
                        float3 WorldSpaceTangent; // optional
                        float3 WorldSpaceBiTangent; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 TangentSpaceViewDirection; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float3 AbsoluteWorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                        float4 uv0; // optional
                        float4 VertexColor; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Albedo;
                        float3 Normal;
                        float3 BentNormal;
                        float CoatMask;
                        float Metallic;
                        float3 Emission;
                        float Smoothness;
                        float3 Specular;
                        float Occlusion;
                        float Alpha;
                    };
                    
                    
                    
#if defined(UNITY_INSTANCING_ENABLED) 
    #define ENABLE_TERRAIN_PERPIXEL_NORMAL
#endif 
 
#ifndef UNITY_TERRAIN_CB_VARS
    #define UNITY_TERRAIN_CB_VARS
#endif

#ifndef UNITY_TERRAIN_CB_DEBUG_VARS
    #define UNITY_TERRAIN_CB_DEBUG_VARS
#endif

CBUFFER_START(UnityTerrain)
    UNITY_TERRAIN_CB_VARS
#ifdef UNITY_INSTANCING_ENABLED 
    float4 _TerrainHeightmapRecipSize;  // float4(1.0f/width, 1.0f/height, 1.0f/(width-1), 1.0f/(height-1))
    float4 _TerrainHeightmapScale;      // float4(hmScale.x, hmScale.y / (float)(kMaxHeight), hmScale.z, 0.0f)
#endif
#ifdef DEBUG_DISPLAY
    UNITY_TERRAIN_CB_DEBUG_VARS
#endif
CBUFFER_END

#ifdef UNITY_INSTANCING_ENABLED
    TEXTURE2D(_TerrainHeightmapTexture);
    TEXTURE2D(_TerrainNormalmapTexture);
    #ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
        SAMPLER(sampler_TerrainNormalmapTexture);
    #endif
#endif

UNITY_INSTANCING_BUFFER_START(Terrain)
   UNITY_DEFINE_INSTANCED_PROP(float4, _TerrainPatchInstanceData)  // float4(xBase, yBase, skipScale, ~)
UNITY_INSTANCING_BUFFER_END(Terrain)

float4 ConstructTerrainTangent(float3 normal, float3 positiveZ)
{
    // Consider a flat terrain. It should have tangent be (1, 0, 0) and bitangent be (0, 0, 1) as the UV of the terrain grid mesh is a scale of the world XZ position.
    // In CreateTangentToWorld function (in SpaceTransform.hlsl), it is cross(normal, tangent) * sgn for the bitangent vector.
    // It is not true in a left-handed coordinate system for the terrain bitangent, if we provide 1 as the tangent.w. It would produce (0, 0, -1) instead of (0, 0, 1).
    // Also terrain's tangent calculation was wrong in a left handed system because cross((0,0,1), terrainNormalOS) points to the wrong direction as negative X.
    // Therefore all the 4 xyzw components of the tangent needs to be flipped to correct the tangent frame.
    // (See TerrainLitData.hlsl - GetSurfaceAndBuiltinData)
    float3 tangent = cross(normal, positiveZ);
    return float4(tangent, -1);
}


AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
{
#if defined(UNITY_INSTANCING_ENABLED) && !_MICROMESH && !_MICROMESHTERRAIN && !_MICROPOLARISMESH && !_MICRODIGGERMESH && !_MICROVERTEXMESH
    float2 patchVertex = input.positionOS.xy;
    float4 instanceData = UNITY_ACCESS_INSTANCED_PROP(Terrain, _TerrainPatchInstanceData);

    float2 sampleCoords = (patchVertex.xy + instanceData.xy) * instanceData.z; // (xy + float2(xBase,yBase)) * skipScale
    float height = UnpackHeightmap(_TerrainHeightmapTexture.Load(int3(sampleCoords, 0)));

    input.positionOS.xz = sampleCoords * _TerrainHeightmapScale.xz;
    input.positionOS.y = height * _TerrainHeightmapScale.y;
    
    #ifdef ATTRIBUTES_NEED_NORMAL
       input.normalOS = float3(0,1,0);
    #endif

    #if defined(VARYINGS_NEED_TEXCOORD0) || defined(VARYINGS_DS_NEED_TEXCOORD0)
       #ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
          input.uv0.xy = sampleCoords;
       #else
          input.uv0.xy = sampleCoords * _TerrainHeightmapRecipSize.zw;
       #endif
    #endif
#endif


    #ifdef ATTRIBUTES_NEED_TANGENT
       #if !_MICROMESH && !_MICROMESHTERRAIN && !_MICROVERTEXMESH && !_MICROPOLARISMESH
           input.tangentOS = ConstructTerrainTangent(input.normalOS, float3(0, 0, 1));
       #endif
    #endif

    return input;
}

        
                    

                    

      // dynamic branching helpers, for regular and aggressive branching
      // debug mode shows how many samples using branching will save us. 
      //
      // These macros are always used instead of the UNITY_BRANCH macro
      // to maintain debug displays and allow branching to be disabled
      // on as granular level as we want. 
      
      #if _BRANCHSAMPLES
         #if _DEBUG_BRANCHCOUNT_WEIGHT || _DEBUG_BRANCHCOUNT_TOTAL
            float _branchWeightCount;
            #define MSBRANCH(w) if (w > 0) _branchWeightCount++; if (w > 0)
         #else
            #define MSBRANCH(w) UNITY_BRANCH if (w > 0)
         #endif
      #else
         #if _DEBUG_BRANCHCOUNT_WEIGHT || _DEBUG_BRANCHCOUNT_TOTAL
            float _branchWeightCount;
            #define MSBRANCH(w) if (w > 0) _branchWeightCount++;
         #else
            #define MSBRANCH(w) 
         #endif
      #endif
      
      #if _BRANCHSAMPLESAGR
         #if _DEBUG_BRANCHCOUNT_TRIPLANAR || _DEBUG_BRANCHCOUNT_CLUSTER || _DEBUG_BRANCHCOUNT_OTHER ||_DEBUG_BRANCHCOUNT_TOTAL
            float _branchTriplanarCount;
            float _branchClusterCount;
            float _branchOtherCount;
            #define MSBRANCHTRIPLANAR(w) if (w > 0.001) _branchTriplanarCount++; if (w > 0.001)
            #define MSBRANCHCLUSTER(w) if (w > 0.001) _branchClusterCount++; if (w > 0.001)
            #define MSBRANCHOTHER(w) if (w > 0.001) _branchOtherCount++; if (w > 0.001)
         #else
            #define MSBRANCHTRIPLANAR(w) UNITY_BRANCH if (w > 0.001)
            #define MSBRANCHCLUSTER(w) UNITY_BRANCH if (w > 0.001)
            #define MSBRANCHOTHER(w) UNITY_BRANCH if (w > 0.001)
         #endif
      #else
         #if _DEBUG_BRANCHCOUNT_TRIPLANAR || _DEBUG_BRANCHCOUNT_CLUSTER || _DEBUG_BRANCHCOUNT_OTHER || _DEBUG_BRANCHCOUNT_TOTAL
            float _branchTriplanarCount;
            float _branchClusterCount;
            float _branchOtherCount;
            #define MSBRANCHTRIPLANAR(w) if (w > 0.001) _branchTriplanarCount++;
            #define MSBRANCHCLUSTER(w) if (w > 0.001) _branchClusterCount++;
            #define MSBRANCHOTHER(w) if (w > 0.001) _branchOtherCount++;
         #else
            #define MSBRANCHTRIPLANAR(w)
            #define MSBRANCHCLUSTER(w)
            #define MSBRANCHOTHER(w)
         #endif
      #endif

      #if _DEBUG_SAMPLECOUNT
         int _sampleCount;
         #define COUNTSAMPLE { _sampleCount++; }
      #else
         #define COUNTSAMPLE
      #endif

      #if _DEBUG_PROCLAYERS
         int _procLayerCount;
         #define COUNTPROCLAYER { _procLayerCount++; }
      #else
         #define COUNTPROCLAYER
      #endif


      #if _DEBUG_USE_TOPOLOGY
         UNITY_DECLARE_TEX2D_NOSAMPLER(_DebugWorldPos);
         UNITY_DECLARE_TEX2D_NOSAMPLER(_DebugWorldNormal);
      #endif
      

      // splat
      UNITY_DECLARE_TEX2DARRAY(_Diffuse);
      float4 _Diffuse_TexelSize;
      UNITY_DECLARE_TEX2DARRAY(_NormalSAO);
      float4 _NormalSAO_TexelSize;

      #if _CONTROLNOISEUV || _GLOBALNOISEUV
         UNITY_DECLARE_TEX2D_NOSAMPLER(_NoiseUV);
      #endif

      #if _PACKINGHQ
         UNITY_DECLARE_TEX2DARRAY(_SmoothAO);
         float4 _SmoothAO_TexelSize;
      #endif

      #if _USESPECULARWORKFLOW
         UNITY_DECLARE_TEX2DARRAY(_Specular);
         float4 _Specular_TexelSize;
      #endif

      #if _USEEMISSIVEMETAL
         UNITY_DECLARE_TEX2DARRAY(_EmissiveMetal);
         float4 _EmissiveMetal_TexelSize;
      #endif

      
      UNITY_DECLARE_TEX2D_NOSAMPLER(_PerPixelNormal);
      
      UNITY_DECLARE_TEX2D(_Control0);
      #if _CUSTOMSPLATTEXTURES
         UNITY_DECLARE_TEX2D(_CustomControl0);
         #if !_MAX4TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl1);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl2);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl3);
         #endif
         #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl4);
         #endif
         #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl5);
         #endif
         #if _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl6);
         #endif
         #if _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl7);
         #endif
      #else
         #if !_MAX4TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control1);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control2);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control3);
         #endif
         #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control4);
         #endif
         #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control5);
         #endif
         #if _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control6);
         #endif
         #if _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control7);
         #endif
      #endif

      sampler2D_float _PerTexProps;
   



      struct TriGradMipFormat
      {
         float4 d0;
         float4 d1;
         float4 d2;
      };

      half InverseLerp(half x, half y, half v) { return (v-x)/max(y-x, 0.001); }
      half2 InverseLerp(half2 x, half2 y, half2 v) { return (v-x)/max(y-x, half2(0.001, 0.001)); }
      half3 InverseLerp(half3 x, half3 y, half3 v) { return (v-x)/max(y-x, half3(0.001, 0.001, 0.001)); }
      half4 InverseLerp(half4 x, half4 y, half4 v) { return (v-x)/max(y-x, half4(0.001, 0.001, 0.001, 0.001)); }
      

      // 2019.3 holes
      #ifdef _ALPHATEST_ON
          UNITY_DECLARE_TEX2D(_TerrainHolesTexture);

          void ClipHoles(float2 uv)
          {
              float hole = UNITY_SAMPLE_TEX2D(_TerrainHolesTexture, uv).r;
              COUNTSAMPLE
              clip(hole < 0.5f ? -1 : 1);
          }
      #endif

      
      #if _TRIPLANAR
         #if _USEGRADMIP
            #define MIPFORMAT TriGradMipFormat
            #define INITMIPFORMAT (TriGradMipFormat)0;
            #define MIPFROMATRAW float4
         #else
            #define MIPFORMAT float3
            #define INITMIPFORMAT 0;
            #define MIPFROMATRAW float3
         #endif
      #else
         #if _USEGRADMIP
            #define MIPFORMAT float4
            #define INITMIPFORMAT 0;
            #define MIPFROMATRAW float4
         #else
            #define MIPFORMAT float
            #define INITMIPFORMAT 0;
            #define MIPFROMATRAW float
         #endif
      #endif

      float2 RotateUV(float2 uv, float amt)
      {
         uv -=0.5;
         float s = sin ( amt);
         float c = cos ( amt );
         float2x2 mtx = float2x2( c, -s, s, c);
         mtx *= 0.5;
         mtx += 0.5;
         mtx = mtx * 2-1;
         uv = mul ( uv, mtx );
         uv += 0.5;
         return uv;
      }

      float4 DecodeToFloat4(float v)
      {
         uint vi = (uint)(v * (256.0f * 256.0f * 256.0f * 256.0f));
         int ex = (int)(vi / (256 * 256 * 256) % 256);
         int ey = (int)((vi / (256 * 256)) % 256);
         int ez = (int)((vi / (256)) % 256);
         int ew = (int)(vi % 256);
         float4 e = float4(ex / 255.0, ey / 255.0, ez / 255.0, ew / 255.0);
         return e;
      }

      struct Input 
      {
         float2 uv_Control0;
         #if (_MICROMESH && _MESHUV2)
         float2 uv2_Diffuse;
         #endif

         float3 viewDir;
         float3 worldPos;
         float3 worldNormal;
         #if _TERRAINBLENDING
         float4 color : COLOR;
         #endif
         #if _MSRENDERLOOP_SURFACESHADER
         INTERNAL_DATA
         #else
         float3x3 TBN;
         #endif

         #if _MICRODIGGERMESH || _MICROVERTEXMESH
            half4 w0;
            #if !_MAX4TEXTURES
               half4 w1;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES
               half4 w2;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
               half4 w3;
            #endif
            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               half4 w4;
            #endif
            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               half4 w5;
            #endif
            #if (_MAX28TEXTURES || _MAX32TEXTURES) && !_STREAMS && !_LAVA && !_WETNESS && !_PUDDLES
               half4 w6;
            #endif

            #if _STEAMS || _WETNESS || _LAVA || _PUDDLES
               half4 s0;
            #endif

         #endif
      };
      
      struct TriplanarConfig
      {
         float3x3 uv0;
         float3x3 uv1;
         float3x3 uv2;
         float3x3 uv3;
         half3 pN;
         half3 pN0;
         half3 pN1;
         half3 pN2;
         half3 pN3;
         half3 axisSign;
         Input IN;
      };


      struct Config
      {
         float2 uv;
         float3 uv0;
         float3 uv1;
         float3 uv2;
         float3 uv3;

         half4 cluster0;
         half4 cluster1;
         half4 cluster2;
         half4 cluster3;

      };


      struct MicroSplatLayer
      {
         half3 Albedo;
         half3 Normal;
         half Smoothness;
         half Occlusion;
         half Metallic;
         half Height;
         half3 Emission;
         #if _USESPECULARWORKFLOW
         half3 Specular;
         #endif
         half Alpha;
         
      };


      struct appdata 
      {
         float4 vertex : POSITION;
         float4 tangent : TANGENT;
         float3 normal : NORMAL;
         float2 texcoord : TEXCOORD0;
         float4 texcoord1 : TEXCOORD1;
         float4 texcoord2 : TEXCOORD2;
         #if _TERRAINBLENDING || _MICRODIGGERMESH || _MICROVERTEXMESH
         half4 color : COLOR;
         #endif
         UNITY_VERTEX_INPUT_INSTANCE_ID
         UNITY_VERTEX_OUTPUT_STEREO
      };


      // raw, unblended samples from arrays
      struct RawSamples
      {
         half4 albedo0;
         half4 albedo1;
         half4 albedo2;
         half4 albedo3;
         half4 normSAO0;
         half4 normSAO1;
         half4 normSAO2;
         half4 normSAO3;
         #if _USEEMISSIVEMETAL || _GLOBALEMIS || _GLOBALSMOOTHAOMETAL || _PERTEXSSS
            half4 emisMetal0;
            half4 emisMetal1;
            half4 emisMetal2;
            half4 emisMetal3;
         #endif
         #if _USESPECULARWORKFLOW
            half3 specular0;
            half3 specular1;
            half3 specular2;
            half3 specular3;
         #endif
      };

      void InitRawSamples(inout RawSamples s)
      {
         s.normSAO0 = half4(0,0,0,1);
         s.normSAO1 = half4(0,0,0,1);
         s.normSAO2 = half4(0,0,0,1);
         s.normSAO3 = half4(0,0,0,1);
      }

       float3 GetGlobalLightDir(Input i)
      {
         float3 lightDir = float3(1,0,0);

         #if _MSRENDERLOOP_UNITYHD || PASS_DEFERRED
            lightDir = normalize(_gGlitterLightDir.xyz);
         #elif _MSRENDERLOOP_UNITYLD
            lightDir = GetMainLight().direction;
         #else
            #ifndef USING_DIRECTIONAL_LIGHT
               lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
            #else
               lightDir = normalize(_WorldSpaceLightPos0.xyz);
            #endif
         #endif
         return lightDir;
      }

      float3 GetGlobalLightDirTS(Input i)
      {
         float3 lightDirWS = GetGlobalLightDir(i);
        
         #if _MSRENDERLOOP_UNITYHD || _MSRENDERLOOP_UNITYLD
            return mul( i.TBN, lightDirWS).xyz;
         #else
            float3 t2w0 = WorldNormalVector(i, float3(1,0,0));
            float3 t2w1 = WorldNormalVector(i, float3(0,1,0));
            float3 t2w2 = WorldNormalVector(i, float3(0,0,1));
            float3x3 t2w = float3x3(t2w0, t2w1, t2w2);
            return mul( t2w, lightDirWS).xyz;
         #endif
      }
      
      half3 GetGlobalLightColor()
      {
         #if _MSRENDERLOOP_UNITYHD || PASS_DEFERRED
            return _gGlitterLightColor;
         #elif _MSRENDERLOOP_UNITYLD
            return normalize(GetMainLight().color);
         #else
            return _LightColor0.rgb;
         #endif
      }



      half3 FuzzyShade(half3 color, half3 normal, half coreMult, half edgeMult, half power, float3 viewDir)
      {
         half dt = saturate(dot(viewDir, normal));
         half dark = 1.0 - (coreMult * dt);
         half edge = pow(1-dt, power) * edgeMult;
         return color * (dark + edge);
      }

      half3 ComputeSSS(Input i, float3 V, float3 N, half3 tint, half thickness, half distortion, half scale, half power)
      {
         float3 L = GetGlobalLightDir(i);
         half3 lightColor = GetGlobalLightColor();
         float3 H = normalize(L + N * distortion);
         float VdotH = pow(saturate(dot(V, -H)), power) * scale;
         float3 I =  (VdotH) * thickness;
         return lightColor * I * tint;
      }


      #if _MAX2LAYER
         inline half BlendWeights(half s1, half s2, half s3, half s4, half4 w)      { return s1 * w.x + s2 * w.y; }
         inline half2 BlendWeights(half2 s1, half2 s2, half2 s3, half2 s4, half4 w) { return s1 * w.x + s2 * w.y; }
         inline half3 BlendWeights(half3 s1, half3 s2, half3 s3, half3 s4, half4 w) { return s1 * w.x + s2 * w.y; }
         inline half4 BlendWeights(half4 s1, half4 s2, half4 s3, half4 s4, half4 w) { return s1 * w.x + s2 * w.y; }
      #elif _MAX3LAYER
         inline half BlendWeights(half s1, half s2, half s3, half s4, half4 w)      { return s1 * w.x + s2 * w.y + s3 * w.z; }
         inline half2 BlendWeights(half2 s1, half2 s2, half2 s3, half2 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z; }
         inline half3 BlendWeights(half3 s1, half3 s2, half3 s3, half3 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z; }
         inline half4 BlendWeights(half4 s1, half4 s2, half4 s3, half4 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z; }
      #else
         inline half BlendWeights(half s1, half s2, half s3, half s4, half4 w)      { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
         inline half2 BlendWeights(half2 s1, half2 s2, half2 s3, half2 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
         inline half3 BlendWeights(half3 s1, half3 s2, half3 s3, half3 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
         inline half4 BlendWeights(half4 s1, half4 s2, half4 s3, half4 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
      #endif

      #if _MAX3LAYER
         #define SAMPLE_PER_TEX(varName, pixel, config, defVal) \
            half4 varName##0 = defVal; \
            half4 varName##1 = defVal; \
            half4 varName##2 = defVal; \
            half4 varName##3 = defVal; \
            varName##0 = tex2Dlod(_PerTexProps, float4(config.uv0.z/32, pixel/32, 0, 0)); \
            varName##1 = tex2Dlod(_PerTexProps, float4(config.uv1.z/32, pixel/32, 0, 0)); \
            varName##2 = tex2Dlod(_PerTexProps, float4(config.uv2.z/32, pixel/32, 0, 0)); \

      #elif _MAX2LAYER
         #define SAMPLE_PER_TEX(varName, pixel, config, defVal) \
            half4 varName##0 = defVal; \
            half4 varName##1 = defVal; \
            half4 varName##2 = defVal; \
            half4 varName##3 = defVal; \
            varName##0 = tex2Dlod(_PerTexProps, float4(config.uv0.z/32, pixel/32, 0, 0)); \
            varName##1 = tex2Dlod(_PerTexProps, float4(config.uv1.z/32, pixel/32, 0, 0)); \

      #else
         #define SAMPLE_PER_TEX(varName, pixel, config, defVal) \
            half4 varName##0 = tex2Dlod(_PerTexProps, float4(config.uv0.z/32, pixel/32, 0, 0)); \
            half4 varName##1 = tex2Dlod(_PerTexProps, float4(config.uv1.z/32, pixel/32, 0, 0)); \
            half4 varName##2 = tex2Dlod(_PerTexProps, float4(config.uv2.z/32, pixel/32, 0, 0)); \
            half4 varName##3 = tex2Dlod(_PerTexProps, float4(config.uv3.z/32, pixel/32, 0, 0)); \

      #endif
      
      half3 BlendNormal3(half3 n1, half3 n2)
      {
         n1.z += 1;
         n2.xy = -n2.xy;

         return n1 * dot(n1, n2) / n1.z - n2;
      }
      
      half2 TransformTriplanarNormal(Input IN, float3x3 t2w, half3 axisSign, half3 absVertNormal,
               half3 pN, half2 a0, half2 a1, half2 a2)
      {
         a0 = a0 * 2 - 1;
         a1 = a1 * 2 - 1;
         a2 = a2 * 2 - 1;
         
         a0.x *= axisSign.x;
         a1.x *= axisSign.y;
         a2.x *= axisSign.z;
         
         half3 n0 = half3(a0.xy, 1);
         half3 n1 = half3(a1.xy, 1);
         half3 n2 = half3(a2.xy, 1);
         
         n0 = BlendNormal3(half3(IN.worldNormal.zy, absVertNormal.x), n0);
         n1 = BlendNormal3(half3(IN.worldNormal.xz, absVertNormal.y), n1);
         n2 = BlendNormal3(half3(IN.worldNormal.xy, absVertNormal.z), n2);
  
         n0.z *= axisSign.x;
         n1.z *= axisSign.y;
         n2.z *= -axisSign.z;
  
         half3 worldNormal = (n0.zyx * pN.x + n1.xzy * pN.y + n2.xyz * pN.z );
         return mul(t2w, worldNormal).xy;
      }
      
      // funcs
      
      inline half MSLuminance(half3 rgb)
      {
         #ifdef UNITY_COLORSPACE_GAMMA
            return dot(rgb, half3(0.22, 0.707, 0.071));
         #else
            return dot(rgb, half3(0.0396819152, 0.458021790, 0.00609653955));
         #endif
      }
      
      
      float2 Hash2D( float2 x )
      {
          float2 k = float2( 0.3183099, 0.3678794 );
          x = x*k + k.yx;
          return -1.0 + 2.0*frac( 16.0 * k*frac( x.x*x.y*(x.x+x.y)) );
      }

      float Noise2D(float2 p )
      {
         float2 i = floor( p );
         float2 f = frac( p );
         
         float2 u = f*f*(3.0-2.0*f);

         return lerp( lerp( dot( Hash2D( i + float2(0.0,0.0) ), f - float2(0.0,0.0) ), 
                           dot( Hash2D( i + float2(1.0,0.0) ), f - float2(1.0,0.0) ), u.x),
                      lerp( dot( Hash2D( i + float2(0.0,1.0) ), f - float2(0.0,1.0) ), 
                           dot( Hash2D( i + float2(1.0,1.0) ), f - float2(1.0,1.0) ), u.x), u.y);
      }
      
      float FBM2D(float2 uv)
      {
         float f = 0.5000*Noise2D( uv ); uv *= 2.01;
         f += 0.2500*Noise2D( uv ); uv *= 1.96;
         f += 0.1250*Noise2D( uv ); 
         return f;
      }
      
      float3 Hash3D( float3 p )
      {
         p = float3( dot(p,float3(127.1,311.7, 74.7)),
                 dot(p,float3(269.5,183.3,246.1)),
                 dot(p,float3(113.5,271.9,124.6)));

         return -1.0 + 2.0*frac(sin(p)*437.5453123);
      }

      float Noise3D( float3 p )
      {
         float3 i = floor( p );
         float3 f = frac( p );
         
         float3 u = f*f*(3.0-2.0*f);

         return lerp( lerp( lerp( dot( Hash3D( i + float3(0.0,0.0,0.0) ), f - float3(0.0,0.0,0.0) ), 
                                dot( Hash3D( i + float3(1.0,0.0,0.0) ), f - float3(1.0,0.0,0.0) ), u.x),
                           lerp( dot( Hash3D( i + float3(0.0,1.0,0.0) ), f - float3(0.0,1.0,0.0) ), 
                                dot( Hash3D( i + float3(1.0,1.0,0.0) ), f - float3(1.0,1.0,0.0) ), u.x), u.y),
                      lerp( lerp( dot( Hash3D( i + float3(0.0,0.0,1.0) ), f - float3(0.0,0.0,1.0) ), 
                                dot( Hash3D( i + float3(1.0,0.0,1.0) ), f - float3(1.0,0.0,1.0) ), u.x),
                           lerp( dot( Hash3D( i + float3(0.0,1.0,1.0) ), f - float3(0.0,1.0,1.0) ), 
                                dot( Hash3D( i + float3(1.0,1.0,1.0) ), f - float3(1.0,1.0,1.0) ), u.x), u.y), u.z );
      }
      
      float FBM3D(float3 uv)
      {
         float f = 0.5000*Noise3D( uv ); uv *= 2.01;
         f += 0.2500*Noise3D( uv ); uv *= 1.96;
         f += 0.1250*Noise3D( uv ); 
         return f;
      }
      
      half2 BlendNormal2(half2 base, half2 blend) { return normalize(half3(base.xy + blend.xy, 1)).xy; } 
      half3 BlendOverlay(half3 base, half3 blend) { return (base < 0.5 ? (2.0 * base * blend) : (1.0 - 2.0 * (1.0 - base) * (1.0 - blend))); }
      half3 BlendMult2X(half3  base, half3 blend) { return (base * (blend * 2)); }
      half3 BlendLighterColor(half3 s, half3 d) { return (s.x + s.y + s.z > d.x + d.y + d.z) ? s : d; } 
      
      float GetSaturation(float3 c)
      {
         float mi = min(min(c.x, c.y), c.z);
         float ma = max(max(c.x, c.y), c.z);
         return (ma - mi)/(ma + 1e-7);
      }

      // Better Color Lerp, does not have darkening issue
      float3 BetterColorLerp(float3 a, float3 b, float x)
      {
         float3 ic = lerp(a, b, x) + float3(1e-6,0.0,0.0);
         float sd = abs(GetSaturation(ic) - lerp(GetSaturation(a), GetSaturation(b), x));
    
         float3 dir = normalize(float3(2.0 * ic.x - ic.y - ic.z, 2.0 * ic.y - ic.x - ic.z, 2.0 * ic.z - ic.y - ic.x));
         float lgt = dot(float3(1.0, 1.0, 1.0), ic);
    
         float ff = dot(dir, normalize(ic));
    
         const float dsp_str = 1.5;
         ic += dsp_str * dir * sd * ff * lgt;
         return saturate(ic);
      }
      
      
      half4 ComputeWeights(half4 iWeights, half h0, half h1, half h2, half h3, half contrast)
      {
          #if _DISABLEHEIGHTBLENDING
             return iWeights;
          #else
             // compute weight with height map
             //half4 weights = half4(iWeights.x * h0, iWeights.y * h1, iWeights.z * h2, iWeights.w * h3);
             half4 weights = half4(iWeights.x * max(h0,0.001), iWeights.y * max(h1,0.001), iWeights.z * max(h2,0.001), iWeights.w * max(h3,0.001));
             
             // Contrast weights
             half maxWeight = max(max(weights.x, max(weights.y, weights.z)), weights.w);
             half transition = max(contrast * maxWeight, 0.0001);
             half threshold = maxWeight - transition;
             half scale = 1.0 / transition;
             weights = saturate((weights - threshold) * scale);
             // Normalize weights.
             half weightScale = 1.0f / (weights.x + weights.y + weights.z + weights.w);
             weights *= weightScale;
             return weights;
          #endif
      }

      half HeightBlend(half h1, half h2, half slope, half contrast)
      {
         #if _DISABLEHEIGHTBLENDING
            return slope;
         #else
            h2 = 1 - h2;
            half tween = saturate((slope - min(h1, h2)) / max(abs(h1 - h2), 0.001)); 
            half blend = saturate( ( tween - (1-contrast) ) / max(contrast, 0.001));
            return blend;
         #endif
      }

      #if _MAX4TEXTURES
         #define TEXCOUNT 4
      #elif _MAX8TEXTURES
         #define TEXCOUNT 8
      #elif _MAX12TEXTURES
         #define TEXCOUNT 12
      #elif _MAX20TEXTURES
         #define TEXCOUNT 20
      #elif _MAX24TEXTURES
         #define TEXCOUNT 24
      #elif _MAX28TEXTURES
         #define TEXCOUNT 28
      #elif _MAX32TEXTURES
         #define TEXCOUNT 32
      #else
         #define TEXCOUNT 16
      #endif


      void Setup(out half4 weights, float2 uv, out Config config, half4 w0, half4 w1, half4 w2, half4 w3, half4 w4, half4 w5, half4 w6, half4 w7, float3 worldPos)
      {
         config = (Config)0;
         half4 indexes = 0;

         config.uv = uv;

         #if _WORLDUV
         uv = worldPos.xz;
         #endif

         #if _DISABLESPLATMAPS
            float2 scaledUV = uv;
         #else
            float2 scaledUV = uv * _UVScale.xy + _UVScale.zw;
         #endif

         // if only 4 textures, and blending 4 textures, skip this whole thing..
         // this saves about 25% of the ALU of the base shader on low end. However if
         // we rely on sorted texture weights (distance resampling) we have to sort..
         float4 defaultIndexes = float4(0,1,2,3);
         #if _MESHSUBARRAY
            defaultIndexes = _MeshSubArrayIndexes;
         #endif

         #if _MESHSUBARRAY || (_MAX4TEXTURES && !_MAX3LAYER && !_MAX2LAYER && !_DISTANCERESAMPLE && !_POM)
            weights = w0;
            config.uv0 = float3(scaledUV, defaultIndexes.x);
            config.uv1 = float3(scaledUV, defaultIndexes.y);
            config.uv2 = float3(scaledUV, defaultIndexes.z);
            config.uv3 = float3(scaledUV, defaultIndexes.w);
            return;
         #endif

         #if _DISABLESPLATMAPS
            weights = float4(1,0,0,0);
            return;
         #else
            half splats[TEXCOUNT];

            splats[0] = w0.x;
            splats[1] = w0.y;
            splats[2] = w0.z;
            splats[3] = w0.w;
            #if !_MAX4TEXTURES
               splats[4] = w1.x;
               splats[5] = w1.y;
               splats[6] = w1.z;
               splats[7] = w1.w;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES
               splats[8] = w2.x;
               splats[9] = w2.y;
               splats[10] = w2.z;
               splats[11] = w2.w;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
               splats[12] = w3.x;
               splats[13] = w3.y;
               splats[14] = w3.z;
               splats[15] = w3.w;
            #endif
            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               splats[16] = w4.x;
               splats[17] = w4.y;
               splats[18] = w4.z;
               splats[19] = w4.w;
            #endif
            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               splats[20] = w5.x;
               splats[21] = w5.y;
               splats[22] = w5.z;
               splats[23] = w5.w;
            #endif
            #if _MAX28TEXTURES || _MAX32TEXTURES
               splats[24] = w6.x;
               splats[25] = w6.y;
               splats[26] = w6.z;
               splats[27] = w6.w;
            #endif
            #if _MAX32TEXTURES
               splats[28] = w7.x;
               splats[29] = w7.y;
               splats[30] = w7.z;
               splats[31] = w7.w;
            #endif



            weights[0] = 0;
            weights[1] = 0;
            weights[2] = 0;
            weights[3] = 0;
            indexes[0] = 0;
            indexes[1] = 0;
            indexes[2] = 0;
            indexes[3] = 0;

            int i = 0;
            for (i = 0; i < TEXCOUNT; ++i)
            {
               half w = splats[i];
               if (w >= weights[0])
               {
                  weights[3] = weights[2];
                  indexes[3] = indexes[2];
                  weights[2] = weights[1];
                  indexes[2] = indexes[1];
                  weights[1] = weights[0];
                  indexes[1] = indexes[0];
                  weights[0] = w;
                  indexes[0] = i;
               }
               else if (w >= weights[1])
               {
                  weights[3] = weights[2];
                  indexes[3] = indexes[2];
                  weights[2] = weights[1];
                  indexes[2] = indexes[1];
                  weights[1] = w;
                  indexes[1] = i;
               }
               else if (w >= weights[2])
               {
                  weights[3] = weights[2];
                  indexes[3] = indexes[2];
                  weights[2] = w;
                  indexes[2] = i;
               }
               else if (w >= weights[3])
               {
                  weights[3] = w;
                  indexes[3] = i;
               }
            }

            // clamp and renormalize
            #if _MAX2LAYER
            weights.zw = 0;
            weights.xy *= (1.0 / (weights.x + weights.y));
            #elif _MAX3LAYER
            weights.w = 0;
            weights.xyz *= (1.0 / (weights.x + weights.y + weights.z));
            #elif !_DISABLEHEIGHTBLENDING || _NORMALIZEWEIGHTS // prevents black when painting, which the unity shader does not prevent.
            weights = normalize(weights);
            #endif

            config.uv0 = float3(scaledUV, indexes.x);
            config.uv1 = float3(scaledUV, indexes.y);
            config.uv2 = float3(scaledUV, indexes.z);
            config.uv3 = float3(scaledUV, indexes.w);


         #endif //_DISABLESPLATMAPS


      }
      
      float ComputeMipLevel(float2 uv, float2 textureSize)
      {
         uv *= textureSize;
         float2  dx_vtc        = ddx(uv);
         float2  dy_vtc        = ddy(uv);
         float delta_max_sqr   = max(dot(dx_vtc, dx_vtc), dot(dy_vtc, dy_vtc));
         return 0.5 * log2(delta_max_sqr);
      }

      inline half2 UnpackNormal2(half4 packednormal)
      {
          return packednormal.wy * 2 - 1;
         
      }

      half3 TriplanarHBlend(half h0, half h1, half h2, half3 pN, half contrast)
      {
         half3 blend = pN / dot(pN, half3(1,1,1));
         float3 heights = float3(h0, h1, h2) + (blend * 3.0);
         half height_start = max(max(heights.x, heights.y), heights.z) - contrast;
         half3 h = max(heights - height_start.xxx, half3(0,0,0));
         blend = h / dot(h, half3(1,1,1));
         return blend;
      }
      

      void ClearAllButAlbedo(inout MicroSplatLayer o, half3 display)
      {
         o.Albedo = display.rgb;
         o.Normal = half3(0, 0, 1);
         o.Smoothness = 0;
         o.Occlusion = 1;
         o.Emission = 0;
         o.Metallic = 0;
         o.Height = 0;
         #if _USESPECULARWORKFLOW
         o.Specular = 0;
         #endif

      }

      void ClearAllButAlbedo(inout MicroSplatLayer o, half display)
      {
         o.Albedo = half3(display, display, display);
         o.Normal = half3(0, 0, 1);
         o.Smoothness = 0;
         o.Occlusion = 1;
         o.Emission = 0;
         o.Metallic = 0;
         o.Height = 0;
         #if _USESPECULARWORKFLOW
         o.Specular = 0;
         #endif

      }

     

      half MicroShadow(float3 lightDir, half3 normal, half ao, half strength)
      {
         half shadow = saturate(abs(dot(normal, lightDir)) + (ao * ao * 2.0) - 1.0);
         return 1 - ((1-shadow) * strength);
      }
      

      void DoDebugOutput(inout MicroSplatLayer l)
      {
         #if _DEBUG_OUTPUT_ALBEDO
            ClearAllButAlbedo(l, l.Albedo);
         #elif _DEBUG_OUTPUT_NORMAL
            // oh unit shader compiler normal stripping, how I hate you so..
            // must multiply by albedo to stop the normal from being white. Why, fuck knows?
            ClearAllButAlbedo(l, float3(l.Normal.xy * 0.5 + 0.5, l.Normal.z * saturate(l.Albedo.z+1)));
         #elif _DEBUG_OUTPUT_SMOOTHNESS
            ClearAllButAlbedo(l, l.Smoothness.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_METAL
            ClearAllButAlbedo(l, l.Metallic.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_AO
            ClearAllButAlbedo(l, l.Occlusion.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_EMISSION
            ClearAllButAlbedo(l, l.Emission * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_HEIGHT
            ClearAllButAlbedo(l, l.Height.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_SPECULAR && _USESPECULARWORKFLOW
            ClearAllButAlbedo(l, l.Specular * saturate(l.Albedo.z+1));
         #elif _DEBUG_BRANCHCOUNT_WEIGHT
            ClearAllButAlbedo(l, _branchWeightCount / 12 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_TRIPLANAR
            ClearAllButAlbedo(l, _branchTriplanarCount / 24 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_CLUSTER
            ClearAllButAlbedo(l, _branchClusterCount / 12 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_OTHER
            ClearAllButAlbedo(l, _branchOtherCount / 8 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_TOTAL
            l.Albedo.r = _branchWeightCount / 12;
            l.Albedo.g = _branchTriplanarCount / 24;
            l.Albedo.b = _branchClusterCount / 12;
            ClearAllButAlbedo(l, (l.Albedo.r + l.Albedo.g + l.Albedo.b + (_branchOtherCount / 8)) / 4); 
         #elif _DEBUG_OUTPUT_MICROSHADOWS
            ClearAllButAlbedo(l,l.Albedo); 
         #elif _DEBUG_SAMPLECOUNT
            float sdisp = (float)_sampleCount / max(_SampleCountDiv, 1);
            half3 sdcolor = float3(sdisp, sdisp > 1 ? 1 : 0, 0);
            ClearAllButAlbedo(l, sdcolor * saturate(l.Albedo.z + 1));
         #elif _DEBUG_PROCLAYERS
            ClearAllButAlbedo(l, (float)_procLayerCount / (float)_PCLayerCount * saturate(l.Albedo.z + 1));
         #endif
      }


      // man I wish unity would wrap everything instead of only what they use. Just seems like a landmine for
      // people like myself.. especially as they keep changing things around and I have to figure out all the new defines
      // and handle changes across Unity versions, which would be automatically handled if they just wrapped these themselves without
      // as much complexity..

      #if (UNITY_VERSION >= 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (SHADER_TARGET_SURFACE_ANALYSIS && !SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))) || (UNITY_VERSION < 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL))) 
           #define MICROSPLAT_SAMPLE_TEX2D_LOD(tex,coord, lod) tex.SampleLevel (sampler##tex,coord, lod)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(tex,samplertex,coord, lod) tex.SampleLevel (sampler##samplertex,coord, lod)
        #else
           #define MICROSPLAT_SAMPLE_TEX2D_LOD(tex,coord,lod) tex2D (tex,coord,0,lod)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(tex,samplertex,coord,lod) tex2D (tex,coord,0,lod)
        #endif
     


        #if (UNITY_VERSION >= 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (SHADER_TARGET_SURFACE_ANALYSIS && !SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))) || (UNITY_VERSION < 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL))) 
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) tex.SampleGrad (sampler##tex,coord,dx,dy)
        #elif defined(SHADER_API_D3D9)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(0,1,0,0) 
        #elif defined(UNITY_COMPILER_HLSL2GLSL) || defined(SHADER_TARGET_SURFACE_ANALYSIS)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) texCUBEgrad (tex,coord,float3(dx.x,dx.y,0),float3(dy.x,dy.y,0))
        #elif defined(SHADER_API_GLES)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(1,1,0,0)
        #elif defined(SHADER_API_D3D11_9X)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(0,1,1,0) 
        #else
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(0,0,1,0) 
        #endif
        
        #if (UNITY_VERSION >= 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (SHADER_TARGET_SURFACE_ANALYSIS && !SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))) || (UNITY_VERSION < 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL))) 
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) tex.SampleGrad (sampler##samp,coord,dx,dy)
        #elif defined(SHADER_API_D3D9)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(0,1,0,0) 
        #elif defined(UNITY_COMPILER_HLSL2GLSL) || defined(SHADER_TARGET_SURFACE_ANALYSIS)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(1,0,1,0)
        #elif defined(SHADER_API_GLES)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(1,1,0,0)
        #elif defined(SHADER_API_D3D11_9X)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(0,1,1,0) 
        #else
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(0,0,1,0) 
        #endif
      

      #if _USELODMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY_LOD(tex, u, l.x)
      #elif _USEGRADMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex, u, l.xy, l.zw)
      #else
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY(tex, u)
      #endif

      #if _USELODMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY_LOD(tex, u, l.x)
      #elif _USEGRADMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex, u, l.xy, l.zw)
      #else
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY(tex, u)
      #endif


      #define MICROSPLAT_SAMPLE_DIFFUSE(u, cl, l) MICROSPLAT_SAMPLE(_Diffuse, u, l)
      #define MICROSPLAT_SAMPLE_EMIS(u, cl, l) MICROSPLAT_SAMPLE(_EmissiveMetal, u, l)
      #define MICROSPLAT_SAMPLE_DIFFUSE_LOD(u, cl, l) UNITY_SAMPLE_TEX2DARRAY_LOD(_Diffuse, u, l)
      

      #if _PACKINGHQ
         #define MICROSPLAT_SAMPLE_NORMAL(u, cl, l) half4(MICROSPLAT_SAMPLE(_NormalSAO, u, l).ga, MICROSPLAT_SAMPLE(_SmoothAO, u, l).ga).brag
      #else
         #define MICROSPLAT_SAMPLE_NORMAL(u, cl, l) MICROSPLAT_SAMPLE(_NormalSAO, u, l)
      #endif

      #if _USESPECULARWORKFLOW
         #define MICROSPLAT_SAMPLE_SPECULAR(u, cl, l) MICROSPLAT_SAMPLE(_Specular, u, l)
      #endif
      




                    
      #undef MICROSPLAT_SAMPLE_TEX2D_LOD
      #undef MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD
      #undef MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD
      #undef MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD

      #define MICROSPLAT_SAMPLE_TEX2D_LOD(tex,coord,lod)                    SAMPLE_TEXTURE2D_LOD(tex,sampler_##tex, coord, lod)
      #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy)                 SAMPLE_TEXTURE2D_GRAD(tex,sampler_##tex,coord,dx,dy)
      #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy)    SAMPLE_TEXTURE2D_GRAD(tex,sampler_##samp,coord,dx,dy)
      #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(tex, samp, coord, lod)    SAMPLE_TEXTURE2D_LOD(tex, sampler_##samp, coord, lod)

      inline half3 UnpackNormal(half4 packednormal)
      {
         half3 normal;
         normal.xy = packednormal.wy * 2 - 1;
         normal.z = sqrt(1 - normal.x*normal.x - normal.y * normal.y);
         return normal;
      }
      

      #undef WorldNormalVector
      #define WorldNormalVector(data, normal) mul(data.TBN, normal)





      #define UnityObjectToWorldNormal(normal) mul(GetObjectToWorldMatrix(), normal)
      
      


      Input DescToInput(SurfaceDescriptionInputs IN)
      {
        Input s = (Input)0;
        s.TBN = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        s.worldNormal = IN.WorldSpaceNormal;
        #if !_SRPTERRAINBLEND
           s.worldPos = GetAbsolutePositionWS(IN.WorldSpacePosition);
        #else
           s.worldPos = IN.WorldSpacePosition;
        #endif
        s.viewDir = IN.TangentSpaceViewDirection;
        s.uv_Control0 = IN.uv0.xy;
        

        #if _MICROMESH && _MESHUV2
            s.uv_Diffuse = IN.uv.xy1;
        #endif

        #if _SRPTERRAINBLEND
            s.color = IN.VertexColor;
        #endif
        return s;
     }

     #define TESSELLATION_INTERPOLATE_BARY(name, bary) output.name = input0.name * bary.x +  input1.name * bary.y +  input2.name * bary.z
     

     // Stochastic shared code

// Compute local triangle barycentric coordinates and vertex IDs
void TriangleGrid(float2 uv, float scale,
   out float w1, out float w2, out float w3,
   out int2 vertex1, out int2 vertex2, out int2 vertex3)
{
   // Scaling of the input
   uv *= 3.464 * scale; // 2 * sqrt(3)

   // Skew input space into simplex triangle grid
   const float2x2 gridToSkewedGrid = float2x2(1.0, 0.0, -0.57735027, 1.15470054);
   float2 skewedCoord = mul(gridToSkewedGrid, uv);

   // Compute local triangle vertex IDs and local barycentric coordinates
   int2 baseId = int2(floor(skewedCoord));
   float3 temp = float3(frac(skewedCoord), 0);
   temp.z = 1.0 - temp.x - temp.y;
   if (temp.z > 0.0)
   {
      w1 = temp.z;
      w2 = temp.y;
      w3 = temp.x;
      vertex1 = baseId;
      vertex2 = baseId + int2(0, 1);
      vertex3 = baseId + int2(1, 0);
   }
   else
   {
      w1 = -temp.z;
      w2 = 1.0 - temp.y;
      w3 = 1.0 - temp.x;
      vertex1 = baseId + int2(1, 1);
      vertex2 = baseId + int2(1, 0);
      vertex3 = baseId + int2(0, 1);
   }
}

// Fast random hash function
float2 SimpleHash2(float2 p)
{
   return frac(sin(mul(float2x2(127.1, 311.7, 269.5, 183.3), p)) * 43758.5453);
}


half3 BaryWeightBlend(half3 iWeights, half tex0, half tex1, half tex2, half contrast)
{
    // compute weight with height map
    const half epsilon = 1.0f / 1024.0f;
    half3 weights = half3(iWeights.x * (tex0 + epsilon), 
                             iWeights.y * (tex1 + epsilon),
                             iWeights.z * (tex2 + epsilon));

    // Contrast weights
    half maxWeight = max(weights.x, max(weights.y, weights.z));
    half transition = contrast * maxWeight;
    half threshold = maxWeight - transition;
    half scale = 1.0f / transition;
    weights = saturate((weights - threshold) * scale);
    // Normalize weights.
    half weightScale = 1.0f / (weights.x + weights.y + weights.z);
    weights *= weightScale;
    return weights;
}

void PrepareStochasticUVs(float scale, float3 uv, out float3 uv1, out float3 uv2, out float3 uv3, out half3 weights)
{
   // Get triangle info
   float w1, w2, w3;
   int2 vertex1, vertex2, vertex3;
   TriangleGrid(uv.xy, scale, w1, w2, w3, vertex1, vertex2, vertex3);

   // Assign random offset to each triangle vertex
   uv1 = uv;
   uv2 = uv;
   uv3 = uv;
   
   uv1.xy += SimpleHash2(vertex1);
   uv2.xy += SimpleHash2(vertex2);
   uv3.xy += SimpleHash2(vertex3);
   weights = half3(w1, w2, w3);
   
}

void PrepareStochasticUVs(float scale, float2 uv, out float2 uv1, out float2 uv2, out float2 uv3, out half3 weights)
{
   // Get triangle info
   float w1, w2, w3;
   int2 vertex1, vertex2, vertex3;
   TriangleGrid(uv, scale, w1, w2, w3, vertex1, vertex2, vertex3);

   // Assign random offset to each triangle vertex
   uv1 = uv;
   uv2 = uv;
   uv3 = uv;
   
   uv1.xy += SimpleHash2(vertex1);
   uv2.xy += SimpleHash2(vertex2);
   uv3.xy += SimpleHash2(vertex3);
   weights = half3(w1, w2, w3);
   
}


      #if _ALPHAHOLETEXTURE
         sampler2D _AlphaHoleTexture;   // must declare with a sampler or windows throws an error, which seems like a compiler bug
      #endif



      void ClipWaterLevel(float3 worldPos)
      {
         clip(worldPos.y - _AlphaData.y);
      }

      void ClipAlphaHole(inout Config c, inout half4 weights)
      {
      #if _ALPHAHOLETEXTURE
         clip(tex2D(_AlphaHoleTexture, c.uv).r - 0.5);
      #else
         if ((int)round(c.uv0.z ) == (int)round(_AlphaData.x))
         {
            clip(-1);
         }
         else if ((int)round(c.uv1.z ) == (int)round(_AlphaData.x) && weights.y > 0)
         {
            weights.y = 0;
            weights = normalize(weights);
         }
         else if ((int)round(c.uv2.z ) == (int)round(_AlphaData.x) && weights.z > 0)
         {
            weights.z = 0;
            weights = normalize(weights);
         }
         else if ((int)round(c.uv3.z ) == (int)round(_AlphaData.x) && weights.w > 0)
         {
            weights.w = 0;
            weights = normalize(weights);
         }
         
      #endif
      }





     
    




   

                    



      void SampleAlbedo(inout Config config, inout TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
         return;
         #endif
         #if _TRIPLANAR
            #if _USEGRADMIP
               float4 d0 = mipLevel.d0;
               float4 d1 = mipLevel.d1;
               float4 d2 = mipLevel.d2;
            #elif _USELODMIP
               float d0 = mipLevel.x;
               float d1 = mipLevel.y;
               float d2 = mipLevel.z;
            #else
               MIPFORMAT d0 = mipLevel;
               MIPFORMAT d1 = mipLevel;
               MIPFORMAT d2 = mipLevel;
            #endif
         
            half4 contrasts = _Contrast.xxxx;
            #if _PERTEXTRIPLANARCONTRAST
               SAMPLE_PER_TEX(ptc, 5.5, config, half4(1,0.5,0,0));
               contrasts = half4(ptc0.y, ptc1.y, ptc2.y, ptc3.y);
            #endif


            #if _PERTEXTRIPLANAR
               SAMPLE_PER_TEX(pttri, 9.5, config, half4(0,0,0,0));
            #endif

            {
               // For per-texture triplanar, we modify the view based blending factor of the triplanar
               // such that you get a pure blend of either top down projection, or with the top down projection
               // removed and renormalized. This causes dynamic flow control optimizations to kick in and avoid
               // the extra texture samples while keeping the code simple. Yay..

               // We also only have to do this in the Albedo, because the pN values will be adjusted after the
               // albedo is sampled, causing future samples to use this data. 
              
               #if _PERTEXTRIPLANAR
                  if (pttri0.x > 0.66)
                  {
                     tc.pN0 = half3(0,1,0);
                  }
                  else if (pttri0.x > 0.33)
                  {
                     tc.pN0.y = 0;
                     tc.pN0.xz = normalize(tc.pN0.xz);
                  }
               #endif


               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN0.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv0[0], config.cluster0, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN0.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv0[1], config.cluster0, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN0.z)
               {
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv0[2], config.cluster0, d2);
                  COUNTSAMPLE
               }

               half3 bf = tc.pN0;
               #if _TRIPLANARHEIGHTBLEND
                  bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN0, contrasts.x);
                  tc.pN0 = bf;
               #endif

               s.albedo0 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            MSBRANCH(weights.y)
            {
               #if _PERTEXTRIPLANAR
                  if (pttri1.x > 0.66)
                  {
                     tc.pN1 = half3(0,1,0);
                  }
                  else if (pttri1.x > 0.33)
                  {
                     tc.pN1.y = 0;
                     tc.pN1.xz = normalize(tc.pN1.xz);
                  }
               #endif

               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN1.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv1[0], config.cluster1, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv1[1], config.cluster1, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.z)
               {
                  COUNTSAMPLE
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv1[2], config.cluster1, d2);
               }
               half3 bf = tc.pN1;
               #if _TRIPLANARHEIGHTBLEND
                  bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN1, contrasts.x);
                  tc.pN1 = bf;
               #endif


               s.albedo1 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            #if !_MAX2LAYER
            MSBRANCH(weights.z)
            {
               #if _PERTEXTRIPLANAR
                  if (pttri2.x > 0.66)
                  {
                     tc.pN2 = half3(0,1,0);
                  }
                  else if (pttri2.x > 0.33)
                  {
                     tc.pN2.y = 0;
                     tc.pN2.xz = normalize(tc.pN2.xz);
                  }
               #endif

               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN2.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv2[0], config.cluster2, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv2[1], config.cluster2, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.z)
               {
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv2[2], config.cluster2, d2);
                  COUNTSAMPLE
               }

               half3 bf = tc.pN2;
               #if _TRIPLANARHEIGHTBLEND
                  bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN2, contrasts.x);
                  tc.pN2 = bf;
               #endif
               

               s.albedo2 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
            MSBRANCH(weights.w)
            {

               #if _PERTEXTRIPLANAR
                  if (pttri3.x > 0.66)
                  {
                     tc.pN3 = half3(0,1,0);
                  }
                  else if (pttri3.x > 0.33)
                  {
                     tc.pN3.y = 0;
                     tc.pN3.xz = normalize(tc.pN3.xz);
                  }
               #endif

               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN3.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv3[0], config.cluster3, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv3[1], config.cluster3, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.z)
               {
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv3[2], config.cluster3, d2);
                  COUNTSAMPLE
               }

               half3 bf = tc.pN3;
               #if _TRIPLANARHEIGHTBLEND
               bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN3, contrasts.x);
               tc.pN3 = bf;
               #endif

               s.albedo3 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            #endif

         #else
            s.albedo0 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv0, config.cluster0, mipLevel);
            COUNTSAMPLE

            MSBRANCH(weights.y)
            {
               s.albedo1 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv1, config.cluster1, mipLevel);
               COUNTSAMPLE
            }
            #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  s.albedo2 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv2, config.cluster2, mipLevel);
                  COUNTSAMPLE
               } 
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  s.albedo3 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv3, config.cluster3, mipLevel);
                  COUNTSAMPLE
               }
            #endif
         #endif

         #if _PERTEXHEIGHTOFFSET || _PERTEXHEIGHTCONTRAST
            SAMPLE_PER_TEX(ptHeight, 10.5, config, 1);

            #if _PERTEXHEIGHTOFFSET
               s.albedo0.a = saturate(s.albedo0.a + ptHeight0.b - 1);
               s.albedo1.a = saturate(s.albedo1.a + ptHeight1.b - 1);
               s.albedo2.a = saturate(s.albedo2.a + ptHeight2.b - 1);
               s.albedo3.a = saturate(s.albedo3.a + ptHeight3.b - 1);
            #endif
            #if _PERTEXHEIGHTCONTRAST
               s.albedo0.a = saturate(pow(s.albedo0.a + 0.5, abs(ptHeight0.a)) - 0.5);
               s.albedo1.a = saturate(pow(s.albedo1.a + 0.5, abs(ptHeight1.a)) - 0.5);
               s.albedo2.a = saturate(pow(s.albedo2.a + 0.5, abs(ptHeight2.a)) - 0.5);
               s.albedo3.a = saturate(pow(s.albedo3.a + 0.5, abs(ptHeight3.a)) - 0.5);
            #endif
         #endif
      }
      
      
      
      void SampleNormal(Config config, TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
         return;
         #endif

         #if _NONOMALMAP
            s.normSAO0 = half4(0,0, 0, 1);
            s.normSAO1 = half4(0,0, 0, 1);
            s.normSAO2 = half4(0,0, 0, 1);
            s.normSAO3 = half4(0,0, 0, 1);
            return;
         #endif
         
         #if _TRIPLANAR
            #if _USEGRADMIP
               float4 d0 = mipLevel.d0;
               float4 d1 = mipLevel.d1;
               float4 d2 = mipLevel.d2;
            #elif _USELODMIP
               float d0 = mipLevel.x;
               float d1 = mipLevel.y;
               float d2 = mipLevel.z;
            #else
               MIPFORMAT d0 = mipLevel;
               MIPFORMAT d1 = mipLevel;
               MIPFORMAT d2 = mipLevel;
            #endif
            
            half3 absVertNormal = abs(tc.IN.worldNormal);
            float3 t2w0 = WorldNormalVector(tc.IN, float3(1,0,0));
            float3 t2w1 = WorldNormalVector(tc.IN, float3(0,1,0));
            float3 t2w2 = WorldNormalVector(tc.IN, float3(0,0,1));
            float3x3 t2w = float3x3(t2w0, t2w1, t2w2);
            
            
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);
               MSBRANCHTRIPLANAR(tc.pN0.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv0[0], config.cluster0, d0).garb;
                  COUNTSAMPLE
               }            
               MSBRANCHTRIPLANAR(tc.pN0.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv0[1], config.cluster0, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN0.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv0[2], config.cluster0, d2).garb;
                  COUNTSAMPLE
               }
               

               s.normSAO0.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN0, a0.xy, a1.xy, a2.xy);
               s.normSAO0.zw = a0.zw * tc.pN0.x + a1.zw * tc.pN0.y + a2.zw * tc.pN0.z;
            }
            MSBRANCH(weights.y)
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);
               MSBRANCHTRIPLANAR(tc.pN1.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv1[0], config.cluster1, d0).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv1[1], config.cluster1, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv1[2], config.cluster1, d2).garb;
                  COUNTSAMPLE
               }
               

               s.normSAO1.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN1, a0.xy, a1.xy, a2.xy);
               s.normSAO1.zw = a0.zw * tc.pN1.x + a1.zw * tc.pN1.y + a2.zw * tc.pN1.z;
            }
            #if !_MAX2LAYER
            MSBRANCH(weights.z)
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);

               MSBRANCHTRIPLANAR(tc.pN2.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv2[0], config.cluster2, d0).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv2[1], config.cluster2, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv2[2], config.cluster2, d2).garb;
                  COUNTSAMPLE
               }
               

               s.normSAO2.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN2, a0.xy, a1.xy, a2.xy);
               s.normSAO2.zw = a0.zw * tc.pN2.x + a1.zw * tc.pN2.y + a2.zw * tc.pN2.z;
            }
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
            MSBRANCH(weights.w)
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);
               MSBRANCHTRIPLANAR(tc.pN3.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv3[0], config.cluster3, d0).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv3[1], config.cluster3, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv3[2], config.cluster3, d2).garb;
                  COUNTSAMPLE
               }

               s.normSAO3.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN3, a0.xy, a1.xy, a2.xy);
               s.normSAO3.zw = a0.zw * tc.pN3.x + a1.zw * tc.pN3.y + a2.zw * tc.pN3.z;
            }
            #endif

         #else
            s.normSAO0 = MICROSPLAT_SAMPLE_NORMAL(config.uv0, config.cluster0, mipLevel).garb;
            COUNTSAMPLE
            s.normSAO0.xy = s.normSAO0.xy * 2 - 1;
            MSBRANCH(weights.y)
            {
               s.normSAO1 = MICROSPLAT_SAMPLE_NORMAL(config.uv1, config.cluster1, mipLevel).garb;
               COUNTSAMPLE
               s.normSAO1.xy = s.normSAO1.xy * 2 - 1;
            }
            #if !_MAX2LAYER
            MSBRANCH(weights.z)
            {
               s.normSAO2 = MICROSPLAT_SAMPLE_NORMAL(config.uv2, config.cluster2, mipLevel).garb;
               COUNTSAMPLE
               s.normSAO2.xy = s.normSAO2.xy * 2 - 1;
            }
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
            MSBRANCH(weights.w)
            {
               s.normSAO3 = MICROSPLAT_SAMPLE_NORMAL(config.uv3, config.cluster3, mipLevel).garb;
               COUNTSAMPLE
               s.normSAO3.xy = s.normSAO3.xy * 2 - 1;
            }
            #endif
         #endif
      }

      void SampleEmis(Config config, TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
            return;
         #endif
         #if _USEEMISSIVEMETAL
            #if _TRIPLANAR
            
               #if _USEGRADMIP
                  float4 d0 = mipLevel.d0;
                  float4 d1 = mipLevel.d1;
                  float4 d2 = mipLevel.d2;
               #elif _USELODMIP
                  float d0 = mipLevel.x;
                  float d1 = mipLevel.y;
                  float d2 = mipLevel.z;
               #else
                  MIPFORMAT d0 = mipLevel;
                  MIPFORMAT d1 = mipLevel;
                  MIPFORMAT d2 = mipLevel;
               #endif
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN0.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv0[0], config.cluster0, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv0[1], config.cluster0, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv0[2], config.cluster0, d2);
                     COUNTSAMPLE
                  }
                  s.emisMetal0 = a0 * tc.pN0.x + a1 * tc.pN0.y + a2 * tc.pN0.z;
               }
               MSBRANCH(weights.y)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN1.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv1[0], config.cluster1, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv1[1], config.cluster1, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv1[2], config.cluster1, d2);
                     COUNTSAMPLE
                  }

                  s.emisMetal1 = a0 * tc.pN1.x + a1 * tc.pN1.y + a2 * tc.pN1.z;
               }
               #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN2.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv2[0], config.cluster2, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv2[1], config.cluster2, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv2[2], config.cluster2, d2);
                     COUNTSAMPLE
                  }
                  
                  s.emisMetal2 = a0 * tc.pN2.x + a1 * tc.pN2.y + a2 * tc.pN2.z;
               }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN3.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv3[0], config.cluster3, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv3[1], config.cluster3, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv3[2], config.cluster3, d2);
                     COUNTSAMPLE
                  }
                  
                  s.emisMetal3 = a0 * tc.pN3.x + a1 * tc.pN3.y + a2 * tc.pN3.z;
               }
               #endif

            #else
               s.emisMetal0 = MICROSPLAT_SAMPLE_EMIS(config.uv0, config.cluster0, mipLevel);
               COUNTSAMPLE

               MSBRANCH(weights.y)
               {
                  s.emisMetal1 = MICROSPLAT_SAMPLE_EMIS(config.uv1, config.cluster1, mipLevel);
                  COUNTSAMPLE
               }
               #if !_MAX2LAYER
                  MSBRANCH(weights.z)
                  {
                     s.emisMetal2 = MICROSPLAT_SAMPLE_EMIS(config.uv2, config.cluster2, mipLevel);
                     COUNTSAMPLE
                  }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  MSBRANCH(weights.w)
                  {
                     s.emisMetal3 = MICROSPLAT_SAMPLE_EMIS(config.uv3, config.cluster3, mipLevel);
                     COUNTSAMPLE
                  }
               #endif
            #endif
         #endif
      }
      
      void SampleSpecular(Config config, TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
            return;
         #endif
         #if _USESPECULARWORKFLOW
            #if _TRIPLANAR

               #if _USEGRADMIP
                  float4 d0 = mipLevel.d0;
                  float4 d1 = mipLevel.d1;
                  float4 d2 = mipLevel.d2;
               #elif _USELODMIP
                  float d0 = mipLevel.x;
                  float d1 = mipLevel.y;
                  float d2 = mipLevel.z;
               #else
                  MIPFORMAT d0 = mipLevel;
                  MIPFORMAT d1 = mipLevel;
                  MIPFORMAT d2 = mipLevel;
               #endif
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN0.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv0[0], config.cluster0, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv0[1], config.cluster0, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv0[2], config.cluster0, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular0 = a0 * tc.pN0.x + a1 * tc.pN0.y + a2 * tc.pN0.z;
               }
               MSBRANCH(weights.y)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN1.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv1[0], config.cluster1, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv1[1], config.cluster1, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv1[2], config.cluster1, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular1 = a0 * tc.pN1.x + a1 * tc.pN1.y + a2 * tc.pN1.z;
               }
               #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN2.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv2[0], config.cluster2, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv2[1], config.cluster2, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv2[2], config.cluster2, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular2 = a0 * tc.pN2.x + a1 * tc.pN2.y + a2 * tc.pN2.z;
               }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN3.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv3[0], config.cluster3, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv3[1], config.cluster3, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv3[2], config.cluster3, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular3 = a0 * tc.pN3.x + a1 * tc.pN3.y + a2 * tc.pN3.z;
               }
               #endif

            #else
               s.specular0 = MICROSPLAT_SAMPLE_SPECULAR(config.uv0, config.cluster0, mipLevel);
               COUNTSAMPLE

               MSBRANCH(weights.y)
               {
                  s.specular1 = MICROSPLAT_SAMPLE_SPECULAR(config.uv1, config.cluster1, mipLevel);
                  COUNTSAMPLE
               }
               #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  s.specular2 = MICROSPLAT_SAMPLE_SPECULAR(config.uv2, config.cluster2, mipLevel);
                  COUNTSAMPLE
               }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  s.specular3 = MICROSPLAT_SAMPLE_SPECULAR(config.uv3, config.cluster3, mipLevel);
                  COUNTSAMPLE
               }
               #endif
            #endif
         #endif
      }

      MicroSplatLayer Sample(Input i, half4 weights, inout Config config, float camDist, float3 worldNormalVertex)
      {
         MicroSplatLayer o = (MicroSplatLayer)0;
         UNITY_INITIALIZE_OUTPUT(MicroSplatLayer,o);

         RawSamples samples = (RawSamples)0;
         InitRawSamples(samples);

         half4 albedo = 0;
         half4 normSAO = half4(0,0,0,1);
         half4 emisMetal = 0;
         half3 specular = 0;
         
         float worldHeight = i.worldPos.y;
         float3 upVector = float3(0,1,0);

         #if _PLANETVECTORS
            upVector = worldNormalVertex;
            worldHeight = distance(i.worldPos, float3(0,0,0));
         #endif

         #if _GLOBALTINT || _GLOBALNORMALS || _GLOBALSMOOTHAOMETAL || _GLOBALEMIS || _GLOBALSPECULAR
            float globalSlopeFilter = 1;
            #if _GLOBALSLOPEFILTER
               float2 gfilterUV = float2(1 - saturate(dot(worldNormalVertex, upVector) * 0.5 + 0.49), 0.5);
               globalSlopeFilter = UNITY_SAMPLE_TEX2D_SAMPLER(_GlobalSlopeTex, _Diffuse, gfilterUV).a;
            #endif
         #endif

         // declare outside of branchy areas..
         half4 fxLevels = half4(0,0,0,0);
         half burnLevel = 0;
         half wetLevel = 0;
         half3 waterNormalFoam = half3(0, 0, 0);
         half porosity = 0.4;
         float streamFoam = 1.0f;
         half pud = 0;
         half snowCover = 0;
         half SSSThickness = 0;
         half3 SSSTint = half3(1,1,1);
         float traxBuffer = 0;
         float3 traxNormal = 0;
         float2 noiseUV = 0;
         
         

         #if _SPLATFADE
         MSBRANCHOTHER(1 - saturate(camDist - _SplatFade.y))
         {
         #endif

         #if _TRAXSINGLE || _TRAXARRAY || _TRAXNOTEXTURE || _SNOWFOOTSTEPS
            traxBuffer = SampleTraxBuffer(i.worldPos, traxNormal);
         #endif
         
         #if _WETNESS || _PUDDLES || _STREAMS || _LAVA
            #if _MICROMESH
               fxLevels = SampleFXLevels(InverseLerp(_UVMeshRange.xy, _UVMeshRange.zw, config.uv), wetLevel, burnLevel, traxBuffer);
            #elif _MICROVERTEXMESH || _MICRODIGGERMESH 
               fxLevels = ProcessFXLevels(i.s0, traxBuffer);
            #else
               fxLevels = SampleFXLevels(config.uv, wetLevel, burnLevel, traxBuffer);
            #endif
         #endif

         TriplanarConfig tc = (TriplanarConfig)0;
         UNITY_INITIALIZE_OUTPUT(TriplanarConfig,tc);
         

         MIPFORMAT albedoLOD = INITMIPFORMAT
         MIPFORMAT normalLOD = INITMIPFORMAT
         MIPFORMAT emisLOD = INITMIPFORMAT
         MIPFORMAT specLOD = INITMIPFORMAT

         #if _TRIPLANAR && !_DISABLESPLATMAPS
            PrepTriplanar(worldNormalVertex, i.worldPos, config, tc, weights, albedoLOD, normalLOD, emisLOD);
            tc.IN = i;
         #endif
         
         
         #if !_TRIPLANAR && !_DISABLESPLATMAPS
            #if _USELODMIP
               albedoLOD = ComputeMipLevel(config.uv0.xy, _Diffuse_TexelSize.zw);
               normalLOD = ComputeMipLevel(config.uv0.xy, _NormalSAO_TexelSize.zw);
               #if _USEEMISSIVEMETAL
                  emisLOD   = ComputeMipLevel(config.uv0.xy, _EmissiveMetal_TexelSize.zw);
               #endif
               #if _USESPECULARWORKFLOW
                  specLOD = ComputeMipLevel(config.uv0.xy, _Specular_TexelSize.zw);;
               #endif
            #elif _USEGRADMIP
               albedoLOD = float4(ddx(config.uv0.xy), ddy(config.uv0.xy));
               normalLOD = albedoLOD;
               #if _USESPECULARWORKFLOW
                  specLOD = albedoLOD;
               #endif
               #if _USEEMISSIVEMETAL
                  emisLOD = albedoLOD;
               #endif
            #endif
         #endif

         #if _PERTEXCURVEWEIGHT
           SAMPLE_PER_TEX(ptCurveWeight, 19.5, config, half4(0.5,1,1,1));
           weights.x = lerp(smoothstep(0.5 - ptCurveWeight0.r, 0.5 + ptCurveWeight0.r, weights.x), weights.x, ptCurveWeight0.r*2);
           weights.y = lerp(smoothstep(0.5 - ptCurveWeight1.r, 0.5 + ptCurveWeight1.r, weights.y), weights.y, ptCurveWeight1.r*2);
           weights.z = lerp(smoothstep(0.5 - ptCurveWeight2.r, 0.5 + ptCurveWeight2.r, weights.z), weights.z, ptCurveWeight2.r*2);
           weights.w = lerp(smoothstep(0.5 - ptCurveWeight3.r, 0.5 + ptCurveWeight3.r, weights.w), weights.w, ptCurveWeight3.r*2);
           weights = normalize(weights);
         #endif
         

         // uvScale before anything
         #if _PERTEXUVSCALEOFFSET && !_TRIPLANAR && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptUVScale, 0.5, config, half4(1,1,0,0));
            config.uv0.xy = config.uv0.xy * ptUVScale0.rg + ptUVScale0.ba;
            config.uv1.xy = config.uv1.xy * ptUVScale1.rg + ptUVScale1.ba;
            #if !_MAX2LAYER
               config.uv2.xy = config.uv2.xy * ptUVScale2.rg + ptUVScale2.ba;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               config.uv3.xy = config.uv3.xy * ptUVScale3.rg + ptUVScale3.ba;
            #endif

            // fix for pertex uv scale using gradient sampler and weight blended derivatives
            #if _USEGRADMIP
               albedoLOD = albedoLOD * ptUVScale0.rgrg * weights.x + 
                           albedoLOD * ptUVScale1.rgrg * weights.y + 
                           albedoLOD * ptUVScale2.rgrg * weights.z + 
                           albedoLOD * ptUVScale3.rgrg * weights.w;
               normalLOD = albedoLOD;
               #if _USEEMISSIVEMETAL
                  emisLOD = albedoLOD;
               #endif
               #if _USESPECULARWORKFLOW
                  specLOD = albedoLOD;
               #endif
            #endif
         #endif

         #if _PERTEXUVROTATION && !_TRIPLANAR && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptUVRot, 16.5, config, half4(0,0,0,0));
            config.uv0.xy = RotateUV(config.uv0.xy, ptUVRot0.x);
            config.uv1.xy = RotateUV(config.uv1.xy, ptUVRot1.x);
            #if !_MAX2LAYER
               config.uv2.xy = RotateUV(config.uv2.xy, ptUVRot2.x);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               config.uv3.xy = RotateUV(config.uv3.xy, ptUVRot0.x);
            #endif
         #endif

         
         o.Alpha = 1;

         
         #if _POM && !_DISABLESPLATMAPS
            DoPOM(i, config, tc, albedoLOD, weights, camDist, worldNormalVertex);
         #endif
         

         SampleAlbedo(config, tc, samples, albedoLOD, weights);

         #if _NOISEHEIGHT
            ApplyNoiseHeight(samples, config.uv, config, i.worldPos, worldNormalVertex);
         #endif
         
         #if _STREAMS || (_PARALLAX && !_DISABLESPLATMAPS)
         half earlyHeight = BlendWeights(samples.albedo0.w, samples.albedo1.w, samples.albedo2.w, samples.albedo3.w, weights);
         #endif

         
         #if _STREAMS
         waterNormalFoam = GetWaterNormal(i, config.uv, worldNormalVertex);
         DoStreamRefract(config, tc, waterNormalFoam, fxLevels.b, earlyHeight);
         #endif

         #if _PARALLAX && !_DISABLESPLATMAPS
            DoParallax(i, earlyHeight, config, tc, samples, weights, camDist);
         #endif


         // Blend results
         #if _PERTEXINTERPCONTRAST && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptContrasts, 1.5, config, 0.5);
            half4 contrast = 0.5;
            contrast.x = ptContrasts0.a;
            contrast.y = ptContrasts1.a;
            #if !_MAX2LAYER
               contrast.z = ptContrasts2.a;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               contrast.w = ptContrasts3.a;
            #endif
            contrast = clamp(contrast + _Contrast, 0.0001, 1.0); 
            half cnt = contrast.x * weights.x + contrast.y * weights.y + contrast.z * weights.z + contrast.w * weights.w;
            half4 heightWeights = ComputeWeights(weights, samples.albedo0.a, samples.albedo1.a, samples.albedo2.a, samples.albedo3.a, cnt);
         #else
            half4 heightWeights = ComputeWeights(weights, samples.albedo0.a, samples.albedo1.a, samples.albedo2.a, samples.albedo3.a, _Contrast);
         #endif


         #if _PARALLAX || _STREAMS
            SampleAlbedo(config, tc, samples, albedoLOD, heightWeights);
         #endif


         SampleNormal(config, tc, samples, normalLOD, heightWeights);

         #if _USEEMISSIVEMETAL
            SampleEmis(config, tc, samples, emisLOD, heightWeights);
         #endif

         #if _USESPECULARWORKFLOW
            SampleSpecular(config, tc, samples, specLOD, heightWeights);
         #endif

         #if _DISTANCERESAMPLE && !_DISABLESPLATMAPS
            DistanceResample(samples, config, tc, camDist, i.viewDir, fxLevels, albedoLOD, i.worldPos, heightWeights, worldNormalVertex);
         #endif

         // PerTexture sampling goes here, passing the samples structure
         
         #if _PERTEXMICROSHADOWS || _PERTEXFUZZYSHADE
            SAMPLE_PER_TEX(ptFuzz, 17.5, config, half4(0, 0, 1, 1));
         #endif

         #if _PERTEXMICROSHADOWS
            #if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_DEFERRED) || (defined(_MSRENDERLOOP_UNITYLD) && defined(_PASSFORWARD) || _MSRENDERLOOP_UNITYHD)
            {
               half3 lightDir = GetGlobalLightDirTS(i);
               half4 microShadows = half4(1,1,1,1);
               microShadows.x = MicroShadow(lightDir, half3(samples.normSAO0.xy, 1), samples.normSAO0.a, ptFuzz0.a);
               microShadows.y = MicroShadow(lightDir, half3(samples.normSAO1.xy, 1), samples.normSAO1.a, ptFuzz1.a);
               microShadows.z = MicroShadow(lightDir, half3(samples.normSAO2.xy, 1), samples.normSAO2.a, ptFuzz2.a);
               microShadows.w = MicroShadow(lightDir, half3(samples.normSAO3.xy, 1), samples.normSAO3.a, ptFuzz3.a);
               samples.normSAO0.a *= microShadows.x;
               samples.normSAO1.a *= microShadows.y;
               #if !_MAX2LAYER
                  samples.normSAO2.a *= microShadows.z;
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  samples.normSAO3.a *= microShadows.w;
               #endif

               
               #if _DEBUG_OUTPUT_MICROSHADOWS
               o.Albedo = BlendWeights(microShadows.x, microShadows.y, microShadows.z, microShadows.a, heightWeights);
               return o;
               #endif

            }
            #endif

         #endif // _PERTEXMICROSHADOWS


         #if _PERTEXFUZZYSHADE
            
            samples.albedo0.rgb = FuzzyShade(samples.albedo0.rgb, half3(samples.normSAO0.rg, 1), ptFuzz0.r, ptFuzz0.g, ptFuzz0.b, i.viewDir);
            samples.albedo1.rgb = FuzzyShade(samples.albedo1.rgb, half3(samples.normSAO1.rg, 1), ptFuzz1.r, ptFuzz1.g, ptFuzz1.b, i.viewDir);
            #if !_MAX2LAYER
               samples.albedo2.rgb = FuzzyShade(samples.albedo2.rgb, half3(samples.normSAO2.rg, 1), ptFuzz2.r, ptFuzz2.g, ptFuzz2.b, i.viewDir);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb = FuzzyShade(samples.albedo3.rgb, half3(samples.normSAO3.rg, 1), ptFuzz3.r, ptFuzz3.g, ptFuzz3.b, i.viewDir);
            #endif
         #endif

         #if _PERTEXSATURATION && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptSaturattion, 9.5, config, half4(1, 1, 1, 1));
            samples.albedo0.rgb = lerp(MSLuminance(samples.albedo0.rgb), samples.albedo0.rgb, ptSaturattion0.a);
            samples.albedo1.rgb = lerp(MSLuminance(samples.albedo1.rgb), samples.albedo1.rgb, ptSaturattion1.a);
            #if !_MAX2LAYER
               samples.albedo2.rgb = lerp(MSLuminance(samples.albedo2.rgb), samples.albedo2.rgb, ptSaturattion2.a);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb = lerp(MSLuminance(samples.albedo3.rgb), samples.albedo3.rgb, ptSaturattion3.a);
            #endif
         
         #endif
         
         #if _PERTEXTINT && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptTints, 1.5, config, half4(1, 1, 1, 1));
            samples.albedo0.rgb *= ptTints0.rgb;
            samples.albedo1.rgb *= ptTints1.rgb;
            #if !_MAX2LAYER
               samples.albedo2.rgb *= ptTints2.rgb;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb *= ptTints3.rgb;
            #endif
         #endif
         
         #if _PCHEIGHTGRADIENT || _PCHEIGHTHSV || _PCSLOPEGRADIENT || _PCSLOPEHSV
            ProceduralGradients(i, samples, config, worldHeight, worldNormalVertex);
         #endif

         
         

         #if _WETNESS || _PUDDLES || _STREAMS
         porosity = _GlobalPorosity;
         #endif


         #if _PERTEXCOLORINTENSITY
            SAMPLE_PER_TEX(ptCI, 23.5, config, half4(1, 1, 1, 1));
            samples.albedo0.rgb = saturate(samples.albedo0.rgb * (1 + ptCI0.rrr));
            samples.albedo1.rgb = saturate(samples.albedo1.rgb * (1 + ptCI1.rrr));
            #if !_MAX2LAYER
               samples.albedo2.rgb = saturate(samples.albedo2.rgb * (1 + ptCI2.rrr));
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb = saturate(samples.albedo3.rgb * (1 + ptCI3.rrr));
            #endif
         #endif

         #if (_PERTEXBRIGHTNESS || _PERTEXCONTRAST || _PERTEXPOROSITY || _PERTEXFOAM) && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptBC, 3.5, config, half4(1, 1, 1, 1));
            #if _PERTEXCONTRAST
               samples.albedo0.rgb = saturate(((samples.albedo0.rgb - 0.5) * ptBC0.g) + 0.5);
               samples.albedo1.rgb = saturate(((samples.albedo1.rgb - 0.5) * ptBC1.g) + 0.5);
               #if !_MAX2LAYER
                 samples.albedo2.rgb = saturate(((samples.albedo2.rgb - 0.5) * ptBC2.g) + 0.5);
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  samples.albedo3.rgb = saturate(((samples.albedo3.rgb - 0.5) * ptBC3.g) + 0.5);
               #endif
            #endif
            #if _PERTEXBRIGHTNESS
               samples.albedo0.rgb = saturate(samples.albedo0.rgb + ptBC0.rrr);
               samples.albedo1.rgb = saturate(samples.albedo1.rgb + ptBC1.rrr);
               #if !_MAX2LAYER
                  samples.albedo2.rgb = saturate(samples.albedo2.rgb + ptBC2.rrr);
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  samples.albedo3.rgb = saturate(samples.albedo3.rgb + ptBC3.rrr);
               #endif
            #endif
            #if _PERTEXPOROSITY
            porosity = BlendWeights(ptBC0.b, ptBC1.b, ptBC2.b, ptBC3.b, heightWeights);
            #endif

            #if _PERTEXFOAM
            streamFoam = BlendWeights(ptBC0.a, ptBC1.a, ptBC2.a, ptBC3.a, heightWeights);
            #endif

         #endif

         #if (_PERTEXNORMSTR || _PERTEXAOSTR || _PERTEXSMOOTHSTR || _PERTEXMETALLIC) && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(perTexMatSettings, 2.5, config, half4(1.0, 1.0, 1.0, 0.0));
         #endif

         #if _PERTEXNORMSTR && !_DISABLESPLATMAPS
            samples.normSAO0.xy *= perTexMatSettings0.r;
            samples.normSAO1.xy *= perTexMatSettings1.r;
            #if !_MAX2LAYER
               samples.normSAO2.xy *= perTexMatSettings2.r;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.normSAO3.xy *= perTexMatSettings3.r;
            #endif
         #endif

         #if _PERTEXAOSTR && !_DISABLESPLATMAPS
            samples.normSAO0.a = pow(samples.normSAO0.a, abs(perTexMatSettings0.b));
            samples.normSAO1.a = pow(samples.normSAO1.a, abs(perTexMatSettings1.b));
            #if !_MAX2LAYER
               samples.normSAO2.a = pow(samples.normSAO2.a, abs(perTexMatSettings2.b));
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.normSAO3.a = pow(samples.normSAO3.a, abs(perTexMatSettings3.b));
            #endif
         #endif

         #if _PERTEXSMOOTHSTR && !_DISABLESPLATMAPS
            samples.normSAO0.b += perTexMatSettings0.g;
            samples.normSAO1.b += perTexMatSettings1.g;
            samples.normSAO0.b = saturate(samples.normSAO0.b);
            samples.normSAO1.b = saturate(samples.normSAO1.b);
            #if !_MAX2LAYER
               samples.normSAO2.b += perTexMatSettings2.g;
               samples.normSAO2.b = saturate(samples.normSAO2.b);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.normSAO3.b += perTexMatSettings3.g;
               samples.normSAO3.b = saturate(samples.normSAO3.b);
            #endif
         #endif

         
         #if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_DEFERRED) || (defined(_MSRENDERLOOP_UNITYLD) && defined(_PASSFORWARD) || _MSRENDERLOOP_UNITYHD) 
          #if _PERTEXSSS
          {
            SAMPLE_PER_TEX(ptSSS, 18.5, config, half4(1, 1, 1, 1)); // tint, thickness
            
            half4 vals = ptSSS0 * heightWeights.x + ptSSS1 * heightWeights.y + ptSSS2 * heightWeights.z + ptSSS3 * heightWeights.w;
            SSSThickness = vals.a;
            SSSTint = vals.rgb;
          }
          #endif
         #endif

         #if (((_DETAILNOISE && _PERTEXDETAILNOISESTRENGTH) || (_DISTANCENOISE && _PERTEXDISTANCENOISESTRENGTH)) || (_NORMALNOISE && _PERTEXNORMALNOISESTRENGTH)) && !_DISABLESPLATMAPS
         ApplyDetailDistanceNoisePerTex(samples, config, camDist, i.worldPos, worldNormalVertex);
         #endif

         
         #if _GLOBALNOISEUV
            // noise defaults so that a value of 1, 1 is 4 pixels in size and moves the uvs by 1 pixel max.
            #if _CUSTOMSPLATTEXTURES
               noiseUV = (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, config.uv * _CustomControl0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _CustomControl0_TexelSize.xy * _NoiseUVParams.y;
            #else
               noiseUV = (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, config.uv * _Control0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _Control0_TexelSize.xy * _NoiseUVParams.y;
            #endif
         #endif

         
         #if _TRAXSINGLE || _TRAXARRAY || _TRAXNOTEXTURE
            ApplyTrax(samples, config, i.worldPos, traxBuffer, traxNormal);
         #endif

         #if (_ANTITILEARRAYDETAIL || _ANTITILEARRAYDISTANCE || _ANTITILEARRAYNORMAL) && !_DISABLESPLATMAPS
         ApplyAntiTilePerTex(samples, config, camDist, i.worldPos, worldNormalVertex, heightWeights);
         #endif

         #if _GEOMAP && !_DISABLESPLATMAPS
         GeoTexturePerTex(samples, i.worldPos, worldHeight, config, worldNormalVertex, upVector);
         #endif
         
         #if _GLOBALTINT && _PERTEXGLOBALTINTSTRENGTH && !_DISABLESPLATMAPS
         GlobalTintTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALNORMALS && _PERTEXGLOBALNORMALSTRENGTH && !_DISABLESPLATMAPS
         GlobalNormalTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALSMOOTHAOMETAL && _PERTEXGLOBALSAOMSTRENGTH && !_DISABLESPLATMAPS
         GlobalSAOMTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _GLOBALEMIS && _PERTEXGLOBALEMISSTRENGTH && !_DISABLESPLATMAPS
         GlobalEmisTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _GLOBALSPECULAR && _PERTEXGLOBALSPECULARSTRENGTH && !_DISABLESPLATMAPS && _USESPECULARWORKFLOW
         GlobalSpecularTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _PERTEXMETALLIC && !_DISABLESPLATMAPS
            half metallic = BlendWeights(perTexMatSettings0.a, perTexMatSettings1.a, perTexMatSettings2.a, perTexMatSettings3.a, heightWeights);
            o.Metallic = metallic;
         #endif

         #if _GLITTER && !_DISABLESPLATMAPS
            DoGlitter(i, samples, config, camDist, worldNormalVertex, i.worldPos);
         #endif
         
         // Blend em..
         #if _DISABLESPLATMAPS
            // If we don't sample from the _Diffuse, then the shader compiler will strip the sampler on
            // some platforms, which will cause everything to break. So we sample from the lowest mip
            // and saturate to 1 to keep the cost minimal. Annoying, but the compiler removes the texture
            // and sampler, even though the sampler is still used.
            albedo = saturate(UNITY_SAMPLE_TEX2DARRAY_LOD(_Diffuse, float3(0,0,0), 12) + 1);
            albedo.a = 0.5; // make height something we can blend with for the combined mesh mode, since it still height blends.
            normSAO = half4(0,0,0,1);
         #else
            albedo = BlendWeights(samples.albedo0, samples.albedo1, samples.albedo2, samples.albedo3, heightWeights);
            normSAO = BlendWeights(samples.normSAO0, samples.normSAO1, samples.normSAO2, samples.normSAO3, heightWeights);
            #if _USEEMISSIVEMETAL && !_DISABLESPLATMAPS
               emisMetal = BlendWeights(samples.emisMetal0, samples.emisMetal1, samples.emisMetal2, samples.emisMetal3, heightWeights);
            #endif

            #if _USESPECULARWORKFLOW && !_DISABLESPLATMAPS
               specular = BlendWeights(samples.specular0, samples.specular1, samples.specular2, samples.specular3, heightWeights);
            #endif
         #endif

         
         // ADVANCEDTERRAIN_ENTRYPOINT 


         #if _MESHOVERLAYSPLATS || _MESHCOMBINED
            o.Alpha = 1.0;
            if (config.uv0.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.x;
            else if (config.uv1.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.y;
            else if (config.uv2.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.z;
            else if (config.uv3.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.w;
         #endif



         // effects which don't require per texture adjustments and are part of the splats sample go here. 
         // Often, as an optimization, you can compute the non-per tex version of above effects here..


         #if ((_DETAILNOISE && !_PERTEXDETAILNOISESTRENGTH) || (_DISTANCENOISE && !_PERTEXDISTANCENOISESTRENGTH) || (_NORMALNOISE && !_PERTEXNORMALNOISESTRENGTH))
            ApplyDetailDistanceNoise(albedo.rgb, normSAO, config, camDist, i.worldPos, worldNormalVertex);
         #endif

         #if _SPLATFADE
         }
         #endif

         #if _SPLATFADE
            // blend in uniform texture over splat fade range
            // only for planets? Fine on terrain, but may want a switch for this..
            #if _TRIPLANAR && (_PLANETNORMAL || _PLANETNORMAL2)
               

               float3 pN = pow(abs(worldNormalVertex), 0.7);
               pN = pN / (pN.x + pN.y + pN.z);
            
               half3 axisSign = sign(worldNormalVertex);

               float2 uv0 = i.worldPos.zy * axisSign.x * _TriplanarUVScale.xy;
               float2 uv1 = i.worldPos.xz * axisSign.y * _TriplanarUVScale.xy;
               float2 uv2 = i.worldPos.xy * axisSign.z * _TriplanarUVScale.xy;

               float2 sfDX = ddx(uv0);
               float2 sfDY = ddy(uv0);

               MSBRANCHOTHER(camDist - _SplatFade.x)
               {
                  float falloff = saturate(InverseLerp(_SplatFade.x, _SplatFade.y, camDist));
                  half4 sfalb0 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(uv0, _SplatFade.z), sfDX, sfDY);
                  half4 sfalb1 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(uv1, _SplatFade.z), sfDX, sfDY);
                  half4 sfalb2 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(uv2, _SplatFade.z), sfDX, sfDY);
                  COUNTSAMPLE
                  COUNTSAMPLE
                  COUNTSAMPLE
                  albedo.rgb = lerp(albedo.rgb, sfalb0.rgb * pN.x + sfalb1 * pN.y + sfalb2 * pN.z, falloff);

                  #if !_NONOMALMAP
                     half4 sfnormSAO0 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(uv0, _SplatFade.z), sfDX, sfDY).garb;
                     half4 sfnormSAO1 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(uv1, _SplatFade.z), sfDX, sfDY).garb;
                     half4 sfnormSAO2 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(uv2, _SplatFade.z), sfDX, sfDY).garb;
                     COUNTSAMPLE
                     COUNTSAMPLE
                     COUNTSAMPLE
                     half4 sfnormSAO = sfnormSAO0 * pN.x + sfnormSAO1 * pN.y + sfnormSAO2 * pN.z;
                     sfnormSAO.xy = sfnormSAO.xy * 2 - 1;

                     normSAO = lerp(normSAO, sfnormSAO, falloff);
                  #endif
              
               }
            #else // _TRIPLANAR && (_PLANETNORMAL || _PLANETNORMAL2)
            float2 sfDX = ddx(config.uv * _UVScale);
            float2 sfDY = ddy(config.uv * _UVScale);

            MSBRANCHOTHER(camDist - _SplatFade.x)
            {
               float falloff = saturate(InverseLerp(_SplatFade.x, _SplatFade.y, camDist));
               half4 sfalb = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(config.uv * _UVScale, _SplatFade.z), sfDX, sfDY);
               COUNTSAMPLE
               albedo.rgb = lerp(albedo.rgb, sfalb.rgb, falloff);

               #if !_NONOMALMAP
                  half4 sfnormSAO = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(config.uv * _UVScale, _SplatFade.z), sfDX, sfDY).garb;
                  COUNTSAMPLE
                  sfnormSAO.xy = sfnormSAO.xy * 2 - 1;

                  normSAO = lerp(normSAO, sfnormSAO, falloff);
               #endif
              
            }
            #endif
         #endif


         #if _MESHCOMBINED
            SampleMeshCombined(albedo, normSAO, emisMetal, specular, o.Alpha, SSSThickness, SSSTint, config, heightWeights);
         #endif
         
         #if _SCATTER
            ApplyScatter(i, albedo, normSAO, config.uv, camDist);
         #endif

         #if _GEOMAP
            GeoTexture(albedo.rgb, normSAO, i.worldPos, worldHeight, config, worldNormalVertex, upVector);
         #endif

         #if _PLANETALBEDO || _PLANETNORMAL || _PLANETALBEDO2 || _PLANETNORMAL2
            ApplyPlanet(i, albedo, normSAO, config, camDist, i.worldPos, worldNormalVertex);
         #endif


         #if _GLOBALTINT && !_PERTEXGLOBALTINTSTRENGTH
            GlobalTintTexture(albedo.rgb, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _VSGRASSMAP
            VSGrassTexture(albedo.rgb, config, camDist);
         #endif

         #if _GLOBALNORMALS && !_PERTEXGLOBALNORMALSTRENGTH
            GlobalNormalTexture(normSAO, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALSMOOTHAOMETAL && !_PERTEXGLOBALSAOMSTRENGTH
            GlobalSAOMTexture(normSAO, emisMetal, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALEMIS && !_PERTEXGLOBALEMISSTRENGTH
            GlobalEmisTexture(emisMetal, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _GLOBALSPECULAR && !_PERTEXGLOBALSPECULARSTRENGTH && _USESPECULARWORKFLOW
            GlobalSpecularTexture(specular.rgb, config, camDist, globalSlopeFilter, noiseUV);
         #endif

        
         
         o.Albedo = albedo.rgb;
         o.Height = albedo.a;
         o.Normal = half3(normSAO.xy, 1);
         o.Smoothness = normSAO.b;
         o.Occlusion = normSAO.a;

         #if _USEEMISSIVEMETAL || _GLOBALSMOOTHAOMETAL || _GLOBALEMIS 
         o.Emission = emisMetal.rgb;
         o.Metallic = emisMetal.a;
	        #if _USEEMISSIVEMETAL
	        o.Emission *= _EmissiveMult;
	        #endif
         #endif

         #if _USESPECULARWORKFLOW
            o.Specular = specular;
         #endif


         


         #if _WETNESS || _PUDDLES || _STREAMS || _LAVA
         pud = DoStreams(i, o, fxLevels, config.uv, porosity, waterNormalFoam, worldNormalVertex, streamFoam, wetLevel, burnLevel, i.worldPos);
         #endif

         
         #if _SNOW
         snowCover = DoSnow(o, config.uv, WorldNormalVector(i, o.Normal), worldNormalVertex, i.worldPos, pud, porosity, camDist, 
            config, weights, SSSTint, SSSThickness, traxBuffer, traxNormal);
         #endif

         #if _PERTEXSSS || _MESHCOMBINEDUSESSS || (_SNOW && _SNOWSSS)
         {
            half3 worldView = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

            o.Emission += ComputeSSS(i, worldView, WorldNormalVector(i, half3(normSAO.xy, 1)),
               SSSTint, SSSThickness, _SSSDistance, _SSSScale, _SSSPower);
         }
         #endif
         
         #if _SNOWGLITTER
            DoSnowGlitter(i, config, o, camDist, worldNormalVertex, snowCover);
         #endif

         #if _WINDPARTICULATE || _SNOWPARTICULATE
         DoWindParticulate(i, o, config, weights, camDist, worldNormalVertex, snowCover);
         #endif

         o.Normal.z = sqrt(1 - saturate(dot(o.Normal.xy, o.Normal.xy)));

         #if _SPECULARFADE
         {
            float specFade = saturate((i.worldPos.y - _SpecularFades.x) / max(_SpecularFades.y - _SpecularFades.x, 0.0001));
            o.Metallic *= specFade;
            o.Smoothness *= specFade;
         }
         #endif

         #if _VSSHADOWMAP
         VSShadowTexture(o, i, config, camDist);
         #endif
         
         #if _TOONWIREFRAME
         ToonWireframe(config.uv, o.Albedo);
         #endif

         #if _DEBUG_TRAXBUFFER
            ClearAllButAlbedo(o, half3(traxBuffer, 0, 0) * saturate(o.Albedo.z+1));
         #elif _DEBUG_WORLDNORMALVERTEX
            ClearAllButAlbedo(o, worldNormalVertex * saturate(o.Albedo.z+1));
         #elif _DEBUG_WORLDNORMAL
            ClearAllButAlbedo(o,  WorldNormalVector(i, o.Normal) * saturate(o.Albedo.z+1));
         #endif

         return o;
      }
      
      void SampleSplats(float2 controlUV, inout half4 w0, inout half4 w1, inout half4 w2, inout half4 w3, inout half4 w4, inout half4 w5, inout half4 w6, inout half4 w7)
      {
         #if _CUSTOMSPLATTEXTURES
            #if !_MICROMESH
            controlUV = (controlUV * (_CustomControl0_TexelSize.zw - 1.0f) + 0.5f) * _CustomControl0_TexelSize.xy;
            #endif

            #if  _CONTROLNOISEUV
               controlUV += (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, controlUV * _CustomControl0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _CustomControl0_TexelSize.xy * _NoiseUVParams.y;
            #endif

            w0 = UNITY_SAMPLE_TEX2D(_CustomControl0, controlUV);
            COUNTSAMPLE

            #if !_MAX4TEXTURES
            w1 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl1, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES
            w2 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl2, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
            w3 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl3, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w4 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl4, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w5 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl5, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX28TEXTURES || _MAX32TEXTURES
            w6 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl6, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX32TEXTURES
            w7 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl7, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif
         #else
            #if !_MICROMESH
            controlUV = (controlUV * (_Control0_TexelSize.zw - 1.0f) + 0.5f) * _Control0_TexelSize.xy;
            #endif

            #if  _CONTROLNOISEUV
               controlUV += (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, controlUV * _Control0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _Control0_TexelSize.xy * _NoiseUVParams.y;
            #endif

            w0 = UNITY_SAMPLE_TEX2D(_Control0, controlUV);
            COUNTSAMPLE

            #if !_MAX4TEXTURES
            w1 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control1, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES
            w2 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control2, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
            w3 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control3, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w4 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control4, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w5 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control5, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX28TEXTURES || _MAX32TEXTURES
            w6 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control6, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX32TEXTURES
            w7 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control7, _Control0, controlUV);
            COUNTSAMPLE
            #endif
         #endif
      }   


      

      MicroSplatLayer SurfImpl(Input i, float3 worldNormalVertex)
      {
         // with DrawInstanced on, view dir is incorrect, so we compute it here. Thanks Obama..
         #if _MSRENDERLOOP_SURFACESHADER && !_DEBUG_USE_TOPOLOGY &&!_TERRAINBLENDABLESHADER && !_MICROMESH && !_MICROMESHTERRAIN && !_MICROPOLARISMESH &&!_MICRODIGGERMESH && !_MICROVERTEXMESH && defined(UNITY_INSTANCING_ENABLED)
            float3 t2w0 = WorldNormalVector(i, float3(1,0,0));
            float3 t2w1 = WorldNormalVector(i, float3(0,1,0));
            float3 t2w2 = WorldNormalVector(i, float3(0,0,1));
            float3x3 t2w = float3x3(t2w0, t2w1, t2w2);
            i.viewDir = normalize(mul(t2w, (_WorldSpaceCameraPos - i.worldPos)));
         #elif !_MSRENDERLOOP_SURFACESHADER
            // tangent space view dir is just not correct in URP
            i.viewDir = normalize( mul(i.TBN, (_WorldSpaceCameraPos - i.worldPos)) );
         #endif


         #if _TERRAINBLENDABLESHADER && _TRIPLANAR
            worldNormalVertex = WorldNormalVector(i, float3(0,0,1));
         #endif
         
         float camDist = distance(_WorldSpaceCameraPos, i.worldPos);
          
         #if _FORCELOCALSPACE
            #if _PLANETVECTORS
                worldNormalVertex = mul(_PQSToLocal, float4(worldNormalVertex, 1)).xyz;
                i.worldPos = i.worldPos + mul(_PQSToLocal, float4(0,0,0,1)).xyz;
             #else
                worldNormalVertex = mul((float3x3)GetWorldToObjectMatrix(), worldNormalVertex).xyz;
                i.worldPos = i.worldPos -  mul(GetObjectToWorldMatrix(), float4(0,0,0,1)).xyz;
             #endif
         #endif

         #if _ORIGINSHIFT
             //worldNormalVertex = mul(_GlobalOriginMTX, float4(worldNormalVertex, 1)).xyz;
             i.worldPos = i.worldPos + mul(_GlobalOriginMTX, float4(0,0,0,1)).xyz;
         #endif

         #if _DEBUG_USE_TOPOLOGY
            i.worldPos = UNITY_SAMPLE_TEX2D_SAMPLER(_DebugWorldPos, _Diffuse, i.uv_Control0);
            worldNormalVertex = UNITY_SAMPLE_TEX2D_SAMPLER(_DebugWorldNormal, _Diffuse, i.uv_Control0);
         #endif

         #if _ALPHABELOWHEIGHT && !_TBDISABLEALPHAHOLES
            ClipWaterLevel(i.worldPos);
         #endif

         #if !_TBDISABLEALPHAHOLES && defined(_ALPHATEST_ON)
            // UNITY 2019.3 holes
            ClipHoles(i.uv_Control0);
         #endif


         float2 origUV = i.uv_Control0;

         #if _MICROMESH && _MESHUV2
         float2 controlUV = i.uv2_Diffuse;
         #else
         float2 controlUV = i.uv_Control0;
         #endif


         #if _MICROMESH
            controlUV = InverseLerp(_UVMeshRange.xy, _UVMeshRange.zw, controlUV);
         #endif

         half4 weights = half4(1,0,0,0);

         Config config = (Config)0;
         UNITY_INITIALIZE_OUTPUT(Config,config);
         config.uv = origUV;

         #if _SPLATFADE
         MSBRANCHOTHER(_SplatFade.y - camDist)
         #endif // _SPLATFADE
         {
            #if !_DISABLESPLATMAPS

               // Sample the splat data, from textures or vertices, and setup the config..
               #if _MICRODIGGERMESH
                  DiggerSetup(i, weights, origUV, config, i.worldPos);
               #elif _MICROVERTEXMESH
                  VertexSetup(i, weights, origUV, config, i.worldPos);
               #elif !_PROCEDURALTEXTURE || _PROCEDURALBLENDSPLATS
                  half4 w0 = 0; half4 w1 = 0; half4 w2 = 0; half4 w3 = 0; half4 w4 = 0; half4 w5 = 0; half4 w6 = 0; half4 w7 = 0;
                  SampleSplats(controlUV, w0, w1, w2, w3, w4, w5, w6, w7);
                  Setup(weights, origUV, config, w0, w1, w2, w3, w4, w5, w6, w7, i.worldPos);
               #endif

               #if _PROCEDURALTEXTURE
                  float3 up = float3(0,1,0);
                  float3 procNormal = worldNormalVertex;
                  float height = i.worldPos.y;
                  ProceduralSetup(i, i.worldPos, height, procNormal, up, weights, origUV, config, ddx(origUV), ddy(origUV), ddx(i.worldPos), ddy(i.worldPos));

                  #if _PLANETNORMAL2 || _PLANETNORMAL
                     config.uv = origUV;
                     float2 pnorm = GetPlanetTangentNormal(i, config, camDist, worldNormalVertex);
                     procNormal.xy = pnorm;
                     procNormal.z = sqrt(1 - procNormal.x * procNormal.x - procNormal.y * procNormal.y);
                     procNormal = WorldNormalVector(i, procNormal);
                     up = worldNormalVertex;
                     float3 center = mul(GetWorldToObjectMatrix(), float3(0,0,0));
                     height = distance(i.worldPos, center); 
                  #endif
               #endif
            #else // _DISABLESPLATMAPS
                Setup(weights, origUV, config, half4(1,0,0,0), 0, 0, 0, 0, 0, 0, 0, i.worldPos);
            #endif
         } // _SPLATFADE else case

         
         #if _TOONFLATTEXTURE
            float2 quv = floor(origUV * _ToonTerrainSize);
            float2 fuv = frac(origUV * _ToonTerrainSize);
            #if !_TOONFLATTEXTUREQUAD
               quv = Hash2D((fuv.x > fuv.y) ? quv : quv * 0.333);
            #endif
            float2 uvq = quv / _ToonTerrainSize;
            config.uv0.xy = uvq;
            config.uv1.xy = uvq;
            config.uv2.xy = uvq;
            config.uv3.xy = uvq;
         #endif
         
         #if (_TEXTURECLUSTER2 || _TEXTURECLUSTER3) && !_DISABLESPLATMAPS
            PrepClusters(origUV, config, i.worldPos, worldNormalVertex);
         #endif

         #if (_ALPHAHOLE || _ALPHAHOLETEXTURE) && !_DISABLESPLATMAPS && !_TBDISABLEALPHAHOLES
         ClipAlphaHole(config, weights);
         #endif


 
         MicroSplatLayer l = Sample(i, weights, config, camDist, worldNormalVertex);

         
         // HI, this is the section where we hack around various Unity and compiler bugs..

         // Unity has a compiler bug with surface shaders where in some situations it will strip/fuckup
         // i.worldPos or i.viewDir thinking your not using them when you are inside a function. I have
         // fought with this bug so many times it's crazy, reported it and provided repros, and nothing has
         // been done about it. So, make sure these are used, and look like they could have an effect on the final
         // output so the compiler doesn't fuck them up.
         
         // Oh, nice, and it turns out that doing this in the base map shader breaks GI, so only do it in the main
         // shader, which is where we're using i.viewDir for parallax. Fucking hell..

         // AND if triplanar is on, this needs to be run otherwise the UV scale is fucked. I feel like I'm just
         // pushing compiler errors around at this point.. And this breaks render baking, so not then either.
         //
         // And sometimes VD is INF or NAN, so we copy it (make sure the compiler knows we are using) and
         // test for a value, and if it's not 1 we make it 1, so it doesn't make albedo black.
         //
         // Jusus fucking christ already..
         #if (!_MICROSPLATBASEMAP || _TRIPLANAR) && !_RENDERBAKE
            float3 vd = i.viewDir;
            if (vd.x != 1)
               vd = 1;
            l.Albedo *= saturate(vd + i.worldPos + 9999);
         #endif

         // Further, on windows, sometimes the diffuse sampler gets stripped, so we have to do this crap.
         // We sample from the lowest mip, so it shouldn't cost much, but still, I hate this, wtf..
         l.Albedo *= saturate(UNITY_SAMPLE_TEX2DARRAY_LOD(_Diffuse, config.uv0, 11).r + 2);
         // same for the control sampler.
         l.Albedo *= saturate(MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(_Control0, _Control0, config.uv, 11).r + 2);

         #if _PROCEDURALTEXTURE
            ProceduralTextureDebugOutput(l, weights, config);
         #endif
         


         return l;

      }



   


                    //MS_BLENDABLE

                    






    
    MicroSplatLayer DoMicroSplat(inout SurfaceDescriptionInputs IN)
    {
       SurfaceDescription surface = (SurfaceDescription)0;
       Input i = DescToInput(IN);
       float3 worldNormalVertex = IN.WorldSpaceNormal;

        #if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL) && !_MICROMESH && !_MICROMESHTERRAIN && !_MICROPOLARISMESH && !_MICRODIGGERMESH && !_MICROVERTEXMESH
            float2 terrainNormalMapUV = (i.uv_Control0.xy + 0.5f) * _TerrainHeightmapRecipSize.xy;
            i.uv_Control0.xy *= _TerrainHeightmapRecipSize.zw;
            

            #if _TOONHARDEDGENORMAL
               terrainNormalMapUV = ToonEdgeUV(terrainNormalMapUV);
            #endif
            float3 geomNormal = normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, terrainNormalMapUV).xyz * 2 - 1);

            worldNormalVertex = mul((float3x3)GetObjectToWorldMatrix(), geomNormal);
            IN.WorldSpaceNormal = worldNormalVertex;
            float4 tangentWS = ConstructTerrainTangent(IN.WorldSpaceNormal, GetObjectToWorldMatrix()._13_23_33);
            IN.WorldSpaceTangent = tangentWS.xyz;
            i.TBN = BuildTangentToWorld(tangentWS, IN.WorldSpaceNormal.xyz);
            IN.WorldSpaceBiTangent = i.TBN[1].xyz;
        #elif _PERPIXNORMAL
            float2 perPixUV = i.uv_Control0;
            #if _TOONHARDEDGENORMAL
               perPixUV = ToonEdgeUV(perPixUV);
            #endif
            float3 geomNormal = (UnpackNormal(UNITY_SAMPLE_TEX2D_SAMPLER(_PerPixelNormal, _Diffuse, perPixUV))).xzy;
            worldNormalVertex = geomNormal;
        #endif    
        
         
         #if _SRPTERRAINBLEND
            SurfaceOutputCustom soc = (SurfaceOutputCustom)0;
            soc.input = i;
            float3 sh = 0;
            BlendWithTerrainSRP(soc, IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);

            MicroSplatLayer l = (MicroSplatLayer)0;
            l.Albedo = soc.Albedo;
            l.Normal = mul(float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal), soc.Normal);
            l.Emission = soc.Emission;
            l.Metallic = soc.Metallic;
            l.Smoothness = soc.Smoothness;
            #if _USESPECULARWORKFLOW
               l.Specular = soc.Specular;
            #endif
            l.Occlusion = soc.Occlusion;
            l.Alpha = soc.Alpha;

         #else
            MicroSplatLayer l = SurfImpl(i, worldNormalVertex);
         #endif


       // per pixel normal
        #if ((defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)) && !_MICROMESHTERRAIN && !_MICROMESH && !_MICROVERTEXMESH && !_MICRODIGGERMESH && !_MICROPOLARISMESH) || (_MICROMESHTERRAIN && _PERPIXNORMAL)
            float3 geomTangent = normalize(cross(geomNormal, float3(0, 0, 1)));
            float3 geomBitangent = normalize(cross(geomTangent, geomNormal));
            l.Normal = l.Normal.x * geomTangent + l.Normal.y * geomBitangent + l.Normal.z * geomNormal;
            l.Normal = l.Normal.xzy;
        #endif

        DoDebugOutput(l);


        return l;
    }



        

                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        MicroSplatLayer l = DoMicroSplat(IN);

                        SurfaceDescription surface = (SurfaceDescription)0;
                        surface.Albedo = l.Albedo;
                        surface.Normal = l.Normal;
                        surface.BentNormal = IN.TangentSpaceNormal;
                        surface.CoatMask = 0;
                        surface.Smoothness = l.Smoothness;
                        #if _USESPECULARWORKFLOW
                           surface.Specular = l.Specular;
                        #endif
                        surface.Metallic = l.Metallic;
                        surface.Occlusion = l.Occlusion;
                        surface.Emission = l.Emission;
                        surface.Alpha = l.Alpha;
                        return surface;
                    }
                    
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    output.texCoord0 = input.texCoord0;
                    // output.texCoord1 = input.texCoord1;
                    // output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    //output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    // output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    output.WorldSpaceNormal =            normalize(input.tangentToWorld[2].xyz);
                    // output.ObjectSpaceNormal =           mul(output.WorldSpaceNormal, (float3x3) GetObjectToWorldMatrix());           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    // output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // specularOcclusion need to be init ahead of decal to quiet the compiler that modify the SurfaceData struct
                // however specularOcclusion can come from the graph, so need to be init here so it can be override.
                surfaceData.specularOcclusion = 1.0;
        
                // copy across graph values, if defined
                surfaceData.baseColor =                 surfaceDescription.Albedo;
                surfaceData.perceptualSmoothness =      surfaceDescription.Smoothness;
                surfaceData.ambientOcclusion =          surfaceDescription.Occlusion;
                // surfaceData.specularOcclusion =         surfaceDescription.SpecularOcclusion;
                surfaceData.metallic =                  surfaceDescription.Metallic;
                // surfaceData.subsurfaceMask =            surfaceDescription.SubsurfaceMask;
                // surfaceData.thickness =                 surfaceDescription.Thickness;
                // surfaceData.diffusionProfileHash =      asuint(surfaceDescription.DiffusionProfileHash);
                #if _USESPECULARWORKFLOW
                surfaceData.specularColor =             surfaceDescription.Specular;
                #endif
                surfaceData.coatMask =                  surfaceDescription.CoatMask;
                // surfaceData.anisotropy =                surfaceDescription.Anisotropy;
                // surfaceData.iridescenceMask =           surfaceDescription.IridescenceMask;
                // surfaceData.iridescenceThickness =      surfaceDescription.IridescenceThickness;
        
        #ifdef _HAS_REFRACTION
                if (_EnableSSRefraction)
                {
                    // surfaceData.ior =                       surfaceDescription.RefractionIndex;
                    // surfaceData.transmittanceColor =        surfaceDescription.RefractionColor;
                    // surfaceData.atDistance =                surfaceDescription.RefractionDistance;
        
                    surfaceData.transmittanceMask = (1.0 - surfaceDescription.Alpha);
                    surfaceDescription.Alpha = 1.0;
                }
                else
                {
                    surfaceData.ior = 1.0;
                    surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                    surfaceData.atDistance = 1.0;
                    surfaceData.transmittanceMask = 0.0;
                    surfaceDescription.Alpha = 1.0;
                }
        #else
                surfaceData.ior = 1.0;
                surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                surfaceData.atDistance = 1.0;
                surfaceData.transmittanceMask = 0.0;
        #endif
                
                // These static material feature allow compile time optimization
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
                // surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
        
        #ifdef _MATERIAL_FEATURE_IRIDESCENCE
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
        #endif
        #ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
        #endif
        
        #if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
                // Require to have setup baseColor
                // Reproduce the energy conservation done in legacy Unity. Not ideal but better for compatibility and users can unchek it
                surfaceData.baseColor *= (1.0 - Max3(surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b));
        #endif
        
        #ifdef _DOUBLESIDED_ON
            float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
        #else
            float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        #endif
        
                // tangent-space normal
                float3 normalTS = float3(0.0f, 0.0f, 1.0f);
                normalTS = surfaceDescription.Normal;
        
                // compute world space normal
                GetNormalWS(fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants);
        
                surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];
        
                surfaceData.tangentWS = normalize(fragInputs.tangentToWorld[0].xyz);    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
                // surfaceData.tangentWS = TransformTangentToWorld(surfaceDescription.Tangent, fragInputs.tangentToWorld);
        
        #if HAVE_DECALS
                if (_EnableDecals)
                {
                    // Both uses and modifies 'surfaceData.normalWS'.
                    DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
                    ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
                }
        #endif
        
                bentNormalWS = surfaceData.normalWS;
                // GetNormalWS(fragInputs, surfaceDescription.BentNormal, bentNormalWS, doubleSidedConstants);
        
                surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);
        
        
                // By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion.
                // If user provide bent normal then we process a better term
        #if defined(_SPECULAR_OCCLUSION_CUSTOM)
                // Just use the value passed through via the slot (not active otherwise)
        #elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
                // If we have bent normal and ambient occlusion, process a specular occlusion
                surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO(V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness(surfaceData.perceptualSmoothness));
        #elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
                surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
        #endif
        
        #ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
                surfaceData.perceptualSmoothness = GeometricNormalFiltering(surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[2], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold);
        #endif
        
        #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO: need to update mip info
                    surfaceData.metallic = 0;
                }
        
                // We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
                // as it can modify attribute use for static lighting
                ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {

        #ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
                LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
        #endif
        
        #ifdef _DOUBLESIDED_ON
            float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
        #else
            float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        #endif
        
                ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdDepthPrepass);
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdDepthPostpass);
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdShadow);
                
                // ApplyDepthOffsetPositionInput(V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput);
        
                float3 bentNormalWS;
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS);
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal 
                InitBuiltinData(posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[2], fragInputs.texCoord1, fragInputs.texCoord2, builtinData);
        
                // override sampleBakedGI:
                // builtinData.bakeDiffuseLighting = surfaceDescription.BakedGI;
                // builtinData.backBakeDiffuseLighting = surfaceDescription.BakedBackGI;
        
                builtinData.emissiveColor = surfaceDescription.Emission;
        
                // builtinData.depthOffset = surfaceDescription.DepthOffset;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #else
                builtinData.distortion = float2(0.0, 0.0);
                builtinData.distortionBlur = 0.0;
        #endif
        
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassLightTransport.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDLitPass.template
            Name "SceneSelectionPass"
            Tags { "LightMode" = "SceneSelectionPass" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            
            
            
            
            
            
            ColorMask 0
        
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            #pragma shader_feature_local _TERRAIN_INSTANCED_PERPIXEL_NORMAL
            #pragma multi_compile_instancing
            #pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap renderinglayer
        
        #pragma multi_compile_local _ _ALPHATEST_ON
        
            // #pragma multi_compile _ LOD_FADE_CROSSFADE
        
            #pragma shader_feature _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _DOUBLESIDED_ON
            #pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
            // #define _MATERIAL_FEATURE_SUBSURFACE_SCATTERING 1
            // #define _MATERIAL_FEATURE_TRANSMISSION 1
            // #define _MATERIAL_FEATURE_ANISOTROPY 1
            // #define _MATERIAL_FEATURE_IRIDESCENCE 1
            // #define _MATERIAL_FEATURE_SPECULAR_COLOR 1
            // #define _ENABLE_FOG_ON_TRANSPARENT 1
            // #define _AMBIENT_OCCLUSION 1
            #define _SPECULAR_OCCLUSION_FROM_AO 1
            // #define _SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL 1
            // #define _SPECULAR_OCCLUSION_CUSTOM 1
            #define _ENERGY_CONSERVING_SPECULAR 1
            // #define _ENABLE_GEOMETRIC_SPECULAR_AA 1
            // #define _HAS_REFRACTION 1
            // #define _REFRACTION_PLANE 1
            // #define _REFRACTION_SPHERE 1
            // #define _DISABLE_DECALS 1
            // #define _DISABLE_SSR 1
            // #define _ADD_PRECOMPUTED_VELOCITY
            // #define _WRITE_TRANSPARENT_MOTION_VECTOR 1
            // #define _DEPTHOFFSET_ON 1
            // #define _BLENDMODE_PRESERVE_SPECULAR_LIGHTING 1

            
      #define _MICROSPLAT 1
      #define _ALPHABELOWHEIGHT 1
      #define _MSRENDERLOOP_UNITYHD 1


        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            // If we use subsurface scattering, enable output split lighting (for forward pass)
            #if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
            #define OUTPUT_SPLIT_LIGHTING
            #endif
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Defines
            //-------------------------------------------------------------------------------------
                    #define SHADERPASS SHADERPASS_DEPTH_ONLY
                #define SCENESELECTIONPASS
                #pragma editor_sync_compilation
                #define RAYTRACING_SHADER_GRAPH_HIGH
                // ACTIVE FIELDS:
                //   Material.Standard
                //   Specular.EnergyConserving
                //   SpecularOcclusionFromAO
                //   SurfaceDescriptionInputs.TangentSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.ObjectSpacePosition
                //   SurfaceDescription.Alpha
                //   features.modifyMesh
                //   VertexDescription.VertexPosition
                //   VertexDescription.VertexNormal
                //   VertexDescription.VertexTangent
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.positionOS
                // Shared Graph Keywords
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            // #define ATTRIBUTES_NEED_TEXCOORD0
            // #define ATTRIBUTES_NEED_TEXCOORD1
            // #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            // #define ATTRIBUTES_NEED_COLOR
            // #define VARYINGS_NEED_POSITION_WS
            // #define VARYINGS_NEED_TANGENT_TO_WORLD
            // #define VARYINGS_NEED_TEXCOORD0
            // #define VARYINGS_NEED_TEXCOORD1
            // #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            // #define VARYINGS_NEED_COLOR
            // #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
        // We need isFontFace when using double sided
        #if defined(_DOUBLESIDED_ON) && !defined(VARYINGS_NEED_CULLFACE)
            #define VARYINGS_NEED_CULLFACE
        #endif
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
            
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
        #ifdef DEBUG_DISPLAY
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
        #if (SHADERPASS == SHADERPASS_FORWARD)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
        
            #define HAS_LIGHTLOOP
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL; // optional
                float4 tangentOS : TANGENT; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_Position;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_Position; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output;
                output.positionCS = input.positionCS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output;
                output.positionCS = input.positionCS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
      
      #define UNITY_DECLARE_TEX2D(name) TEXTURE2D(name); SAMPLER(sampler_##name);
      #define UNITY_DECLARE_TEX2D_NOSAMPLER(name) TEXTURE2D(name);
      #define UNITY_DECLARE_TEX2DARRAY(name) TEXTURE2D_ARRAY(name); SAMPLER(sampler_##name);
     
      #define UNITY_SAMPLE_TEX2DARRAY(tex,coord)            SAMPLE_TEXTURE2D_ARRAY(tex, sampler_##tex, coord.xy, coord.z)
      #define UNITY_SAMPLE_TEX2DARRAY_LOD(tex,coord,lod)    SAMPLE_TEXTURE2D_ARRAY_LOD(tex, sampler_##tex, coord.xy, coord.z, lod)
      #define UNITY_SAMPLE_TEX2D(tex, coord)                SAMPLE_TEXTURE2D(tex, sampler_##tex, coord)
      #define UNITY_SAMPLE_TEX2D_SAMPLER(tex, samp, coord)  SAMPLE_TEXTURE2D(tex, sampler_##samp, coord)

     
      #if defined(UNITY_COMPILER_HLSL)
         #define UNITY_INITIALIZE_OUTPUT(type,name) name = (type)0;
      #else
         #define UNITY_INITIALIZE_OUTPUT(type,name)
      #endif

      #define sampler2D_float sampler2D
      #define sampler2D_half sampler2D

      


   
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
  
                    float4 _EmissionColor;
                    float _RenderQueueType;
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
                    float _UseShadowThreshold;
                    float _DoubleSidedEnable;
                    float _DoubleSidedNormalMode;
                    float4 _DoubleSidedConstants;
                    

      #if _MESHSUBARRAY
         half4 _MeshSubArrayIndexes;
      #endif


      #if _USEEMISSIVEMETAL
         half _EmissiveMult;
      #endif

      float4 _UVScale; // scale and offset

      float2 _ToonTerrainSize;

      half _Contrast;
      
      float3 _gGlitterLightDir;
      float3 _gGlitterLightWorldPos;
      half3 _gGlitterLightColor;

       #if _VSSHADOWMAP
         float4 gVSSunDirection;
      #endif

      #if _FORCELOCALSPACE && _PLANETVECTORS
         float4x4 _PQSToLocal;
      #endif

      #if _ORIGINSHIFT
         float4x4 _GlobalOriginMTX;
      #endif

      float4 _Control0_TexelSize;
      float4 _CustomControl0_TexelSize;
      float4 _PerPixelNormal_TexelSize;

      #if _CONTROLNOISEUV || _GLOBALNOISEUV
         float2 _NoiseUVParams;
      #endif





      float2 _AlphaData;
      


                    CBUFFER_END
                
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 TangentSpaceNormal; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float Alpha;
                    };


                    
#if defined(UNITY_INSTANCING_ENABLED) 
    #define ENABLE_TERRAIN_PERPIXEL_NORMAL
#endif 
 
#ifndef UNITY_TERRAIN_CB_VARS
    #define UNITY_TERRAIN_CB_VARS
#endif

#ifndef UNITY_TERRAIN_CB_DEBUG_VARS
    #define UNITY_TERRAIN_CB_DEBUG_VARS
#endif

CBUFFER_START(UnityTerrain)
    UNITY_TERRAIN_CB_VARS
#ifdef UNITY_INSTANCING_ENABLED 
    float4 _TerrainHeightmapRecipSize;  // float4(1.0f/width, 1.0f/height, 1.0f/(width-1), 1.0f/(height-1))
    float4 _TerrainHeightmapScale;      // float4(hmScale.x, hmScale.y / (float)(kMaxHeight), hmScale.z, 0.0f)
#endif
#ifdef DEBUG_DISPLAY
    UNITY_TERRAIN_CB_DEBUG_VARS
#endif
CBUFFER_END

#ifdef UNITY_INSTANCING_ENABLED
    TEXTURE2D(_TerrainHeightmapTexture);
    TEXTURE2D(_TerrainNormalmapTexture);
    #ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
        SAMPLER(sampler_TerrainNormalmapTexture);
    #endif
#endif

UNITY_INSTANCING_BUFFER_START(Terrain)
   UNITY_DEFINE_INSTANCED_PROP(float4, _TerrainPatchInstanceData)  // float4(xBase, yBase, skipScale, ~)
UNITY_INSTANCING_BUFFER_END(Terrain)

float4 ConstructTerrainTangent(float3 normal, float3 positiveZ)
{
    // Consider a flat terrain. It should have tangent be (1, 0, 0) and bitangent be (0, 0, 1) as the UV of the terrain grid mesh is a scale of the world XZ position.
    // In CreateTangentToWorld function (in SpaceTransform.hlsl), it is cross(normal, tangent) * sgn for the bitangent vector.
    // It is not true in a left-handed coordinate system for the terrain bitangent, if we provide 1 as the tangent.w. It would produce (0, 0, -1) instead of (0, 0, 1).
    // Also terrain's tangent calculation was wrong in a left handed system because cross((0,0,1), terrainNormalOS) points to the wrong direction as negative X.
    // Therefore all the 4 xyzw components of the tangent needs to be flipped to correct the tangent frame.
    // (See TerrainLitData.hlsl - GetSurfaceAndBuiltinData)
    float3 tangent = cross(normal, positiveZ);
    return float4(tangent, -1);
}


AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
{
#if defined(UNITY_INSTANCING_ENABLED) && !_MICROMESH && !_MICROMESHTERRAIN && !_MICROPOLARISMESH && !_MICRODIGGERMESH && !_MICROVERTEXMESH
    float2 patchVertex = input.positionOS.xy;
    float4 instanceData = UNITY_ACCESS_INSTANCED_PROP(Terrain, _TerrainPatchInstanceData);

    float2 sampleCoords = (patchVertex.xy + instanceData.xy) * instanceData.z; // (xy + float2(xBase,yBase)) * skipScale
    float height = UnpackHeightmap(_TerrainHeightmapTexture.Load(int3(sampleCoords, 0)));

    input.positionOS.xz = sampleCoords * _TerrainHeightmapScale.xz;
    input.positionOS.y = height * _TerrainHeightmapScale.y;
    
    #ifdef ATTRIBUTES_NEED_NORMAL
       input.normalOS = float3(0,1,0);
    #endif

    #if defined(VARYINGS_NEED_TEXCOORD0) || defined(VARYINGS_DS_NEED_TEXCOORD0)
       #ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
          input.uv0.xy = sampleCoords;
       #else
          input.uv0.xy = sampleCoords * _TerrainHeightmapRecipSize.zw;
       #endif
    #endif
#endif


    #ifdef ATTRIBUTES_NEED_TANGENT
       #if !_MICROMESH && !_MICROMESHTERRAIN && !_MICROVERTEXMESH && !_MICROPOLARISMESH
           input.tangentOS = ConstructTerrainTangent(input.normalOS, float3(0, 0, 1));
       #endif
    #endif

    return input;
}

        


                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {

                        SurfaceDescription surface = (SurfaceDescription)0;
 
                        surface.Alpha = 1;
                        return surface;
                    }
                    
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------

        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    // output.positionRWS = input.positionRWS;
                    // output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    // output.texCoord0 = input.texCoord0;
                    // output.texCoord1 = input.texCoord1;
                    // output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    // output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    // output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    // output.WorldSpaceNormal =            normalize(input.tangentToWorld[2].xyz);
                    // output.ObjectSpaceNormal =           mul(output.WorldSpaceNormal, (float3x3) GetObjectToWorldMatrix());           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    // output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    // output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    // output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    // output.WorldSpacePosition =          input.positionRWS;
                    // output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    // output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    // output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    // output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // specularOcclusion need to be init ahead of decal to quiet the compiler that modify the SurfaceData struct
                // however specularOcclusion can come from the graph, so need to be init here so it can be override.
                surfaceData.specularOcclusion = 1.0;
        
                // copy across graph values, if defined
                // surfaceData.baseColor =                 surfaceDescription.Albedo;
                // surfaceData.perceptualSmoothness =      surfaceDescription.Smoothness;
                // surfaceData.ambientOcclusion =          surfaceDescription.Occlusion;
                // surfaceData.specularOcclusion =         surfaceDescription.SpecularOcclusion;
                // surfaceData.metallic =                  surfaceDescription.Metallic;
                // surfaceData.subsurfaceMask =            surfaceDescription.SubsurfaceMask;
                // surfaceData.thickness =                 surfaceDescription.Thickness;
                // surfaceData.diffusionProfileHash =      asuint(surfaceDescription.DiffusionProfileHash);
                // surfaceData.specularColor =             surfaceDescription.Specular;
                // surfaceData.coatMask =                  surfaceDescription.CoatMask;
                // surfaceData.anisotropy =                surfaceDescription.Anisotropy;
                // surfaceData.iridescenceMask =           surfaceDescription.IridescenceMask;
                // surfaceData.iridescenceThickness =      surfaceDescription.IridescenceThickness;
        
        #ifdef _HAS_REFRACTION
                if (_EnableSSRefraction)
                {
                    // surfaceData.ior =                       surfaceDescription.RefractionIndex;
                    // surfaceData.transmittanceColor =        surfaceDescription.RefractionColor;
                    // surfaceData.atDistance =                surfaceDescription.RefractionDistance;
        
                    surfaceData.transmittanceMask = (1.0 - surfaceDescription.Alpha);
                    surfaceDescription.Alpha = 1.0;
                }
                else
                {
                    surfaceData.ior = 1.0;
                    surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                    surfaceData.atDistance = 1.0;
                    surfaceData.transmittanceMask = 0.0;
                    surfaceDescription.Alpha = 1.0;
                }
        #else
                surfaceData.ior = 1.0;
                surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                surfaceData.atDistance = 1.0;
                surfaceData.transmittanceMask = 0.0;
        #endif
                
                // These static material feature allow compile time optimization
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
                // surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
        
        #ifdef _MATERIAL_FEATURE_IRIDESCENCE
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
        #endif
        #ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
        #endif
        
        #if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
                // Require to have setup baseColor
                // Reproduce the energy conservation done in legacy Unity. Not ideal but better for compatibility and users can unchek it
                surfaceData.baseColor *= (1.0 - Max3(surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b));
        #endif
        
        #ifdef _DOUBLESIDED_ON
            float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
        #else
            float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        #endif
        
                // tangent-space normal
                float3 normalTS = float3(0.0f, 0.0f, 1.0f);
                // normalTS = surfaceDescription.Normal;
        
                // compute world space normal
                GetNormalWS(fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants);
        
                surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];
        
                surfaceData.tangentWS = normalize(fragInputs.tangentToWorld[0].xyz);    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
                // surfaceData.tangentWS = TransformTangentToWorld(surfaceDescription.Tangent, fragInputs.tangentToWorld);
        
        #if HAVE_DECALS
                if (_EnableDecals)
                {
                    // Both uses and modifies 'surfaceData.normalWS'.
                    DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
                    ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
                }
        #endif
        
                bentNormalWS = surfaceData.normalWS;
                // GetNormalWS(fragInputs, surfaceDescription.BentNormal, bentNormalWS, doubleSidedConstants);
        
                surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);
        
        
                // By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion.
                // If user provide bent normal then we process a better term
        #if defined(_SPECULAR_OCCLUSION_CUSTOM)
                // Just use the value passed through via the slot (not active otherwise)
        #elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
                // If we have bent normal and ambient occlusion, process a specular occlusion
                surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO(V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness(surfaceData.perceptualSmoothness));
        #elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
                surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
        #endif
        
        #ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
                surfaceData.perceptualSmoothness = GeometricNormalFiltering(surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[2], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold);
        #endif
        
        #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO: need to update mip info
                    surfaceData.metallic = 0;
                }
        
                // We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
                // as it can modify attribute use for static lighting
                ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
        #ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
                uint3 fadeMaskSeed = asuint((int3)(V * _ScreenSize.xyx)); // Quantize V to _ScreenSize values
                LODDitheringTransition(fadeMaskSeed, unity_LODFade.x);
        #endif
        
        #ifdef _DOUBLESIDED_ON
            float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
        #else
            float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        #endif
        
                ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdDepthPrepass);
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdDepthPostpass);
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdShadow);
                
                // ApplyDepthOffsetPositionInput(V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput);
        
                float3 bentNormalWS;
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS);
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal 
                InitBuiltinData(posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[2], fragInputs.texCoord1, fragInputs.texCoord2, builtinData);
        
                // override sampleBakedGI:
                // builtinData.bakeDiffuseLighting = surfaceDescription.BakedGI;
                // builtinData.backBakeDiffuseLighting = surfaceDescription.BakedBackGI;
        
                // builtinData.emissiveColor = surfaceDescription.Emission;
        
                // builtinData.depthOffset = surfaceDescription.DepthOffset;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #else
                builtinData.distortion = float2(0.0, 0.0);
                builtinData.distortionBlur = 0.0;
        #endif
        
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassDepthOnly.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDLitPass.template
            Name "DepthOnly"
            Tags { "LightMode" = "DepthOnly" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            
            Cull [_CullMode]
        
            
            ZWrite On
        
            
            // Stencil setup
        Stencil
        {
           WriteMask [_StencilWriteMaskDepth]
           Ref [_StencilRefDepth]
           Comp Always
           Pass Replace
        }
        
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            #pragma shader_feature_local _TERRAIN_INSTANCED_PERPIXEL_NORMAL
            #pragma multi_compile_instancing
            #pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap renderinglayer
        
        #pragma multi_compile_local _ _ALPHATEST_ON
        
            // #pragma multi_compile _ LOD_FADE_CROSSFADE
        
            #pragma shader_feature _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _DOUBLESIDED_ON
            #pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
            // #define _MATERIAL_FEATURE_SUBSURFACE_SCATTERING 1
            // #define _MATERIAL_FEATURE_TRANSMISSION 1
            // #define _MATERIAL_FEATURE_ANISOTROPY 1
            // #define _MATERIAL_FEATURE_IRIDESCENCE 1
            // #define _MATERIAL_FEATURE_SPECULAR_COLOR 1
            // #define _ENABLE_FOG_ON_TRANSPARENT 1
            // #define _AMBIENT_OCCLUSION 1
            #define _SPECULAR_OCCLUSION_FROM_AO 1
            // #define _SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL 1
            // #define _SPECULAR_OCCLUSION_CUSTOM 1
            #define _ENERGY_CONSERVING_SPECULAR 1
            // #define _ENABLE_GEOMETRIC_SPECULAR_AA 1
            // #define _HAS_REFRACTION 1
            // #define _REFRACTION_PLANE 1
            // #define _REFRACTION_SPHERE 1
            // #define _DISABLE_DECALS 1
            // #define _DISABLE_SSR 1
            // #define _ADD_PRECOMPUTED_VELOCITY
            // #define _WRITE_TRANSPARENT_MOTION_VECTOR 1
            // #define _DEPTHOFFSET_ON 1
            // #define _BLENDMODE_PRESERVE_SPECULAR_LIGHTING 1

            
      #define _MICROSPLAT 1
      #define _ALPHABELOWHEIGHT 1
      #define _MSRENDERLOOP_UNITYHD 1


        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            // If we use subsurface scattering, enable output split lighting (for forward pass)
            #if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
            #define OUTPUT_SPLIT_LIGHTING
            #endif
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Defines
            //-------------------------------------------------------------------------------------
                    #define SHADERPASS SHADERPASS_DEPTH_ONLY
                #pragma multi_compile _ WRITE_NORMAL_BUFFER
                #pragma multi_compile _ WRITE_MSAA_DEPTH
                #define RAYTRACING_SHADER_GRAPH_HIGH
                // ACTIVE FIELDS:
                //   Material.Standard
                //   Specular.EnergyConserving
                //   SpecularOcclusionFromAO
                //   SurfaceDescriptionInputs.TangentSpaceNormal
                //   SurfaceDescriptionInputs.TangentSpaceViewDirection
                //   SurfaceDescriptionInputs.uv0
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.ObjectSpacePosition
                //   SurfaceDescription.Normal
                //   SurfaceDescription.Smoothness
                //   SurfaceDescription.Alpha
                //   features.modifyMesh
                //   VertexDescription.VertexPosition
                //   VertexDescription.VertexNormal
                //   VertexDescription.VertexTangent
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.uv0
                //   AttributesMesh.uv1
                //   AttributesMesh.color
                //   AttributesMesh.uv2
                //   AttributesMesh.uv3
                //   FragInputs.tangentToWorld
                //   FragInputs.positionRWS
                //   FragInputs.texCoord0
                //   FragInputs.texCoord1
                //   FragInputs.texCoord2
                //   FragInputs.texCoord3
                //   FragInputs.color
                //   SurfaceDescriptionInputs.WorldSpaceViewDirection
                //   SurfaceDescriptionInputs.WorldSpaceTangent
                //   SurfaceDescriptionInputs.WorldSpaceBiTangent
                //   SurfaceDescriptionInputs.WorldSpaceNormal
                //   AttributesMesh.positionOS
                //   VaryingsMeshToPS.tangentWS
                //   VaryingsMeshToPS.normalWS
                //   VaryingsMeshToPS.positionRWS
                //   VaryingsMeshToPS.texCoord0
                //   VaryingsMeshToPS.texCoord1
                //   VaryingsMeshToPS.texCoord2
                //   VaryingsMeshToPS.texCoord3
                //   VaryingsMeshToPS.color
                // Shared Graph Keywords
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define ATTRIBUTES_NEED_TEXCOORD3
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD1
            #define VARYINGS_NEED_TEXCOORD2
            #define VARYINGS_NEED_TEXCOORD3
            //#define VARYINGS_NEED_COLOR
            // #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
        // We need isFontFace when using double sided
        #if defined(_DOUBLESIDED_ON) && !defined(VARYINGS_NEED_CULLFACE)
            #define VARYINGS_NEED_CULLFACE
        #endif
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
            
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
        #ifdef DEBUG_DISPLAY
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
        #if (SHADERPASS == SHADERPASS_FORWARD)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
        
            #define HAS_LIGHTLOOP
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL; // optional
                float4 tangentOS : TANGENT; // optional
                float4 uv0 : TEXCOORD0; // optional
                float4 uv1 : TEXCOORD1; // optional
                float4 uv2 : TEXCOORD2; // optional
                float4 uv3 : TEXCOORD3; // optional
                //float4 color : COLOR; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_Position;
                float3 positionRWS; // optional
                float3 normalWS; // optional
                float4 tangentWS; // optional
                float4 texCoord0; // optional
                float4 texCoord1; // optional
                float4 texCoord2; // optional
                float4 texCoord3; // optional
                //float4 color; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_Position; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
                float4 interp02 : TEXCOORD2; // auto-packed
                float4 interp03 : TEXCOORD3; // auto-packed
                float4 interp04 : TEXCOORD4; // auto-packed
                float4 interp05 : TEXCOORD5; // auto-packed
                float4 interp06 : TEXCOORD6; // auto-packed
                //float4 interp07 : TEXCOORD7; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                output.interp03.xyzw = input.texCoord0;
                output.interp04.xyzw = input.texCoord1;
                output.interp05.xyzw = input.texCoord2;
                output.interp06.xyzw = input.texCoord3;
                //output.interp07.xyzw = input.color;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                output.texCoord0 = input.interp03.xyzw;
                output.texCoord1 = input.interp04.xyzw;
                output.texCoord2 = input.interp05.xyzw;
                output.texCoord3 = input.interp06.xyzw;
                //output.color = input.interp07.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
      
      #define UNITY_DECLARE_TEX2D(name) TEXTURE2D(name); SAMPLER(sampler_##name);
      #define UNITY_DECLARE_TEX2D_NOSAMPLER(name) TEXTURE2D(name);
      #define UNITY_DECLARE_TEX2DARRAY(name) TEXTURE2D_ARRAY(name); SAMPLER(sampler_##name);
     
      #define UNITY_SAMPLE_TEX2DARRAY(tex,coord)            SAMPLE_TEXTURE2D_ARRAY(tex, sampler_##tex, coord.xy, coord.z)
      #define UNITY_SAMPLE_TEX2DARRAY_LOD(tex,coord,lod)    SAMPLE_TEXTURE2D_ARRAY_LOD(tex, sampler_##tex, coord.xy, coord.z, lod)
      #define UNITY_SAMPLE_TEX2D(tex, coord)                SAMPLE_TEXTURE2D(tex, sampler_##tex, coord)
      #define UNITY_SAMPLE_TEX2D_SAMPLER(tex, samp, coord)  SAMPLE_TEXTURE2D(tex, sampler_##samp, coord)

     
      #if defined(UNITY_COMPILER_HLSL)
         #define UNITY_INITIALIZE_OUTPUT(type,name) name = (type)0;
      #else
         #define UNITY_INITIALIZE_OUTPUT(type,name)
      #endif

      #define sampler2D_float sampler2D
      #define sampler2D_half sampler2D

      


   
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 _EmissionColor;
                    float _RenderQueueType;
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
                    float _UseShadowThreshold;
                    float _DoubleSidedEnable;
                    float _DoubleSidedNormalMode;
                    float4 _DoubleSidedConstants;
                    

      #if _MESHSUBARRAY
         half4 _MeshSubArrayIndexes;
      #endif


      #if _USEEMISSIVEMETAL
         half _EmissiveMult;
      #endif

      float4 _UVScale; // scale and offset

      float2 _ToonTerrainSize;

      half _Contrast;
      
      float3 _gGlitterLightDir;
      float3 _gGlitterLightWorldPos;
      half3 _gGlitterLightColor;

       #if _VSSHADOWMAP
         float4 gVSSunDirection;
      #endif

      #if _FORCELOCALSPACE && _PLANETVECTORS
         float4x4 _PQSToLocal;
      #endif

      #if _ORIGINSHIFT
         float4x4 _GlobalOriginMTX;
      #endif

      float4 _Control0_TexelSize;
      float4 _CustomControl0_TexelSize;
      float4 _PerPixelNormal_TexelSize;

      #if _CONTROLNOISEUV || _GLOBALNOISEUV
         float2 _NoiseUVParams;
      #endif





      float2 _AlphaData;
      


                    CBUFFER_END
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpaceNormal; // optional
                        float3 TangentSpaceNormal; // optional
                        float3 WorldSpaceTangent; // optional
                        float3 WorldSpaceBiTangent; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 TangentSpaceViewDirection; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                        float4 uv0; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Normal;
                        float Smoothness;
                        float Alpha;
                    };
                    
                
#if defined(UNITY_INSTANCING_ENABLED) 
    #define ENABLE_TERRAIN_PERPIXEL_NORMAL
#endif 
 
#ifndef UNITY_TERRAIN_CB_VARS
    #define UNITY_TERRAIN_CB_VARS
#endif

#ifndef UNITY_TERRAIN_CB_DEBUG_VARS
    #define UNITY_TERRAIN_CB_DEBUG_VARS
#endif

CBUFFER_START(UnityTerrain)
    UNITY_TERRAIN_CB_VARS
#ifdef UNITY_INSTANCING_ENABLED 
    float4 _TerrainHeightmapRecipSize;  // float4(1.0f/width, 1.0f/height, 1.0f/(width-1), 1.0f/(height-1))
    float4 _TerrainHeightmapScale;      // float4(hmScale.x, hmScale.y / (float)(kMaxHeight), hmScale.z, 0.0f)
#endif
#ifdef DEBUG_DISPLAY
    UNITY_TERRAIN_CB_DEBUG_VARS
#endif
CBUFFER_END

#ifdef UNITY_INSTANCING_ENABLED
    TEXTURE2D(_TerrainHeightmapTexture);
    TEXTURE2D(_TerrainNormalmapTexture);
    #ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
        SAMPLER(sampler_TerrainNormalmapTexture);
    #endif
#endif

UNITY_INSTANCING_BUFFER_START(Terrain)
   UNITY_DEFINE_INSTANCED_PROP(float4, _TerrainPatchInstanceData)  // float4(xBase, yBase, skipScale, ~)
UNITY_INSTANCING_BUFFER_END(Terrain)

float4 ConstructTerrainTangent(float3 normal, float3 positiveZ)
{
    // Consider a flat terrain. It should have tangent be (1, 0, 0) and bitangent be (0, 0, 1) as the UV of the terrain grid mesh is a scale of the world XZ position.
    // In CreateTangentToWorld function (in SpaceTransform.hlsl), it is cross(normal, tangent) * sgn for the bitangent vector.
    // It is not true in a left-handed coordinate system for the terrain bitangent, if we provide 1 as the tangent.w. It would produce (0, 0, -1) instead of (0, 0, 1).
    // Also terrain's tangent calculation was wrong in a left handed system because cross((0,0,1), terrainNormalOS) points to the wrong direction as negative X.
    // Therefore all the 4 xyzw components of the tangent needs to be flipped to correct the tangent frame.
    // (See TerrainLitData.hlsl - GetSurfaceAndBuiltinData)
    float3 tangent = cross(normal, positiveZ);
    return float4(tangent, -1);
}


AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
{
#if defined(UNITY_INSTANCING_ENABLED) && !_MICROMESH && !_MICROMESHTERRAIN && !_MICROPOLARISMESH && !_MICRODIGGERMESH && !_MICROVERTEXMESH
    float2 patchVertex = input.positionOS.xy;
    float4 instanceData = UNITY_ACCESS_INSTANCED_PROP(Terrain, _TerrainPatchInstanceData);

    float2 sampleCoords = (patchVertex.xy + instanceData.xy) * instanceData.z; // (xy + float2(xBase,yBase)) * skipScale
    float height = UnpackHeightmap(_TerrainHeightmapTexture.Load(int3(sampleCoords, 0)));

    input.positionOS.xz = sampleCoords * _TerrainHeightmapScale.xz;
    input.positionOS.y = height * _TerrainHeightmapScale.y;
    
    #ifdef ATTRIBUTES_NEED_NORMAL
       input.normalOS = float3(0,1,0);
    #endif

    #if defined(VARYINGS_NEED_TEXCOORD0) || defined(VARYINGS_DS_NEED_TEXCOORD0)
       #ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
          input.uv0.xy = sampleCoords;
       #else
          input.uv0.xy = sampleCoords * _TerrainHeightmapRecipSize.zw;
       #endif
    #endif
#endif


    #ifdef ATTRIBUTES_NEED_TANGENT
       #if !_MICROMESH && !_MICROMESHTERRAIN && !_MICROVERTEXMESH && !_MICROPOLARISMESH
           input.tangentOS = ConstructTerrainTangent(input.normalOS, float3(0, 0, 1));
       #endif
    #endif

    return input;
}

        
                

                    

      // dynamic branching helpers, for regular and aggressive branching
      // debug mode shows how many samples using branching will save us. 
      //
      // These macros are always used instead of the UNITY_BRANCH macro
      // to maintain debug displays and allow branching to be disabled
      // on as granular level as we want. 
      
      #if _BRANCHSAMPLES
         #if _DEBUG_BRANCHCOUNT_WEIGHT || _DEBUG_BRANCHCOUNT_TOTAL
            float _branchWeightCount;
            #define MSBRANCH(w) if (w > 0) _branchWeightCount++; if (w > 0)
         #else
            #define MSBRANCH(w) UNITY_BRANCH if (w > 0)
         #endif
      #else
         #if _DEBUG_BRANCHCOUNT_WEIGHT || _DEBUG_BRANCHCOUNT_TOTAL
            float _branchWeightCount;
            #define MSBRANCH(w) if (w > 0) _branchWeightCount++;
         #else
            #define MSBRANCH(w) 
         #endif
      #endif
      
      #if _BRANCHSAMPLESAGR
         #if _DEBUG_BRANCHCOUNT_TRIPLANAR || _DEBUG_BRANCHCOUNT_CLUSTER || _DEBUG_BRANCHCOUNT_OTHER ||_DEBUG_BRANCHCOUNT_TOTAL
            float _branchTriplanarCount;
            float _branchClusterCount;
            float _branchOtherCount;
            #define MSBRANCHTRIPLANAR(w) if (w > 0.001) _branchTriplanarCount++; if (w > 0.001)
            #define MSBRANCHCLUSTER(w) if (w > 0.001) _branchClusterCount++; if (w > 0.001)
            #define MSBRANCHOTHER(w) if (w > 0.001) _branchOtherCount++; if (w > 0.001)
         #else
            #define MSBRANCHTRIPLANAR(w) UNITY_BRANCH if (w > 0.001)
            #define MSBRANCHCLUSTER(w) UNITY_BRANCH if (w > 0.001)
            #define MSBRANCHOTHER(w) UNITY_BRANCH if (w > 0.001)
         #endif
      #else
         #if _DEBUG_BRANCHCOUNT_TRIPLANAR || _DEBUG_BRANCHCOUNT_CLUSTER || _DEBUG_BRANCHCOUNT_OTHER || _DEBUG_BRANCHCOUNT_TOTAL
            float _branchTriplanarCount;
            float _branchClusterCount;
            float _branchOtherCount;
            #define MSBRANCHTRIPLANAR(w) if (w > 0.001) _branchTriplanarCount++;
            #define MSBRANCHCLUSTER(w) if (w > 0.001) _branchClusterCount++;
            #define MSBRANCHOTHER(w) if (w > 0.001) _branchOtherCount++;
         #else
            #define MSBRANCHTRIPLANAR(w)
            #define MSBRANCHCLUSTER(w)
            #define MSBRANCHOTHER(w)
         #endif
      #endif

      #if _DEBUG_SAMPLECOUNT
         int _sampleCount;
         #define COUNTSAMPLE { _sampleCount++; }
      #else
         #define COUNTSAMPLE
      #endif

      #if _DEBUG_PROCLAYERS
         int _procLayerCount;
         #define COUNTPROCLAYER { _procLayerCount++; }
      #else
         #define COUNTPROCLAYER
      #endif


      #if _DEBUG_USE_TOPOLOGY
         UNITY_DECLARE_TEX2D_NOSAMPLER(_DebugWorldPos);
         UNITY_DECLARE_TEX2D_NOSAMPLER(_DebugWorldNormal);
      #endif
      

      // splat
      UNITY_DECLARE_TEX2DARRAY(_Diffuse);
      float4 _Diffuse_TexelSize;
      UNITY_DECLARE_TEX2DARRAY(_NormalSAO);
      float4 _NormalSAO_TexelSize;

      #if _CONTROLNOISEUV || _GLOBALNOISEUV
         UNITY_DECLARE_TEX2D_NOSAMPLER(_NoiseUV);
      #endif

      #if _PACKINGHQ
         UNITY_DECLARE_TEX2DARRAY(_SmoothAO);
         float4 _SmoothAO_TexelSize;
      #endif

      #if _USESPECULARWORKFLOW
         UNITY_DECLARE_TEX2DARRAY(_Specular);
         float4 _Specular_TexelSize;
      #endif

      #if _USEEMISSIVEMETAL
         UNITY_DECLARE_TEX2DARRAY(_EmissiveMetal);
         float4 _EmissiveMetal_TexelSize;
      #endif

      
      UNITY_DECLARE_TEX2D_NOSAMPLER(_PerPixelNormal);
      
      UNITY_DECLARE_TEX2D(_Control0);
      #if _CUSTOMSPLATTEXTURES
         UNITY_DECLARE_TEX2D(_CustomControl0);
         #if !_MAX4TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl1);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl2);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl3);
         #endif
         #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl4);
         #endif
         #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl5);
         #endif
         #if _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl6);
         #endif
         #if _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl7);
         #endif
      #else
         #if !_MAX4TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control1);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control2);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control3);
         #endif
         #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control4);
         #endif
         #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control5);
         #endif
         #if _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control6);
         #endif
         #if _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control7);
         #endif
      #endif

      sampler2D_float _PerTexProps;
   



      struct TriGradMipFormat
      {
         float4 d0;
         float4 d1;
         float4 d2;
      };

      half InverseLerp(half x, half y, half v) { return (v-x)/max(y-x, 0.001); }
      half2 InverseLerp(half2 x, half2 y, half2 v) { return (v-x)/max(y-x, half2(0.001, 0.001)); }
      half3 InverseLerp(half3 x, half3 y, half3 v) { return (v-x)/max(y-x, half3(0.001, 0.001, 0.001)); }
      half4 InverseLerp(half4 x, half4 y, half4 v) { return (v-x)/max(y-x, half4(0.001, 0.001, 0.001, 0.001)); }
      

      // 2019.3 holes
      #ifdef _ALPHATEST_ON
          UNITY_DECLARE_TEX2D(_TerrainHolesTexture);

          void ClipHoles(float2 uv)
          {
              float hole = UNITY_SAMPLE_TEX2D(_TerrainHolesTexture, uv).r;
              COUNTSAMPLE
              clip(hole < 0.5f ? -1 : 1);
          }
      #endif

      
      #if _TRIPLANAR
         #if _USEGRADMIP
            #define MIPFORMAT TriGradMipFormat
            #define INITMIPFORMAT (TriGradMipFormat)0;
            #define MIPFROMATRAW float4
         #else
            #define MIPFORMAT float3
            #define INITMIPFORMAT 0;
            #define MIPFROMATRAW float3
         #endif
      #else
         #if _USEGRADMIP
            #define MIPFORMAT float4
            #define INITMIPFORMAT 0;
            #define MIPFROMATRAW float4
         #else
            #define MIPFORMAT float
            #define INITMIPFORMAT 0;
            #define MIPFROMATRAW float
         #endif
      #endif

      float2 RotateUV(float2 uv, float amt)
      {
         uv -=0.5;
         float s = sin ( amt);
         float c = cos ( amt );
         float2x2 mtx = float2x2( c, -s, s, c);
         mtx *= 0.5;
         mtx += 0.5;
         mtx = mtx * 2-1;
         uv = mul ( uv, mtx );
         uv += 0.5;
         return uv;
      }

      float4 DecodeToFloat4(float v)
      {
         uint vi = (uint)(v * (256.0f * 256.0f * 256.0f * 256.0f));
         int ex = (int)(vi / (256 * 256 * 256) % 256);
         int ey = (int)((vi / (256 * 256)) % 256);
         int ez = (int)((vi / (256)) % 256);
         int ew = (int)(vi % 256);
         float4 e = float4(ex / 255.0, ey / 255.0, ez / 255.0, ew / 255.0);
         return e;
      }

      struct Input 
      {
         float2 uv_Control0;
         #if (_MICROMESH && _MESHUV2)
         float2 uv2_Diffuse;
         #endif

         float3 viewDir;
         float3 worldPos;
         float3 worldNormal;
         #if _TERRAINBLENDING
         float4 color : COLOR;
         #endif
         #if _MSRENDERLOOP_SURFACESHADER
         INTERNAL_DATA
         #else
         float3x3 TBN;
         #endif

         #if _MICRODIGGERMESH || _MICROVERTEXMESH
            half4 w0;
            #if !_MAX4TEXTURES
               half4 w1;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES
               half4 w2;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
               half4 w3;
            #endif
            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               half4 w4;
            #endif
            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               half4 w5;
            #endif
            #if (_MAX28TEXTURES || _MAX32TEXTURES) && !_STREAMS && !_LAVA && !_WETNESS && !_PUDDLES
               half4 w6;
            #endif

            #if _STEAMS || _WETNESS || _LAVA || _PUDDLES
               half4 s0;
            #endif

         #endif
      };
      
      struct TriplanarConfig
      {
         float3x3 uv0;
         float3x3 uv1;
         float3x3 uv2;
         float3x3 uv3;
         half3 pN;
         half3 pN0;
         half3 pN1;
         half3 pN2;
         half3 pN3;
         half3 axisSign;
         Input IN;
      };


      struct Config
      {
         float2 uv;
         float3 uv0;
         float3 uv1;
         float3 uv2;
         float3 uv3;

         half4 cluster0;
         half4 cluster1;
         half4 cluster2;
         half4 cluster3;

      };


      struct MicroSplatLayer
      {
         half3 Albedo;
         half3 Normal;
         half Smoothness;
         half Occlusion;
         half Metallic;
         half Height;
         half3 Emission;
         #if _USESPECULARWORKFLOW
         half3 Specular;
         #endif
         half Alpha;
         
      };


      struct appdata 
      {
         float4 vertex : POSITION;
         float4 tangent : TANGENT;
         float3 normal : NORMAL;
         float2 texcoord : TEXCOORD0;
         float4 texcoord1 : TEXCOORD1;
         float4 texcoord2 : TEXCOORD2;
         #if _TERRAINBLENDING || _MICRODIGGERMESH || _MICROVERTEXMESH
         half4 color : COLOR;
         #endif
         UNITY_VERTEX_INPUT_INSTANCE_ID
         UNITY_VERTEX_OUTPUT_STEREO
      };


      // raw, unblended samples from arrays
      struct RawSamples
      {
         half4 albedo0;
         half4 albedo1;
         half4 albedo2;
         half4 albedo3;
         half4 normSAO0;
         half4 normSAO1;
         half4 normSAO2;
         half4 normSAO3;
         #if _USEEMISSIVEMETAL || _GLOBALEMIS || _GLOBALSMOOTHAOMETAL || _PERTEXSSS
            half4 emisMetal0;
            half4 emisMetal1;
            half4 emisMetal2;
            half4 emisMetal3;
         #endif
         #if _USESPECULARWORKFLOW
            half3 specular0;
            half3 specular1;
            half3 specular2;
            half3 specular3;
         #endif
      };

      void InitRawSamples(inout RawSamples s)
      {
         s.normSAO0 = half4(0,0,0,1);
         s.normSAO1 = half4(0,0,0,1);
         s.normSAO2 = half4(0,0,0,1);
         s.normSAO3 = half4(0,0,0,1);
      }

       float3 GetGlobalLightDir(Input i)
      {
         float3 lightDir = float3(1,0,0);

         #if _MSRENDERLOOP_UNITYHD || PASS_DEFERRED
            lightDir = normalize(_gGlitterLightDir.xyz);
         #elif _MSRENDERLOOP_UNITYLD
            lightDir = GetMainLight().direction;
         #else
            #ifndef USING_DIRECTIONAL_LIGHT
               lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
            #else
               lightDir = normalize(_WorldSpaceLightPos0.xyz);
            #endif
         #endif
         return lightDir;
      }

      float3 GetGlobalLightDirTS(Input i)
      {
         float3 lightDirWS = GetGlobalLightDir(i);
        
         #if _MSRENDERLOOP_UNITYHD || _MSRENDERLOOP_UNITYLD
            return mul( i.TBN, lightDirWS).xyz;
         #else
            float3 t2w0 = WorldNormalVector(i, float3(1,0,0));
            float3 t2w1 = WorldNormalVector(i, float3(0,1,0));
            float3 t2w2 = WorldNormalVector(i, float3(0,0,1));
            float3x3 t2w = float3x3(t2w0, t2w1, t2w2);
            return mul( t2w, lightDirWS).xyz;
         #endif
      }
      
      half3 GetGlobalLightColor()
      {
         #if _MSRENDERLOOP_UNITYHD || PASS_DEFERRED
            return _gGlitterLightColor;
         #elif _MSRENDERLOOP_UNITYLD
            return normalize(GetMainLight().color);
         #else
            return _LightColor0.rgb;
         #endif
      }



      half3 FuzzyShade(half3 color, half3 normal, half coreMult, half edgeMult, half power, float3 viewDir)
      {
         half dt = saturate(dot(viewDir, normal));
         half dark = 1.0 - (coreMult * dt);
         half edge = pow(1-dt, power) * edgeMult;
         return color * (dark + edge);
      }

      half3 ComputeSSS(Input i, float3 V, float3 N, half3 tint, half thickness, half distortion, half scale, half power)
      {
         float3 L = GetGlobalLightDir(i);
         half3 lightColor = GetGlobalLightColor();
         float3 H = normalize(L + N * distortion);
         float VdotH = pow(saturate(dot(V, -H)), power) * scale;
         float3 I =  (VdotH) * thickness;
         return lightColor * I * tint;
      }


      #if _MAX2LAYER
         inline half BlendWeights(half s1, half s2, half s3, half s4, half4 w)      { return s1 * w.x + s2 * w.y; }
         inline half2 BlendWeights(half2 s1, half2 s2, half2 s3, half2 s4, half4 w) { return s1 * w.x + s2 * w.y; }
         inline half3 BlendWeights(half3 s1, half3 s2, half3 s3, half3 s4, half4 w) { return s1 * w.x + s2 * w.y; }
         inline half4 BlendWeights(half4 s1, half4 s2, half4 s3, half4 s4, half4 w) { return s1 * w.x + s2 * w.y; }
      #elif _MAX3LAYER
         inline half BlendWeights(half s1, half s2, half s3, half s4, half4 w)      { return s1 * w.x + s2 * w.y + s3 * w.z; }
         inline half2 BlendWeights(half2 s1, half2 s2, half2 s3, half2 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z; }
         inline half3 BlendWeights(half3 s1, half3 s2, half3 s3, half3 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z; }
         inline half4 BlendWeights(half4 s1, half4 s2, half4 s3, half4 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z; }
      #else
         inline half BlendWeights(half s1, half s2, half s3, half s4, half4 w)      { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
         inline half2 BlendWeights(half2 s1, half2 s2, half2 s3, half2 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
         inline half3 BlendWeights(half3 s1, half3 s2, half3 s3, half3 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
         inline half4 BlendWeights(half4 s1, half4 s2, half4 s3, half4 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
      #endif

      #if _MAX3LAYER
         #define SAMPLE_PER_TEX(varName, pixel, config, defVal) \
            half4 varName##0 = defVal; \
            half4 varName##1 = defVal; \
            half4 varName##2 = defVal; \
            half4 varName##3 = defVal; \
            varName##0 = tex2Dlod(_PerTexProps, float4(config.uv0.z/32, pixel/32, 0, 0)); \
            varName##1 = tex2Dlod(_PerTexProps, float4(config.uv1.z/32, pixel/32, 0, 0)); \
            varName##2 = tex2Dlod(_PerTexProps, float4(config.uv2.z/32, pixel/32, 0, 0)); \

      #elif _MAX2LAYER
         #define SAMPLE_PER_TEX(varName, pixel, config, defVal) \
            half4 varName##0 = defVal; \
            half4 varName##1 = defVal; \
            half4 varName##2 = defVal; \
            half4 varName##3 = defVal; \
            varName##0 = tex2Dlod(_PerTexProps, float4(config.uv0.z/32, pixel/32, 0, 0)); \
            varName##1 = tex2Dlod(_PerTexProps, float4(config.uv1.z/32, pixel/32, 0, 0)); \

      #else
         #define SAMPLE_PER_TEX(varName, pixel, config, defVal) \
            half4 varName##0 = tex2Dlod(_PerTexProps, float4(config.uv0.z/32, pixel/32, 0, 0)); \
            half4 varName##1 = tex2Dlod(_PerTexProps, float4(config.uv1.z/32, pixel/32, 0, 0)); \
            half4 varName##2 = tex2Dlod(_PerTexProps, float4(config.uv2.z/32, pixel/32, 0, 0)); \
            half4 varName##3 = tex2Dlod(_PerTexProps, float4(config.uv3.z/32, pixel/32, 0, 0)); \

      #endif
      
      half3 BlendNormal3(half3 n1, half3 n2)
      {
         n1.z += 1;
         n2.xy = -n2.xy;

         return n1 * dot(n1, n2) / n1.z - n2;
      }
      
      half2 TransformTriplanarNormal(Input IN, float3x3 t2w, half3 axisSign, half3 absVertNormal,
               half3 pN, half2 a0, half2 a1, half2 a2)
      {
         a0 = a0 * 2 - 1;
         a1 = a1 * 2 - 1;
         a2 = a2 * 2 - 1;
         
         a0.x *= axisSign.x;
         a1.x *= axisSign.y;
         a2.x *= axisSign.z;
         
         half3 n0 = half3(a0.xy, 1);
         half3 n1 = half3(a1.xy, 1);
         half3 n2 = half3(a2.xy, 1);
         
         n0 = BlendNormal3(half3(IN.worldNormal.zy, absVertNormal.x), n0);
         n1 = BlendNormal3(half3(IN.worldNormal.xz, absVertNormal.y), n1);
         n2 = BlendNormal3(half3(IN.worldNormal.xy, absVertNormal.z), n2);
  
         n0.z *= axisSign.x;
         n1.z *= axisSign.y;
         n2.z *= -axisSign.z;
  
         half3 worldNormal = (n0.zyx * pN.x + n1.xzy * pN.y + n2.xyz * pN.z );
         return mul(t2w, worldNormal).xy;
      }
      
      // funcs
      
      inline half MSLuminance(half3 rgb)
      {
         #ifdef UNITY_COLORSPACE_GAMMA
            return dot(rgb, half3(0.22, 0.707, 0.071));
         #else
            return dot(rgb, half3(0.0396819152, 0.458021790, 0.00609653955));
         #endif
      }
      
      
      float2 Hash2D( float2 x )
      {
          float2 k = float2( 0.3183099, 0.3678794 );
          x = x*k + k.yx;
          return -1.0 + 2.0*frac( 16.0 * k*frac( x.x*x.y*(x.x+x.y)) );
      }

      float Noise2D(float2 p )
      {
         float2 i = floor( p );
         float2 f = frac( p );
         
         float2 u = f*f*(3.0-2.0*f);

         return lerp( lerp( dot( Hash2D( i + float2(0.0,0.0) ), f - float2(0.0,0.0) ), 
                           dot( Hash2D( i + float2(1.0,0.0) ), f - float2(1.0,0.0) ), u.x),
                      lerp( dot( Hash2D( i + float2(0.0,1.0) ), f - float2(0.0,1.0) ), 
                           dot( Hash2D( i + float2(1.0,1.0) ), f - float2(1.0,1.0) ), u.x), u.y);
      }
      
      float FBM2D(float2 uv)
      {
         float f = 0.5000*Noise2D( uv ); uv *= 2.01;
         f += 0.2500*Noise2D( uv ); uv *= 1.96;
         f += 0.1250*Noise2D( uv ); 
         return f;
      }
      
      float3 Hash3D( float3 p )
      {
         p = float3( dot(p,float3(127.1,311.7, 74.7)),
                 dot(p,float3(269.5,183.3,246.1)),
                 dot(p,float3(113.5,271.9,124.6)));

         return -1.0 + 2.0*frac(sin(p)*437.5453123);
      }

      float Noise3D( float3 p )
      {
         float3 i = floor( p );
         float3 f = frac( p );
         
         float3 u = f*f*(3.0-2.0*f);

         return lerp( lerp( lerp( dot( Hash3D( i + float3(0.0,0.0,0.0) ), f - float3(0.0,0.0,0.0) ), 
                                dot( Hash3D( i + float3(1.0,0.0,0.0) ), f - float3(1.0,0.0,0.0) ), u.x),
                           lerp( dot( Hash3D( i + float3(0.0,1.0,0.0) ), f - float3(0.0,1.0,0.0) ), 
                                dot( Hash3D( i + float3(1.0,1.0,0.0) ), f - float3(1.0,1.0,0.0) ), u.x), u.y),
                      lerp( lerp( dot( Hash3D( i + float3(0.0,0.0,1.0) ), f - float3(0.0,0.0,1.0) ), 
                                dot( Hash3D( i + float3(1.0,0.0,1.0) ), f - float3(1.0,0.0,1.0) ), u.x),
                           lerp( dot( Hash3D( i + float3(0.0,1.0,1.0) ), f - float3(0.0,1.0,1.0) ), 
                                dot( Hash3D( i + float3(1.0,1.0,1.0) ), f - float3(1.0,1.0,1.0) ), u.x), u.y), u.z );
      }
      
      float FBM3D(float3 uv)
      {
         float f = 0.5000*Noise3D( uv ); uv *= 2.01;
         f += 0.2500*Noise3D( uv ); uv *= 1.96;
         f += 0.1250*Noise3D( uv ); 
         return f;
      }
      
      half2 BlendNormal2(half2 base, half2 blend) { return normalize(half3(base.xy + blend.xy, 1)).xy; } 
      half3 BlendOverlay(half3 base, half3 blend) { return (base < 0.5 ? (2.0 * base * blend) : (1.0 - 2.0 * (1.0 - base) * (1.0 - blend))); }
      half3 BlendMult2X(half3  base, half3 blend) { return (base * (blend * 2)); }
      half3 BlendLighterColor(half3 s, half3 d) { return (s.x + s.y + s.z > d.x + d.y + d.z) ? s : d; } 
      
      float GetSaturation(float3 c)
      {
         float mi = min(min(c.x, c.y), c.z);
         float ma = max(max(c.x, c.y), c.z);
         return (ma - mi)/(ma + 1e-7);
      }

      // Better Color Lerp, does not have darkening issue
      float3 BetterColorLerp(float3 a, float3 b, float x)
      {
         float3 ic = lerp(a, b, x) + float3(1e-6,0.0,0.0);
         float sd = abs(GetSaturation(ic) - lerp(GetSaturation(a), GetSaturation(b), x));
    
         float3 dir = normalize(float3(2.0 * ic.x - ic.y - ic.z, 2.0 * ic.y - ic.x - ic.z, 2.0 * ic.z - ic.y - ic.x));
         float lgt = dot(float3(1.0, 1.0, 1.0), ic);
    
         float ff = dot(dir, normalize(ic));
    
         const float dsp_str = 1.5;
         ic += dsp_str * dir * sd * ff * lgt;
         return saturate(ic);
      }
      
      
      half4 ComputeWeights(half4 iWeights, half h0, half h1, half h2, half h3, half contrast)
      {
          #if _DISABLEHEIGHTBLENDING
             return iWeights;
          #else
             // compute weight with height map
             //half4 weights = half4(iWeights.x * h0, iWeights.y * h1, iWeights.z * h2, iWeights.w * h3);
             half4 weights = half4(iWeights.x * max(h0,0.001), iWeights.y * max(h1,0.001), iWeights.z * max(h2,0.001), iWeights.w * max(h3,0.001));
             
             // Contrast weights
             half maxWeight = max(max(weights.x, max(weights.y, weights.z)), weights.w);
             half transition = max(contrast * maxWeight, 0.0001);
             half threshold = maxWeight - transition;
             half scale = 1.0 / transition;
             weights = saturate((weights - threshold) * scale);
             // Normalize weights.
             half weightScale = 1.0f / (weights.x + weights.y + weights.z + weights.w);
             weights *= weightScale;
             return weights;
          #endif
      }

      half HeightBlend(half h1, half h2, half slope, half contrast)
      {
         #if _DISABLEHEIGHTBLENDING
            return slope;
         #else
            h2 = 1 - h2;
            half tween = saturate((slope - min(h1, h2)) / max(abs(h1 - h2), 0.001)); 
            half blend = saturate( ( tween - (1-contrast) ) / max(contrast, 0.001));
            return blend;
         #endif
      }

      #if _MAX4TEXTURES
         #define TEXCOUNT 4
      #elif _MAX8TEXTURES
         #define TEXCOUNT 8
      #elif _MAX12TEXTURES
         #define TEXCOUNT 12
      #elif _MAX20TEXTURES
         #define TEXCOUNT 20
      #elif _MAX24TEXTURES
         #define TEXCOUNT 24
      #elif _MAX28TEXTURES
         #define TEXCOUNT 28
      #elif _MAX32TEXTURES
         #define TEXCOUNT 32
      #else
         #define TEXCOUNT 16
      #endif


      void Setup(out half4 weights, float2 uv, out Config config, half4 w0, half4 w1, half4 w2, half4 w3, half4 w4, half4 w5, half4 w6, half4 w7, float3 worldPos)
      {
         config = (Config)0;
         half4 indexes = 0;

         config.uv = uv;

         #if _WORLDUV
         uv = worldPos.xz;
         #endif

         #if _DISABLESPLATMAPS
            float2 scaledUV = uv;
         #else
            float2 scaledUV = uv * _UVScale.xy + _UVScale.zw;
         #endif

         // if only 4 textures, and blending 4 textures, skip this whole thing..
         // this saves about 25% of the ALU of the base shader on low end. However if
         // we rely on sorted texture weights (distance resampling) we have to sort..
         float4 defaultIndexes = float4(0,1,2,3);
         #if _MESHSUBARRAY
            defaultIndexes = _MeshSubArrayIndexes;
         #endif

         #if _MESHSUBARRAY || (_MAX4TEXTURES && !_MAX3LAYER && !_MAX2LAYER && !_DISTANCERESAMPLE && !_POM)
            weights = w0;
            config.uv0 = float3(scaledUV, defaultIndexes.x);
            config.uv1 = float3(scaledUV, defaultIndexes.y);
            config.uv2 = float3(scaledUV, defaultIndexes.z);
            config.uv3 = float3(scaledUV, defaultIndexes.w);
            return;
         #endif

         #if _DISABLESPLATMAPS
            weights = float4(1,0,0,0);
            return;
         #else
            half splats[TEXCOUNT];

            splats[0] = w0.x;
            splats[1] = w0.y;
            splats[2] = w0.z;
            splats[3] = w0.w;
            #if !_MAX4TEXTURES
               splats[4] = w1.x;
               splats[5] = w1.y;
               splats[6] = w1.z;
               splats[7] = w1.w;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES
               splats[8] = w2.x;
               splats[9] = w2.y;
               splats[10] = w2.z;
               splats[11] = w2.w;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
               splats[12] = w3.x;
               splats[13] = w3.y;
               splats[14] = w3.z;
               splats[15] = w3.w;
            #endif
            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               splats[16] = w4.x;
               splats[17] = w4.y;
               splats[18] = w4.z;
               splats[19] = w4.w;
            #endif
            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               splats[20] = w5.x;
               splats[21] = w5.y;
               splats[22] = w5.z;
               splats[23] = w5.w;
            #endif
            #if _MAX28TEXTURES || _MAX32TEXTURES
               splats[24] = w6.x;
               splats[25] = w6.y;
               splats[26] = w6.z;
               splats[27] = w6.w;
            #endif
            #if _MAX32TEXTURES
               splats[28] = w7.x;
               splats[29] = w7.y;
               splats[30] = w7.z;
               splats[31] = w7.w;
            #endif



            weights[0] = 0;
            weights[1] = 0;
            weights[2] = 0;
            weights[3] = 0;
            indexes[0] = 0;
            indexes[1] = 0;
            indexes[2] = 0;
            indexes[3] = 0;

            int i = 0;
            for (i = 0; i < TEXCOUNT; ++i)
            {
               half w = splats[i];
               if (w >= weights[0])
               {
                  weights[3] = weights[2];
                  indexes[3] = indexes[2];
                  weights[2] = weights[1];
                  indexes[2] = indexes[1];
                  weights[1] = weights[0];
                  indexes[1] = indexes[0];
                  weights[0] = w;
                  indexes[0] = i;
               }
               else if (w >= weights[1])
               {
                  weights[3] = weights[2];
                  indexes[3] = indexes[2];
                  weights[2] = weights[1];
                  indexes[2] = indexes[1];
                  weights[1] = w;
                  indexes[1] = i;
               }
               else if (w >= weights[2])
               {
                  weights[3] = weights[2];
                  indexes[3] = indexes[2];
                  weights[2] = w;
                  indexes[2] = i;
               }
               else if (w >= weights[3])
               {
                  weights[3] = w;
                  indexes[3] = i;
               }
            }

            // clamp and renormalize
            #if _MAX2LAYER
            weights.zw = 0;
            weights.xy *= (1.0 / (weights.x + weights.y));
            #elif _MAX3LAYER
            weights.w = 0;
            weights.xyz *= (1.0 / (weights.x + weights.y + weights.z));
            #elif !_DISABLEHEIGHTBLENDING || _NORMALIZEWEIGHTS // prevents black when painting, which the unity shader does not prevent.
            weights = normalize(weights);
            #endif

            config.uv0 = float3(scaledUV, indexes.x);
            config.uv1 = float3(scaledUV, indexes.y);
            config.uv2 = float3(scaledUV, indexes.z);
            config.uv3 = float3(scaledUV, indexes.w);


         #endif //_DISABLESPLATMAPS


      }
      
      float ComputeMipLevel(float2 uv, float2 textureSize)
      {
         uv *= textureSize;
         float2  dx_vtc        = ddx(uv);
         float2  dy_vtc        = ddy(uv);
         float delta_max_sqr   = max(dot(dx_vtc, dx_vtc), dot(dy_vtc, dy_vtc));
         return 0.5 * log2(delta_max_sqr);
      }

      inline half2 UnpackNormal2(half4 packednormal)
      {
          return packednormal.wy * 2 - 1;
         
      }

      half3 TriplanarHBlend(half h0, half h1, half h2, half3 pN, half contrast)
      {
         half3 blend = pN / dot(pN, half3(1,1,1));
         float3 heights = float3(h0, h1, h2) + (blend * 3.0);
         half height_start = max(max(heights.x, heights.y), heights.z) - contrast;
         half3 h = max(heights - height_start.xxx, half3(0,0,0));
         blend = h / dot(h, half3(1,1,1));
         return blend;
      }
      

      void ClearAllButAlbedo(inout MicroSplatLayer o, half3 display)
      {
         o.Albedo = display.rgb;
         o.Normal = half3(0, 0, 1);
         o.Smoothness = 0;
         o.Occlusion = 1;
         o.Emission = 0;
         o.Metallic = 0;
         o.Height = 0;
         #if _USESPECULARWORKFLOW
         o.Specular = 0;
         #endif

      }

      void ClearAllButAlbedo(inout MicroSplatLayer o, half display)
      {
         o.Albedo = half3(display, display, display);
         o.Normal = half3(0, 0, 1);
         o.Smoothness = 0;
         o.Occlusion = 1;
         o.Emission = 0;
         o.Metallic = 0;
         o.Height = 0;
         #if _USESPECULARWORKFLOW
         o.Specular = 0;
         #endif

      }

     

      half MicroShadow(float3 lightDir, half3 normal, half ao, half strength)
      {
         half shadow = saturate(abs(dot(normal, lightDir)) + (ao * ao * 2.0) - 1.0);
         return 1 - ((1-shadow) * strength);
      }
      

      void DoDebugOutput(inout MicroSplatLayer l)
      {
         #if _DEBUG_OUTPUT_ALBEDO
            ClearAllButAlbedo(l, l.Albedo);
         #elif _DEBUG_OUTPUT_NORMAL
            // oh unit shader compiler normal stripping, how I hate you so..
            // must multiply by albedo to stop the normal from being white. Why, fuck knows?
            ClearAllButAlbedo(l, float3(l.Normal.xy * 0.5 + 0.5, l.Normal.z * saturate(l.Albedo.z+1)));
         #elif _DEBUG_OUTPUT_SMOOTHNESS
            ClearAllButAlbedo(l, l.Smoothness.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_METAL
            ClearAllButAlbedo(l, l.Metallic.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_AO
            ClearAllButAlbedo(l, l.Occlusion.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_EMISSION
            ClearAllButAlbedo(l, l.Emission * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_HEIGHT
            ClearAllButAlbedo(l, l.Height.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_SPECULAR && _USESPECULARWORKFLOW
            ClearAllButAlbedo(l, l.Specular * saturate(l.Albedo.z+1));
         #elif _DEBUG_BRANCHCOUNT_WEIGHT
            ClearAllButAlbedo(l, _branchWeightCount / 12 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_TRIPLANAR
            ClearAllButAlbedo(l, _branchTriplanarCount / 24 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_CLUSTER
            ClearAllButAlbedo(l, _branchClusterCount / 12 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_OTHER
            ClearAllButAlbedo(l, _branchOtherCount / 8 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_TOTAL
            l.Albedo.r = _branchWeightCount / 12;
            l.Albedo.g = _branchTriplanarCount / 24;
            l.Albedo.b = _branchClusterCount / 12;
            ClearAllButAlbedo(l, (l.Albedo.r + l.Albedo.g + l.Albedo.b + (_branchOtherCount / 8)) / 4); 
         #elif _DEBUG_OUTPUT_MICROSHADOWS
            ClearAllButAlbedo(l,l.Albedo); 
         #elif _DEBUG_SAMPLECOUNT
            float sdisp = (float)_sampleCount / max(_SampleCountDiv, 1);
            half3 sdcolor = float3(sdisp, sdisp > 1 ? 1 : 0, 0);
            ClearAllButAlbedo(l, sdcolor * saturate(l.Albedo.z + 1));
         #elif _DEBUG_PROCLAYERS
            ClearAllButAlbedo(l, (float)_procLayerCount / (float)_PCLayerCount * saturate(l.Albedo.z + 1));
         #endif
      }


      // man I wish unity would wrap everything instead of only what they use. Just seems like a landmine for
      // people like myself.. especially as they keep changing things around and I have to figure out all the new defines
      // and handle changes across Unity versions, which would be automatically handled if they just wrapped these themselves without
      // as much complexity..

      #if (UNITY_VERSION >= 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (SHADER_TARGET_SURFACE_ANALYSIS && !SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))) || (UNITY_VERSION < 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL))) 
           #define MICROSPLAT_SAMPLE_TEX2D_LOD(tex,coord, lod) tex.SampleLevel (sampler##tex,coord, lod)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(tex,samplertex,coord, lod) tex.SampleLevel (sampler##samplertex,coord, lod)
        #else
           #define MICROSPLAT_SAMPLE_TEX2D_LOD(tex,coord,lod) tex2D (tex,coord,0,lod)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(tex,samplertex,coord,lod) tex2D (tex,coord,0,lod)
        #endif
     


        #if (UNITY_VERSION >= 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (SHADER_TARGET_SURFACE_ANALYSIS && !SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))) || (UNITY_VERSION < 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL))) 
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) tex.SampleGrad (sampler##tex,coord,dx,dy)
        #elif defined(SHADER_API_D3D9)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(0,1,0,0) 
        #elif defined(UNITY_COMPILER_HLSL2GLSL) || defined(SHADER_TARGET_SURFACE_ANALYSIS)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) texCUBEgrad (tex,coord,float3(dx.x,dx.y,0),float3(dy.x,dy.y,0))
        #elif defined(SHADER_API_GLES)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(1,1,0,0)
        #elif defined(SHADER_API_D3D11_9X)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(0,1,1,0) 
        #else
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(0,0,1,0) 
        #endif
        
        #if (UNITY_VERSION >= 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (SHADER_TARGET_SURFACE_ANALYSIS && !SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))) || (UNITY_VERSION < 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL))) 
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) tex.SampleGrad (sampler##samp,coord,dx,dy)
        #elif defined(SHADER_API_D3D9)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(0,1,0,0) 
        #elif defined(UNITY_COMPILER_HLSL2GLSL) || defined(SHADER_TARGET_SURFACE_ANALYSIS)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(1,0,1,0)
        #elif defined(SHADER_API_GLES)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(1,1,0,0)
        #elif defined(SHADER_API_D3D11_9X)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(0,1,1,0) 
        #else
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(0,0,1,0) 
        #endif
      

      #if _USELODMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY_LOD(tex, u, l.x)
      #elif _USEGRADMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex, u, l.xy, l.zw)
      #else
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY(tex, u)
      #endif

      #if _USELODMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY_LOD(tex, u, l.x)
      #elif _USEGRADMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex, u, l.xy, l.zw)
      #else
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY(tex, u)
      #endif


      #define MICROSPLAT_SAMPLE_DIFFUSE(u, cl, l) MICROSPLAT_SAMPLE(_Diffuse, u, l)
      #define MICROSPLAT_SAMPLE_EMIS(u, cl, l) MICROSPLAT_SAMPLE(_EmissiveMetal, u, l)
      #define MICROSPLAT_SAMPLE_DIFFUSE_LOD(u, cl, l) UNITY_SAMPLE_TEX2DARRAY_LOD(_Diffuse, u, l)
      

      #if _PACKINGHQ
         #define MICROSPLAT_SAMPLE_NORMAL(u, cl, l) half4(MICROSPLAT_SAMPLE(_NormalSAO, u, l).ga, MICROSPLAT_SAMPLE(_SmoothAO, u, l).ga).brag
      #else
         #define MICROSPLAT_SAMPLE_NORMAL(u, cl, l) MICROSPLAT_SAMPLE(_NormalSAO, u, l)
      #endif

      #if _USESPECULARWORKFLOW
         #define MICROSPLAT_SAMPLE_SPECULAR(u, cl, l) MICROSPLAT_SAMPLE(_Specular, u, l)
      #endif
      




                    
      #undef MICROSPLAT_SAMPLE_TEX2D_LOD
      #undef MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD
      #undef MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD
      #undef MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD

      #define MICROSPLAT_SAMPLE_TEX2D_LOD(tex,coord,lod)                    SAMPLE_TEXTURE2D_LOD(tex,sampler_##tex, coord, lod)
      #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy)                 SAMPLE_TEXTURE2D_GRAD(tex,sampler_##tex,coord,dx,dy)
      #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy)    SAMPLE_TEXTURE2D_GRAD(tex,sampler_##samp,coord,dx,dy)
      #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(tex, samp, coord, lod)    SAMPLE_TEXTURE2D_LOD(tex, sampler_##samp, coord, lod)

      inline half3 UnpackNormal(half4 packednormal)
      {
         half3 normal;
         normal.xy = packednormal.wy * 2 - 1;
         normal.z = sqrt(1 - normal.x*normal.x - normal.y * normal.y);
         return normal;
      }
      

      #undef WorldNormalVector
      #define WorldNormalVector(data, normal) mul(data.TBN, normal)





      #define UnityObjectToWorldNormal(normal) mul(GetObjectToWorldMatrix(), normal)
      
      


      Input DescToInput(SurfaceDescriptionInputs IN)
      {
        Input s = (Input)0;
        s.TBN = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        s.worldNormal = IN.WorldSpaceNormal;
        #if !_SRPTERRAINBLEND
           s.worldPos = GetAbsolutePositionWS(IN.WorldSpacePosition);
        #else
           s.worldPos = IN.WorldSpacePosition;
        #endif
        s.viewDir = IN.TangentSpaceViewDirection;
        s.uv_Control0 = IN.uv0.xy;
        

        #if _MICROMESH && _MESHUV2
            s.uv_Diffuse = IN.uv.xy1;
        #endif

        #if _SRPTERRAINBLEND
            s.color = IN.VertexColor;
        #endif
        return s;
     }

     #define TESSELLATION_INTERPOLATE_BARY(name, bary) output.name = input0.name * bary.x +  input1.name * bary.y +  input2.name * bary.z
     

     // Stochastic shared code

// Compute local triangle barycentric coordinates and vertex IDs
void TriangleGrid(float2 uv, float scale,
   out float w1, out float w2, out float w3,
   out int2 vertex1, out int2 vertex2, out int2 vertex3)
{
   // Scaling of the input
   uv *= 3.464 * scale; // 2 * sqrt(3)

   // Skew input space into simplex triangle grid
   const float2x2 gridToSkewedGrid = float2x2(1.0, 0.0, -0.57735027, 1.15470054);
   float2 skewedCoord = mul(gridToSkewedGrid, uv);

   // Compute local triangle vertex IDs and local barycentric coordinates
   int2 baseId = int2(floor(skewedCoord));
   float3 temp = float3(frac(skewedCoord), 0);
   temp.z = 1.0 - temp.x - temp.y;
   if (temp.z > 0.0)
   {
      w1 = temp.z;
      w2 = temp.y;
      w3 = temp.x;
      vertex1 = baseId;
      vertex2 = baseId + int2(0, 1);
      vertex3 = baseId + int2(1, 0);
   }
   else
   {
      w1 = -temp.z;
      w2 = 1.0 - temp.y;
      w3 = 1.0 - temp.x;
      vertex1 = baseId + int2(1, 1);
      vertex2 = baseId + int2(1, 0);
      vertex3 = baseId + int2(0, 1);
   }
}

// Fast random hash function
float2 SimpleHash2(float2 p)
{
   return frac(sin(mul(float2x2(127.1, 311.7, 269.5, 183.3), p)) * 43758.5453);
}


half3 BaryWeightBlend(half3 iWeights, half tex0, half tex1, half tex2, half contrast)
{
    // compute weight with height map
    const half epsilon = 1.0f / 1024.0f;
    half3 weights = half3(iWeights.x * (tex0 + epsilon), 
                             iWeights.y * (tex1 + epsilon),
                             iWeights.z * (tex2 + epsilon));

    // Contrast weights
    half maxWeight = max(weights.x, max(weights.y, weights.z));
    half transition = contrast * maxWeight;
    half threshold = maxWeight - transition;
    half scale = 1.0f / transition;
    weights = saturate((weights - threshold) * scale);
    // Normalize weights.
    half weightScale = 1.0f / (weights.x + weights.y + weights.z);
    weights *= weightScale;
    return weights;
}

void PrepareStochasticUVs(float scale, float3 uv, out float3 uv1, out float3 uv2, out float3 uv3, out half3 weights)
{
   // Get triangle info
   float w1, w2, w3;
   int2 vertex1, vertex2, vertex3;
   TriangleGrid(uv.xy, scale, w1, w2, w3, vertex1, vertex2, vertex3);

   // Assign random offset to each triangle vertex
   uv1 = uv;
   uv2 = uv;
   uv3 = uv;
   
   uv1.xy += SimpleHash2(vertex1);
   uv2.xy += SimpleHash2(vertex2);
   uv3.xy += SimpleHash2(vertex3);
   weights = half3(w1, w2, w3);
   
}

void PrepareStochasticUVs(float scale, float2 uv, out float2 uv1, out float2 uv2, out float2 uv3, out half3 weights)
{
   // Get triangle info
   float w1, w2, w3;
   int2 vertex1, vertex2, vertex3;
   TriangleGrid(uv, scale, w1, w2, w3, vertex1, vertex2, vertex3);

   // Assign random offset to each triangle vertex
   uv1 = uv;
   uv2 = uv;
   uv3 = uv;
   
   uv1.xy += SimpleHash2(vertex1);
   uv2.xy += SimpleHash2(vertex2);
   uv3.xy += SimpleHash2(vertex3);
   weights = half3(w1, w2, w3);
   
}


      #if _ALPHAHOLETEXTURE
         sampler2D _AlphaHoleTexture;   // must declare with a sampler or windows throws an error, which seems like a compiler bug
      #endif



      void ClipWaterLevel(float3 worldPos)
      {
         clip(worldPos.y - _AlphaData.y);
      }

      void ClipAlphaHole(inout Config c, inout half4 weights)
      {
      #if _ALPHAHOLETEXTURE
         clip(tex2D(_AlphaHoleTexture, c.uv).r - 0.5);
      #else
         if ((int)round(c.uv0.z ) == (int)round(_AlphaData.x))
         {
            clip(-1);
         }
         else if ((int)round(c.uv1.z ) == (int)round(_AlphaData.x) && weights.y > 0)
         {
            weights.y = 0;
            weights = normalize(weights);
         }
         else if ((int)round(c.uv2.z ) == (int)round(_AlphaData.x) && weights.z > 0)
         {
            weights.z = 0;
            weights = normalize(weights);
         }
         else if ((int)round(c.uv3.z ) == (int)round(_AlphaData.x) && weights.w > 0)
         {
            weights.w = 0;
            weights = normalize(weights);
         }
         
      #endif
      }





     
    




   

                    



      void SampleAlbedo(inout Config config, inout TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
         return;
         #endif
         #if _TRIPLANAR
            #if _USEGRADMIP
               float4 d0 = mipLevel.d0;
               float4 d1 = mipLevel.d1;
               float4 d2 = mipLevel.d2;
            #elif _USELODMIP
               float d0 = mipLevel.x;
               float d1 = mipLevel.y;
               float d2 = mipLevel.z;
            #else
               MIPFORMAT d0 = mipLevel;
               MIPFORMAT d1 = mipLevel;
               MIPFORMAT d2 = mipLevel;
            #endif
         
            half4 contrasts = _Contrast.xxxx;
            #if _PERTEXTRIPLANARCONTRAST
               SAMPLE_PER_TEX(ptc, 5.5, config, half4(1,0.5,0,0));
               contrasts = half4(ptc0.y, ptc1.y, ptc2.y, ptc3.y);
            #endif


            #if _PERTEXTRIPLANAR
               SAMPLE_PER_TEX(pttri, 9.5, config, half4(0,0,0,0));
            #endif

            {
               // For per-texture triplanar, we modify the view based blending factor of the triplanar
               // such that you get a pure blend of either top down projection, or with the top down projection
               // removed and renormalized. This causes dynamic flow control optimizations to kick in and avoid
               // the extra texture samples while keeping the code simple. Yay..

               // We also only have to do this in the Albedo, because the pN values will be adjusted after the
               // albedo is sampled, causing future samples to use this data. 
              
               #if _PERTEXTRIPLANAR
                  if (pttri0.x > 0.66)
                  {
                     tc.pN0 = half3(0,1,0);
                  }
                  else if (pttri0.x > 0.33)
                  {
                     tc.pN0.y = 0;
                     tc.pN0.xz = normalize(tc.pN0.xz);
                  }
               #endif


               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN0.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv0[0], config.cluster0, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN0.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv0[1], config.cluster0, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN0.z)
               {
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv0[2], config.cluster0, d2);
                  COUNTSAMPLE
               }

               half3 bf = tc.pN0;
               #if _TRIPLANARHEIGHTBLEND
                  bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN0, contrasts.x);
                  tc.pN0 = bf;
               #endif

               s.albedo0 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            MSBRANCH(weights.y)
            {
               #if _PERTEXTRIPLANAR
                  if (pttri1.x > 0.66)
                  {
                     tc.pN1 = half3(0,1,0);
                  }
                  else if (pttri1.x > 0.33)
                  {
                     tc.pN1.y = 0;
                     tc.pN1.xz = normalize(tc.pN1.xz);
                  }
               #endif

               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN1.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv1[0], config.cluster1, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv1[1], config.cluster1, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.z)
               {
                  COUNTSAMPLE
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv1[2], config.cluster1, d2);
               }
               half3 bf = tc.pN1;
               #if _TRIPLANARHEIGHTBLEND
                  bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN1, contrasts.x);
                  tc.pN1 = bf;
               #endif


               s.albedo1 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            #if !_MAX2LAYER
            MSBRANCH(weights.z)
            {
               #if _PERTEXTRIPLANAR
                  if (pttri2.x > 0.66)
                  {
                     tc.pN2 = half3(0,1,0);
                  }
                  else if (pttri2.x > 0.33)
                  {
                     tc.pN2.y = 0;
                     tc.pN2.xz = normalize(tc.pN2.xz);
                  }
               #endif

               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN2.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv2[0], config.cluster2, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv2[1], config.cluster2, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.z)
               {
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv2[2], config.cluster2, d2);
                  COUNTSAMPLE
               }

               half3 bf = tc.pN2;
               #if _TRIPLANARHEIGHTBLEND
                  bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN2, contrasts.x);
                  tc.pN2 = bf;
               #endif
               

               s.albedo2 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
            MSBRANCH(weights.w)
            {

               #if _PERTEXTRIPLANAR
                  if (pttri3.x > 0.66)
                  {
                     tc.pN3 = half3(0,1,0);
                  }
                  else if (pttri3.x > 0.33)
                  {
                     tc.pN3.y = 0;
                     tc.pN3.xz = normalize(tc.pN3.xz);
                  }
               #endif

               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN3.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv3[0], config.cluster3, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv3[1], config.cluster3, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.z)
               {
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv3[2], config.cluster3, d2);
                  COUNTSAMPLE
               }

               half3 bf = tc.pN3;
               #if _TRIPLANARHEIGHTBLEND
               bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN3, contrasts.x);
               tc.pN3 = bf;
               #endif

               s.albedo3 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            #endif

         #else
            s.albedo0 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv0, config.cluster0, mipLevel);
            COUNTSAMPLE

            MSBRANCH(weights.y)
            {
               s.albedo1 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv1, config.cluster1, mipLevel);
               COUNTSAMPLE
            }
            #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  s.albedo2 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv2, config.cluster2, mipLevel);
                  COUNTSAMPLE
               } 
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  s.albedo3 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv3, config.cluster3, mipLevel);
                  COUNTSAMPLE
               }
            #endif
         #endif

         #if _PERTEXHEIGHTOFFSET || _PERTEXHEIGHTCONTRAST
            SAMPLE_PER_TEX(ptHeight, 10.5, config, 1);

            #if _PERTEXHEIGHTOFFSET
               s.albedo0.a = saturate(s.albedo0.a + ptHeight0.b - 1);
               s.albedo1.a = saturate(s.albedo1.a + ptHeight1.b - 1);
               s.albedo2.a = saturate(s.albedo2.a + ptHeight2.b - 1);
               s.albedo3.a = saturate(s.albedo3.a + ptHeight3.b - 1);
            #endif
            #if _PERTEXHEIGHTCONTRAST
               s.albedo0.a = saturate(pow(s.albedo0.a + 0.5, abs(ptHeight0.a)) - 0.5);
               s.albedo1.a = saturate(pow(s.albedo1.a + 0.5, abs(ptHeight1.a)) - 0.5);
               s.albedo2.a = saturate(pow(s.albedo2.a + 0.5, abs(ptHeight2.a)) - 0.5);
               s.albedo3.a = saturate(pow(s.albedo3.a + 0.5, abs(ptHeight3.a)) - 0.5);
            #endif
         #endif
      }
      
      
      
      void SampleNormal(Config config, TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
         return;
         #endif

         #if _NONOMALMAP
            s.normSAO0 = half4(0,0, 0, 1);
            s.normSAO1 = half4(0,0, 0, 1);
            s.normSAO2 = half4(0,0, 0, 1);
            s.normSAO3 = half4(0,0, 0, 1);
            return;
         #endif
         
         #if _TRIPLANAR
            #if _USEGRADMIP
               float4 d0 = mipLevel.d0;
               float4 d1 = mipLevel.d1;
               float4 d2 = mipLevel.d2;
            #elif _USELODMIP
               float d0 = mipLevel.x;
               float d1 = mipLevel.y;
               float d2 = mipLevel.z;
            #else
               MIPFORMAT d0 = mipLevel;
               MIPFORMAT d1 = mipLevel;
               MIPFORMAT d2 = mipLevel;
            #endif
            
            half3 absVertNormal = abs(tc.IN.worldNormal);
            float3 t2w0 = WorldNormalVector(tc.IN, float3(1,0,0));
            float3 t2w1 = WorldNormalVector(tc.IN, float3(0,1,0));
            float3 t2w2 = WorldNormalVector(tc.IN, float3(0,0,1));
            float3x3 t2w = float3x3(t2w0, t2w1, t2w2);
            
            
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);
               MSBRANCHTRIPLANAR(tc.pN0.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv0[0], config.cluster0, d0).garb;
                  COUNTSAMPLE
               }            
               MSBRANCHTRIPLANAR(tc.pN0.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv0[1], config.cluster0, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN0.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv0[2], config.cluster0, d2).garb;
                  COUNTSAMPLE
               }
               

               s.normSAO0.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN0, a0.xy, a1.xy, a2.xy);
               s.normSAO0.zw = a0.zw * tc.pN0.x + a1.zw * tc.pN0.y + a2.zw * tc.pN0.z;
            }
            MSBRANCH(weights.y)
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);
               MSBRANCHTRIPLANAR(tc.pN1.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv1[0], config.cluster1, d0).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv1[1], config.cluster1, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv1[2], config.cluster1, d2).garb;
                  COUNTSAMPLE
               }
               

               s.normSAO1.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN1, a0.xy, a1.xy, a2.xy);
               s.normSAO1.zw = a0.zw * tc.pN1.x + a1.zw * tc.pN1.y + a2.zw * tc.pN1.z;
            }
            #if !_MAX2LAYER
            MSBRANCH(weights.z)
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);

               MSBRANCHTRIPLANAR(tc.pN2.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv2[0], config.cluster2, d0).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv2[1], config.cluster2, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv2[2], config.cluster2, d2).garb;
                  COUNTSAMPLE
               }
               

               s.normSAO2.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN2, a0.xy, a1.xy, a2.xy);
               s.normSAO2.zw = a0.zw * tc.pN2.x + a1.zw * tc.pN2.y + a2.zw * tc.pN2.z;
            }
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
            MSBRANCH(weights.w)
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);
               MSBRANCHTRIPLANAR(tc.pN3.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv3[0], config.cluster3, d0).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv3[1], config.cluster3, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv3[2], config.cluster3, d2).garb;
                  COUNTSAMPLE
               }

               s.normSAO3.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN3, a0.xy, a1.xy, a2.xy);
               s.normSAO3.zw = a0.zw * tc.pN3.x + a1.zw * tc.pN3.y + a2.zw * tc.pN3.z;
            }
            #endif

         #else
            s.normSAO0 = MICROSPLAT_SAMPLE_NORMAL(config.uv0, config.cluster0, mipLevel).garb;
            COUNTSAMPLE
            s.normSAO0.xy = s.normSAO0.xy * 2 - 1;
            MSBRANCH(weights.y)
            {
               s.normSAO1 = MICROSPLAT_SAMPLE_NORMAL(config.uv1, config.cluster1, mipLevel).garb;
               COUNTSAMPLE
               s.normSAO1.xy = s.normSAO1.xy * 2 - 1;
            }
            #if !_MAX2LAYER
            MSBRANCH(weights.z)
            {
               s.normSAO2 = MICROSPLAT_SAMPLE_NORMAL(config.uv2, config.cluster2, mipLevel).garb;
               COUNTSAMPLE
               s.normSAO2.xy = s.normSAO2.xy * 2 - 1;
            }
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
            MSBRANCH(weights.w)
            {
               s.normSAO3 = MICROSPLAT_SAMPLE_NORMAL(config.uv3, config.cluster3, mipLevel).garb;
               COUNTSAMPLE
               s.normSAO3.xy = s.normSAO3.xy * 2 - 1;
            }
            #endif
         #endif
      }

      void SampleEmis(Config config, TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
            return;
         #endif
         #if _USEEMISSIVEMETAL
            #if _TRIPLANAR
            
               #if _USEGRADMIP
                  float4 d0 = mipLevel.d0;
                  float4 d1 = mipLevel.d1;
                  float4 d2 = mipLevel.d2;
               #elif _USELODMIP
                  float d0 = mipLevel.x;
                  float d1 = mipLevel.y;
                  float d2 = mipLevel.z;
               #else
                  MIPFORMAT d0 = mipLevel;
                  MIPFORMAT d1 = mipLevel;
                  MIPFORMAT d2 = mipLevel;
               #endif
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN0.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv0[0], config.cluster0, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv0[1], config.cluster0, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv0[2], config.cluster0, d2);
                     COUNTSAMPLE
                  }
                  s.emisMetal0 = a0 * tc.pN0.x + a1 * tc.pN0.y + a2 * tc.pN0.z;
               }
               MSBRANCH(weights.y)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN1.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv1[0], config.cluster1, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv1[1], config.cluster1, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv1[2], config.cluster1, d2);
                     COUNTSAMPLE
                  }

                  s.emisMetal1 = a0 * tc.pN1.x + a1 * tc.pN1.y + a2 * tc.pN1.z;
               }
               #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN2.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv2[0], config.cluster2, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv2[1], config.cluster2, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv2[2], config.cluster2, d2);
                     COUNTSAMPLE
                  }
                  
                  s.emisMetal2 = a0 * tc.pN2.x + a1 * tc.pN2.y + a2 * tc.pN2.z;
               }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN3.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv3[0], config.cluster3, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv3[1], config.cluster3, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv3[2], config.cluster3, d2);
                     COUNTSAMPLE
                  }
                  
                  s.emisMetal3 = a0 * tc.pN3.x + a1 * tc.pN3.y + a2 * tc.pN3.z;
               }
               #endif

            #else
               s.emisMetal0 = MICROSPLAT_SAMPLE_EMIS(config.uv0, config.cluster0, mipLevel);
               COUNTSAMPLE

               MSBRANCH(weights.y)
               {
                  s.emisMetal1 = MICROSPLAT_SAMPLE_EMIS(config.uv1, config.cluster1, mipLevel);
                  COUNTSAMPLE
               }
               #if !_MAX2LAYER
                  MSBRANCH(weights.z)
                  {
                     s.emisMetal2 = MICROSPLAT_SAMPLE_EMIS(config.uv2, config.cluster2, mipLevel);
                     COUNTSAMPLE
                  }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  MSBRANCH(weights.w)
                  {
                     s.emisMetal3 = MICROSPLAT_SAMPLE_EMIS(config.uv3, config.cluster3, mipLevel);
                     COUNTSAMPLE
                  }
               #endif
            #endif
         #endif
      }
      
      void SampleSpecular(Config config, TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
            return;
         #endif
         #if _USESPECULARWORKFLOW
            #if _TRIPLANAR

               #if _USEGRADMIP
                  float4 d0 = mipLevel.d0;
                  float4 d1 = mipLevel.d1;
                  float4 d2 = mipLevel.d2;
               #elif _USELODMIP
                  float d0 = mipLevel.x;
                  float d1 = mipLevel.y;
                  float d2 = mipLevel.z;
               #else
                  MIPFORMAT d0 = mipLevel;
                  MIPFORMAT d1 = mipLevel;
                  MIPFORMAT d2 = mipLevel;
               #endif
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN0.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv0[0], config.cluster0, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv0[1], config.cluster0, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv0[2], config.cluster0, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular0 = a0 * tc.pN0.x + a1 * tc.pN0.y + a2 * tc.pN0.z;
               }
               MSBRANCH(weights.y)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN1.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv1[0], config.cluster1, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv1[1], config.cluster1, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv1[2], config.cluster1, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular1 = a0 * tc.pN1.x + a1 * tc.pN1.y + a2 * tc.pN1.z;
               }
               #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN2.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv2[0], config.cluster2, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv2[1], config.cluster2, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv2[2], config.cluster2, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular2 = a0 * tc.pN2.x + a1 * tc.pN2.y + a2 * tc.pN2.z;
               }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN3.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv3[0], config.cluster3, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv3[1], config.cluster3, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv3[2], config.cluster3, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular3 = a0 * tc.pN3.x + a1 * tc.pN3.y + a2 * tc.pN3.z;
               }
               #endif

            #else
               s.specular0 = MICROSPLAT_SAMPLE_SPECULAR(config.uv0, config.cluster0, mipLevel);
               COUNTSAMPLE

               MSBRANCH(weights.y)
               {
                  s.specular1 = MICROSPLAT_SAMPLE_SPECULAR(config.uv1, config.cluster1, mipLevel);
                  COUNTSAMPLE
               }
               #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  s.specular2 = MICROSPLAT_SAMPLE_SPECULAR(config.uv2, config.cluster2, mipLevel);
                  COUNTSAMPLE
               }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  s.specular3 = MICROSPLAT_SAMPLE_SPECULAR(config.uv3, config.cluster3, mipLevel);
                  COUNTSAMPLE
               }
               #endif
            #endif
         #endif
      }

      MicroSplatLayer Sample(Input i, half4 weights, inout Config config, float camDist, float3 worldNormalVertex)
      {
         MicroSplatLayer o = (MicroSplatLayer)0;
         UNITY_INITIALIZE_OUTPUT(MicroSplatLayer,o);

         RawSamples samples = (RawSamples)0;
         InitRawSamples(samples);

         half4 albedo = 0;
         half4 normSAO = half4(0,0,0,1);
         half4 emisMetal = 0;
         half3 specular = 0;
         
         float worldHeight = i.worldPos.y;
         float3 upVector = float3(0,1,0);

         #if _PLANETVECTORS
            upVector = worldNormalVertex;
            worldHeight = distance(i.worldPos, float3(0,0,0));
         #endif

         #if _GLOBALTINT || _GLOBALNORMALS || _GLOBALSMOOTHAOMETAL || _GLOBALEMIS || _GLOBALSPECULAR
            float globalSlopeFilter = 1;
            #if _GLOBALSLOPEFILTER
               float2 gfilterUV = float2(1 - saturate(dot(worldNormalVertex, upVector) * 0.5 + 0.49), 0.5);
               globalSlopeFilter = UNITY_SAMPLE_TEX2D_SAMPLER(_GlobalSlopeTex, _Diffuse, gfilterUV).a;
            #endif
         #endif

         // declare outside of branchy areas..
         half4 fxLevels = half4(0,0,0,0);
         half burnLevel = 0;
         half wetLevel = 0;
         half3 waterNormalFoam = half3(0, 0, 0);
         half porosity = 0.4;
         float streamFoam = 1.0f;
         half pud = 0;
         half snowCover = 0;
         half SSSThickness = 0;
         half3 SSSTint = half3(1,1,1);
         float traxBuffer = 0;
         float3 traxNormal = 0;
         float2 noiseUV = 0;
         
         

         #if _SPLATFADE
         MSBRANCHOTHER(1 - saturate(camDist - _SplatFade.y))
         {
         #endif

         #if _TRAXSINGLE || _TRAXARRAY || _TRAXNOTEXTURE || _SNOWFOOTSTEPS
            traxBuffer = SampleTraxBuffer(i.worldPos, traxNormal);
         #endif
         
         #if _WETNESS || _PUDDLES || _STREAMS || _LAVA
            #if _MICROMESH
               fxLevels = SampleFXLevels(InverseLerp(_UVMeshRange.xy, _UVMeshRange.zw, config.uv), wetLevel, burnLevel, traxBuffer);
            #elif _MICROVERTEXMESH || _MICRODIGGERMESH 
               fxLevels = ProcessFXLevels(i.s0, traxBuffer);
            #else
               fxLevels = SampleFXLevels(config.uv, wetLevel, burnLevel, traxBuffer);
            #endif
         #endif

         TriplanarConfig tc = (TriplanarConfig)0;
         UNITY_INITIALIZE_OUTPUT(TriplanarConfig,tc);
         

         MIPFORMAT albedoLOD = INITMIPFORMAT
         MIPFORMAT normalLOD = INITMIPFORMAT
         MIPFORMAT emisLOD = INITMIPFORMAT
         MIPFORMAT specLOD = INITMIPFORMAT

         #if _TRIPLANAR && !_DISABLESPLATMAPS
            PrepTriplanar(worldNormalVertex, i.worldPos, config, tc, weights, albedoLOD, normalLOD, emisLOD);
            tc.IN = i;
         #endif
         
         
         #if !_TRIPLANAR && !_DISABLESPLATMAPS
            #if _USELODMIP
               albedoLOD = ComputeMipLevel(config.uv0.xy, _Diffuse_TexelSize.zw);
               normalLOD = ComputeMipLevel(config.uv0.xy, _NormalSAO_TexelSize.zw);
               #if _USEEMISSIVEMETAL
                  emisLOD   = ComputeMipLevel(config.uv0.xy, _EmissiveMetal_TexelSize.zw);
               #endif
               #if _USESPECULARWORKFLOW
                  specLOD = ComputeMipLevel(config.uv0.xy, _Specular_TexelSize.zw);;
               #endif
            #elif _USEGRADMIP
               albedoLOD = float4(ddx(config.uv0.xy), ddy(config.uv0.xy));
               normalLOD = albedoLOD;
               #if _USESPECULARWORKFLOW
                  specLOD = albedoLOD;
               #endif
               #if _USEEMISSIVEMETAL
                  emisLOD = albedoLOD;
               #endif
            #endif
         #endif

         #if _PERTEXCURVEWEIGHT
           SAMPLE_PER_TEX(ptCurveWeight, 19.5, config, half4(0.5,1,1,1));
           weights.x = lerp(smoothstep(0.5 - ptCurveWeight0.r, 0.5 + ptCurveWeight0.r, weights.x), weights.x, ptCurveWeight0.r*2);
           weights.y = lerp(smoothstep(0.5 - ptCurveWeight1.r, 0.5 + ptCurveWeight1.r, weights.y), weights.y, ptCurveWeight1.r*2);
           weights.z = lerp(smoothstep(0.5 - ptCurveWeight2.r, 0.5 + ptCurveWeight2.r, weights.z), weights.z, ptCurveWeight2.r*2);
           weights.w = lerp(smoothstep(0.5 - ptCurveWeight3.r, 0.5 + ptCurveWeight3.r, weights.w), weights.w, ptCurveWeight3.r*2);
           weights = normalize(weights);
         #endif
         

         // uvScale before anything
         #if _PERTEXUVSCALEOFFSET && !_TRIPLANAR && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptUVScale, 0.5, config, half4(1,1,0,0));
            config.uv0.xy = config.uv0.xy * ptUVScale0.rg + ptUVScale0.ba;
            config.uv1.xy = config.uv1.xy * ptUVScale1.rg + ptUVScale1.ba;
            #if !_MAX2LAYER
               config.uv2.xy = config.uv2.xy * ptUVScale2.rg + ptUVScale2.ba;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               config.uv3.xy = config.uv3.xy * ptUVScale3.rg + ptUVScale3.ba;
            #endif

            // fix for pertex uv scale using gradient sampler and weight blended derivatives
            #if _USEGRADMIP
               albedoLOD = albedoLOD * ptUVScale0.rgrg * weights.x + 
                           albedoLOD * ptUVScale1.rgrg * weights.y + 
                           albedoLOD * ptUVScale2.rgrg * weights.z + 
                           albedoLOD * ptUVScale3.rgrg * weights.w;
               normalLOD = albedoLOD;
               #if _USEEMISSIVEMETAL
                  emisLOD = albedoLOD;
               #endif
               #if _USESPECULARWORKFLOW
                  specLOD = albedoLOD;
               #endif
            #endif
         #endif

         #if _PERTEXUVROTATION && !_TRIPLANAR && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptUVRot, 16.5, config, half4(0,0,0,0));
            config.uv0.xy = RotateUV(config.uv0.xy, ptUVRot0.x);
            config.uv1.xy = RotateUV(config.uv1.xy, ptUVRot1.x);
            #if !_MAX2LAYER
               config.uv2.xy = RotateUV(config.uv2.xy, ptUVRot2.x);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               config.uv3.xy = RotateUV(config.uv3.xy, ptUVRot0.x);
            #endif
         #endif

         
         o.Alpha = 1;

         
         #if _POM && !_DISABLESPLATMAPS
            DoPOM(i, config, tc, albedoLOD, weights, camDist, worldNormalVertex);
         #endif
         

         SampleAlbedo(config, tc, samples, albedoLOD, weights);

         #if _NOISEHEIGHT
            ApplyNoiseHeight(samples, config.uv, config, i.worldPos, worldNormalVertex);
         #endif
         
         #if _STREAMS || (_PARALLAX && !_DISABLESPLATMAPS)
         half earlyHeight = BlendWeights(samples.albedo0.w, samples.albedo1.w, samples.albedo2.w, samples.albedo3.w, weights);
         #endif

         
         #if _STREAMS
         waterNormalFoam = GetWaterNormal(i, config.uv, worldNormalVertex);
         DoStreamRefract(config, tc, waterNormalFoam, fxLevels.b, earlyHeight);
         #endif

         #if _PARALLAX && !_DISABLESPLATMAPS
            DoParallax(i, earlyHeight, config, tc, samples, weights, camDist);
         #endif


         // Blend results
         #if _PERTEXINTERPCONTRAST && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptContrasts, 1.5, config, 0.5);
            half4 contrast = 0.5;
            contrast.x = ptContrasts0.a;
            contrast.y = ptContrasts1.a;
            #if !_MAX2LAYER
               contrast.z = ptContrasts2.a;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               contrast.w = ptContrasts3.a;
            #endif
            contrast = clamp(contrast + _Contrast, 0.0001, 1.0); 
            half cnt = contrast.x * weights.x + contrast.y * weights.y + contrast.z * weights.z + contrast.w * weights.w;
            half4 heightWeights = ComputeWeights(weights, samples.albedo0.a, samples.albedo1.a, samples.albedo2.a, samples.albedo3.a, cnt);
         #else
            half4 heightWeights = ComputeWeights(weights, samples.albedo0.a, samples.albedo1.a, samples.albedo2.a, samples.albedo3.a, _Contrast);
         #endif


         #if _PARALLAX || _STREAMS
            SampleAlbedo(config, tc, samples, albedoLOD, heightWeights);
         #endif


         SampleNormal(config, tc, samples, normalLOD, heightWeights);

         #if _USEEMISSIVEMETAL
            SampleEmis(config, tc, samples, emisLOD, heightWeights);
         #endif

         #if _USESPECULARWORKFLOW
            SampleSpecular(config, tc, samples, specLOD, heightWeights);
         #endif

         #if _DISTANCERESAMPLE && !_DISABLESPLATMAPS
            DistanceResample(samples, config, tc, camDist, i.viewDir, fxLevels, albedoLOD, i.worldPos, heightWeights, worldNormalVertex);
         #endif

         // PerTexture sampling goes here, passing the samples structure
         
         #if _PERTEXMICROSHADOWS || _PERTEXFUZZYSHADE
            SAMPLE_PER_TEX(ptFuzz, 17.5, config, half4(0, 0, 1, 1));
         #endif

         #if _PERTEXMICROSHADOWS
            #if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_DEFERRED) || (defined(_MSRENDERLOOP_UNITYLD) && defined(_PASSFORWARD) || _MSRENDERLOOP_UNITYHD)
            {
               half3 lightDir = GetGlobalLightDirTS(i);
               half4 microShadows = half4(1,1,1,1);
               microShadows.x = MicroShadow(lightDir, half3(samples.normSAO0.xy, 1), samples.normSAO0.a, ptFuzz0.a);
               microShadows.y = MicroShadow(lightDir, half3(samples.normSAO1.xy, 1), samples.normSAO1.a, ptFuzz1.a);
               microShadows.z = MicroShadow(lightDir, half3(samples.normSAO2.xy, 1), samples.normSAO2.a, ptFuzz2.a);
               microShadows.w = MicroShadow(lightDir, half3(samples.normSAO3.xy, 1), samples.normSAO3.a, ptFuzz3.a);
               samples.normSAO0.a *= microShadows.x;
               samples.normSAO1.a *= microShadows.y;
               #if !_MAX2LAYER
                  samples.normSAO2.a *= microShadows.z;
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  samples.normSAO3.a *= microShadows.w;
               #endif

               
               #if _DEBUG_OUTPUT_MICROSHADOWS
               o.Albedo = BlendWeights(microShadows.x, microShadows.y, microShadows.z, microShadows.a, heightWeights);
               return o;
               #endif

            }
            #endif

         #endif // _PERTEXMICROSHADOWS


         #if _PERTEXFUZZYSHADE
            
            samples.albedo0.rgb = FuzzyShade(samples.albedo0.rgb, half3(samples.normSAO0.rg, 1), ptFuzz0.r, ptFuzz0.g, ptFuzz0.b, i.viewDir);
            samples.albedo1.rgb = FuzzyShade(samples.albedo1.rgb, half3(samples.normSAO1.rg, 1), ptFuzz1.r, ptFuzz1.g, ptFuzz1.b, i.viewDir);
            #if !_MAX2LAYER
               samples.albedo2.rgb = FuzzyShade(samples.albedo2.rgb, half3(samples.normSAO2.rg, 1), ptFuzz2.r, ptFuzz2.g, ptFuzz2.b, i.viewDir);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb = FuzzyShade(samples.albedo3.rgb, half3(samples.normSAO3.rg, 1), ptFuzz3.r, ptFuzz3.g, ptFuzz3.b, i.viewDir);
            #endif
         #endif

         #if _PERTEXSATURATION && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptSaturattion, 9.5, config, half4(1, 1, 1, 1));
            samples.albedo0.rgb = lerp(MSLuminance(samples.albedo0.rgb), samples.albedo0.rgb, ptSaturattion0.a);
            samples.albedo1.rgb = lerp(MSLuminance(samples.albedo1.rgb), samples.albedo1.rgb, ptSaturattion1.a);
            #if !_MAX2LAYER
               samples.albedo2.rgb = lerp(MSLuminance(samples.albedo2.rgb), samples.albedo2.rgb, ptSaturattion2.a);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb = lerp(MSLuminance(samples.albedo3.rgb), samples.albedo3.rgb, ptSaturattion3.a);
            #endif
         
         #endif
         
         #if _PERTEXTINT && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptTints, 1.5, config, half4(1, 1, 1, 1));
            samples.albedo0.rgb *= ptTints0.rgb;
            samples.albedo1.rgb *= ptTints1.rgb;
            #if !_MAX2LAYER
               samples.albedo2.rgb *= ptTints2.rgb;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb *= ptTints3.rgb;
            #endif
         #endif
         
         #if _PCHEIGHTGRADIENT || _PCHEIGHTHSV || _PCSLOPEGRADIENT || _PCSLOPEHSV
            ProceduralGradients(i, samples, config, worldHeight, worldNormalVertex);
         #endif

         
         

         #if _WETNESS || _PUDDLES || _STREAMS
         porosity = _GlobalPorosity;
         #endif


         #if _PERTEXCOLORINTENSITY
            SAMPLE_PER_TEX(ptCI, 23.5, config, half4(1, 1, 1, 1));
            samples.albedo0.rgb = saturate(samples.albedo0.rgb * (1 + ptCI0.rrr));
            samples.albedo1.rgb = saturate(samples.albedo1.rgb * (1 + ptCI1.rrr));
            #if !_MAX2LAYER
               samples.albedo2.rgb = saturate(samples.albedo2.rgb * (1 + ptCI2.rrr));
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb = saturate(samples.albedo3.rgb * (1 + ptCI3.rrr));
            #endif
         #endif

         #if (_PERTEXBRIGHTNESS || _PERTEXCONTRAST || _PERTEXPOROSITY || _PERTEXFOAM) && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptBC, 3.5, config, half4(1, 1, 1, 1));
            #if _PERTEXCONTRAST
               samples.albedo0.rgb = saturate(((samples.albedo0.rgb - 0.5) * ptBC0.g) + 0.5);
               samples.albedo1.rgb = saturate(((samples.albedo1.rgb - 0.5) * ptBC1.g) + 0.5);
               #if !_MAX2LAYER
                 samples.albedo2.rgb = saturate(((samples.albedo2.rgb - 0.5) * ptBC2.g) + 0.5);
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  samples.albedo3.rgb = saturate(((samples.albedo3.rgb - 0.5) * ptBC3.g) + 0.5);
               #endif
            #endif
            #if _PERTEXBRIGHTNESS
               samples.albedo0.rgb = saturate(samples.albedo0.rgb + ptBC0.rrr);
               samples.albedo1.rgb = saturate(samples.albedo1.rgb + ptBC1.rrr);
               #if !_MAX2LAYER
                  samples.albedo2.rgb = saturate(samples.albedo2.rgb + ptBC2.rrr);
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  samples.albedo3.rgb = saturate(samples.albedo3.rgb + ptBC3.rrr);
               #endif
            #endif
            #if _PERTEXPOROSITY
            porosity = BlendWeights(ptBC0.b, ptBC1.b, ptBC2.b, ptBC3.b, heightWeights);
            #endif

            #if _PERTEXFOAM
            streamFoam = BlendWeights(ptBC0.a, ptBC1.a, ptBC2.a, ptBC3.a, heightWeights);
            #endif

         #endif

         #if (_PERTEXNORMSTR || _PERTEXAOSTR || _PERTEXSMOOTHSTR || _PERTEXMETALLIC) && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(perTexMatSettings, 2.5, config, half4(1.0, 1.0, 1.0, 0.0));
         #endif

         #if _PERTEXNORMSTR && !_DISABLESPLATMAPS
            samples.normSAO0.xy *= perTexMatSettings0.r;
            samples.normSAO1.xy *= perTexMatSettings1.r;
            #if !_MAX2LAYER
               samples.normSAO2.xy *= perTexMatSettings2.r;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.normSAO3.xy *= perTexMatSettings3.r;
            #endif
         #endif

         #if _PERTEXAOSTR && !_DISABLESPLATMAPS
            samples.normSAO0.a = pow(samples.normSAO0.a, abs(perTexMatSettings0.b));
            samples.normSAO1.a = pow(samples.normSAO1.a, abs(perTexMatSettings1.b));
            #if !_MAX2LAYER
               samples.normSAO2.a = pow(samples.normSAO2.a, abs(perTexMatSettings2.b));
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.normSAO3.a = pow(samples.normSAO3.a, abs(perTexMatSettings3.b));
            #endif
         #endif

         #if _PERTEXSMOOTHSTR && !_DISABLESPLATMAPS
            samples.normSAO0.b += perTexMatSettings0.g;
            samples.normSAO1.b += perTexMatSettings1.g;
            samples.normSAO0.b = saturate(samples.normSAO0.b);
            samples.normSAO1.b = saturate(samples.normSAO1.b);
            #if !_MAX2LAYER
               samples.normSAO2.b += perTexMatSettings2.g;
               samples.normSAO2.b = saturate(samples.normSAO2.b);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.normSAO3.b += perTexMatSettings3.g;
               samples.normSAO3.b = saturate(samples.normSAO3.b);
            #endif
         #endif

         
         #if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_DEFERRED) || (defined(_MSRENDERLOOP_UNITYLD) && defined(_PASSFORWARD) || _MSRENDERLOOP_UNITYHD) 
          #if _PERTEXSSS
          {
            SAMPLE_PER_TEX(ptSSS, 18.5, config, half4(1, 1, 1, 1)); // tint, thickness
            
            half4 vals = ptSSS0 * heightWeights.x + ptSSS1 * heightWeights.y + ptSSS2 * heightWeights.z + ptSSS3 * heightWeights.w;
            SSSThickness = vals.a;
            SSSTint = vals.rgb;
          }
          #endif
         #endif

         #if (((_DETAILNOISE && _PERTEXDETAILNOISESTRENGTH) || (_DISTANCENOISE && _PERTEXDISTANCENOISESTRENGTH)) || (_NORMALNOISE && _PERTEXNORMALNOISESTRENGTH)) && !_DISABLESPLATMAPS
         ApplyDetailDistanceNoisePerTex(samples, config, camDist, i.worldPos, worldNormalVertex);
         #endif

         
         #if _GLOBALNOISEUV
            // noise defaults so that a value of 1, 1 is 4 pixels in size and moves the uvs by 1 pixel max.
            #if _CUSTOMSPLATTEXTURES
               noiseUV = (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, config.uv * _CustomControl0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _CustomControl0_TexelSize.xy * _NoiseUVParams.y;
            #else
               noiseUV = (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, config.uv * _Control0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _Control0_TexelSize.xy * _NoiseUVParams.y;
            #endif
         #endif

         
         #if _TRAXSINGLE || _TRAXARRAY || _TRAXNOTEXTURE
            ApplyTrax(samples, config, i.worldPos, traxBuffer, traxNormal);
         #endif

         #if (_ANTITILEARRAYDETAIL || _ANTITILEARRAYDISTANCE || _ANTITILEARRAYNORMAL) && !_DISABLESPLATMAPS
         ApplyAntiTilePerTex(samples, config, camDist, i.worldPos, worldNormalVertex, heightWeights);
         #endif

         #if _GEOMAP && !_DISABLESPLATMAPS
         GeoTexturePerTex(samples, i.worldPos, worldHeight, config, worldNormalVertex, upVector);
         #endif
         
         #if _GLOBALTINT && _PERTEXGLOBALTINTSTRENGTH && !_DISABLESPLATMAPS
         GlobalTintTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALNORMALS && _PERTEXGLOBALNORMALSTRENGTH && !_DISABLESPLATMAPS
         GlobalNormalTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALSMOOTHAOMETAL && _PERTEXGLOBALSAOMSTRENGTH && !_DISABLESPLATMAPS
         GlobalSAOMTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _GLOBALEMIS && _PERTEXGLOBALEMISSTRENGTH && !_DISABLESPLATMAPS
         GlobalEmisTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _GLOBALSPECULAR && _PERTEXGLOBALSPECULARSTRENGTH && !_DISABLESPLATMAPS && _USESPECULARWORKFLOW
         GlobalSpecularTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _PERTEXMETALLIC && !_DISABLESPLATMAPS
            half metallic = BlendWeights(perTexMatSettings0.a, perTexMatSettings1.a, perTexMatSettings2.a, perTexMatSettings3.a, heightWeights);
            o.Metallic = metallic;
         #endif

         #if _GLITTER && !_DISABLESPLATMAPS
            DoGlitter(i, samples, config, camDist, worldNormalVertex, i.worldPos);
         #endif
         
         // Blend em..
         #if _DISABLESPLATMAPS
            // If we don't sample from the _Diffuse, then the shader compiler will strip the sampler on
            // some platforms, which will cause everything to break. So we sample from the lowest mip
            // and saturate to 1 to keep the cost minimal. Annoying, but the compiler removes the texture
            // and sampler, even though the sampler is still used.
            albedo = saturate(UNITY_SAMPLE_TEX2DARRAY_LOD(_Diffuse, float3(0,0,0), 12) + 1);
            albedo.a = 0.5; // make height something we can blend with for the combined mesh mode, since it still height blends.
            normSAO = half4(0,0,0,1);
         #else
            albedo = BlendWeights(samples.albedo0, samples.albedo1, samples.albedo2, samples.albedo3, heightWeights);
            normSAO = BlendWeights(samples.normSAO0, samples.normSAO1, samples.normSAO2, samples.normSAO3, heightWeights);
            #if _USEEMISSIVEMETAL && !_DISABLESPLATMAPS
               emisMetal = BlendWeights(samples.emisMetal0, samples.emisMetal1, samples.emisMetal2, samples.emisMetal3, heightWeights);
            #endif

            #if _USESPECULARWORKFLOW && !_DISABLESPLATMAPS
               specular = BlendWeights(samples.specular0, samples.specular1, samples.specular2, samples.specular3, heightWeights);
            #endif
         #endif

         
         // ADVANCEDTERRAIN_ENTRYPOINT 


         #if _MESHOVERLAYSPLATS || _MESHCOMBINED
            o.Alpha = 1.0;
            if (config.uv0.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.x;
            else if (config.uv1.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.y;
            else if (config.uv2.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.z;
            else if (config.uv3.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.w;
         #endif



         // effects which don't require per texture adjustments and are part of the splats sample go here. 
         // Often, as an optimization, you can compute the non-per tex version of above effects here..


         #if ((_DETAILNOISE && !_PERTEXDETAILNOISESTRENGTH) || (_DISTANCENOISE && !_PERTEXDISTANCENOISESTRENGTH) || (_NORMALNOISE && !_PERTEXNORMALNOISESTRENGTH))
            ApplyDetailDistanceNoise(albedo.rgb, normSAO, config, camDist, i.worldPos, worldNormalVertex);
         #endif

         #if _SPLATFADE
         }
         #endif

         #if _SPLATFADE
            // blend in uniform texture over splat fade range
            // only for planets? Fine on terrain, but may want a switch for this..
            #if _TRIPLANAR && (_PLANETNORMAL || _PLANETNORMAL2)
               

               float3 pN = pow(abs(worldNormalVertex), 0.7);
               pN = pN / (pN.x + pN.y + pN.z);
            
               half3 axisSign = sign(worldNormalVertex);

               float2 uv0 = i.worldPos.zy * axisSign.x * _TriplanarUVScale.xy;
               float2 uv1 = i.worldPos.xz * axisSign.y * _TriplanarUVScale.xy;
               float2 uv2 = i.worldPos.xy * axisSign.z * _TriplanarUVScale.xy;

               float2 sfDX = ddx(uv0);
               float2 sfDY = ddy(uv0);

               MSBRANCHOTHER(camDist - _SplatFade.x)
               {
                  float falloff = saturate(InverseLerp(_SplatFade.x, _SplatFade.y, camDist));
                  half4 sfalb0 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(uv0, _SplatFade.z), sfDX, sfDY);
                  half4 sfalb1 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(uv1, _SplatFade.z), sfDX, sfDY);
                  half4 sfalb2 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(uv2, _SplatFade.z), sfDX, sfDY);
                  COUNTSAMPLE
                  COUNTSAMPLE
                  COUNTSAMPLE
                  albedo.rgb = lerp(albedo.rgb, sfalb0.rgb * pN.x + sfalb1 * pN.y + sfalb2 * pN.z, falloff);

                  #if !_NONOMALMAP
                     half4 sfnormSAO0 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(uv0, _SplatFade.z), sfDX, sfDY).garb;
                     half4 sfnormSAO1 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(uv1, _SplatFade.z), sfDX, sfDY).garb;
                     half4 sfnormSAO2 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(uv2, _SplatFade.z), sfDX, sfDY).garb;
                     COUNTSAMPLE
                     COUNTSAMPLE
                     COUNTSAMPLE
                     half4 sfnormSAO = sfnormSAO0 * pN.x + sfnormSAO1 * pN.y + sfnormSAO2 * pN.z;
                     sfnormSAO.xy = sfnormSAO.xy * 2 - 1;

                     normSAO = lerp(normSAO, sfnormSAO, falloff);
                  #endif
              
               }
            #else // _TRIPLANAR && (_PLANETNORMAL || _PLANETNORMAL2)
            float2 sfDX = ddx(config.uv * _UVScale);
            float2 sfDY = ddy(config.uv * _UVScale);

            MSBRANCHOTHER(camDist - _SplatFade.x)
            {
               float falloff = saturate(InverseLerp(_SplatFade.x, _SplatFade.y, camDist));
               half4 sfalb = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(config.uv * _UVScale, _SplatFade.z), sfDX, sfDY);
               COUNTSAMPLE
               albedo.rgb = lerp(albedo.rgb, sfalb.rgb, falloff);

               #if !_NONOMALMAP
                  half4 sfnormSAO = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(config.uv * _UVScale, _SplatFade.z), sfDX, sfDY).garb;
                  COUNTSAMPLE
                  sfnormSAO.xy = sfnormSAO.xy * 2 - 1;

                  normSAO = lerp(normSAO, sfnormSAO, falloff);
               #endif
              
            }
            #endif
         #endif


         #if _MESHCOMBINED
            SampleMeshCombined(albedo, normSAO, emisMetal, specular, o.Alpha, SSSThickness, SSSTint, config, heightWeights);
         #endif
         
         #if _SCATTER
            ApplyScatter(i, albedo, normSAO, config.uv, camDist);
         #endif

         #if _GEOMAP
            GeoTexture(albedo.rgb, normSAO, i.worldPos, worldHeight, config, worldNormalVertex, upVector);
         #endif

         #if _PLANETALBEDO || _PLANETNORMAL || _PLANETALBEDO2 || _PLANETNORMAL2
            ApplyPlanet(i, albedo, normSAO, config, camDist, i.worldPos, worldNormalVertex);
         #endif


         #if _GLOBALTINT && !_PERTEXGLOBALTINTSTRENGTH
            GlobalTintTexture(albedo.rgb, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _VSGRASSMAP
            VSGrassTexture(albedo.rgb, config, camDist);
         #endif

         #if _GLOBALNORMALS && !_PERTEXGLOBALNORMALSTRENGTH
            GlobalNormalTexture(normSAO, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALSMOOTHAOMETAL && !_PERTEXGLOBALSAOMSTRENGTH
            GlobalSAOMTexture(normSAO, emisMetal, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALEMIS && !_PERTEXGLOBALEMISSTRENGTH
            GlobalEmisTexture(emisMetal, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _GLOBALSPECULAR && !_PERTEXGLOBALSPECULARSTRENGTH && _USESPECULARWORKFLOW
            GlobalSpecularTexture(specular.rgb, config, camDist, globalSlopeFilter, noiseUV);
         #endif

        
         
         o.Albedo = albedo.rgb;
         o.Height = albedo.a;
         o.Normal = half3(normSAO.xy, 1);
         o.Smoothness = normSAO.b;
         o.Occlusion = normSAO.a;

         #if _USEEMISSIVEMETAL || _GLOBALSMOOTHAOMETAL || _GLOBALEMIS 
         o.Emission = emisMetal.rgb;
         o.Metallic = emisMetal.a;
	        #if _USEEMISSIVEMETAL
	        o.Emission *= _EmissiveMult;
	        #endif
         #endif

         #if _USESPECULARWORKFLOW
            o.Specular = specular;
         #endif


         


         #if _WETNESS || _PUDDLES || _STREAMS || _LAVA
         pud = DoStreams(i, o, fxLevels, config.uv, porosity, waterNormalFoam, worldNormalVertex, streamFoam, wetLevel, burnLevel, i.worldPos);
         #endif

         
         #if _SNOW
         snowCover = DoSnow(o, config.uv, WorldNormalVector(i, o.Normal), worldNormalVertex, i.worldPos, pud, porosity, camDist, 
            config, weights, SSSTint, SSSThickness, traxBuffer, traxNormal);
         #endif

         #if _PERTEXSSS || _MESHCOMBINEDUSESSS || (_SNOW && _SNOWSSS)
         {
            half3 worldView = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

            o.Emission += ComputeSSS(i, worldView, WorldNormalVector(i, half3(normSAO.xy, 1)),
               SSSTint, SSSThickness, _SSSDistance, _SSSScale, _SSSPower);
         }
         #endif
         
         #if _SNOWGLITTER
            DoSnowGlitter(i, config, o, camDist, worldNormalVertex, snowCover);
         #endif

         #if _WINDPARTICULATE || _SNOWPARTICULATE
         DoWindParticulate(i, o, config, weights, camDist, worldNormalVertex, snowCover);
         #endif

         o.Normal.z = sqrt(1 - saturate(dot(o.Normal.xy, o.Normal.xy)));

         #if _SPECULARFADE
         {
            float specFade = saturate((i.worldPos.y - _SpecularFades.x) / max(_SpecularFades.y - _SpecularFades.x, 0.0001));
            o.Metallic *= specFade;
            o.Smoothness *= specFade;
         }
         #endif

         #if _VSSHADOWMAP
         VSShadowTexture(o, i, config, camDist);
         #endif
         
         #if _TOONWIREFRAME
         ToonWireframe(config.uv, o.Albedo);
         #endif

         #if _DEBUG_TRAXBUFFER
            ClearAllButAlbedo(o, half3(traxBuffer, 0, 0) * saturate(o.Albedo.z+1));
         #elif _DEBUG_WORLDNORMALVERTEX
            ClearAllButAlbedo(o, worldNormalVertex * saturate(o.Albedo.z+1));
         #elif _DEBUG_WORLDNORMAL
            ClearAllButAlbedo(o,  WorldNormalVector(i, o.Normal) * saturate(o.Albedo.z+1));
         #endif

         return o;
      }
      
      void SampleSplats(float2 controlUV, inout half4 w0, inout half4 w1, inout half4 w2, inout half4 w3, inout half4 w4, inout half4 w5, inout half4 w6, inout half4 w7)
      {
         #if _CUSTOMSPLATTEXTURES
            #if !_MICROMESH
            controlUV = (controlUV * (_CustomControl0_TexelSize.zw - 1.0f) + 0.5f) * _CustomControl0_TexelSize.xy;
            #endif

            #if  _CONTROLNOISEUV
               controlUV += (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, controlUV * _CustomControl0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _CustomControl0_TexelSize.xy * _NoiseUVParams.y;
            #endif

            w0 = UNITY_SAMPLE_TEX2D(_CustomControl0, controlUV);
            COUNTSAMPLE

            #if !_MAX4TEXTURES
            w1 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl1, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES
            w2 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl2, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
            w3 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl3, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w4 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl4, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w5 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl5, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX28TEXTURES || _MAX32TEXTURES
            w6 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl6, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX32TEXTURES
            w7 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl7, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif
         #else
            #if !_MICROMESH
            controlUV = (controlUV * (_Control0_TexelSize.zw - 1.0f) + 0.5f) * _Control0_TexelSize.xy;
            #endif

            #if  _CONTROLNOISEUV
               controlUV += (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, controlUV * _Control0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _Control0_TexelSize.xy * _NoiseUVParams.y;
            #endif

            w0 = UNITY_SAMPLE_TEX2D(_Control0, controlUV);
            COUNTSAMPLE

            #if !_MAX4TEXTURES
            w1 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control1, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES
            w2 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control2, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
            w3 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control3, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w4 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control4, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w5 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control5, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX28TEXTURES || _MAX32TEXTURES
            w6 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control6, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX32TEXTURES
            w7 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control7, _Control0, controlUV);
            COUNTSAMPLE
            #endif
         #endif
      }   


      

      MicroSplatLayer SurfImpl(Input i, float3 worldNormalVertex)
      {
         // with DrawInstanced on, view dir is incorrect, so we compute it here. Thanks Obama..
         #if _MSRENDERLOOP_SURFACESHADER && !_DEBUG_USE_TOPOLOGY &&!_TERRAINBLENDABLESHADER && !_MICROMESH && !_MICROMESHTERRAIN && !_MICROPOLARISMESH &&!_MICRODIGGERMESH && !_MICROVERTEXMESH && defined(UNITY_INSTANCING_ENABLED)
            float3 t2w0 = WorldNormalVector(i, float3(1,0,0));
            float3 t2w1 = WorldNormalVector(i, float3(0,1,0));
            float3 t2w2 = WorldNormalVector(i, float3(0,0,1));
            float3x3 t2w = float3x3(t2w0, t2w1, t2w2);
            i.viewDir = normalize(mul(t2w, (_WorldSpaceCameraPos - i.worldPos)));
         #elif !_MSRENDERLOOP_SURFACESHADER
            // tangent space view dir is just not correct in URP
            i.viewDir = normalize( mul(i.TBN, (_WorldSpaceCameraPos - i.worldPos)) );
         #endif


         #if _TERRAINBLENDABLESHADER && _TRIPLANAR
            worldNormalVertex = WorldNormalVector(i, float3(0,0,1));
         #endif
         
         float camDist = distance(_WorldSpaceCameraPos, i.worldPos);
          
         #if _FORCELOCALSPACE
            #if _PLANETVECTORS
                worldNormalVertex = mul(_PQSToLocal, float4(worldNormalVertex, 1)).xyz;
                i.worldPos = i.worldPos + mul(_PQSToLocal, float4(0,0,0,1)).xyz;
             #else
                worldNormalVertex = mul((float3x3)GetWorldToObjectMatrix(), worldNormalVertex).xyz;
                i.worldPos = i.worldPos -  mul(GetObjectToWorldMatrix(), float4(0,0,0,1)).xyz;
             #endif
         #endif

         #if _ORIGINSHIFT
             //worldNormalVertex = mul(_GlobalOriginMTX, float4(worldNormalVertex, 1)).xyz;
             i.worldPos = i.worldPos + mul(_GlobalOriginMTX, float4(0,0,0,1)).xyz;
         #endif

         #if _DEBUG_USE_TOPOLOGY
            i.worldPos = UNITY_SAMPLE_TEX2D_SAMPLER(_DebugWorldPos, _Diffuse, i.uv_Control0);
            worldNormalVertex = UNITY_SAMPLE_TEX2D_SAMPLER(_DebugWorldNormal, _Diffuse, i.uv_Control0);
         #endif

         #if _ALPHABELOWHEIGHT && !_TBDISABLEALPHAHOLES
            ClipWaterLevel(i.worldPos);
         #endif

         #if !_TBDISABLEALPHAHOLES && defined(_ALPHATEST_ON)
            // UNITY 2019.3 holes
            ClipHoles(i.uv_Control0);
         #endif


         float2 origUV = i.uv_Control0;

         #if _MICROMESH && _MESHUV2
         float2 controlUV = i.uv2_Diffuse;
         #else
         float2 controlUV = i.uv_Control0;
         #endif


         #if _MICROMESH
            controlUV = InverseLerp(_UVMeshRange.xy, _UVMeshRange.zw, controlUV);
         #endif

         half4 weights = half4(1,0,0,0);

         Config config = (Config)0;
         UNITY_INITIALIZE_OUTPUT(Config,config);
         config.uv = origUV;

         #if _SPLATFADE
         MSBRANCHOTHER(_SplatFade.y - camDist)
         #endif // _SPLATFADE
         {
            #if !_DISABLESPLATMAPS

               // Sample the splat data, from textures or vertices, and setup the config..
               #if _MICRODIGGERMESH
                  DiggerSetup(i, weights, origUV, config, i.worldPos);
               #elif _MICROVERTEXMESH
                  VertexSetup(i, weights, origUV, config, i.worldPos);
               #elif !_PROCEDURALTEXTURE || _PROCEDURALBLENDSPLATS
                  half4 w0 = 0; half4 w1 = 0; half4 w2 = 0; half4 w3 = 0; half4 w4 = 0; half4 w5 = 0; half4 w6 = 0; half4 w7 = 0;
                  SampleSplats(controlUV, w0, w1, w2, w3, w4, w5, w6, w7);
                  Setup(weights, origUV, config, w0, w1, w2, w3, w4, w5, w6, w7, i.worldPos);
               #endif

               #if _PROCEDURALTEXTURE
                  float3 up = float3(0,1,0);
                  float3 procNormal = worldNormalVertex;
                  float height = i.worldPos.y;
                  ProceduralSetup(i, i.worldPos, height, procNormal, up, weights, origUV, config, ddx(origUV), ddy(origUV), ddx(i.worldPos), ddy(i.worldPos));

                  #if _PLANETNORMAL2 || _PLANETNORMAL
                     config.uv = origUV;
                     float2 pnorm = GetPlanetTangentNormal(i, config, camDist, worldNormalVertex);
                     procNormal.xy = pnorm;
                     procNormal.z = sqrt(1 - procNormal.x * procNormal.x - procNormal.y * procNormal.y);
                     procNormal = WorldNormalVector(i, procNormal);
                     up = worldNormalVertex;
                     float3 center = mul(GetWorldToObjectMatrix(), float3(0,0,0));
                     height = distance(i.worldPos, center); 
                  #endif
               #endif
            #else // _DISABLESPLATMAPS
                Setup(weights, origUV, config, half4(1,0,0,0), 0, 0, 0, 0, 0, 0, 0, i.worldPos);
            #endif
         } // _SPLATFADE else case

         
         #if _TOONFLATTEXTURE
            float2 quv = floor(origUV * _ToonTerrainSize);
            float2 fuv = frac(origUV * _ToonTerrainSize);
            #if !_TOONFLATTEXTUREQUAD
               quv = Hash2D((fuv.x > fuv.y) ? quv : quv * 0.333);
            #endif
            float2 uvq = quv / _ToonTerrainSize;
            config.uv0.xy = uvq;
            config.uv1.xy = uvq;
            config.uv2.xy = uvq;
            config.uv3.xy = uvq;
         #endif
         
         #if (_TEXTURECLUSTER2 || _TEXTURECLUSTER3) && !_DISABLESPLATMAPS
            PrepClusters(origUV, config, i.worldPos, worldNormalVertex);
         #endif

         #if (_ALPHAHOLE || _ALPHAHOLETEXTURE) && !_DISABLESPLATMAPS && !_TBDISABLEALPHAHOLES
         ClipAlphaHole(config, weights);
         #endif


 
         MicroSplatLayer l = Sample(i, weights, config, camDist, worldNormalVertex);

         
         // HI, this is the section where we hack around various Unity and compiler bugs..

         // Unity has a compiler bug with surface shaders where in some situations it will strip/fuckup
         // i.worldPos or i.viewDir thinking your not using them when you are inside a function. I have
         // fought with this bug so many times it's crazy, reported it and provided repros, and nothing has
         // been done about it. So, make sure these are used, and look like they could have an effect on the final
         // output so the compiler doesn't fuck them up.
         
         // Oh, nice, and it turns out that doing this in the base map shader breaks GI, so only do it in the main
         // shader, which is where we're using i.viewDir for parallax. Fucking hell..

         // AND if triplanar is on, this needs to be run otherwise the UV scale is fucked. I feel like I'm just
         // pushing compiler errors around at this point.. And this breaks render baking, so not then either.
         //
         // And sometimes VD is INF or NAN, so we copy it (make sure the compiler knows we are using) and
         // test for a value, and if it's not 1 we make it 1, so it doesn't make albedo black.
         //
         // Jusus fucking christ already..
         #if (!_MICROSPLATBASEMAP || _TRIPLANAR) && !_RENDERBAKE
            float3 vd = i.viewDir;
            if (vd.x != 1)
               vd = 1;
            l.Albedo *= saturate(vd + i.worldPos + 9999);
         #endif

         // Further, on windows, sometimes the diffuse sampler gets stripped, so we have to do this crap.
         // We sample from the lowest mip, so it shouldn't cost much, but still, I hate this, wtf..
         l.Albedo *= saturate(UNITY_SAMPLE_TEX2DARRAY_LOD(_Diffuse, config.uv0, 11).r + 2);
         // same for the control sampler.
         l.Albedo *= saturate(MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(_Control0, _Control0, config.uv, 11).r + 2);

         #if _PROCEDURALTEXTURE
            ProceduralTextureDebugOutput(l, weights, config);
         #endif
         


         return l;

      }



   


                    //MS_BLENDABLE

                    






    
    MicroSplatLayer DoMicroSplat(inout SurfaceDescriptionInputs IN)
    {
       SurfaceDescription surface = (SurfaceDescription)0;
       Input i = DescToInput(IN);
       float3 worldNormalVertex = IN.WorldSpaceNormal;

        #if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL) && !_MICROMESH && !_MICROMESHTERRAIN && !_MICROPOLARISMESH && !_MICRODIGGERMESH && !_MICROVERTEXMESH
            float2 terrainNormalMapUV = (i.uv_Control0.xy + 0.5f) * _TerrainHeightmapRecipSize.xy;
            i.uv_Control0.xy *= _TerrainHeightmapRecipSize.zw;
            

            #if _TOONHARDEDGENORMAL
               terrainNormalMapUV = ToonEdgeUV(terrainNormalMapUV);
            #endif
            float3 geomNormal = normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, terrainNormalMapUV).xyz * 2 - 1);

            worldNormalVertex = mul((float3x3)GetObjectToWorldMatrix(), geomNormal);
            IN.WorldSpaceNormal = worldNormalVertex;
            float4 tangentWS = ConstructTerrainTangent(IN.WorldSpaceNormal, GetObjectToWorldMatrix()._13_23_33);
            IN.WorldSpaceTangent = tangentWS.xyz;
            i.TBN = BuildTangentToWorld(tangentWS, IN.WorldSpaceNormal.xyz);
            IN.WorldSpaceBiTangent = i.TBN[1].xyz;
        #elif _PERPIXNORMAL
            float2 perPixUV = i.uv_Control0;
            #if _TOONHARDEDGENORMAL
               perPixUV = ToonEdgeUV(perPixUV);
            #endif
            float3 geomNormal = (UnpackNormal(UNITY_SAMPLE_TEX2D_SAMPLER(_PerPixelNormal, _Diffuse, perPixUV))).xzy;
            worldNormalVertex = geomNormal;
        #endif    
        
         
         #if _SRPTERRAINBLEND
            SurfaceOutputCustom soc = (SurfaceOutputCustom)0;
            soc.input = i;
            float3 sh = 0;
            BlendWithTerrainSRP(soc, IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);

            MicroSplatLayer l = (MicroSplatLayer)0;
            l.Albedo = soc.Albedo;
            l.Normal = mul(float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal), soc.Normal);
            l.Emission = soc.Emission;
            l.Metallic = soc.Metallic;
            l.Smoothness = soc.Smoothness;
            #if _USESPECULARWORKFLOW
               l.Specular = soc.Specular;
            #endif
            l.Occlusion = soc.Occlusion;
            l.Alpha = soc.Alpha;

         #else
            MicroSplatLayer l = SurfImpl(i, worldNormalVertex);
         #endif


       // per pixel normal
        #if ((defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)) && !_MICROMESHTERRAIN && !_MICROMESH && !_MICROVERTEXMESH && !_MICRODIGGERMESH && !_MICROPOLARISMESH) || (_MICROMESHTERRAIN && _PERPIXNORMAL)
            float3 geomTangent = normalize(cross(geomNormal, float3(0, 0, 1)));
            float3 geomBitangent = normalize(cross(geomTangent, geomNormal));
            l.Normal = l.Normal.x * geomTangent + l.Normal.y * geomBitangent + l.Normal.z * geomNormal;
            l.Normal = l.Normal.xzy;
        #endif

        DoDebugOutput(l);


        return l;
    }



        

                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        MicroSplatLayer l = DoMicroSplat(IN);

                        SurfaceDescription surface = (SurfaceDescription)0;
 
                        surface.Normal = l.Normal;
                        surface.Smoothness = l.Smoothness;
                        surface.Alpha = l.Alpha;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    output.texCoord0 = input.texCoord0;
                    output.texCoord1 = input.texCoord1;
                    output.texCoord2 = input.texCoord2;
                    //output.texCoord3 = input.texCoord3;
                    //output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    // output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    output.WorldSpaceNormal =            normalize(input.tangentToWorld[2].xyz);
                    // output.ObjectSpaceNormal =           mul(output.WorldSpaceNormal, (float3x3) GetObjectToWorldMatrix());           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    // output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // specularOcclusion need to be init ahead of decal to quiet the compiler that modify the SurfaceData struct
                // however specularOcclusion can come from the graph, so need to be init here so it can be override.
                surfaceData.specularOcclusion = 1.0;
        
                // copy across graph values, if defined
                // surfaceData.baseColor =                 surfaceDescription.Albedo;
                surfaceData.perceptualSmoothness =      surfaceDescription.Smoothness;
                // surfaceData.ambientOcclusion =          surfaceDescription.Occlusion;
                // surfaceData.specularOcclusion =         surfaceDescription.SpecularOcclusion;
                // surfaceData.metallic =                  surfaceDescription.Metallic;
                // surfaceData.subsurfaceMask =            surfaceDescription.SubsurfaceMask;
                // surfaceData.thickness =                 surfaceDescription.Thickness;
                // surfaceData.diffusionProfileHash =      asuint(surfaceDescription.DiffusionProfileHash);
                // surfaceData.specularColor =             surfaceDescription.Specular;
                // surfaceData.coatMask =                  surfaceDescription.CoatMask;
                // surfaceData.anisotropy =                surfaceDescription.Anisotropy;
                // surfaceData.iridescenceMask =           surfaceDescription.IridescenceMask;
                // surfaceData.iridescenceThickness =      surfaceDescription.IridescenceThickness;
        
        #ifdef _HAS_REFRACTION
                if (_EnableSSRefraction)
                {
                    // surfaceData.ior =                       surfaceDescription.RefractionIndex;
                    // surfaceData.transmittanceColor =        surfaceDescription.RefractionColor;
                    // surfaceData.atDistance =                surfaceDescription.RefractionDistance;
        
                    surfaceData.transmittanceMask = (1.0 - surfaceDescription.Alpha);
                    surfaceDescription.Alpha = 1.0;
                }
                else
                {
                    surfaceData.ior = 1.0;
                    surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                    surfaceData.atDistance = 1.0;
                    surfaceData.transmittanceMask = 0.0;
                    surfaceDescription.Alpha = 1.0;
                }
        #else
                surfaceData.ior = 1.0;
                surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                surfaceData.atDistance = 1.0;
                surfaceData.transmittanceMask = 0.0;
        #endif
                
                // These static material feature allow compile time optimization
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
                // surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
        
        #ifdef _MATERIAL_FEATURE_IRIDESCENCE
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
        #endif
        #ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
        #endif
        
        #if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
                // Require to have setup baseColor
                // Reproduce the energy conservation done in legacy Unity. Not ideal but better for compatibility and users can unchek it
                surfaceData.baseColor *= (1.0 - Max3(surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b));
        #endif
        
        #ifdef _DOUBLESIDED_ON
            float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
        #else
            float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        #endif
        
                // tangent-space normal
                float3 normalTS = float3(0.0f, 0.0f, 1.0f);
                normalTS = surfaceDescription.Normal;
        
                // compute world space normal
                GetNormalWS(fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants);
        
                surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];
        
                surfaceData.tangentWS = normalize(fragInputs.tangentToWorld[0].xyz);    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
                // surfaceData.tangentWS = TransformTangentToWorld(surfaceDescription.Tangent, fragInputs.tangentToWorld);
        
        #if HAVE_DECALS
                if (_EnableDecals)
                {
                    // Both uses and modifies 'surfaceData.normalWS'.
                    DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
                    ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
                }
        #endif
        
                bentNormalWS = surfaceData.normalWS;
                // GetNormalWS(fragInputs, surfaceDescription.BentNormal, bentNormalWS, doubleSidedConstants);
        
                surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);
        
        
                // By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion.
                // If user provide bent normal then we process a better term
        #if defined(_SPECULAR_OCCLUSION_CUSTOM)
                // Just use the value passed through via the slot (not active otherwise)
        #elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
                // If we have bent normal and ambient occlusion, process a specular occlusion
                surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO(V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness(surfaceData.perceptualSmoothness));
        #elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
                surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
        #endif
        
        #ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
                surfaceData.perceptualSmoothness = GeometricNormalFiltering(surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[2], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold);
        #endif
        
        #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO: need to update mip info
                    surfaceData.metallic = 0;
                }
        
                // We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
                // as it can modify attribute use for static lighting
                ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
        #ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
                uint3 fadeMaskSeed = asuint((int3)(V * _ScreenSize.xyx)); // Quantize V to _ScreenSize values
                LODDitheringTransition(fadeMaskSeed, unity_LODFade.x);
        #endif
        
        #ifdef _DOUBLESIDED_ON
            float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
        #else
            float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        #endif
        
                ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdDepthPrepass);
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdDepthPostpass);
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdShadow);
                
                // ApplyDepthOffsetPositionInput(V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput);
        
                float3 bentNormalWS;
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS);
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal 
                InitBuiltinData(posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[2], fragInputs.texCoord1, fragInputs.texCoord2, builtinData);
        
                // override sampleBakedGI:
                // builtinData.bakeDiffuseLighting = surfaceDescription.BakedGI;
                // builtinData.backBakeDiffuseLighting = surfaceDescription.BakedBackGI;
        
                // builtinData.emissiveColor = surfaceDescription.Emission;
        
                // builtinData.depthOffset = surfaceDescription.DepthOffset;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #else
                builtinData.distortion = float2(0.0, 0.0);
                builtinData.distortionBlur = 0.0;
        #endif
        
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassDepthOnly.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDLitPass.template
            Name "GBuffer"
            Tags { "LightMode" = "GBuffer" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            
            Cull [_CullMode]
        
            ZTest [_ZTestGBuffer]
        
            
            
            // Stencil setup
        Stencil
        {
           WriteMask [_StencilWriteMaskGBuffer]
           Ref [_StencilRefGBuffer]
           Comp Always
           Pass Replace
        }
        
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            #pragma shader_feature_local _TERRAIN_INSTANCED_PERPIXEL_NORMAL
            #pragma multi_compile_instancing
            #pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap renderinglayer
        
        #pragma multi_compile_local _ _ALPHATEST_ON
        
            // #pragma multi_compile _ LOD_FADE_CROSSFADE
        
            #pragma shader_feature _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _DOUBLESIDED_ON
            #pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
            // #define _MATERIAL_FEATURE_SUBSURFACE_SCATTERING 1
            // #define _MATERIAL_FEATURE_TRANSMISSION 1
            // #define _MATERIAL_FEATURE_ANISOTROPY 1
            // #define _MATERIAL_FEATURE_IRIDESCENCE 1
            // #define _MATERIAL_FEATURE_SPECULAR_COLOR 1
            // #define _ENABLE_FOG_ON_TRANSPARENT 1
            #define _AMBIENT_OCCLUSION 1
            #define _SPECULAR_OCCLUSION_FROM_AO 1
            // #define _SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL 1
            // #define _SPECULAR_OCCLUSION_CUSTOM 1
            #define _ENERGY_CONSERVING_SPECULAR 1
            // #define _ENABLE_GEOMETRIC_SPECULAR_AA 1
            // #define _HAS_REFRACTION 1
            // #define _REFRACTION_PLANE 1
            // #define _REFRACTION_SPHERE 1
            // #define _DISABLE_DECALS 1
            // #define _DISABLE_SSR 1
            // #define _ADD_PRECOMPUTED_VELOCITY
            // #define _WRITE_TRANSPARENT_MOTION_VECTOR 1
            // #define _DEPTHOFFSET_ON 1
            // #define _BLENDMODE_PRESERVE_SPECULAR_LIGHTING 1

            
      #define _MICROSPLAT 1
      #define _ALPHABELOWHEIGHT 1
      #define _MSRENDERLOOP_UNITYHD 1


        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            // If we use subsurface scattering, enable output split lighting (for forward pass)
            #if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
            #define OUTPUT_SPLIT_LIGHTING
            #endif
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Defines
            //-------------------------------------------------------------------------------------
                    #define SHADERPASS SHADERPASS_GBUFFER
                #pragma multi_compile _ DEBUG_DISPLAY
                #pragma multi_compile _ LIGHTMAP_ON
                #pragma multi_compile _ DIRLIGHTMAP_COMBINED
                #pragma multi_compile _ DYNAMICLIGHTMAP_ON
                #pragma multi_compile _ SHADOWS_SHADOWMASK
                #pragma multi_compile DECALS_OFF DECALS_3RT DECALS_4RT
                #pragma multi_compile _ LIGHT_LAYERS
                #define RAYTRACING_SHADER_GRAPH_HIGH
                #define REQUIRE_DEPTH_TEXTURE
                // ACTIVE FIELDS:
                //   Material.Standard
                //   Specular.EnergyConserving
                //   SpecularOcclusionFromAO
                //   AmbientOcclusion
                //   SurfaceDescriptionInputs.ScreenPosition
                //   SurfaceDescriptionInputs.VertexColor
                //   SurfaceDescriptionInputs.WorldSpaceNormal
                //   SurfaceDescriptionInputs.TangentSpaceNormal
                //   SurfaceDescriptionInputs.WorldSpaceTangent
                //   SurfaceDescriptionInputs.WorldSpaceBiTangent
                //   SurfaceDescriptionInputs.WorldSpaceViewDirection
                //   SurfaceDescriptionInputs.TangentSpaceViewDirection
                //   SurfaceDescriptionInputs.ObjectSpacePosition
                //   SurfaceDescriptionInputs.AbsoluteWorldSpacePosition
                //   SurfaceDescriptionInputs.uv0
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.ObjectSpacePosition
                //   SurfaceDescription.Albedo
                //   SurfaceDescription.Normal
                //   SurfaceDescription.BentNormal
                //   SurfaceDescription.CoatMask
                //   SurfaceDescription.Metallic
                //   SurfaceDescription.Emission
                //   SurfaceDescription.Smoothness
                //   SurfaceDescription.Occlusion
                //   SurfaceDescription.Alpha
                //   features.modifyMesh
                //   VertexDescription.VertexPosition
                //   VertexDescription.VertexNormal
                //   VertexDescription.VertexTangent
                //   FragInputs.tangentToWorld
                //   FragInputs.positionRWS
                //   FragInputs.texCoord1
                //   FragInputs.texCoord2
                //   SurfaceDescriptionInputs.WorldSpacePosition
                //   FragInputs.color
                //   FragInputs.texCoord0
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.positionOS
                //   VaryingsMeshToPS.tangentWS
                //   VaryingsMeshToPS.normalWS
                //   VaryingsMeshToPS.positionRWS
                //   VaryingsMeshToPS.texCoord1
                //   VaryingsMeshToPS.texCoord2
                //   VaryingsMeshToPS.color
                //   VaryingsMeshToPS.texCoord0
                //   AttributesMesh.uv1
                //   AttributesMesh.uv2
                //   AttributesMesh.color
                //   AttributesMesh.uv0
                // Shared Graph Keywords
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            //#define ATTRIBUTES_NEED_TEXCOORD1
            //#define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            //#define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            #define VARYINGS_NEED_TEXCOORD0
            //#define VARYINGS_NEED_TEXCOORD1
            //#define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            //#define VARYINGS_NEED_COLOR
            // #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
        // We need isFontFace when using double sided
        #if defined(_DOUBLESIDED_ON) && !defined(VARYINGS_NEED_CULLFACE)
            #define VARYINGS_NEED_CULLFACE
        #endif
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
            
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
        #ifdef DEBUG_DISPLAY
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
        #if (SHADERPASS == SHADERPASS_FORWARD)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
        
            #define HAS_LIGHTLOOP
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL; // optional
                float4 tangentOS : TANGENT; // optional
                float4 uv0 : TEXCOORD0; // optional
                float4 uv1 : TEXCOORD1; // optional
                float4 uv2 : TEXCOORD2; // optional
                //float4 color : COLOR; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_Position;
                float3 positionRWS; // optional
                float3 normalWS; // optional
                float4 tangentWS; // optional
                float4 texCoord0; // optional
                float4 texCoord1; // optional
                float4 texCoord2; // optional
                //float4 color; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_Position; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
                float4 interp02 : TEXCOORD2; // auto-packed
                float4 interp03 : TEXCOORD3; // auto-packed
                float4 interp04 : TEXCOORD4; // auto-packed
                float4 interp05 : TEXCOORD5; // auto-packed
                //float4 interp06 : TEXCOORD6; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                output.interp03.xyzw = input.texCoord0;
                output.interp04.xyzw = input.texCoord1;
                output.interp05.xyzw = input.texCoord2;
                //output.interp06.xyzw = input.color;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                output.texCoord0 = input.interp03.xyzw;
                output.texCoord1 = input.interp04.xyzw;
                output.texCoord2 = input.interp05.xyzw;
                //output.color = input.interp06.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------

        
      
      #define UNITY_DECLARE_TEX2D(name) TEXTURE2D(name); SAMPLER(sampler_##name);
      #define UNITY_DECLARE_TEX2D_NOSAMPLER(name) TEXTURE2D(name);
      #define UNITY_DECLARE_TEX2DARRAY(name) TEXTURE2D_ARRAY(name); SAMPLER(sampler_##name);
     
      #define UNITY_SAMPLE_TEX2DARRAY(tex,coord)            SAMPLE_TEXTURE2D_ARRAY(tex, sampler_##tex, coord.xy, coord.z)
      #define UNITY_SAMPLE_TEX2DARRAY_LOD(tex,coord,lod)    SAMPLE_TEXTURE2D_ARRAY_LOD(tex, sampler_##tex, coord.xy, coord.z, lod)
      #define UNITY_SAMPLE_TEX2D(tex, coord)                SAMPLE_TEXTURE2D(tex, sampler_##tex, coord)
      #define UNITY_SAMPLE_TEX2D_SAMPLER(tex, samp, coord)  SAMPLE_TEXTURE2D(tex, sampler_##samp, coord)

     
      #if defined(UNITY_COMPILER_HLSL)
         #define UNITY_INITIALIZE_OUTPUT(type,name) name = (type)0;
      #else
         #define UNITY_INITIALIZE_OUTPUT(type,name)
      #endif

      #define sampler2D_float sampler2D
      #define sampler2D_half sampler2D

      


   

            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 _EmissionColor;
                    float _RenderQueueType;
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
                    float _UseShadowThreshold;
                    float _DoubleSidedEnable;
                    float _DoubleSidedNormalMode;
                    float4 _DoubleSidedConstants;
                    

      #if _MESHSUBARRAY
         half4 _MeshSubArrayIndexes;
      #endif


      #if _USEEMISSIVEMETAL
         half _EmissiveMult;
      #endif

      float4 _UVScale; // scale and offset

      float2 _ToonTerrainSize;

      half _Contrast;
      
      float3 _gGlitterLightDir;
      float3 _gGlitterLightWorldPos;
      half3 _gGlitterLightColor;

       #if _VSSHADOWMAP
         float4 gVSSunDirection;
      #endif

      #if _FORCELOCALSPACE && _PLANETVECTORS
         float4x4 _PQSToLocal;
      #endif

      #if _ORIGINSHIFT
         float4x4 _GlobalOriginMTX;
      #endif

      float4 _Control0_TexelSize;
      float4 _CustomControl0_TexelSize;
      float4 _PerPixelNormal_TexelSize;

      #if _CONTROLNOISEUV || _GLOBALNOISEUV
         float2 _NoiseUVParams;
      #endif





      float2 _AlphaData;
      


                    CBUFFER_END
                
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpaceNormal; // optional
                        float3 TangentSpaceNormal; // optional
                        float3 WorldSpaceTangent; // optional
                        float3 WorldSpaceBiTangent; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 TangentSpaceViewDirection; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float3 AbsoluteWorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                        float4 uv0; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Albedo;
                        float3 Normal;
                        float3 BentNormal;
                        float CoatMask;
                        float Metallic;
                        float3 Emission;
                        float3 Specular;
                        float Smoothness;
                        float Occlusion;
                        float Alpha;
                    };
                    
                    
#if defined(UNITY_INSTANCING_ENABLED) 
    #define ENABLE_TERRAIN_PERPIXEL_NORMAL
#endif 
 
#ifndef UNITY_TERRAIN_CB_VARS
    #define UNITY_TERRAIN_CB_VARS
#endif

#ifndef UNITY_TERRAIN_CB_DEBUG_VARS
    #define UNITY_TERRAIN_CB_DEBUG_VARS
#endif

CBUFFER_START(UnityTerrain)
    UNITY_TERRAIN_CB_VARS
#ifdef UNITY_INSTANCING_ENABLED 
    float4 _TerrainHeightmapRecipSize;  // float4(1.0f/width, 1.0f/height, 1.0f/(width-1), 1.0f/(height-1))
    float4 _TerrainHeightmapScale;      // float4(hmScale.x, hmScale.y / (float)(kMaxHeight), hmScale.z, 0.0f)
#endif
#ifdef DEBUG_DISPLAY
    UNITY_TERRAIN_CB_DEBUG_VARS
#endif
CBUFFER_END

#ifdef UNITY_INSTANCING_ENABLED
    TEXTURE2D(_TerrainHeightmapTexture);
    TEXTURE2D(_TerrainNormalmapTexture);
    #ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
        SAMPLER(sampler_TerrainNormalmapTexture);
    #endif
#endif

UNITY_INSTANCING_BUFFER_START(Terrain)
   UNITY_DEFINE_INSTANCED_PROP(float4, _TerrainPatchInstanceData)  // float4(xBase, yBase, skipScale, ~)
UNITY_INSTANCING_BUFFER_END(Terrain)

float4 ConstructTerrainTangent(float3 normal, float3 positiveZ)
{
    // Consider a flat terrain. It should have tangent be (1, 0, 0) and bitangent be (0, 0, 1) as the UV of the terrain grid mesh is a scale of the world XZ position.
    // In CreateTangentToWorld function (in SpaceTransform.hlsl), it is cross(normal, tangent) * sgn for the bitangent vector.
    // It is not true in a left-handed coordinate system for the terrain bitangent, if we provide 1 as the tangent.w. It would produce (0, 0, -1) instead of (0, 0, 1).
    // Also terrain's tangent calculation was wrong in a left handed system because cross((0,0,1), terrainNormalOS) points to the wrong direction as negative X.
    // Therefore all the 4 xyzw components of the tangent needs to be flipped to correct the tangent frame.
    // (See TerrainLitData.hlsl - GetSurfaceAndBuiltinData)
    float3 tangent = cross(normal, positiveZ);
    return float4(tangent, -1);
}


AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
{
#if defined(UNITY_INSTANCING_ENABLED) && !_MICROMESH && !_MICROMESHTERRAIN && !_MICROPOLARISMESH && !_MICRODIGGERMESH && !_MICROVERTEXMESH
    float2 patchVertex = input.positionOS.xy;
    float4 instanceData = UNITY_ACCESS_INSTANCED_PROP(Terrain, _TerrainPatchInstanceData);

    float2 sampleCoords = (patchVertex.xy + instanceData.xy) * instanceData.z; // (xy + float2(xBase,yBase)) * skipScale
    float height = UnpackHeightmap(_TerrainHeightmapTexture.Load(int3(sampleCoords, 0)));

    input.positionOS.xz = sampleCoords * _TerrainHeightmapScale.xz;
    input.positionOS.y = height * _TerrainHeightmapScale.y;
    
    #ifdef ATTRIBUTES_NEED_NORMAL
       input.normalOS = float3(0,1,0);
    #endif

    #if defined(VARYINGS_NEED_TEXCOORD0) || defined(VARYINGS_DS_NEED_TEXCOORD0)
       #ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
          input.uv0.xy = sampleCoords;
       #else
          input.uv0.xy = sampleCoords * _TerrainHeightmapRecipSize.zw;
       #endif
    #endif
#endif


    #ifdef ATTRIBUTES_NEED_TANGENT
       #if !_MICROMESH && !_MICROMESHTERRAIN && !_MICROVERTEXMESH && !_MICROPOLARISMESH
           input.tangentOS = ConstructTerrainTangent(input.normalOS, float3(0, 0, 1));
       #endif
    #endif

    return input;
}

        
                    

                    

      // dynamic branching helpers, for regular and aggressive branching
      // debug mode shows how many samples using branching will save us. 
      //
      // These macros are always used instead of the UNITY_BRANCH macro
      // to maintain debug displays and allow branching to be disabled
      // on as granular level as we want. 
      
      #if _BRANCHSAMPLES
         #if _DEBUG_BRANCHCOUNT_WEIGHT || _DEBUG_BRANCHCOUNT_TOTAL
            float _branchWeightCount;
            #define MSBRANCH(w) if (w > 0) _branchWeightCount++; if (w > 0)
         #else
            #define MSBRANCH(w) UNITY_BRANCH if (w > 0)
         #endif
      #else
         #if _DEBUG_BRANCHCOUNT_WEIGHT || _DEBUG_BRANCHCOUNT_TOTAL
            float _branchWeightCount;
            #define MSBRANCH(w) if (w > 0) _branchWeightCount++;
         #else
            #define MSBRANCH(w) 
         #endif
      #endif
      
      #if _BRANCHSAMPLESAGR
         #if _DEBUG_BRANCHCOUNT_TRIPLANAR || _DEBUG_BRANCHCOUNT_CLUSTER || _DEBUG_BRANCHCOUNT_OTHER ||_DEBUG_BRANCHCOUNT_TOTAL
            float _branchTriplanarCount;
            float _branchClusterCount;
            float _branchOtherCount;
            #define MSBRANCHTRIPLANAR(w) if (w > 0.001) _branchTriplanarCount++; if (w > 0.001)
            #define MSBRANCHCLUSTER(w) if (w > 0.001) _branchClusterCount++; if (w > 0.001)
            #define MSBRANCHOTHER(w) if (w > 0.001) _branchOtherCount++; if (w > 0.001)
         #else
            #define MSBRANCHTRIPLANAR(w) UNITY_BRANCH if (w > 0.001)
            #define MSBRANCHCLUSTER(w) UNITY_BRANCH if (w > 0.001)
            #define MSBRANCHOTHER(w) UNITY_BRANCH if (w > 0.001)
         #endif
      #else
         #if _DEBUG_BRANCHCOUNT_TRIPLANAR || _DEBUG_BRANCHCOUNT_CLUSTER || _DEBUG_BRANCHCOUNT_OTHER || _DEBUG_BRANCHCOUNT_TOTAL
            float _branchTriplanarCount;
            float _branchClusterCount;
            float _branchOtherCount;
            #define MSBRANCHTRIPLANAR(w) if (w > 0.001) _branchTriplanarCount++;
            #define MSBRANCHCLUSTER(w) if (w > 0.001) _branchClusterCount++;
            #define MSBRANCHOTHER(w) if (w > 0.001) _branchOtherCount++;
         #else
            #define MSBRANCHTRIPLANAR(w)
            #define MSBRANCHCLUSTER(w)
            #define MSBRANCHOTHER(w)
         #endif
      #endif

      #if _DEBUG_SAMPLECOUNT
         int _sampleCount;
         #define COUNTSAMPLE { _sampleCount++; }
      #else
         #define COUNTSAMPLE
      #endif

      #if _DEBUG_PROCLAYERS
         int _procLayerCount;
         #define COUNTPROCLAYER { _procLayerCount++; }
      #else
         #define COUNTPROCLAYER
      #endif


      #if _DEBUG_USE_TOPOLOGY
         UNITY_DECLARE_TEX2D_NOSAMPLER(_DebugWorldPos);
         UNITY_DECLARE_TEX2D_NOSAMPLER(_DebugWorldNormal);
      #endif
      

      // splat
      UNITY_DECLARE_TEX2DARRAY(_Diffuse);
      float4 _Diffuse_TexelSize;
      UNITY_DECLARE_TEX2DARRAY(_NormalSAO);
      float4 _NormalSAO_TexelSize;

      #if _CONTROLNOISEUV || _GLOBALNOISEUV
         UNITY_DECLARE_TEX2D_NOSAMPLER(_NoiseUV);
      #endif

      #if _PACKINGHQ
         UNITY_DECLARE_TEX2DARRAY(_SmoothAO);
         float4 _SmoothAO_TexelSize;
      #endif

      #if _USESPECULARWORKFLOW
         UNITY_DECLARE_TEX2DARRAY(_Specular);
         float4 _Specular_TexelSize;
      #endif

      #if _USEEMISSIVEMETAL
         UNITY_DECLARE_TEX2DARRAY(_EmissiveMetal);
         float4 _EmissiveMetal_TexelSize;
      #endif

      
      UNITY_DECLARE_TEX2D_NOSAMPLER(_PerPixelNormal);
      
      UNITY_DECLARE_TEX2D(_Control0);
      #if _CUSTOMSPLATTEXTURES
         UNITY_DECLARE_TEX2D(_CustomControl0);
         #if !_MAX4TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl1);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl2);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl3);
         #endif
         #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl4);
         #endif
         #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl5);
         #endif
         #if _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl6);
         #endif
         #if _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl7);
         #endif
      #else
         #if !_MAX4TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control1);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control2);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control3);
         #endif
         #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control4);
         #endif
         #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control5);
         #endif
         #if _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control6);
         #endif
         #if _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control7);
         #endif
      #endif

      sampler2D_float _PerTexProps;
   



      struct TriGradMipFormat
      {
         float4 d0;
         float4 d1;
         float4 d2;
      };

      half InverseLerp(half x, half y, half v) { return (v-x)/max(y-x, 0.001); }
      half2 InverseLerp(half2 x, half2 y, half2 v) { return (v-x)/max(y-x, half2(0.001, 0.001)); }
      half3 InverseLerp(half3 x, half3 y, half3 v) { return (v-x)/max(y-x, half3(0.001, 0.001, 0.001)); }
      half4 InverseLerp(half4 x, half4 y, half4 v) { return (v-x)/max(y-x, half4(0.001, 0.001, 0.001, 0.001)); }
      

      // 2019.3 holes
      #ifdef _ALPHATEST_ON
          UNITY_DECLARE_TEX2D(_TerrainHolesTexture);

          void ClipHoles(float2 uv)
          {
              float hole = UNITY_SAMPLE_TEX2D(_TerrainHolesTexture, uv).r;
              COUNTSAMPLE
              clip(hole < 0.5f ? -1 : 1);
          }
      #endif

      
      #if _TRIPLANAR
         #if _USEGRADMIP
            #define MIPFORMAT TriGradMipFormat
            #define INITMIPFORMAT (TriGradMipFormat)0;
            #define MIPFROMATRAW float4
         #else
            #define MIPFORMAT float3
            #define INITMIPFORMAT 0;
            #define MIPFROMATRAW float3
         #endif
      #else
         #if _USEGRADMIP
            #define MIPFORMAT float4
            #define INITMIPFORMAT 0;
            #define MIPFROMATRAW float4
         #else
            #define MIPFORMAT float
            #define INITMIPFORMAT 0;
            #define MIPFROMATRAW float
         #endif
      #endif

      float2 RotateUV(float2 uv, float amt)
      {
         uv -=0.5;
         float s = sin ( amt);
         float c = cos ( amt );
         float2x2 mtx = float2x2( c, -s, s, c);
         mtx *= 0.5;
         mtx += 0.5;
         mtx = mtx * 2-1;
         uv = mul ( uv, mtx );
         uv += 0.5;
         return uv;
      }

      float4 DecodeToFloat4(float v)
      {
         uint vi = (uint)(v * (256.0f * 256.0f * 256.0f * 256.0f));
         int ex = (int)(vi / (256 * 256 * 256) % 256);
         int ey = (int)((vi / (256 * 256)) % 256);
         int ez = (int)((vi / (256)) % 256);
         int ew = (int)(vi % 256);
         float4 e = float4(ex / 255.0, ey / 255.0, ez / 255.0, ew / 255.0);
         return e;
      }

      struct Input 
      {
         float2 uv_Control0;
         #if (_MICROMESH && _MESHUV2)
         float2 uv2_Diffuse;
         #endif

         float3 viewDir;
         float3 worldPos;
         float3 worldNormal;
         #if _TERRAINBLENDING
         float4 color : COLOR;
         #endif
         #if _MSRENDERLOOP_SURFACESHADER
         INTERNAL_DATA
         #else
         float3x3 TBN;
         #endif

         #if _MICRODIGGERMESH || _MICROVERTEXMESH
            half4 w0;
            #if !_MAX4TEXTURES
               half4 w1;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES
               half4 w2;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
               half4 w3;
            #endif
            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               half4 w4;
            #endif
            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               half4 w5;
            #endif
            #if (_MAX28TEXTURES || _MAX32TEXTURES) && !_STREAMS && !_LAVA && !_WETNESS && !_PUDDLES
               half4 w6;
            #endif

            #if _STEAMS || _WETNESS || _LAVA || _PUDDLES
               half4 s0;
            #endif

         #endif
      };
      
      struct TriplanarConfig
      {
         float3x3 uv0;
         float3x3 uv1;
         float3x3 uv2;
         float3x3 uv3;
         half3 pN;
         half3 pN0;
         half3 pN1;
         half3 pN2;
         half3 pN3;
         half3 axisSign;
         Input IN;
      };


      struct Config
      {
         float2 uv;
         float3 uv0;
         float3 uv1;
         float3 uv2;
         float3 uv3;

         half4 cluster0;
         half4 cluster1;
         half4 cluster2;
         half4 cluster3;

      };


      struct MicroSplatLayer
      {
         half3 Albedo;
         half3 Normal;
         half Smoothness;
         half Occlusion;
         half Metallic;
         half Height;
         half3 Emission;
         #if _USESPECULARWORKFLOW
         half3 Specular;
         #endif
         half Alpha;
         
      };


      struct appdata 
      {
         float4 vertex : POSITION;
         float4 tangent : TANGENT;
         float3 normal : NORMAL;
         float2 texcoord : TEXCOORD0;
         float4 texcoord1 : TEXCOORD1;
         float4 texcoord2 : TEXCOORD2;
         #if _TERRAINBLENDING || _MICRODIGGERMESH || _MICROVERTEXMESH
         half4 color : COLOR;
         #endif
         UNITY_VERTEX_INPUT_INSTANCE_ID
         UNITY_VERTEX_OUTPUT_STEREO
      };


      // raw, unblended samples from arrays
      struct RawSamples
      {
         half4 albedo0;
         half4 albedo1;
         half4 albedo2;
         half4 albedo3;
         half4 normSAO0;
         half4 normSAO1;
         half4 normSAO2;
         half4 normSAO3;
         #if _USEEMISSIVEMETAL || _GLOBALEMIS || _GLOBALSMOOTHAOMETAL || _PERTEXSSS
            half4 emisMetal0;
            half4 emisMetal1;
            half4 emisMetal2;
            half4 emisMetal3;
         #endif
         #if _USESPECULARWORKFLOW
            half3 specular0;
            half3 specular1;
            half3 specular2;
            half3 specular3;
         #endif
      };

      void InitRawSamples(inout RawSamples s)
      {
         s.normSAO0 = half4(0,0,0,1);
         s.normSAO1 = half4(0,0,0,1);
         s.normSAO2 = half4(0,0,0,1);
         s.normSAO3 = half4(0,0,0,1);
      }

       float3 GetGlobalLightDir(Input i)
      {
         float3 lightDir = float3(1,0,0);

         #if _MSRENDERLOOP_UNITYHD || PASS_DEFERRED
            lightDir = normalize(_gGlitterLightDir.xyz);
         #elif _MSRENDERLOOP_UNITYLD
            lightDir = GetMainLight().direction;
         #else
            #ifndef USING_DIRECTIONAL_LIGHT
               lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
            #else
               lightDir = normalize(_WorldSpaceLightPos0.xyz);
            #endif
         #endif
         return lightDir;
      }

      float3 GetGlobalLightDirTS(Input i)
      {
         float3 lightDirWS = GetGlobalLightDir(i);
        
         #if _MSRENDERLOOP_UNITYHD || _MSRENDERLOOP_UNITYLD
            return mul( i.TBN, lightDirWS).xyz;
         #else
            float3 t2w0 = WorldNormalVector(i, float3(1,0,0));
            float3 t2w1 = WorldNormalVector(i, float3(0,1,0));
            float3 t2w2 = WorldNormalVector(i, float3(0,0,1));
            float3x3 t2w = float3x3(t2w0, t2w1, t2w2);
            return mul( t2w, lightDirWS).xyz;
         #endif
      }
      
      half3 GetGlobalLightColor()
      {
         #if _MSRENDERLOOP_UNITYHD || PASS_DEFERRED
            return _gGlitterLightColor;
         #elif _MSRENDERLOOP_UNITYLD
            return normalize(GetMainLight().color);
         #else
            return _LightColor0.rgb;
         #endif
      }



      half3 FuzzyShade(half3 color, half3 normal, half coreMult, half edgeMult, half power, float3 viewDir)
      {
         half dt = saturate(dot(viewDir, normal));
         half dark = 1.0 - (coreMult * dt);
         half edge = pow(1-dt, power) * edgeMult;
         return color * (dark + edge);
      }

      half3 ComputeSSS(Input i, float3 V, float3 N, half3 tint, half thickness, half distortion, half scale, half power)
      {
         float3 L = GetGlobalLightDir(i);
         half3 lightColor = GetGlobalLightColor();
         float3 H = normalize(L + N * distortion);
         float VdotH = pow(saturate(dot(V, -H)), power) * scale;
         float3 I =  (VdotH) * thickness;
         return lightColor * I * tint;
      }


      #if _MAX2LAYER
         inline half BlendWeights(half s1, half s2, half s3, half s4, half4 w)      { return s1 * w.x + s2 * w.y; }
         inline half2 BlendWeights(half2 s1, half2 s2, half2 s3, half2 s4, half4 w) { return s1 * w.x + s2 * w.y; }
         inline half3 BlendWeights(half3 s1, half3 s2, half3 s3, half3 s4, half4 w) { return s1 * w.x + s2 * w.y; }
         inline half4 BlendWeights(half4 s1, half4 s2, half4 s3, half4 s4, half4 w) { return s1 * w.x + s2 * w.y; }
      #elif _MAX3LAYER
         inline half BlendWeights(half s1, half s2, half s3, half s4, half4 w)      { return s1 * w.x + s2 * w.y + s3 * w.z; }
         inline half2 BlendWeights(half2 s1, half2 s2, half2 s3, half2 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z; }
         inline half3 BlendWeights(half3 s1, half3 s2, half3 s3, half3 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z; }
         inline half4 BlendWeights(half4 s1, half4 s2, half4 s3, half4 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z; }
      #else
         inline half BlendWeights(half s1, half s2, half s3, half s4, half4 w)      { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
         inline half2 BlendWeights(half2 s1, half2 s2, half2 s3, half2 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
         inline half3 BlendWeights(half3 s1, half3 s2, half3 s3, half3 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
         inline half4 BlendWeights(half4 s1, half4 s2, half4 s3, half4 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
      #endif

      #if _MAX3LAYER
         #define SAMPLE_PER_TEX(varName, pixel, config, defVal) \
            half4 varName##0 = defVal; \
            half4 varName##1 = defVal; \
            half4 varName##2 = defVal; \
            half4 varName##3 = defVal; \
            varName##0 = tex2Dlod(_PerTexProps, float4(config.uv0.z/32, pixel/32, 0, 0)); \
            varName##1 = tex2Dlod(_PerTexProps, float4(config.uv1.z/32, pixel/32, 0, 0)); \
            varName##2 = tex2Dlod(_PerTexProps, float4(config.uv2.z/32, pixel/32, 0, 0)); \

      #elif _MAX2LAYER
         #define SAMPLE_PER_TEX(varName, pixel, config, defVal) \
            half4 varName##0 = defVal; \
            half4 varName##1 = defVal; \
            half4 varName##2 = defVal; \
            half4 varName##3 = defVal; \
            varName##0 = tex2Dlod(_PerTexProps, float4(config.uv0.z/32, pixel/32, 0, 0)); \
            varName##1 = tex2Dlod(_PerTexProps, float4(config.uv1.z/32, pixel/32, 0, 0)); \

      #else
         #define SAMPLE_PER_TEX(varName, pixel, config, defVal) \
            half4 varName##0 = tex2Dlod(_PerTexProps, float4(config.uv0.z/32, pixel/32, 0, 0)); \
            half4 varName##1 = tex2Dlod(_PerTexProps, float4(config.uv1.z/32, pixel/32, 0, 0)); \
            half4 varName##2 = tex2Dlod(_PerTexProps, float4(config.uv2.z/32, pixel/32, 0, 0)); \
            half4 varName##3 = tex2Dlod(_PerTexProps, float4(config.uv3.z/32, pixel/32, 0, 0)); \

      #endif
      
      half3 BlendNormal3(half3 n1, half3 n2)
      {
         n1.z += 1;
         n2.xy = -n2.xy;

         return n1 * dot(n1, n2) / n1.z - n2;
      }
      
      half2 TransformTriplanarNormal(Input IN, float3x3 t2w, half3 axisSign, half3 absVertNormal,
               half3 pN, half2 a0, half2 a1, half2 a2)
      {
         a0 = a0 * 2 - 1;
         a1 = a1 * 2 - 1;
         a2 = a2 * 2 - 1;
         
         a0.x *= axisSign.x;
         a1.x *= axisSign.y;
         a2.x *= axisSign.z;
         
         half3 n0 = half3(a0.xy, 1);
         half3 n1 = half3(a1.xy, 1);
         half3 n2 = half3(a2.xy, 1);
         
         n0 = BlendNormal3(half3(IN.worldNormal.zy, absVertNormal.x), n0);
         n1 = BlendNormal3(half3(IN.worldNormal.xz, absVertNormal.y), n1);
         n2 = BlendNormal3(half3(IN.worldNormal.xy, absVertNormal.z), n2);
  
         n0.z *= axisSign.x;
         n1.z *= axisSign.y;
         n2.z *= -axisSign.z;
  
         half3 worldNormal = (n0.zyx * pN.x + n1.xzy * pN.y + n2.xyz * pN.z );
         return mul(t2w, worldNormal).xy;
      }
      
      // funcs
      
      inline half MSLuminance(half3 rgb)
      {
         #ifdef UNITY_COLORSPACE_GAMMA
            return dot(rgb, half3(0.22, 0.707, 0.071));
         #else
            return dot(rgb, half3(0.0396819152, 0.458021790, 0.00609653955));
         #endif
      }
      
      
      float2 Hash2D( float2 x )
      {
          float2 k = float2( 0.3183099, 0.3678794 );
          x = x*k + k.yx;
          return -1.0 + 2.0*frac( 16.0 * k*frac( x.x*x.y*(x.x+x.y)) );
      }

      float Noise2D(float2 p )
      {
         float2 i = floor( p );
         float2 f = frac( p );
         
         float2 u = f*f*(3.0-2.0*f);

         return lerp( lerp( dot( Hash2D( i + float2(0.0,0.0) ), f - float2(0.0,0.0) ), 
                           dot( Hash2D( i + float2(1.0,0.0) ), f - float2(1.0,0.0) ), u.x),
                      lerp( dot( Hash2D( i + float2(0.0,1.0) ), f - float2(0.0,1.0) ), 
                           dot( Hash2D( i + float2(1.0,1.0) ), f - float2(1.0,1.0) ), u.x), u.y);
      }
      
      float FBM2D(float2 uv)
      {
         float f = 0.5000*Noise2D( uv ); uv *= 2.01;
         f += 0.2500*Noise2D( uv ); uv *= 1.96;
         f += 0.1250*Noise2D( uv ); 
         return f;
      }
      
      float3 Hash3D( float3 p )
      {
         p = float3( dot(p,float3(127.1,311.7, 74.7)),
                 dot(p,float3(269.5,183.3,246.1)),
                 dot(p,float3(113.5,271.9,124.6)));

         return -1.0 + 2.0*frac(sin(p)*437.5453123);
      }

      float Noise3D( float3 p )
      {
         float3 i = floor( p );
         float3 f = frac( p );
         
         float3 u = f*f*(3.0-2.0*f);

         return lerp( lerp( lerp( dot( Hash3D( i + float3(0.0,0.0,0.0) ), f - float3(0.0,0.0,0.0) ), 
                                dot( Hash3D( i + float3(1.0,0.0,0.0) ), f - float3(1.0,0.0,0.0) ), u.x),
                           lerp( dot( Hash3D( i + float3(0.0,1.0,0.0) ), f - float3(0.0,1.0,0.0) ), 
                                dot( Hash3D( i + float3(1.0,1.0,0.0) ), f - float3(1.0,1.0,0.0) ), u.x), u.y),
                      lerp( lerp( dot( Hash3D( i + float3(0.0,0.0,1.0) ), f - float3(0.0,0.0,1.0) ), 
                                dot( Hash3D( i + float3(1.0,0.0,1.0) ), f - float3(1.0,0.0,1.0) ), u.x),
                           lerp( dot( Hash3D( i + float3(0.0,1.0,1.0) ), f - float3(0.0,1.0,1.0) ), 
                                dot( Hash3D( i + float3(1.0,1.0,1.0) ), f - float3(1.0,1.0,1.0) ), u.x), u.y), u.z );
      }
      
      float FBM3D(float3 uv)
      {
         float f = 0.5000*Noise3D( uv ); uv *= 2.01;
         f += 0.2500*Noise3D( uv ); uv *= 1.96;
         f += 0.1250*Noise3D( uv ); 
         return f;
      }
      
      half2 BlendNormal2(half2 base, half2 blend) { return normalize(half3(base.xy + blend.xy, 1)).xy; } 
      half3 BlendOverlay(half3 base, half3 blend) { return (base < 0.5 ? (2.0 * base * blend) : (1.0 - 2.0 * (1.0 - base) * (1.0 - blend))); }
      half3 BlendMult2X(half3  base, half3 blend) { return (base * (blend * 2)); }
      half3 BlendLighterColor(half3 s, half3 d) { return (s.x + s.y + s.z > d.x + d.y + d.z) ? s : d; } 
      
      float GetSaturation(float3 c)
      {
         float mi = min(min(c.x, c.y), c.z);
         float ma = max(max(c.x, c.y), c.z);
         return (ma - mi)/(ma + 1e-7);
      }

      // Better Color Lerp, does not have darkening issue
      float3 BetterColorLerp(float3 a, float3 b, float x)
      {
         float3 ic = lerp(a, b, x) + float3(1e-6,0.0,0.0);
         float sd = abs(GetSaturation(ic) - lerp(GetSaturation(a), GetSaturation(b), x));
    
         float3 dir = normalize(float3(2.0 * ic.x - ic.y - ic.z, 2.0 * ic.y - ic.x - ic.z, 2.0 * ic.z - ic.y - ic.x));
         float lgt = dot(float3(1.0, 1.0, 1.0), ic);
    
         float ff = dot(dir, normalize(ic));
    
         const float dsp_str = 1.5;
         ic += dsp_str * dir * sd * ff * lgt;
         return saturate(ic);
      }
      
      
      half4 ComputeWeights(half4 iWeights, half h0, half h1, half h2, half h3, half contrast)
      {
          #if _DISABLEHEIGHTBLENDING
             return iWeights;
          #else
             // compute weight with height map
             //half4 weights = half4(iWeights.x * h0, iWeights.y * h1, iWeights.z * h2, iWeights.w * h3);
             half4 weights = half4(iWeights.x * max(h0,0.001), iWeights.y * max(h1,0.001), iWeights.z * max(h2,0.001), iWeights.w * max(h3,0.001));
             
             // Contrast weights
             half maxWeight = max(max(weights.x, max(weights.y, weights.z)), weights.w);
             half transition = max(contrast * maxWeight, 0.0001);
             half threshold = maxWeight - transition;
             half scale = 1.0 / transition;
             weights = saturate((weights - threshold) * scale);
             // Normalize weights.
             half weightScale = 1.0f / (weights.x + weights.y + weights.z + weights.w);
             weights *= weightScale;
             return weights;
          #endif
      }

      half HeightBlend(half h1, half h2, half slope, half contrast)
      {
         #if _DISABLEHEIGHTBLENDING
            return slope;
         #else
            h2 = 1 - h2;
            half tween = saturate((slope - min(h1, h2)) / max(abs(h1 - h2), 0.001)); 
            half blend = saturate( ( tween - (1-contrast) ) / max(contrast, 0.001));
            return blend;
         #endif
      }

      #if _MAX4TEXTURES
         #define TEXCOUNT 4
      #elif _MAX8TEXTURES
         #define TEXCOUNT 8
      #elif _MAX12TEXTURES
         #define TEXCOUNT 12
      #elif _MAX20TEXTURES
         #define TEXCOUNT 20
      #elif _MAX24TEXTURES
         #define TEXCOUNT 24
      #elif _MAX28TEXTURES
         #define TEXCOUNT 28
      #elif _MAX32TEXTURES
         #define TEXCOUNT 32
      #else
         #define TEXCOUNT 16
      #endif


      void Setup(out half4 weights, float2 uv, out Config config, half4 w0, half4 w1, half4 w2, half4 w3, half4 w4, half4 w5, half4 w6, half4 w7, float3 worldPos)
      {
         config = (Config)0;
         half4 indexes = 0;

         config.uv = uv;

         #if _WORLDUV
         uv = worldPos.xz;
         #endif

         #if _DISABLESPLATMAPS
            float2 scaledUV = uv;
         #else
            float2 scaledUV = uv * _UVScale.xy + _UVScale.zw;
         #endif

         // if only 4 textures, and blending 4 textures, skip this whole thing..
         // this saves about 25% of the ALU of the base shader on low end. However if
         // we rely on sorted texture weights (distance resampling) we have to sort..
         float4 defaultIndexes = float4(0,1,2,3);
         #if _MESHSUBARRAY
            defaultIndexes = _MeshSubArrayIndexes;
         #endif

         #if _MESHSUBARRAY || (_MAX4TEXTURES && !_MAX3LAYER && !_MAX2LAYER && !_DISTANCERESAMPLE && !_POM)
            weights = w0;
            config.uv0 = float3(scaledUV, defaultIndexes.x);
            config.uv1 = float3(scaledUV, defaultIndexes.y);
            config.uv2 = float3(scaledUV, defaultIndexes.z);
            config.uv3 = float3(scaledUV, defaultIndexes.w);
            return;
         #endif

         #if _DISABLESPLATMAPS
            weights = float4(1,0,0,0);
            return;
         #else
            half splats[TEXCOUNT];

            splats[0] = w0.x;
            splats[1] = w0.y;
            splats[2] = w0.z;
            splats[3] = w0.w;
            #if !_MAX4TEXTURES
               splats[4] = w1.x;
               splats[5] = w1.y;
               splats[6] = w1.z;
               splats[7] = w1.w;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES
               splats[8] = w2.x;
               splats[9] = w2.y;
               splats[10] = w2.z;
               splats[11] = w2.w;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
               splats[12] = w3.x;
               splats[13] = w3.y;
               splats[14] = w3.z;
               splats[15] = w3.w;
            #endif
            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               splats[16] = w4.x;
               splats[17] = w4.y;
               splats[18] = w4.z;
               splats[19] = w4.w;
            #endif
            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               splats[20] = w5.x;
               splats[21] = w5.y;
               splats[22] = w5.z;
               splats[23] = w5.w;
            #endif
            #if _MAX28TEXTURES || _MAX32TEXTURES
               splats[24] = w6.x;
               splats[25] = w6.y;
               splats[26] = w6.z;
               splats[27] = w6.w;
            #endif
            #if _MAX32TEXTURES
               splats[28] = w7.x;
               splats[29] = w7.y;
               splats[30] = w7.z;
               splats[31] = w7.w;
            #endif



            weights[0] = 0;
            weights[1] = 0;
            weights[2] = 0;
            weights[3] = 0;
            indexes[0] = 0;
            indexes[1] = 0;
            indexes[2] = 0;
            indexes[3] = 0;

            int i = 0;
            for (i = 0; i < TEXCOUNT; ++i)
            {
               half w = splats[i];
               if (w >= weights[0])
               {
                  weights[3] = weights[2];
                  indexes[3] = indexes[2];
                  weights[2] = weights[1];
                  indexes[2] = indexes[1];
                  weights[1] = weights[0];
                  indexes[1] = indexes[0];
                  weights[0] = w;
                  indexes[0] = i;
               }
               else if (w >= weights[1])
               {
                  weights[3] = weights[2];
                  indexes[3] = indexes[2];
                  weights[2] = weights[1];
                  indexes[2] = indexes[1];
                  weights[1] = w;
                  indexes[1] = i;
               }
               else if (w >= weights[2])
               {
                  weights[3] = weights[2];
                  indexes[3] = indexes[2];
                  weights[2] = w;
                  indexes[2] = i;
               }
               else if (w >= weights[3])
               {
                  weights[3] = w;
                  indexes[3] = i;
               }
            }

            // clamp and renormalize
            #if _MAX2LAYER
            weights.zw = 0;
            weights.xy *= (1.0 / (weights.x + weights.y));
            #elif _MAX3LAYER
            weights.w = 0;
            weights.xyz *= (1.0 / (weights.x + weights.y + weights.z));
            #elif !_DISABLEHEIGHTBLENDING || _NORMALIZEWEIGHTS // prevents black when painting, which the unity shader does not prevent.
            weights = normalize(weights);
            #endif

            config.uv0 = float3(scaledUV, indexes.x);
            config.uv1 = float3(scaledUV, indexes.y);
            config.uv2 = float3(scaledUV, indexes.z);
            config.uv3 = float3(scaledUV, indexes.w);


         #endif //_DISABLESPLATMAPS


      }
      
      float ComputeMipLevel(float2 uv, float2 textureSize)
      {
         uv *= textureSize;
         float2  dx_vtc        = ddx(uv);
         float2  dy_vtc        = ddy(uv);
         float delta_max_sqr   = max(dot(dx_vtc, dx_vtc), dot(dy_vtc, dy_vtc));
         return 0.5 * log2(delta_max_sqr);
      }

      inline half2 UnpackNormal2(half4 packednormal)
      {
          return packednormal.wy * 2 - 1;
         
      }

      half3 TriplanarHBlend(half h0, half h1, half h2, half3 pN, half contrast)
      {
         half3 blend = pN / dot(pN, half3(1,1,1));
         float3 heights = float3(h0, h1, h2) + (blend * 3.0);
         half height_start = max(max(heights.x, heights.y), heights.z) - contrast;
         half3 h = max(heights - height_start.xxx, half3(0,0,0));
         blend = h / dot(h, half3(1,1,1));
         return blend;
      }
      

      void ClearAllButAlbedo(inout MicroSplatLayer o, half3 display)
      {
         o.Albedo = display.rgb;
         o.Normal = half3(0, 0, 1);
         o.Smoothness = 0;
         o.Occlusion = 1;
         o.Emission = 0;
         o.Metallic = 0;
         o.Height = 0;
         #if _USESPECULARWORKFLOW
         o.Specular = 0;
         #endif

      }

      void ClearAllButAlbedo(inout MicroSplatLayer o, half display)
      {
         o.Albedo = half3(display, display, display);
         o.Normal = half3(0, 0, 1);
         o.Smoothness = 0;
         o.Occlusion = 1;
         o.Emission = 0;
         o.Metallic = 0;
         o.Height = 0;
         #if _USESPECULARWORKFLOW
         o.Specular = 0;
         #endif

      }

     

      half MicroShadow(float3 lightDir, half3 normal, half ao, half strength)
      {
         half shadow = saturate(abs(dot(normal, lightDir)) + (ao * ao * 2.0) - 1.0);
         return 1 - ((1-shadow) * strength);
      }
      

      void DoDebugOutput(inout MicroSplatLayer l)
      {
         #if _DEBUG_OUTPUT_ALBEDO
            ClearAllButAlbedo(l, l.Albedo);
         #elif _DEBUG_OUTPUT_NORMAL
            // oh unit shader compiler normal stripping, how I hate you so..
            // must multiply by albedo to stop the normal from being white. Why, fuck knows?
            ClearAllButAlbedo(l, float3(l.Normal.xy * 0.5 + 0.5, l.Normal.z * saturate(l.Albedo.z+1)));
         #elif _DEBUG_OUTPUT_SMOOTHNESS
            ClearAllButAlbedo(l, l.Smoothness.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_METAL
            ClearAllButAlbedo(l, l.Metallic.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_AO
            ClearAllButAlbedo(l, l.Occlusion.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_EMISSION
            ClearAllButAlbedo(l, l.Emission * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_HEIGHT
            ClearAllButAlbedo(l, l.Height.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_SPECULAR && _USESPECULARWORKFLOW
            ClearAllButAlbedo(l, l.Specular * saturate(l.Albedo.z+1));
         #elif _DEBUG_BRANCHCOUNT_WEIGHT
            ClearAllButAlbedo(l, _branchWeightCount / 12 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_TRIPLANAR
            ClearAllButAlbedo(l, _branchTriplanarCount / 24 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_CLUSTER
            ClearAllButAlbedo(l, _branchClusterCount / 12 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_OTHER
            ClearAllButAlbedo(l, _branchOtherCount / 8 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_TOTAL
            l.Albedo.r = _branchWeightCount / 12;
            l.Albedo.g = _branchTriplanarCount / 24;
            l.Albedo.b = _branchClusterCount / 12;
            ClearAllButAlbedo(l, (l.Albedo.r + l.Albedo.g + l.Albedo.b + (_branchOtherCount / 8)) / 4); 
         #elif _DEBUG_OUTPUT_MICROSHADOWS
            ClearAllButAlbedo(l,l.Albedo); 
         #elif _DEBUG_SAMPLECOUNT
            float sdisp = (float)_sampleCount / max(_SampleCountDiv, 1);
            half3 sdcolor = float3(sdisp, sdisp > 1 ? 1 : 0, 0);
            ClearAllButAlbedo(l, sdcolor * saturate(l.Albedo.z + 1));
         #elif _DEBUG_PROCLAYERS
            ClearAllButAlbedo(l, (float)_procLayerCount / (float)_PCLayerCount * saturate(l.Albedo.z + 1));
         #endif
      }


      // man I wish unity would wrap everything instead of only what they use. Just seems like a landmine for
      // people like myself.. especially as they keep changing things around and I have to figure out all the new defines
      // and handle changes across Unity versions, which would be automatically handled if they just wrapped these themselves without
      // as much complexity..

      #if (UNITY_VERSION >= 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (SHADER_TARGET_SURFACE_ANALYSIS && !SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))) || (UNITY_VERSION < 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL))) 
           #define MICROSPLAT_SAMPLE_TEX2D_LOD(tex,coord, lod) tex.SampleLevel (sampler##tex,coord, lod)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(tex,samplertex,coord, lod) tex.SampleLevel (sampler##samplertex,coord, lod)
        #else
           #define MICROSPLAT_SAMPLE_TEX2D_LOD(tex,coord,lod) tex2D (tex,coord,0,lod)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(tex,samplertex,coord,lod) tex2D (tex,coord,0,lod)
        #endif
     


        #if (UNITY_VERSION >= 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (SHADER_TARGET_SURFACE_ANALYSIS && !SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))) || (UNITY_VERSION < 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL))) 
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) tex.SampleGrad (sampler##tex,coord,dx,dy)
        #elif defined(SHADER_API_D3D9)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(0,1,0,0) 
        #elif defined(UNITY_COMPILER_HLSL2GLSL) || defined(SHADER_TARGET_SURFACE_ANALYSIS)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) texCUBEgrad (tex,coord,float3(dx.x,dx.y,0),float3(dy.x,dy.y,0))
        #elif defined(SHADER_API_GLES)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(1,1,0,0)
        #elif defined(SHADER_API_D3D11_9X)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(0,1,1,0) 
        #else
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(0,0,1,0) 
        #endif
        
        #if (UNITY_VERSION >= 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (SHADER_TARGET_SURFACE_ANALYSIS && !SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))) || (UNITY_VERSION < 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL))) 
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) tex.SampleGrad (sampler##samp,coord,dx,dy)
        #elif defined(SHADER_API_D3D9)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(0,1,0,0) 
        #elif defined(UNITY_COMPILER_HLSL2GLSL) || defined(SHADER_TARGET_SURFACE_ANALYSIS)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(1,0,1,0)
        #elif defined(SHADER_API_GLES)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(1,1,0,0)
        #elif defined(SHADER_API_D3D11_9X)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(0,1,1,0) 
        #else
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(0,0,1,0) 
        #endif
      

      #if _USELODMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY_LOD(tex, u, l.x)
      #elif _USEGRADMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex, u, l.xy, l.zw)
      #else
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY(tex, u)
      #endif

      #if _USELODMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY_LOD(tex, u, l.x)
      #elif _USEGRADMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex, u, l.xy, l.zw)
      #else
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY(tex, u)
      #endif


      #define MICROSPLAT_SAMPLE_DIFFUSE(u, cl, l) MICROSPLAT_SAMPLE(_Diffuse, u, l)
      #define MICROSPLAT_SAMPLE_EMIS(u, cl, l) MICROSPLAT_SAMPLE(_EmissiveMetal, u, l)
      #define MICROSPLAT_SAMPLE_DIFFUSE_LOD(u, cl, l) UNITY_SAMPLE_TEX2DARRAY_LOD(_Diffuse, u, l)
      

      #if _PACKINGHQ
         #define MICROSPLAT_SAMPLE_NORMAL(u, cl, l) half4(MICROSPLAT_SAMPLE(_NormalSAO, u, l).ga, MICROSPLAT_SAMPLE(_SmoothAO, u, l).ga).brag
      #else
         #define MICROSPLAT_SAMPLE_NORMAL(u, cl, l) MICROSPLAT_SAMPLE(_NormalSAO, u, l)
      #endif

      #if _USESPECULARWORKFLOW
         #define MICROSPLAT_SAMPLE_SPECULAR(u, cl, l) MICROSPLAT_SAMPLE(_Specular, u, l)
      #endif
      




                    
      #undef MICROSPLAT_SAMPLE_TEX2D_LOD
      #undef MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD
      #undef MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD
      #undef MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD

      #define MICROSPLAT_SAMPLE_TEX2D_LOD(tex,coord,lod)                    SAMPLE_TEXTURE2D_LOD(tex,sampler_##tex, coord, lod)
      #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy)                 SAMPLE_TEXTURE2D_GRAD(tex,sampler_##tex,coord,dx,dy)
      #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy)    SAMPLE_TEXTURE2D_GRAD(tex,sampler_##samp,coord,dx,dy)
      #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(tex, samp, coord, lod)    SAMPLE_TEXTURE2D_LOD(tex, sampler_##samp, coord, lod)

      inline half3 UnpackNormal(half4 packednormal)
      {
         half3 normal;
         normal.xy = packednormal.wy * 2 - 1;
         normal.z = sqrt(1 - normal.x*normal.x - normal.y * normal.y);
         return normal;
      }
      

      #undef WorldNormalVector
      #define WorldNormalVector(data, normal) mul(data.TBN, normal)





      #define UnityObjectToWorldNormal(normal) mul(GetObjectToWorldMatrix(), normal)
      
      


      Input DescToInput(SurfaceDescriptionInputs IN)
      {
        Input s = (Input)0;
        s.TBN = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        s.worldNormal = IN.WorldSpaceNormal;
        #if !_SRPTERRAINBLEND
           s.worldPos = GetAbsolutePositionWS(IN.WorldSpacePosition);
        #else
           s.worldPos = IN.WorldSpacePosition;
        #endif
        s.viewDir = IN.TangentSpaceViewDirection;
        s.uv_Control0 = IN.uv0.xy;
        

        #if _MICROMESH && _MESHUV2
            s.uv_Diffuse = IN.uv.xy1;
        #endif

        #if _SRPTERRAINBLEND
            s.color = IN.VertexColor;
        #endif
        return s;
     }

     #define TESSELLATION_INTERPOLATE_BARY(name, bary) output.name = input0.name * bary.x +  input1.name * bary.y +  input2.name * bary.z
     

     // Stochastic shared code

// Compute local triangle barycentric coordinates and vertex IDs
void TriangleGrid(float2 uv, float scale,
   out float w1, out float w2, out float w3,
   out int2 vertex1, out int2 vertex2, out int2 vertex3)
{
   // Scaling of the input
   uv *= 3.464 * scale; // 2 * sqrt(3)

   // Skew input space into simplex triangle grid
   const float2x2 gridToSkewedGrid = float2x2(1.0, 0.0, -0.57735027, 1.15470054);
   float2 skewedCoord = mul(gridToSkewedGrid, uv);

   // Compute local triangle vertex IDs and local barycentric coordinates
   int2 baseId = int2(floor(skewedCoord));
   float3 temp = float3(frac(skewedCoord), 0);
   temp.z = 1.0 - temp.x - temp.y;
   if (temp.z > 0.0)
   {
      w1 = temp.z;
      w2 = temp.y;
      w3 = temp.x;
      vertex1 = baseId;
      vertex2 = baseId + int2(0, 1);
      vertex3 = baseId + int2(1, 0);
   }
   else
   {
      w1 = -temp.z;
      w2 = 1.0 - temp.y;
      w3 = 1.0 - temp.x;
      vertex1 = baseId + int2(1, 1);
      vertex2 = baseId + int2(1, 0);
      vertex3 = baseId + int2(0, 1);
   }
}

// Fast random hash function
float2 SimpleHash2(float2 p)
{
   return frac(sin(mul(float2x2(127.1, 311.7, 269.5, 183.3), p)) * 43758.5453);
}


half3 BaryWeightBlend(half3 iWeights, half tex0, half tex1, half tex2, half contrast)
{
    // compute weight with height map
    const half epsilon = 1.0f / 1024.0f;
    half3 weights = half3(iWeights.x * (tex0 + epsilon), 
                             iWeights.y * (tex1 + epsilon),
                             iWeights.z * (tex2 + epsilon));

    // Contrast weights
    half maxWeight = max(weights.x, max(weights.y, weights.z));
    half transition = contrast * maxWeight;
    half threshold = maxWeight - transition;
    half scale = 1.0f / transition;
    weights = saturate((weights - threshold) * scale);
    // Normalize weights.
    half weightScale = 1.0f / (weights.x + weights.y + weights.z);
    weights *= weightScale;
    return weights;
}

void PrepareStochasticUVs(float scale, float3 uv, out float3 uv1, out float3 uv2, out float3 uv3, out half3 weights)
{
   // Get triangle info
   float w1, w2, w3;
   int2 vertex1, vertex2, vertex3;
   TriangleGrid(uv.xy, scale, w1, w2, w3, vertex1, vertex2, vertex3);

   // Assign random offset to each triangle vertex
   uv1 = uv;
   uv2 = uv;
   uv3 = uv;
   
   uv1.xy += SimpleHash2(vertex1);
   uv2.xy += SimpleHash2(vertex2);
   uv3.xy += SimpleHash2(vertex3);
   weights = half3(w1, w2, w3);
   
}

void PrepareStochasticUVs(float scale, float2 uv, out float2 uv1, out float2 uv2, out float2 uv3, out half3 weights)
{
   // Get triangle info
   float w1, w2, w3;
   int2 vertex1, vertex2, vertex3;
   TriangleGrid(uv, scale, w1, w2, w3, vertex1, vertex2, vertex3);

   // Assign random offset to each triangle vertex
   uv1 = uv;
   uv2 = uv;
   uv3 = uv;
   
   uv1.xy += SimpleHash2(vertex1);
   uv2.xy += SimpleHash2(vertex2);
   uv3.xy += SimpleHash2(vertex3);
   weights = half3(w1, w2, w3);
   
}


      #if _ALPHAHOLETEXTURE
         sampler2D _AlphaHoleTexture;   // must declare with a sampler or windows throws an error, which seems like a compiler bug
      #endif



      void ClipWaterLevel(float3 worldPos)
      {
         clip(worldPos.y - _AlphaData.y);
      }

      void ClipAlphaHole(inout Config c, inout half4 weights)
      {
      #if _ALPHAHOLETEXTURE
         clip(tex2D(_AlphaHoleTexture, c.uv).r - 0.5);
      #else
         if ((int)round(c.uv0.z ) == (int)round(_AlphaData.x))
         {
            clip(-1);
         }
         else if ((int)round(c.uv1.z ) == (int)round(_AlphaData.x) && weights.y > 0)
         {
            weights.y = 0;
            weights = normalize(weights);
         }
         else if ((int)round(c.uv2.z ) == (int)round(_AlphaData.x) && weights.z > 0)
         {
            weights.z = 0;
            weights = normalize(weights);
         }
         else if ((int)round(c.uv3.z ) == (int)round(_AlphaData.x) && weights.w > 0)
         {
            weights.w = 0;
            weights = normalize(weights);
         }
         
      #endif
      }





     
    




   

                    



      void SampleAlbedo(inout Config config, inout TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
         return;
         #endif
         #if _TRIPLANAR
            #if _USEGRADMIP
               float4 d0 = mipLevel.d0;
               float4 d1 = mipLevel.d1;
               float4 d2 = mipLevel.d2;
            #elif _USELODMIP
               float d0 = mipLevel.x;
               float d1 = mipLevel.y;
               float d2 = mipLevel.z;
            #else
               MIPFORMAT d0 = mipLevel;
               MIPFORMAT d1 = mipLevel;
               MIPFORMAT d2 = mipLevel;
            #endif
         
            half4 contrasts = _Contrast.xxxx;
            #if _PERTEXTRIPLANARCONTRAST
               SAMPLE_PER_TEX(ptc, 5.5, config, half4(1,0.5,0,0));
               contrasts = half4(ptc0.y, ptc1.y, ptc2.y, ptc3.y);
            #endif


            #if _PERTEXTRIPLANAR
               SAMPLE_PER_TEX(pttri, 9.5, config, half4(0,0,0,0));
            #endif

            {
               // For per-texture triplanar, we modify the view based blending factor of the triplanar
               // such that you get a pure blend of either top down projection, or with the top down projection
               // removed and renormalized. This causes dynamic flow control optimizations to kick in and avoid
               // the extra texture samples while keeping the code simple. Yay..

               // We also only have to do this in the Albedo, because the pN values will be adjusted after the
               // albedo is sampled, causing future samples to use this data. 
              
               #if _PERTEXTRIPLANAR
                  if (pttri0.x > 0.66)
                  {
                     tc.pN0 = half3(0,1,0);
                  }
                  else if (pttri0.x > 0.33)
                  {
                     tc.pN0.y = 0;
                     tc.pN0.xz = normalize(tc.pN0.xz);
                  }
               #endif


               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN0.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv0[0], config.cluster0, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN0.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv0[1], config.cluster0, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN0.z)
               {
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv0[2], config.cluster0, d2);
                  COUNTSAMPLE
               }

               half3 bf = tc.pN0;
               #if _TRIPLANARHEIGHTBLEND
                  bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN0, contrasts.x);
                  tc.pN0 = bf;
               #endif

               s.albedo0 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            MSBRANCH(weights.y)
            {
               #if _PERTEXTRIPLANAR
                  if (pttri1.x > 0.66)
                  {
                     tc.pN1 = half3(0,1,0);
                  }
                  else if (pttri1.x > 0.33)
                  {
                     tc.pN1.y = 0;
                     tc.pN1.xz = normalize(tc.pN1.xz);
                  }
               #endif

               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN1.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv1[0], config.cluster1, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv1[1], config.cluster1, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.z)
               {
                  COUNTSAMPLE
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv1[2], config.cluster1, d2);
               }
               half3 bf = tc.pN1;
               #if _TRIPLANARHEIGHTBLEND
                  bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN1, contrasts.x);
                  tc.pN1 = bf;
               #endif


               s.albedo1 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            #if !_MAX2LAYER
            MSBRANCH(weights.z)
            {
               #if _PERTEXTRIPLANAR
                  if (pttri2.x > 0.66)
                  {
                     tc.pN2 = half3(0,1,0);
                  }
                  else if (pttri2.x > 0.33)
                  {
                     tc.pN2.y = 0;
                     tc.pN2.xz = normalize(tc.pN2.xz);
                  }
               #endif

               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN2.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv2[0], config.cluster2, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv2[1], config.cluster2, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.z)
               {
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv2[2], config.cluster2, d2);
                  COUNTSAMPLE
               }

               half3 bf = tc.pN2;
               #if _TRIPLANARHEIGHTBLEND
                  bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN2, contrasts.x);
                  tc.pN2 = bf;
               #endif
               

               s.albedo2 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
            MSBRANCH(weights.w)
            {

               #if _PERTEXTRIPLANAR
                  if (pttri3.x > 0.66)
                  {
                     tc.pN3 = half3(0,1,0);
                  }
                  else if (pttri3.x > 0.33)
                  {
                     tc.pN3.y = 0;
                     tc.pN3.xz = normalize(tc.pN3.xz);
                  }
               #endif

               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN3.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv3[0], config.cluster3, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv3[1], config.cluster3, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.z)
               {
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv3[2], config.cluster3, d2);
                  COUNTSAMPLE
               }

               half3 bf = tc.pN3;
               #if _TRIPLANARHEIGHTBLEND
               bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN3, contrasts.x);
               tc.pN3 = bf;
               #endif

               s.albedo3 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            #endif

         #else
            s.albedo0 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv0, config.cluster0, mipLevel);
            COUNTSAMPLE

            MSBRANCH(weights.y)
            {
               s.albedo1 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv1, config.cluster1, mipLevel);
               COUNTSAMPLE
            }
            #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  s.albedo2 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv2, config.cluster2, mipLevel);
                  COUNTSAMPLE
               } 
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  s.albedo3 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv3, config.cluster3, mipLevel);
                  COUNTSAMPLE
               }
            #endif
         #endif

         #if _PERTEXHEIGHTOFFSET || _PERTEXHEIGHTCONTRAST
            SAMPLE_PER_TEX(ptHeight, 10.5, config, 1);

            #if _PERTEXHEIGHTOFFSET
               s.albedo0.a = saturate(s.albedo0.a + ptHeight0.b - 1);
               s.albedo1.a = saturate(s.albedo1.a + ptHeight1.b - 1);
               s.albedo2.a = saturate(s.albedo2.a + ptHeight2.b - 1);
               s.albedo3.a = saturate(s.albedo3.a + ptHeight3.b - 1);
            #endif
            #if _PERTEXHEIGHTCONTRAST
               s.albedo0.a = saturate(pow(s.albedo0.a + 0.5, abs(ptHeight0.a)) - 0.5);
               s.albedo1.a = saturate(pow(s.albedo1.a + 0.5, abs(ptHeight1.a)) - 0.5);
               s.albedo2.a = saturate(pow(s.albedo2.a + 0.5, abs(ptHeight2.a)) - 0.5);
               s.albedo3.a = saturate(pow(s.albedo3.a + 0.5, abs(ptHeight3.a)) - 0.5);
            #endif
         #endif
      }
      
      
      
      void SampleNormal(Config config, TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
         return;
         #endif

         #if _NONOMALMAP
            s.normSAO0 = half4(0,0, 0, 1);
            s.normSAO1 = half4(0,0, 0, 1);
            s.normSAO2 = half4(0,0, 0, 1);
            s.normSAO3 = half4(0,0, 0, 1);
            return;
         #endif
         
         #if _TRIPLANAR
            #if _USEGRADMIP
               float4 d0 = mipLevel.d0;
               float4 d1 = mipLevel.d1;
               float4 d2 = mipLevel.d2;
            #elif _USELODMIP
               float d0 = mipLevel.x;
               float d1 = mipLevel.y;
               float d2 = mipLevel.z;
            #else
               MIPFORMAT d0 = mipLevel;
               MIPFORMAT d1 = mipLevel;
               MIPFORMAT d2 = mipLevel;
            #endif
            
            half3 absVertNormal = abs(tc.IN.worldNormal);
            float3 t2w0 = WorldNormalVector(tc.IN, float3(1,0,0));
            float3 t2w1 = WorldNormalVector(tc.IN, float3(0,1,0));
            float3 t2w2 = WorldNormalVector(tc.IN, float3(0,0,1));
            float3x3 t2w = float3x3(t2w0, t2w1, t2w2);
            
            
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);
               MSBRANCHTRIPLANAR(tc.pN0.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv0[0], config.cluster0, d0).garb;
                  COUNTSAMPLE
               }            
               MSBRANCHTRIPLANAR(tc.pN0.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv0[1], config.cluster0, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN0.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv0[2], config.cluster0, d2).garb;
                  COUNTSAMPLE
               }
               

               s.normSAO0.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN0, a0.xy, a1.xy, a2.xy);
               s.normSAO0.zw = a0.zw * tc.pN0.x + a1.zw * tc.pN0.y + a2.zw * tc.pN0.z;
            }
            MSBRANCH(weights.y)
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);
               MSBRANCHTRIPLANAR(tc.pN1.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv1[0], config.cluster1, d0).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv1[1], config.cluster1, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv1[2], config.cluster1, d2).garb;
                  COUNTSAMPLE
               }
               

               s.normSAO1.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN1, a0.xy, a1.xy, a2.xy);
               s.normSAO1.zw = a0.zw * tc.pN1.x + a1.zw * tc.pN1.y + a2.zw * tc.pN1.z;
            }
            #if !_MAX2LAYER
            MSBRANCH(weights.z)
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);

               MSBRANCHTRIPLANAR(tc.pN2.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv2[0], config.cluster2, d0).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv2[1], config.cluster2, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv2[2], config.cluster2, d2).garb;
                  COUNTSAMPLE
               }
               

               s.normSAO2.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN2, a0.xy, a1.xy, a2.xy);
               s.normSAO2.zw = a0.zw * tc.pN2.x + a1.zw * tc.pN2.y + a2.zw * tc.pN2.z;
            }
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
            MSBRANCH(weights.w)
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);
               MSBRANCHTRIPLANAR(tc.pN3.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv3[0], config.cluster3, d0).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv3[1], config.cluster3, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv3[2], config.cluster3, d2).garb;
                  COUNTSAMPLE
               }

               s.normSAO3.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN3, a0.xy, a1.xy, a2.xy);
               s.normSAO3.zw = a0.zw * tc.pN3.x + a1.zw * tc.pN3.y + a2.zw * tc.pN3.z;
            }
            #endif

         #else
            s.normSAO0 = MICROSPLAT_SAMPLE_NORMAL(config.uv0, config.cluster0, mipLevel).garb;
            COUNTSAMPLE
            s.normSAO0.xy = s.normSAO0.xy * 2 - 1;
            MSBRANCH(weights.y)
            {
               s.normSAO1 = MICROSPLAT_SAMPLE_NORMAL(config.uv1, config.cluster1, mipLevel).garb;
               COUNTSAMPLE
               s.normSAO1.xy = s.normSAO1.xy * 2 - 1;
            }
            #if !_MAX2LAYER
            MSBRANCH(weights.z)
            {
               s.normSAO2 = MICROSPLAT_SAMPLE_NORMAL(config.uv2, config.cluster2, mipLevel).garb;
               COUNTSAMPLE
               s.normSAO2.xy = s.normSAO2.xy * 2 - 1;
            }
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
            MSBRANCH(weights.w)
            {
               s.normSAO3 = MICROSPLAT_SAMPLE_NORMAL(config.uv3, config.cluster3, mipLevel).garb;
               COUNTSAMPLE
               s.normSAO3.xy = s.normSAO3.xy * 2 - 1;
            }
            #endif
         #endif
      }

      void SampleEmis(Config config, TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
            return;
         #endif
         #if _USEEMISSIVEMETAL
            #if _TRIPLANAR
            
               #if _USEGRADMIP
                  float4 d0 = mipLevel.d0;
                  float4 d1 = mipLevel.d1;
                  float4 d2 = mipLevel.d2;
               #elif _USELODMIP
                  float d0 = mipLevel.x;
                  float d1 = mipLevel.y;
                  float d2 = mipLevel.z;
               #else
                  MIPFORMAT d0 = mipLevel;
                  MIPFORMAT d1 = mipLevel;
                  MIPFORMAT d2 = mipLevel;
               #endif
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN0.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv0[0], config.cluster0, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv0[1], config.cluster0, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv0[2], config.cluster0, d2);
                     COUNTSAMPLE
                  }
                  s.emisMetal0 = a0 * tc.pN0.x + a1 * tc.pN0.y + a2 * tc.pN0.z;
               }
               MSBRANCH(weights.y)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN1.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv1[0], config.cluster1, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv1[1], config.cluster1, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv1[2], config.cluster1, d2);
                     COUNTSAMPLE
                  }

                  s.emisMetal1 = a0 * tc.pN1.x + a1 * tc.pN1.y + a2 * tc.pN1.z;
               }
               #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN2.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv2[0], config.cluster2, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv2[1], config.cluster2, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv2[2], config.cluster2, d2);
                     COUNTSAMPLE
                  }
                  
                  s.emisMetal2 = a0 * tc.pN2.x + a1 * tc.pN2.y + a2 * tc.pN2.z;
               }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN3.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv3[0], config.cluster3, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv3[1], config.cluster3, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv3[2], config.cluster3, d2);
                     COUNTSAMPLE
                  }
                  
                  s.emisMetal3 = a0 * tc.pN3.x + a1 * tc.pN3.y + a2 * tc.pN3.z;
               }
               #endif

            #else
               s.emisMetal0 = MICROSPLAT_SAMPLE_EMIS(config.uv0, config.cluster0, mipLevel);
               COUNTSAMPLE

               MSBRANCH(weights.y)
               {
                  s.emisMetal1 = MICROSPLAT_SAMPLE_EMIS(config.uv1, config.cluster1, mipLevel);
                  COUNTSAMPLE
               }
               #if !_MAX2LAYER
                  MSBRANCH(weights.z)
                  {
                     s.emisMetal2 = MICROSPLAT_SAMPLE_EMIS(config.uv2, config.cluster2, mipLevel);
                     COUNTSAMPLE
                  }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  MSBRANCH(weights.w)
                  {
                     s.emisMetal3 = MICROSPLAT_SAMPLE_EMIS(config.uv3, config.cluster3, mipLevel);
                     COUNTSAMPLE
                  }
               #endif
            #endif
         #endif
      }
      
      void SampleSpecular(Config config, TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
            return;
         #endif
         #if _USESPECULARWORKFLOW
            #if _TRIPLANAR

               #if _USEGRADMIP
                  float4 d0 = mipLevel.d0;
                  float4 d1 = mipLevel.d1;
                  float4 d2 = mipLevel.d2;
               #elif _USELODMIP
                  float d0 = mipLevel.x;
                  float d1 = mipLevel.y;
                  float d2 = mipLevel.z;
               #else
                  MIPFORMAT d0 = mipLevel;
                  MIPFORMAT d1 = mipLevel;
                  MIPFORMAT d2 = mipLevel;
               #endif
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN0.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv0[0], config.cluster0, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv0[1], config.cluster0, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv0[2], config.cluster0, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular0 = a0 * tc.pN0.x + a1 * tc.pN0.y + a2 * tc.pN0.z;
               }
               MSBRANCH(weights.y)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN1.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv1[0], config.cluster1, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv1[1], config.cluster1, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv1[2], config.cluster1, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular1 = a0 * tc.pN1.x + a1 * tc.pN1.y + a2 * tc.pN1.z;
               }
               #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN2.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv2[0], config.cluster2, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv2[1], config.cluster2, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv2[2], config.cluster2, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular2 = a0 * tc.pN2.x + a1 * tc.pN2.y + a2 * tc.pN2.z;
               }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN3.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv3[0], config.cluster3, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv3[1], config.cluster3, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv3[2], config.cluster3, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular3 = a0 * tc.pN3.x + a1 * tc.pN3.y + a2 * tc.pN3.z;
               }
               #endif

            #else
               s.specular0 = MICROSPLAT_SAMPLE_SPECULAR(config.uv0, config.cluster0, mipLevel);
               COUNTSAMPLE

               MSBRANCH(weights.y)
               {
                  s.specular1 = MICROSPLAT_SAMPLE_SPECULAR(config.uv1, config.cluster1, mipLevel);
                  COUNTSAMPLE
               }
               #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  s.specular2 = MICROSPLAT_SAMPLE_SPECULAR(config.uv2, config.cluster2, mipLevel);
                  COUNTSAMPLE
               }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  s.specular3 = MICROSPLAT_SAMPLE_SPECULAR(config.uv3, config.cluster3, mipLevel);
                  COUNTSAMPLE
               }
               #endif
            #endif
         #endif
      }

      MicroSplatLayer Sample(Input i, half4 weights, inout Config config, float camDist, float3 worldNormalVertex)
      {
         MicroSplatLayer o = (MicroSplatLayer)0;
         UNITY_INITIALIZE_OUTPUT(MicroSplatLayer,o);

         RawSamples samples = (RawSamples)0;
         InitRawSamples(samples);

         half4 albedo = 0;
         half4 normSAO = half4(0,0,0,1);
         half4 emisMetal = 0;
         half3 specular = 0;
         
         float worldHeight = i.worldPos.y;
         float3 upVector = float3(0,1,0);

         #if _PLANETVECTORS
            upVector = worldNormalVertex;
            worldHeight = distance(i.worldPos, float3(0,0,0));
         #endif

         #if _GLOBALTINT || _GLOBALNORMALS || _GLOBALSMOOTHAOMETAL || _GLOBALEMIS || _GLOBALSPECULAR
            float globalSlopeFilter = 1;
            #if _GLOBALSLOPEFILTER
               float2 gfilterUV = float2(1 - saturate(dot(worldNormalVertex, upVector) * 0.5 + 0.49), 0.5);
               globalSlopeFilter = UNITY_SAMPLE_TEX2D_SAMPLER(_GlobalSlopeTex, _Diffuse, gfilterUV).a;
            #endif
         #endif

         // declare outside of branchy areas..
         half4 fxLevels = half4(0,0,0,0);
         half burnLevel = 0;
         half wetLevel = 0;
         half3 waterNormalFoam = half3(0, 0, 0);
         half porosity = 0.4;
         float streamFoam = 1.0f;
         half pud = 0;
         half snowCover = 0;
         half SSSThickness = 0;
         half3 SSSTint = half3(1,1,1);
         float traxBuffer = 0;
         float3 traxNormal = 0;
         float2 noiseUV = 0;
         
         

         #if _SPLATFADE
         MSBRANCHOTHER(1 - saturate(camDist - _SplatFade.y))
         {
         #endif

         #if _TRAXSINGLE || _TRAXARRAY || _TRAXNOTEXTURE || _SNOWFOOTSTEPS
            traxBuffer = SampleTraxBuffer(i.worldPos, traxNormal);
         #endif
         
         #if _WETNESS || _PUDDLES || _STREAMS || _LAVA
            #if _MICROMESH
               fxLevels = SampleFXLevels(InverseLerp(_UVMeshRange.xy, _UVMeshRange.zw, config.uv), wetLevel, burnLevel, traxBuffer);
            #elif _MICROVERTEXMESH || _MICRODIGGERMESH 
               fxLevels = ProcessFXLevels(i.s0, traxBuffer);
            #else
               fxLevels = SampleFXLevels(config.uv, wetLevel, burnLevel, traxBuffer);
            #endif
         #endif

         TriplanarConfig tc = (TriplanarConfig)0;
         UNITY_INITIALIZE_OUTPUT(TriplanarConfig,tc);
         

         MIPFORMAT albedoLOD = INITMIPFORMAT
         MIPFORMAT normalLOD = INITMIPFORMAT
         MIPFORMAT emisLOD = INITMIPFORMAT
         MIPFORMAT specLOD = INITMIPFORMAT

         #if _TRIPLANAR && !_DISABLESPLATMAPS
            PrepTriplanar(worldNormalVertex, i.worldPos, config, tc, weights, albedoLOD, normalLOD, emisLOD);
            tc.IN = i;
         #endif
         
         
         #if !_TRIPLANAR && !_DISABLESPLATMAPS
            #if _USELODMIP
               albedoLOD = ComputeMipLevel(config.uv0.xy, _Diffuse_TexelSize.zw);
               normalLOD = ComputeMipLevel(config.uv0.xy, _NormalSAO_TexelSize.zw);
               #if _USEEMISSIVEMETAL
                  emisLOD   = ComputeMipLevel(config.uv0.xy, _EmissiveMetal_TexelSize.zw);
               #endif
               #if _USESPECULARWORKFLOW
                  specLOD = ComputeMipLevel(config.uv0.xy, _Specular_TexelSize.zw);;
               #endif
            #elif _USEGRADMIP
               albedoLOD = float4(ddx(config.uv0.xy), ddy(config.uv0.xy));
               normalLOD = albedoLOD;
               #if _USESPECULARWORKFLOW
                  specLOD = albedoLOD;
               #endif
               #if _USEEMISSIVEMETAL
                  emisLOD = albedoLOD;
               #endif
            #endif
         #endif

         #if _PERTEXCURVEWEIGHT
           SAMPLE_PER_TEX(ptCurveWeight, 19.5, config, half4(0.5,1,1,1));
           weights.x = lerp(smoothstep(0.5 - ptCurveWeight0.r, 0.5 + ptCurveWeight0.r, weights.x), weights.x, ptCurveWeight0.r*2);
           weights.y = lerp(smoothstep(0.5 - ptCurveWeight1.r, 0.5 + ptCurveWeight1.r, weights.y), weights.y, ptCurveWeight1.r*2);
           weights.z = lerp(smoothstep(0.5 - ptCurveWeight2.r, 0.5 + ptCurveWeight2.r, weights.z), weights.z, ptCurveWeight2.r*2);
           weights.w = lerp(smoothstep(0.5 - ptCurveWeight3.r, 0.5 + ptCurveWeight3.r, weights.w), weights.w, ptCurveWeight3.r*2);
           weights = normalize(weights);
         #endif
         

         // uvScale before anything
         #if _PERTEXUVSCALEOFFSET && !_TRIPLANAR && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptUVScale, 0.5, config, half4(1,1,0,0));
            config.uv0.xy = config.uv0.xy * ptUVScale0.rg + ptUVScale0.ba;
            config.uv1.xy = config.uv1.xy * ptUVScale1.rg + ptUVScale1.ba;
            #if !_MAX2LAYER
               config.uv2.xy = config.uv2.xy * ptUVScale2.rg + ptUVScale2.ba;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               config.uv3.xy = config.uv3.xy * ptUVScale3.rg + ptUVScale3.ba;
            #endif

            // fix for pertex uv scale using gradient sampler and weight blended derivatives
            #if _USEGRADMIP
               albedoLOD = albedoLOD * ptUVScale0.rgrg * weights.x + 
                           albedoLOD * ptUVScale1.rgrg * weights.y + 
                           albedoLOD * ptUVScale2.rgrg * weights.z + 
                           albedoLOD * ptUVScale3.rgrg * weights.w;
               normalLOD = albedoLOD;
               #if _USEEMISSIVEMETAL
                  emisLOD = albedoLOD;
               #endif
               #if _USESPECULARWORKFLOW
                  specLOD = albedoLOD;
               #endif
            #endif
         #endif

         #if _PERTEXUVROTATION && !_TRIPLANAR && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptUVRot, 16.5, config, half4(0,0,0,0));
            config.uv0.xy = RotateUV(config.uv0.xy, ptUVRot0.x);
            config.uv1.xy = RotateUV(config.uv1.xy, ptUVRot1.x);
            #if !_MAX2LAYER
               config.uv2.xy = RotateUV(config.uv2.xy, ptUVRot2.x);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               config.uv3.xy = RotateUV(config.uv3.xy, ptUVRot0.x);
            #endif
         #endif

         
         o.Alpha = 1;

         
         #if _POM && !_DISABLESPLATMAPS
            DoPOM(i, config, tc, albedoLOD, weights, camDist, worldNormalVertex);
         #endif
         

         SampleAlbedo(config, tc, samples, albedoLOD, weights);

         #if _NOISEHEIGHT
            ApplyNoiseHeight(samples, config.uv, config, i.worldPos, worldNormalVertex);
         #endif
         
         #if _STREAMS || (_PARALLAX && !_DISABLESPLATMAPS)
         half earlyHeight = BlendWeights(samples.albedo0.w, samples.albedo1.w, samples.albedo2.w, samples.albedo3.w, weights);
         #endif

         
         #if _STREAMS
         waterNormalFoam = GetWaterNormal(i, config.uv, worldNormalVertex);
         DoStreamRefract(config, tc, waterNormalFoam, fxLevels.b, earlyHeight);
         #endif

         #if _PARALLAX && !_DISABLESPLATMAPS
            DoParallax(i, earlyHeight, config, tc, samples, weights, camDist);
         #endif


         // Blend results
         #if _PERTEXINTERPCONTRAST && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptContrasts, 1.5, config, 0.5);
            half4 contrast = 0.5;
            contrast.x = ptContrasts0.a;
            contrast.y = ptContrasts1.a;
            #if !_MAX2LAYER
               contrast.z = ptContrasts2.a;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               contrast.w = ptContrasts3.a;
            #endif
            contrast = clamp(contrast + _Contrast, 0.0001, 1.0); 
            half cnt = contrast.x * weights.x + contrast.y * weights.y + contrast.z * weights.z + contrast.w * weights.w;
            half4 heightWeights = ComputeWeights(weights, samples.albedo0.a, samples.albedo1.a, samples.albedo2.a, samples.albedo3.a, cnt);
         #else
            half4 heightWeights = ComputeWeights(weights, samples.albedo0.a, samples.albedo1.a, samples.albedo2.a, samples.albedo3.a, _Contrast);
         #endif


         #if _PARALLAX || _STREAMS
            SampleAlbedo(config, tc, samples, albedoLOD, heightWeights);
         #endif


         SampleNormal(config, tc, samples, normalLOD, heightWeights);

         #if _USEEMISSIVEMETAL
            SampleEmis(config, tc, samples, emisLOD, heightWeights);
         #endif

         #if _USESPECULARWORKFLOW
            SampleSpecular(config, tc, samples, specLOD, heightWeights);
         #endif

         #if _DISTANCERESAMPLE && !_DISABLESPLATMAPS
            DistanceResample(samples, config, tc, camDist, i.viewDir, fxLevels, albedoLOD, i.worldPos, heightWeights, worldNormalVertex);
         #endif

         // PerTexture sampling goes here, passing the samples structure
         
         #if _PERTEXMICROSHADOWS || _PERTEXFUZZYSHADE
            SAMPLE_PER_TEX(ptFuzz, 17.5, config, half4(0, 0, 1, 1));
         #endif

         #if _PERTEXMICROSHADOWS
            #if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_DEFERRED) || (defined(_MSRENDERLOOP_UNITYLD) && defined(_PASSFORWARD) || _MSRENDERLOOP_UNITYHD)
            {
               half3 lightDir = GetGlobalLightDirTS(i);
               half4 microShadows = half4(1,1,1,1);
               microShadows.x = MicroShadow(lightDir, half3(samples.normSAO0.xy, 1), samples.normSAO0.a, ptFuzz0.a);
               microShadows.y = MicroShadow(lightDir, half3(samples.normSAO1.xy, 1), samples.normSAO1.a, ptFuzz1.a);
               microShadows.z = MicroShadow(lightDir, half3(samples.normSAO2.xy, 1), samples.normSAO2.a, ptFuzz2.a);
               microShadows.w = MicroShadow(lightDir, half3(samples.normSAO3.xy, 1), samples.normSAO3.a, ptFuzz3.a);
               samples.normSAO0.a *= microShadows.x;
               samples.normSAO1.a *= microShadows.y;
               #if !_MAX2LAYER
                  samples.normSAO2.a *= microShadows.z;
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  samples.normSAO3.a *= microShadows.w;
               #endif

               
               #if _DEBUG_OUTPUT_MICROSHADOWS
               o.Albedo = BlendWeights(microShadows.x, microShadows.y, microShadows.z, microShadows.a, heightWeights);
               return o;
               #endif

            }
            #endif

         #endif // _PERTEXMICROSHADOWS


         #if _PERTEXFUZZYSHADE
            
            samples.albedo0.rgb = FuzzyShade(samples.albedo0.rgb, half3(samples.normSAO0.rg, 1), ptFuzz0.r, ptFuzz0.g, ptFuzz0.b, i.viewDir);
            samples.albedo1.rgb = FuzzyShade(samples.albedo1.rgb, half3(samples.normSAO1.rg, 1), ptFuzz1.r, ptFuzz1.g, ptFuzz1.b, i.viewDir);
            #if !_MAX2LAYER
               samples.albedo2.rgb = FuzzyShade(samples.albedo2.rgb, half3(samples.normSAO2.rg, 1), ptFuzz2.r, ptFuzz2.g, ptFuzz2.b, i.viewDir);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb = FuzzyShade(samples.albedo3.rgb, half3(samples.normSAO3.rg, 1), ptFuzz3.r, ptFuzz3.g, ptFuzz3.b, i.viewDir);
            #endif
         #endif

         #if _PERTEXSATURATION && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptSaturattion, 9.5, config, half4(1, 1, 1, 1));
            samples.albedo0.rgb = lerp(MSLuminance(samples.albedo0.rgb), samples.albedo0.rgb, ptSaturattion0.a);
            samples.albedo1.rgb = lerp(MSLuminance(samples.albedo1.rgb), samples.albedo1.rgb, ptSaturattion1.a);
            #if !_MAX2LAYER
               samples.albedo2.rgb = lerp(MSLuminance(samples.albedo2.rgb), samples.albedo2.rgb, ptSaturattion2.a);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb = lerp(MSLuminance(samples.albedo3.rgb), samples.albedo3.rgb, ptSaturattion3.a);
            #endif
         
         #endif
         
         #if _PERTEXTINT && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptTints, 1.5, config, half4(1, 1, 1, 1));
            samples.albedo0.rgb *= ptTints0.rgb;
            samples.albedo1.rgb *= ptTints1.rgb;
            #if !_MAX2LAYER
               samples.albedo2.rgb *= ptTints2.rgb;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb *= ptTints3.rgb;
            #endif
         #endif
         
         #if _PCHEIGHTGRADIENT || _PCHEIGHTHSV || _PCSLOPEGRADIENT || _PCSLOPEHSV
            ProceduralGradients(i, samples, config, worldHeight, worldNormalVertex);
         #endif

         
         

         #if _WETNESS || _PUDDLES || _STREAMS
         porosity = _GlobalPorosity;
         #endif


         #if _PERTEXCOLORINTENSITY
            SAMPLE_PER_TEX(ptCI, 23.5, config, half4(1, 1, 1, 1));
            samples.albedo0.rgb = saturate(samples.albedo0.rgb * (1 + ptCI0.rrr));
            samples.albedo1.rgb = saturate(samples.albedo1.rgb * (1 + ptCI1.rrr));
            #if !_MAX2LAYER
               samples.albedo2.rgb = saturate(samples.albedo2.rgb * (1 + ptCI2.rrr));
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb = saturate(samples.albedo3.rgb * (1 + ptCI3.rrr));
            #endif
         #endif

         #if (_PERTEXBRIGHTNESS || _PERTEXCONTRAST || _PERTEXPOROSITY || _PERTEXFOAM) && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptBC, 3.5, config, half4(1, 1, 1, 1));
            #if _PERTEXCONTRAST
               samples.albedo0.rgb = saturate(((samples.albedo0.rgb - 0.5) * ptBC0.g) + 0.5);
               samples.albedo1.rgb = saturate(((samples.albedo1.rgb - 0.5) * ptBC1.g) + 0.5);
               #if !_MAX2LAYER
                 samples.albedo2.rgb = saturate(((samples.albedo2.rgb - 0.5) * ptBC2.g) + 0.5);
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  samples.albedo3.rgb = saturate(((samples.albedo3.rgb - 0.5) * ptBC3.g) + 0.5);
               #endif
            #endif
            #if _PERTEXBRIGHTNESS
               samples.albedo0.rgb = saturate(samples.albedo0.rgb + ptBC0.rrr);
               samples.albedo1.rgb = saturate(samples.albedo1.rgb + ptBC1.rrr);
               #if !_MAX2LAYER
                  samples.albedo2.rgb = saturate(samples.albedo2.rgb + ptBC2.rrr);
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  samples.albedo3.rgb = saturate(samples.albedo3.rgb + ptBC3.rrr);
               #endif
            #endif
            #if _PERTEXPOROSITY
            porosity = BlendWeights(ptBC0.b, ptBC1.b, ptBC2.b, ptBC3.b, heightWeights);
            #endif

            #if _PERTEXFOAM
            streamFoam = BlendWeights(ptBC0.a, ptBC1.a, ptBC2.a, ptBC3.a, heightWeights);
            #endif

         #endif

         #if (_PERTEXNORMSTR || _PERTEXAOSTR || _PERTEXSMOOTHSTR || _PERTEXMETALLIC) && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(perTexMatSettings, 2.5, config, half4(1.0, 1.0, 1.0, 0.0));
         #endif

         #if _PERTEXNORMSTR && !_DISABLESPLATMAPS
            samples.normSAO0.xy *= perTexMatSettings0.r;
            samples.normSAO1.xy *= perTexMatSettings1.r;
            #if !_MAX2LAYER
               samples.normSAO2.xy *= perTexMatSettings2.r;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.normSAO3.xy *= perTexMatSettings3.r;
            #endif
         #endif

         #if _PERTEXAOSTR && !_DISABLESPLATMAPS
            samples.normSAO0.a = pow(samples.normSAO0.a, abs(perTexMatSettings0.b));
            samples.normSAO1.a = pow(samples.normSAO1.a, abs(perTexMatSettings1.b));
            #if !_MAX2LAYER
               samples.normSAO2.a = pow(samples.normSAO2.a, abs(perTexMatSettings2.b));
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.normSAO3.a = pow(samples.normSAO3.a, abs(perTexMatSettings3.b));
            #endif
         #endif

         #if _PERTEXSMOOTHSTR && !_DISABLESPLATMAPS
            samples.normSAO0.b += perTexMatSettings0.g;
            samples.normSAO1.b += perTexMatSettings1.g;
            samples.normSAO0.b = saturate(samples.normSAO0.b);
            samples.normSAO1.b = saturate(samples.normSAO1.b);
            #if !_MAX2LAYER
               samples.normSAO2.b += perTexMatSettings2.g;
               samples.normSAO2.b = saturate(samples.normSAO2.b);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.normSAO3.b += perTexMatSettings3.g;
               samples.normSAO3.b = saturate(samples.normSAO3.b);
            #endif
         #endif

         
         #if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_DEFERRED) || (defined(_MSRENDERLOOP_UNITYLD) && defined(_PASSFORWARD) || _MSRENDERLOOP_UNITYHD) 
          #if _PERTEXSSS
          {
            SAMPLE_PER_TEX(ptSSS, 18.5, config, half4(1, 1, 1, 1)); // tint, thickness
            
            half4 vals = ptSSS0 * heightWeights.x + ptSSS1 * heightWeights.y + ptSSS2 * heightWeights.z + ptSSS3 * heightWeights.w;
            SSSThickness = vals.a;
            SSSTint = vals.rgb;
          }
          #endif
         #endif

         #if (((_DETAILNOISE && _PERTEXDETAILNOISESTRENGTH) || (_DISTANCENOISE && _PERTEXDISTANCENOISESTRENGTH)) || (_NORMALNOISE && _PERTEXNORMALNOISESTRENGTH)) && !_DISABLESPLATMAPS
         ApplyDetailDistanceNoisePerTex(samples, config, camDist, i.worldPos, worldNormalVertex);
         #endif

         
         #if _GLOBALNOISEUV
            // noise defaults so that a value of 1, 1 is 4 pixels in size and moves the uvs by 1 pixel max.
            #if _CUSTOMSPLATTEXTURES
               noiseUV = (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, config.uv * _CustomControl0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _CustomControl0_TexelSize.xy * _NoiseUVParams.y;
            #else
               noiseUV = (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, config.uv * _Control0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _Control0_TexelSize.xy * _NoiseUVParams.y;
            #endif
         #endif

         
         #if _TRAXSINGLE || _TRAXARRAY || _TRAXNOTEXTURE
            ApplyTrax(samples, config, i.worldPos, traxBuffer, traxNormal);
         #endif

         #if (_ANTITILEARRAYDETAIL || _ANTITILEARRAYDISTANCE || _ANTITILEARRAYNORMAL) && !_DISABLESPLATMAPS
         ApplyAntiTilePerTex(samples, config, camDist, i.worldPos, worldNormalVertex, heightWeights);
         #endif

         #if _GEOMAP && !_DISABLESPLATMAPS
         GeoTexturePerTex(samples, i.worldPos, worldHeight, config, worldNormalVertex, upVector);
         #endif
         
         #if _GLOBALTINT && _PERTEXGLOBALTINTSTRENGTH && !_DISABLESPLATMAPS
         GlobalTintTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALNORMALS && _PERTEXGLOBALNORMALSTRENGTH && !_DISABLESPLATMAPS
         GlobalNormalTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALSMOOTHAOMETAL && _PERTEXGLOBALSAOMSTRENGTH && !_DISABLESPLATMAPS
         GlobalSAOMTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _GLOBALEMIS && _PERTEXGLOBALEMISSTRENGTH && !_DISABLESPLATMAPS
         GlobalEmisTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _GLOBALSPECULAR && _PERTEXGLOBALSPECULARSTRENGTH && !_DISABLESPLATMAPS && _USESPECULARWORKFLOW
         GlobalSpecularTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _PERTEXMETALLIC && !_DISABLESPLATMAPS
            half metallic = BlendWeights(perTexMatSettings0.a, perTexMatSettings1.a, perTexMatSettings2.a, perTexMatSettings3.a, heightWeights);
            o.Metallic = metallic;
         #endif

         #if _GLITTER && !_DISABLESPLATMAPS
            DoGlitter(i, samples, config, camDist, worldNormalVertex, i.worldPos);
         #endif
         
         // Blend em..
         #if _DISABLESPLATMAPS
            // If we don't sample from the _Diffuse, then the shader compiler will strip the sampler on
            // some platforms, which will cause everything to break. So we sample from the lowest mip
            // and saturate to 1 to keep the cost minimal. Annoying, but the compiler removes the texture
            // and sampler, even though the sampler is still used.
            albedo = saturate(UNITY_SAMPLE_TEX2DARRAY_LOD(_Diffuse, float3(0,0,0), 12) + 1);
            albedo.a = 0.5; // make height something we can blend with for the combined mesh mode, since it still height blends.
            normSAO = half4(0,0,0,1);
         #else
            albedo = BlendWeights(samples.albedo0, samples.albedo1, samples.albedo2, samples.albedo3, heightWeights);
            normSAO = BlendWeights(samples.normSAO0, samples.normSAO1, samples.normSAO2, samples.normSAO3, heightWeights);
            #if _USEEMISSIVEMETAL && !_DISABLESPLATMAPS
               emisMetal = BlendWeights(samples.emisMetal0, samples.emisMetal1, samples.emisMetal2, samples.emisMetal3, heightWeights);
            #endif

            #if _USESPECULARWORKFLOW && !_DISABLESPLATMAPS
               specular = BlendWeights(samples.specular0, samples.specular1, samples.specular2, samples.specular3, heightWeights);
            #endif
         #endif

         
         // ADVANCEDTERRAIN_ENTRYPOINT 


         #if _MESHOVERLAYSPLATS || _MESHCOMBINED
            o.Alpha = 1.0;
            if (config.uv0.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.x;
            else if (config.uv1.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.y;
            else if (config.uv2.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.z;
            else if (config.uv3.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.w;
         #endif



         // effects which don't require per texture adjustments and are part of the splats sample go here. 
         // Often, as an optimization, you can compute the non-per tex version of above effects here..


         #if ((_DETAILNOISE && !_PERTEXDETAILNOISESTRENGTH) || (_DISTANCENOISE && !_PERTEXDISTANCENOISESTRENGTH) || (_NORMALNOISE && !_PERTEXNORMALNOISESTRENGTH))
            ApplyDetailDistanceNoise(albedo.rgb, normSAO, config, camDist, i.worldPos, worldNormalVertex);
         #endif

         #if _SPLATFADE
         }
         #endif

         #if _SPLATFADE
            // blend in uniform texture over splat fade range
            // only for planets? Fine on terrain, but may want a switch for this..
            #if _TRIPLANAR && (_PLANETNORMAL || _PLANETNORMAL2)
               

               float3 pN = pow(abs(worldNormalVertex), 0.7);
               pN = pN / (pN.x + pN.y + pN.z);
            
               half3 axisSign = sign(worldNormalVertex);

               float2 uv0 = i.worldPos.zy * axisSign.x * _TriplanarUVScale.xy;
               float2 uv1 = i.worldPos.xz * axisSign.y * _TriplanarUVScale.xy;
               float2 uv2 = i.worldPos.xy * axisSign.z * _TriplanarUVScale.xy;

               float2 sfDX = ddx(uv0);
               float2 sfDY = ddy(uv0);

               MSBRANCHOTHER(camDist - _SplatFade.x)
               {
                  float falloff = saturate(InverseLerp(_SplatFade.x, _SplatFade.y, camDist));
                  half4 sfalb0 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(uv0, _SplatFade.z), sfDX, sfDY);
                  half4 sfalb1 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(uv1, _SplatFade.z), sfDX, sfDY);
                  half4 sfalb2 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(uv2, _SplatFade.z), sfDX, sfDY);
                  COUNTSAMPLE
                  COUNTSAMPLE
                  COUNTSAMPLE
                  albedo.rgb = lerp(albedo.rgb, sfalb0.rgb * pN.x + sfalb1 * pN.y + sfalb2 * pN.z, falloff);

                  #if !_NONOMALMAP
                     half4 sfnormSAO0 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(uv0, _SplatFade.z), sfDX, sfDY).garb;
                     half4 sfnormSAO1 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(uv1, _SplatFade.z), sfDX, sfDY).garb;
                     half4 sfnormSAO2 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(uv2, _SplatFade.z), sfDX, sfDY).garb;
                     COUNTSAMPLE
                     COUNTSAMPLE
                     COUNTSAMPLE
                     half4 sfnormSAO = sfnormSAO0 * pN.x + sfnormSAO1 * pN.y + sfnormSAO2 * pN.z;
                     sfnormSAO.xy = sfnormSAO.xy * 2 - 1;

                     normSAO = lerp(normSAO, sfnormSAO, falloff);
                  #endif
              
               }
            #else // _TRIPLANAR && (_PLANETNORMAL || _PLANETNORMAL2)
            float2 sfDX = ddx(config.uv * _UVScale);
            float2 sfDY = ddy(config.uv * _UVScale);

            MSBRANCHOTHER(camDist - _SplatFade.x)
            {
               float falloff = saturate(InverseLerp(_SplatFade.x, _SplatFade.y, camDist));
               half4 sfalb = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(config.uv * _UVScale, _SplatFade.z), sfDX, sfDY);
               COUNTSAMPLE
               albedo.rgb = lerp(albedo.rgb, sfalb.rgb, falloff);

               #if !_NONOMALMAP
                  half4 sfnormSAO = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(config.uv * _UVScale, _SplatFade.z), sfDX, sfDY).garb;
                  COUNTSAMPLE
                  sfnormSAO.xy = sfnormSAO.xy * 2 - 1;

                  normSAO = lerp(normSAO, sfnormSAO, falloff);
               #endif
              
            }
            #endif
         #endif


         #if _MESHCOMBINED
            SampleMeshCombined(albedo, normSAO, emisMetal, specular, o.Alpha, SSSThickness, SSSTint, config, heightWeights);
         #endif
         
         #if _SCATTER
            ApplyScatter(i, albedo, normSAO, config.uv, camDist);
         #endif

         #if _GEOMAP
            GeoTexture(albedo.rgb, normSAO, i.worldPos, worldHeight, config, worldNormalVertex, upVector);
         #endif

         #if _PLANETALBEDO || _PLANETNORMAL || _PLANETALBEDO2 || _PLANETNORMAL2
            ApplyPlanet(i, albedo, normSAO, config, camDist, i.worldPos, worldNormalVertex);
         #endif


         #if _GLOBALTINT && !_PERTEXGLOBALTINTSTRENGTH
            GlobalTintTexture(albedo.rgb, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _VSGRASSMAP
            VSGrassTexture(albedo.rgb, config, camDist);
         #endif

         #if _GLOBALNORMALS && !_PERTEXGLOBALNORMALSTRENGTH
            GlobalNormalTexture(normSAO, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALSMOOTHAOMETAL && !_PERTEXGLOBALSAOMSTRENGTH
            GlobalSAOMTexture(normSAO, emisMetal, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALEMIS && !_PERTEXGLOBALEMISSTRENGTH
            GlobalEmisTexture(emisMetal, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _GLOBALSPECULAR && !_PERTEXGLOBALSPECULARSTRENGTH && _USESPECULARWORKFLOW
            GlobalSpecularTexture(specular.rgb, config, camDist, globalSlopeFilter, noiseUV);
         #endif

        
         
         o.Albedo = albedo.rgb;
         o.Height = albedo.a;
         o.Normal = half3(normSAO.xy, 1);
         o.Smoothness = normSAO.b;
         o.Occlusion = normSAO.a;

         #if _USEEMISSIVEMETAL || _GLOBALSMOOTHAOMETAL || _GLOBALEMIS 
         o.Emission = emisMetal.rgb;
         o.Metallic = emisMetal.a;
	        #if _USEEMISSIVEMETAL
	        o.Emission *= _EmissiveMult;
	        #endif
         #endif

         #if _USESPECULARWORKFLOW
            o.Specular = specular;
         #endif


         


         #if _WETNESS || _PUDDLES || _STREAMS || _LAVA
         pud = DoStreams(i, o, fxLevels, config.uv, porosity, waterNormalFoam, worldNormalVertex, streamFoam, wetLevel, burnLevel, i.worldPos);
         #endif

         
         #if _SNOW
         snowCover = DoSnow(o, config.uv, WorldNormalVector(i, o.Normal), worldNormalVertex, i.worldPos, pud, porosity, camDist, 
            config, weights, SSSTint, SSSThickness, traxBuffer, traxNormal);
         #endif

         #if _PERTEXSSS || _MESHCOMBINEDUSESSS || (_SNOW && _SNOWSSS)
         {
            half3 worldView = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

            o.Emission += ComputeSSS(i, worldView, WorldNormalVector(i, half3(normSAO.xy, 1)),
               SSSTint, SSSThickness, _SSSDistance, _SSSScale, _SSSPower);
         }
         #endif
         
         #if _SNOWGLITTER
            DoSnowGlitter(i, config, o, camDist, worldNormalVertex, snowCover);
         #endif

         #if _WINDPARTICULATE || _SNOWPARTICULATE
         DoWindParticulate(i, o, config, weights, camDist, worldNormalVertex, snowCover);
         #endif

         o.Normal.z = sqrt(1 - saturate(dot(o.Normal.xy, o.Normal.xy)));

         #if _SPECULARFADE
         {
            float specFade = saturate((i.worldPos.y - _SpecularFades.x) / max(_SpecularFades.y - _SpecularFades.x, 0.0001));
            o.Metallic *= specFade;
            o.Smoothness *= specFade;
         }
         #endif

         #if _VSSHADOWMAP
         VSShadowTexture(o, i, config, camDist);
         #endif
         
         #if _TOONWIREFRAME
         ToonWireframe(config.uv, o.Albedo);
         #endif

         #if _DEBUG_TRAXBUFFER
            ClearAllButAlbedo(o, half3(traxBuffer, 0, 0) * saturate(o.Albedo.z+1));
         #elif _DEBUG_WORLDNORMALVERTEX
            ClearAllButAlbedo(o, worldNormalVertex * saturate(o.Albedo.z+1));
         #elif _DEBUG_WORLDNORMAL
            ClearAllButAlbedo(o,  WorldNormalVector(i, o.Normal) * saturate(o.Albedo.z+1));
         #endif

         return o;
      }
      
      void SampleSplats(float2 controlUV, inout half4 w0, inout half4 w1, inout half4 w2, inout half4 w3, inout half4 w4, inout half4 w5, inout half4 w6, inout half4 w7)
      {
         #if _CUSTOMSPLATTEXTURES
            #if !_MICROMESH
            controlUV = (controlUV * (_CustomControl0_TexelSize.zw - 1.0f) + 0.5f) * _CustomControl0_TexelSize.xy;
            #endif

            #if  _CONTROLNOISEUV
               controlUV += (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, controlUV * _CustomControl0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _CustomControl0_TexelSize.xy * _NoiseUVParams.y;
            #endif

            w0 = UNITY_SAMPLE_TEX2D(_CustomControl0, controlUV);
            COUNTSAMPLE

            #if !_MAX4TEXTURES
            w1 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl1, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES
            w2 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl2, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
            w3 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl3, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w4 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl4, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w5 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl5, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX28TEXTURES || _MAX32TEXTURES
            w6 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl6, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX32TEXTURES
            w7 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl7, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif
         #else
            #if !_MICROMESH
            controlUV = (controlUV * (_Control0_TexelSize.zw - 1.0f) + 0.5f) * _Control0_TexelSize.xy;
            #endif

            #if  _CONTROLNOISEUV
               controlUV += (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, controlUV * _Control0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _Control0_TexelSize.xy * _NoiseUVParams.y;
            #endif

            w0 = UNITY_SAMPLE_TEX2D(_Control0, controlUV);
            COUNTSAMPLE

            #if !_MAX4TEXTURES
            w1 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control1, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES
            w2 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control2, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
            w3 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control3, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w4 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control4, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w5 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control5, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX28TEXTURES || _MAX32TEXTURES
            w6 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control6, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX32TEXTURES
            w7 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control7, _Control0, controlUV);
            COUNTSAMPLE
            #endif
         #endif
      }   


      

      MicroSplatLayer SurfImpl(Input i, float3 worldNormalVertex)
      {
         // with DrawInstanced on, view dir is incorrect, so we compute it here. Thanks Obama..
         #if _MSRENDERLOOP_SURFACESHADER && !_DEBUG_USE_TOPOLOGY &&!_TERRAINBLENDABLESHADER && !_MICROMESH && !_MICROMESHTERRAIN && !_MICROPOLARISMESH &&!_MICRODIGGERMESH && !_MICROVERTEXMESH && defined(UNITY_INSTANCING_ENABLED)
            float3 t2w0 = WorldNormalVector(i, float3(1,0,0));
            float3 t2w1 = WorldNormalVector(i, float3(0,1,0));
            float3 t2w2 = WorldNormalVector(i, float3(0,0,1));
            float3x3 t2w = float3x3(t2w0, t2w1, t2w2);
            i.viewDir = normalize(mul(t2w, (_WorldSpaceCameraPos - i.worldPos)));
         #elif !_MSRENDERLOOP_SURFACESHADER
            // tangent space view dir is just not correct in URP
            i.viewDir = normalize( mul(i.TBN, (_WorldSpaceCameraPos - i.worldPos)) );
         #endif


         #if _TERRAINBLENDABLESHADER && _TRIPLANAR
            worldNormalVertex = WorldNormalVector(i, float3(0,0,1));
         #endif
         
         float camDist = distance(_WorldSpaceCameraPos, i.worldPos);
          
         #if _FORCELOCALSPACE
            #if _PLANETVECTORS
                worldNormalVertex = mul(_PQSToLocal, float4(worldNormalVertex, 1)).xyz;
                i.worldPos = i.worldPos + mul(_PQSToLocal, float4(0,0,0,1)).xyz;
             #else
                worldNormalVertex = mul((float3x3)GetWorldToObjectMatrix(), worldNormalVertex).xyz;
                i.worldPos = i.worldPos -  mul(GetObjectToWorldMatrix(), float4(0,0,0,1)).xyz;
             #endif
         #endif

         #if _ORIGINSHIFT
             //worldNormalVertex = mul(_GlobalOriginMTX, float4(worldNormalVertex, 1)).xyz;
             i.worldPos = i.worldPos + mul(_GlobalOriginMTX, float4(0,0,0,1)).xyz;
         #endif

         #if _DEBUG_USE_TOPOLOGY
            i.worldPos = UNITY_SAMPLE_TEX2D_SAMPLER(_DebugWorldPos, _Diffuse, i.uv_Control0);
            worldNormalVertex = UNITY_SAMPLE_TEX2D_SAMPLER(_DebugWorldNormal, _Diffuse, i.uv_Control0);
         #endif

         #if _ALPHABELOWHEIGHT && !_TBDISABLEALPHAHOLES
            ClipWaterLevel(i.worldPos);
         #endif

         #if !_TBDISABLEALPHAHOLES && defined(_ALPHATEST_ON)
            // UNITY 2019.3 holes
            ClipHoles(i.uv_Control0);
         #endif


         float2 origUV = i.uv_Control0;

         #if _MICROMESH && _MESHUV2
         float2 controlUV = i.uv2_Diffuse;
         #else
         float2 controlUV = i.uv_Control0;
         #endif


         #if _MICROMESH
            controlUV = InverseLerp(_UVMeshRange.xy, _UVMeshRange.zw, controlUV);
         #endif

         half4 weights = half4(1,0,0,0);

         Config config = (Config)0;
         UNITY_INITIALIZE_OUTPUT(Config,config);
         config.uv = origUV;

         #if _SPLATFADE
         MSBRANCHOTHER(_SplatFade.y - camDist)
         #endif // _SPLATFADE
         {
            #if !_DISABLESPLATMAPS

               // Sample the splat data, from textures or vertices, and setup the config..
               #if _MICRODIGGERMESH
                  DiggerSetup(i, weights, origUV, config, i.worldPos);
               #elif _MICROVERTEXMESH
                  VertexSetup(i, weights, origUV, config, i.worldPos);
               #elif !_PROCEDURALTEXTURE || _PROCEDURALBLENDSPLATS
                  half4 w0 = 0; half4 w1 = 0; half4 w2 = 0; half4 w3 = 0; half4 w4 = 0; half4 w5 = 0; half4 w6 = 0; half4 w7 = 0;
                  SampleSplats(controlUV, w0, w1, w2, w3, w4, w5, w6, w7);
                  Setup(weights, origUV, config, w0, w1, w2, w3, w4, w5, w6, w7, i.worldPos);
               #endif

               #if _PROCEDURALTEXTURE
                  float3 up = float3(0,1,0);
                  float3 procNormal = worldNormalVertex;
                  float height = i.worldPos.y;
                  ProceduralSetup(i, i.worldPos, height, procNormal, up, weights, origUV, config, ddx(origUV), ddy(origUV), ddx(i.worldPos), ddy(i.worldPos));

                  #if _PLANETNORMAL2 || _PLANETNORMAL
                     config.uv = origUV;
                     float2 pnorm = GetPlanetTangentNormal(i, config, camDist, worldNormalVertex);
                     procNormal.xy = pnorm;
                     procNormal.z = sqrt(1 - procNormal.x * procNormal.x - procNormal.y * procNormal.y);
                     procNormal = WorldNormalVector(i, procNormal);
                     up = worldNormalVertex;
                     float3 center = mul(GetWorldToObjectMatrix(), float3(0,0,0));
                     height = distance(i.worldPos, center); 
                  #endif
               #endif
            #else // _DISABLESPLATMAPS
                Setup(weights, origUV, config, half4(1,0,0,0), 0, 0, 0, 0, 0, 0, 0, i.worldPos);
            #endif
         } // _SPLATFADE else case

         
         #if _TOONFLATTEXTURE
            float2 quv = floor(origUV * _ToonTerrainSize);
            float2 fuv = frac(origUV * _ToonTerrainSize);
            #if !_TOONFLATTEXTUREQUAD
               quv = Hash2D((fuv.x > fuv.y) ? quv : quv * 0.333);
            #endif
            float2 uvq = quv / _ToonTerrainSize;
            config.uv0.xy = uvq;
            config.uv1.xy = uvq;
            config.uv2.xy = uvq;
            config.uv3.xy = uvq;
         #endif
         
         #if (_TEXTURECLUSTER2 || _TEXTURECLUSTER3) && !_DISABLESPLATMAPS
            PrepClusters(origUV, config, i.worldPos, worldNormalVertex);
         #endif

         #if (_ALPHAHOLE || _ALPHAHOLETEXTURE) && !_DISABLESPLATMAPS && !_TBDISABLEALPHAHOLES
         ClipAlphaHole(config, weights);
         #endif


 
         MicroSplatLayer l = Sample(i, weights, config, camDist, worldNormalVertex);

         
         // HI, this is the section where we hack around various Unity and compiler bugs..

         // Unity has a compiler bug with surface shaders where in some situations it will strip/fuckup
         // i.worldPos or i.viewDir thinking your not using them when you are inside a function. I have
         // fought with this bug so many times it's crazy, reported it and provided repros, and nothing has
         // been done about it. So, make sure these are used, and look like they could have an effect on the final
         // output so the compiler doesn't fuck them up.
         
         // Oh, nice, and it turns out that doing this in the base map shader breaks GI, so only do it in the main
         // shader, which is where we're using i.viewDir for parallax. Fucking hell..

         // AND if triplanar is on, this needs to be run otherwise the UV scale is fucked. I feel like I'm just
         // pushing compiler errors around at this point.. And this breaks render baking, so not then either.
         //
         // And sometimes VD is INF or NAN, so we copy it (make sure the compiler knows we are using) and
         // test for a value, and if it's not 1 we make it 1, so it doesn't make albedo black.
         //
         // Jusus fucking christ already..
         #if (!_MICROSPLATBASEMAP || _TRIPLANAR) && !_RENDERBAKE
            float3 vd = i.viewDir;
            if (vd.x != 1)
               vd = 1;
            l.Albedo *= saturate(vd + i.worldPos + 9999);
         #endif

         // Further, on windows, sometimes the diffuse sampler gets stripped, so we have to do this crap.
         // We sample from the lowest mip, so it shouldn't cost much, but still, I hate this, wtf..
         l.Albedo *= saturate(UNITY_SAMPLE_TEX2DARRAY_LOD(_Diffuse, config.uv0, 11).r + 2);
         // same for the control sampler.
         l.Albedo *= saturate(MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(_Control0, _Control0, config.uv, 11).r + 2);

         #if _PROCEDURALTEXTURE
            ProceduralTextureDebugOutput(l, weights, config);
         #endif
         


         return l;

      }



   


                    //MS_BLENDABLE

                    






    
    MicroSplatLayer DoMicroSplat(inout SurfaceDescriptionInputs IN)
    {
       SurfaceDescription surface = (SurfaceDescription)0;
       Input i = DescToInput(IN);
       float3 worldNormalVertex = IN.WorldSpaceNormal;

        #if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL) && !_MICROMESH && !_MICROMESHTERRAIN && !_MICROPOLARISMESH && !_MICRODIGGERMESH && !_MICROVERTEXMESH
            float2 terrainNormalMapUV = (i.uv_Control0.xy + 0.5f) * _TerrainHeightmapRecipSize.xy;
            i.uv_Control0.xy *= _TerrainHeightmapRecipSize.zw;
            

            #if _TOONHARDEDGENORMAL
               terrainNormalMapUV = ToonEdgeUV(terrainNormalMapUV);
            #endif
            float3 geomNormal = normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, terrainNormalMapUV).xyz * 2 - 1);

            worldNormalVertex = mul((float3x3)GetObjectToWorldMatrix(), geomNormal);
            IN.WorldSpaceNormal = worldNormalVertex;
            float4 tangentWS = ConstructTerrainTangent(IN.WorldSpaceNormal, GetObjectToWorldMatrix()._13_23_33);
            IN.WorldSpaceTangent = tangentWS.xyz;
            i.TBN = BuildTangentToWorld(tangentWS, IN.WorldSpaceNormal.xyz);
            IN.WorldSpaceBiTangent = i.TBN[1].xyz;
        #elif _PERPIXNORMAL
            float2 perPixUV = i.uv_Control0;
            #if _TOONHARDEDGENORMAL
               perPixUV = ToonEdgeUV(perPixUV);
            #endif
            float3 geomNormal = (UnpackNormal(UNITY_SAMPLE_TEX2D_SAMPLER(_PerPixelNormal, _Diffuse, perPixUV))).xzy;
            worldNormalVertex = geomNormal;
        #endif    
        
         
         #if _SRPTERRAINBLEND
            SurfaceOutputCustom soc = (SurfaceOutputCustom)0;
            soc.input = i;
            float3 sh = 0;
            BlendWithTerrainSRP(soc, IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);

            MicroSplatLayer l = (MicroSplatLayer)0;
            l.Albedo = soc.Albedo;
            l.Normal = mul(float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal), soc.Normal);
            l.Emission = soc.Emission;
            l.Metallic = soc.Metallic;
            l.Smoothness = soc.Smoothness;
            #if _USESPECULARWORKFLOW
               l.Specular = soc.Specular;
            #endif
            l.Occlusion = soc.Occlusion;
            l.Alpha = soc.Alpha;

         #else
            MicroSplatLayer l = SurfImpl(i, worldNormalVertex);
         #endif


       // per pixel normal
        #if ((defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)) && !_MICROMESHTERRAIN && !_MICROMESH && !_MICROVERTEXMESH && !_MICRODIGGERMESH && !_MICROPOLARISMESH) || (_MICROMESHTERRAIN && _PERPIXNORMAL)
            float3 geomTangent = normalize(cross(geomNormal, float3(0, 0, 1)));
            float3 geomBitangent = normalize(cross(geomTangent, geomNormal));
            l.Normal = l.Normal.x * geomTangent + l.Normal.y * geomBitangent + l.Normal.z * geomNormal;
            l.Normal = l.Normal.xzy;
        #endif

        DoDebugOutput(l);


        return l;
    }



        

                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        MicroSplatLayer l = DoMicroSplat(IN);

                        SurfaceDescription surface = (SurfaceDescription)0;
                        surface.Albedo = l.Albedo;
                        surface.Normal = l.Normal;
                        surface.BentNormal = IN.TangentSpaceNormal;
                        surface.CoatMask = 0;
                        surface.Smoothness = l.Smoothness;
                        #if _USESPECULARWORKFLOW
                           surface.Specular = l.Specular;
                        #endif
                        surface.Metallic = l.Metallic;
                        surface.Occlusion = l.Occlusion;
                        surface.Emission = l.Emission;
                        surface.Alpha = l.Alpha;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    output.texCoord0 = input.texCoord0;
                    output.texCoord1 = input.texCoord1;
                    output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    //output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    // output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    output.WorldSpaceNormal =            normalize(input.tangentToWorld[2].xyz);
                    // output.ObjectSpaceNormal =           mul(output.WorldSpaceNormal, (float3x3) GetObjectToWorldMatrix());           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    // output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // specularOcclusion need to be init ahead of decal to quiet the compiler that modify the SurfaceData struct
                // however specularOcclusion can come from the graph, so need to be init here so it can be override.
                surfaceData.specularOcclusion = 1.0;
        
                // copy across graph values, if defined
                surfaceData.baseColor =                 surfaceDescription.Albedo;
                surfaceData.perceptualSmoothness =      surfaceDescription.Smoothness;
                surfaceData.ambientOcclusion =          surfaceDescription.Occlusion;
                // surfaceData.specularOcclusion =         surfaceDescription.SpecularOcclusion;
                surfaceData.metallic =                  surfaceDescription.Metallic;
                // surfaceData.subsurfaceMask =            surfaceDescription.SubsurfaceMask;
                // surfaceData.thickness =                 surfaceDescription.Thickness;
                // surfaceData.diffusionProfileHash =      asuint(surfaceDescription.DiffusionProfileHash);
                #if _USESPECULARWORKFLOW
                   surfaceData.specularColor =             surfaceDescription.Specular;
                #endif
                surfaceData.coatMask =                  surfaceDescription.CoatMask;
                // surfaceData.anisotropy =                surfaceDescription.Anisotropy;
                // surfaceData.iridescenceMask =           surfaceDescription.IridescenceMask;
                // surfaceData.iridescenceThickness =      surfaceDescription.IridescenceThickness;
        
        #ifdef _HAS_REFRACTION
                if (_EnableSSRefraction)
                {
                    // surfaceData.ior =                       surfaceDescription.RefractionIndex;
                    // surfaceData.transmittanceColor =        surfaceDescription.RefractionColor;
                    // surfaceData.atDistance =                surfaceDescription.RefractionDistance;
        
                    surfaceData.transmittanceMask = (1.0 - surfaceDescription.Alpha);
                    surfaceDescription.Alpha = 1.0;
                }
                else
                {
                    surfaceData.ior = 1.0;
                    surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                    surfaceData.atDistance = 1.0;
                    surfaceData.transmittanceMask = 0.0;
                    surfaceDescription.Alpha = 1.0;
                }
        #else
                surfaceData.ior = 1.0;
                surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                surfaceData.atDistance = 1.0;
                surfaceData.transmittanceMask = 0.0;
        #endif
                
                // These static material feature allow compile time optimization
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
                // surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
        
        #ifdef _MATERIAL_FEATURE_IRIDESCENCE
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
        #endif
        #ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
        #endif
        
        #if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
                // Require to have setup baseColor
                // Reproduce the energy conservation done in legacy Unity. Not ideal but better for compatibility and users can unchek it
                surfaceData.baseColor *= (1.0 - Max3(surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b));
        #endif
        
        #ifdef _DOUBLESIDED_ON
            float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
        #else
            float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        #endif
        
                // tangent-space normal
                float3 normalTS = float3(0.0f, 0.0f, 1.0f);
                normalTS = surfaceDescription.Normal;
        
                // compute world space normal
                GetNormalWS(fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants);
        
                surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];
        
                surfaceData.tangentWS = normalize(fragInputs.tangentToWorld[0].xyz);    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
                // surfaceData.tangentWS = TransformTangentToWorld(surfaceDescription.Tangent, fragInputs.tangentToWorld);
        
        #if HAVE_DECALS
                if (_EnableDecals)
                {
                    // Both uses and modifies 'surfaceData.normalWS'.
                    DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
                    ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
                }
        #endif
        
                bentNormalWS = surfaceData.normalWS;
                // GetNormalWS(fragInputs, surfaceDescription.BentNormal, bentNormalWS, doubleSidedConstants);
        
                surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);
        
        
                // By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion.
                // If user provide bent normal then we process a better term
        #if defined(_SPECULAR_OCCLUSION_CUSTOM)
                // Just use the value passed through via the slot (not active otherwise)
        #elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
                // If we have bent normal and ambient occlusion, process a specular occlusion
                surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO(V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness(surfaceData.perceptualSmoothness));
        #elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
                surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
        #endif
        
        #ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
                surfaceData.perceptualSmoothness = GeometricNormalFiltering(surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[2], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold);
        #endif
        
        #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO: need to update mip info
                    surfaceData.metallic = 0;
                }
        
                // We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
                // as it can modify attribute use for static lighting
                ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
        #ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
                uint3 fadeMaskSeed = asuint((int3)(V * _ScreenSize.xyx)); // Quantize V to _ScreenSize values
                LODDitheringTransition(fadeMaskSeed, unity_LODFade.x);
        #endif
        
        #ifdef _DOUBLESIDED_ON
            float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
        #else
            float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        #endif
        
                ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdDepthPrepass);
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdDepthPostpass);
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdShadow);
                
                // ApplyDepthOffsetPositionInput(V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput);
        
                float3 bentNormalWS;
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS);
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal 
                InitBuiltinData(posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[2], fragInputs.texCoord1, fragInputs.texCoord2, builtinData);
        
                // override sampleBakedGI:
                // builtinData.bakeDiffuseLighting = surfaceDescription.BakedGI;
                // builtinData.backBakeDiffuseLighting = surfaceDescription.BakedBackGI;
        
                builtinData.emissiveColor = surfaceDescription.Emission;
        
                // builtinData.depthOffset = surfaceDescription.DepthOffset;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #else
                builtinData.distortion = float2(0.0, 0.0);
                builtinData.distortionBlur = 0.0;
        #endif
        
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassGBuffer.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        
        
        Pass
        {
            // based on HDLitPass.template
            Name "Forward"
            Tags { "LightMode" = "Forward" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            Blend [_SrcBlend] [_DstBlend], [_AlphaSrcBlend] [_AlphaDstBlend]
        
            Cull [_CullModeForward]
        
            ZTest [_ZTestDepthEqualForOpaque]
        
            ZWrite [_ZWrite]
        
            
            // Stencil setup
        Stencil
        {
           WriteMask [_StencilWriteMask]
           Ref [_StencilRef]
           Comp Always
           Pass Replace
        }
        
            ColorMask [_ColorMaskTransparentVel] 1
        
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            #pragma shader_feature_local _TERRAIN_INSTANCED_PERPIXEL_NORMAL
            #pragma multi_compile_instancing
            #pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap renderinglayer
        
        #pragma multi_compile_local _ _ALPHATEST_ON

            // #pragma multi_compile _ LOD_FADE_CROSSFADE
        
            #pragma shader_feature _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _DOUBLESIDED_ON
            #pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
            // #define _MATERIAL_FEATURE_SUBSURFACE_SCATTERING 1
            // #define _MATERIAL_FEATURE_TRANSMISSION 1
            // #define _MATERIAL_FEATURE_ANISOTROPY 1
            // #define _MATERIAL_FEATURE_IRIDESCENCE 1
            // #define _MATERIAL_FEATURE_SPECULAR_COLOR 1
            // #define _ENABLE_FOG_ON_TRANSPARENT 1
            #define _AMBIENT_OCCLUSION 1
            #define _SPECULAR_OCCLUSION_FROM_AO 1
            // #define _SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL 1
            // #define _SPECULAR_OCCLUSION_CUSTOM 1
            #define _ENERGY_CONSERVING_SPECULAR 1
            // #define _ENABLE_GEOMETRIC_SPECULAR_AA 1
            // #define _HAS_REFRACTION 1
            // #define _REFRACTION_PLANE 1
            // #define _REFRACTION_SPHERE 1
            // #define _DISABLE_DECALS 1
            // #define _DISABLE_SSR 1
            // #define _ADD_PRECOMPUTED_VELOCITY
            // #define _WRITE_TRANSPARENT_MOTION_VECTOR 1
            // #define _DEPTHOFFSET_ON 1
            // #define _BLENDMODE_PRESERVE_SPECULAR_LIGHTING 1

            
      #define _MICROSPLAT 1
      #define _ALPHABELOWHEIGHT 1
      #define _MSRENDERLOOP_UNITYHD 1


        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            // If we use subsurface scattering, enable output split lighting (for forward pass)
            #if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
            #define OUTPUT_SPLIT_LIGHTING
            #endif
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Defines
            //-------------------------------------------------------------------------------------
                    #define SHADERPASS SHADERPASS_FORWARD
                #pragma multi_compile _ DEBUG_DISPLAY
                #pragma multi_compile _ LIGHTMAP_ON
                #pragma multi_compile _ DIRLIGHTMAP_COMBINED
                #pragma multi_compile _ DYNAMICLIGHTMAP_ON
                #pragma multi_compile _ SHADOWS_SHADOWMASK
                #pragma multi_compile DECALS_OFF DECALS_3RT DECALS_4RT
                #pragma multi_compile USE_FPTL_LIGHTLIST USE_CLUSTERED_LIGHTLIST
                #pragma multi_compile SHADOW_LOW SHADOW_MEDIUM SHADOW_HIGH
                #define REQUIRE_DEPTH_TEXTURE
                // ACTIVE FIELDS:
                //   Material.Standard
                //   Specular.EnergyConserving
                //   SpecularOcclusionFromAO
                //   AmbientOcclusion
                //   SurfaceDescriptionInputs.ScreenPosition
                //   SurfaceDescriptionInputs.VertexColor
                //   SurfaceDescriptionInputs.WorldSpaceNormal
                //   SurfaceDescriptionInputs.TangentSpaceNormal
                //   SurfaceDescriptionInputs.WorldSpaceTangent
                //   SurfaceDescriptionInputs.WorldSpaceBiTangent
                //   SurfaceDescriptionInputs.WorldSpaceViewDirection
                //   SurfaceDescriptionInputs.TangentSpaceViewDirection
                //   SurfaceDescriptionInputs.ObjectSpacePosition
                //   SurfaceDescriptionInputs.AbsoluteWorldSpacePosition
                //   SurfaceDescriptionInputs.uv0
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.ObjectSpacePosition
                //   SurfaceDescription.Albedo
                //   SurfaceDescription.Normal
                //   SurfaceDescription.BentNormal
                //   SurfaceDescription.CoatMask
                //   SurfaceDescription.Metallic
                //   SurfaceDescription.Emission
                //   SurfaceDescription.Smoothness
                //   SurfaceDescription.Occlusion
                //   SurfaceDescription.Alpha
                //   features.modifyMesh
                //   VertexDescription.VertexPosition
                //   VertexDescription.VertexNormal
                //   VertexDescription.VertexTangent
                //   FragInputs.tangentToWorld
                //   FragInputs.positionRWS
                //   FragInputs.texCoord1
                //   FragInputs.texCoord2
                //   SurfaceDescriptionInputs.WorldSpacePosition
                //   FragInputs.color
                //   FragInputs.texCoord0
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.positionOS
                //   VaryingsMeshToPS.tangentWS
                //   VaryingsMeshToPS.normalWS
                //   VaryingsMeshToPS.positionRWS
                //   VaryingsMeshToPS.texCoord1
                //   VaryingsMeshToPS.texCoord2
                //   VaryingsMeshToPS.color
                //   VaryingsMeshToPS.texCoord0
                //   AttributesMesh.uv1
                //   AttributesMesh.uv2
                //   AttributesMesh.color
                //   AttributesMesh.uv0
                // Shared Graph Keywords
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
           //#define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD1
            #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
           // #define VARYINGS_NEED_COLOR
            // #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
        // We need isFontFace when using double sided
        #if defined(_DOUBLESIDED_ON) && !defined(VARYINGS_NEED_CULLFACE)
            #define VARYINGS_NEED_CULLFACE
        #endif
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
            
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
        #ifdef DEBUG_DISPLAY
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
        #if (SHADERPASS == SHADERPASS_FORWARD)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
        
            #define HAS_LIGHTLOOP
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL; // optional
                float4 tangentOS : TANGENT; // optional
                float4 uv0 : TEXCOORD0; // optional
                float4 uv1 : TEXCOORD1; // optional
                float4 uv2 : TEXCOORD2; // optional
                //float4 color : COLOR; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_Position;
                float3 positionRWS; // optional
                float3 normalWS; // optional
                float4 tangentWS; // optional
                float4 texCoord0; // optional
                float4 texCoord1; // optional
                float4 texCoord2; // optional
                //float4 color; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_Position; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
                float4 interp02 : TEXCOORD2; // auto-packed
                float4 interp03 : TEXCOORD3; // auto-packed
                float4 interp04 : TEXCOORD4; // auto-packed
                float4 interp05 : TEXCOORD5; // auto-packed
                //float4 interp06 : TEXCOORD6; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                output.interp03.xyzw = input.texCoord0;
                output.interp04.xyzw = input.texCoord1;
                output.interp05.xyzw = input.texCoord2;
                //output.interp06.xyzw = input.color;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                output.texCoord0 = input.interp03.xyzw;
                output.texCoord1 = input.interp04.xyzw;
                output.texCoord2 = input.interp05.xyzw;
                //output.color = input.interp06.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
      
      #define UNITY_DECLARE_TEX2D(name) TEXTURE2D(name); SAMPLER(sampler_##name);
      #define UNITY_DECLARE_TEX2D_NOSAMPLER(name) TEXTURE2D(name);
      #define UNITY_DECLARE_TEX2DARRAY(name) TEXTURE2D_ARRAY(name); SAMPLER(sampler_##name);
     
      #define UNITY_SAMPLE_TEX2DARRAY(tex,coord)            SAMPLE_TEXTURE2D_ARRAY(tex, sampler_##tex, coord.xy, coord.z)
      #define UNITY_SAMPLE_TEX2DARRAY_LOD(tex,coord,lod)    SAMPLE_TEXTURE2D_ARRAY_LOD(tex, sampler_##tex, coord.xy, coord.z, lod)
      #define UNITY_SAMPLE_TEX2D(tex, coord)                SAMPLE_TEXTURE2D(tex, sampler_##tex, coord)
      #define UNITY_SAMPLE_TEX2D_SAMPLER(tex, samp, coord)  SAMPLE_TEXTURE2D(tex, sampler_##samp, coord)

     
      #if defined(UNITY_COMPILER_HLSL)
         #define UNITY_INITIALIZE_OUTPUT(type,name) name = (type)0;
      #else
         #define UNITY_INITIALIZE_OUTPUT(type,name)
      #endif

      #define sampler2D_float sampler2D
      #define sampler2D_half sampler2D

      


   
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 _EmissionColor;
                    float _RenderQueueType;
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
                    float _UseShadowThreshold;
                    float _DoubleSidedEnable;
                    float _DoubleSidedNormalMode;
                    float4 _DoubleSidedConstants;
                    

      #if _MESHSUBARRAY
         half4 _MeshSubArrayIndexes;
      #endif


      #if _USEEMISSIVEMETAL
         half _EmissiveMult;
      #endif

      float4 _UVScale; // scale and offset

      float2 _ToonTerrainSize;

      half _Contrast;
      
      float3 _gGlitterLightDir;
      float3 _gGlitterLightWorldPos;
      half3 _gGlitterLightColor;

       #if _VSSHADOWMAP
         float4 gVSSunDirection;
      #endif

      #if _FORCELOCALSPACE && _PLANETVECTORS
         float4x4 _PQSToLocal;
      #endif

      #if _ORIGINSHIFT
         float4x4 _GlobalOriginMTX;
      #endif

      float4 _Control0_TexelSize;
      float4 _CustomControl0_TexelSize;
      float4 _PerPixelNormal_TexelSize;

      #if _CONTROLNOISEUV || _GLOBALNOISEUV
         float2 _NoiseUVParams;
      #endif





      float2 _AlphaData;
      


                    CBUFFER_END
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpaceNormal; // optional
                        float3 TangentSpaceNormal; // optional
                        float3 WorldSpaceTangent; // optional
                        float3 WorldSpaceBiTangent; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 TangentSpaceViewDirection; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float3 AbsoluteWorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                        float4 uv0; // optional
                        float4 VertexColor; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Albedo;
                        float3 Normal;
                        float3 BentNormal;
                        float CoatMask;
                        float Metallic;
                        float3 Emission;
                        float Smoothness;
                        float3 Specular;
                        float Occlusion;
                        float Alpha;
                    };
                    
                    
#if defined(UNITY_INSTANCING_ENABLED) 
    #define ENABLE_TERRAIN_PERPIXEL_NORMAL
#endif 
 
#ifndef UNITY_TERRAIN_CB_VARS
    #define UNITY_TERRAIN_CB_VARS
#endif

#ifndef UNITY_TERRAIN_CB_DEBUG_VARS
    #define UNITY_TERRAIN_CB_DEBUG_VARS
#endif

CBUFFER_START(UnityTerrain)
    UNITY_TERRAIN_CB_VARS
#ifdef UNITY_INSTANCING_ENABLED 
    float4 _TerrainHeightmapRecipSize;  // float4(1.0f/width, 1.0f/height, 1.0f/(width-1), 1.0f/(height-1))
    float4 _TerrainHeightmapScale;      // float4(hmScale.x, hmScale.y / (float)(kMaxHeight), hmScale.z, 0.0f)
#endif
#ifdef DEBUG_DISPLAY
    UNITY_TERRAIN_CB_DEBUG_VARS
#endif
CBUFFER_END

#ifdef UNITY_INSTANCING_ENABLED
    TEXTURE2D(_TerrainHeightmapTexture);
    TEXTURE2D(_TerrainNormalmapTexture);
    #ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
        SAMPLER(sampler_TerrainNormalmapTexture);
    #endif
#endif

UNITY_INSTANCING_BUFFER_START(Terrain)
   UNITY_DEFINE_INSTANCED_PROP(float4, _TerrainPatchInstanceData)  // float4(xBase, yBase, skipScale, ~)
UNITY_INSTANCING_BUFFER_END(Terrain)

float4 ConstructTerrainTangent(float3 normal, float3 positiveZ)
{
    // Consider a flat terrain. It should have tangent be (1, 0, 0) and bitangent be (0, 0, 1) as the UV of the terrain grid mesh is a scale of the world XZ position.
    // In CreateTangentToWorld function (in SpaceTransform.hlsl), it is cross(normal, tangent) * sgn for the bitangent vector.
    // It is not true in a left-handed coordinate system for the terrain bitangent, if we provide 1 as the tangent.w. It would produce (0, 0, -1) instead of (0, 0, 1).
    // Also terrain's tangent calculation was wrong in a left handed system because cross((0,0,1), terrainNormalOS) points to the wrong direction as negative X.
    // Therefore all the 4 xyzw components of the tangent needs to be flipped to correct the tangent frame.
    // (See TerrainLitData.hlsl - GetSurfaceAndBuiltinData)
    float3 tangent = cross(normal, positiveZ);
    return float4(tangent, -1);
}


AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
{
#if defined(UNITY_INSTANCING_ENABLED) && !_MICROMESH && !_MICROMESHTERRAIN && !_MICROPOLARISMESH && !_MICRODIGGERMESH && !_MICROVERTEXMESH
    float2 patchVertex = input.positionOS.xy;
    float4 instanceData = UNITY_ACCESS_INSTANCED_PROP(Terrain, _TerrainPatchInstanceData);

    float2 sampleCoords = (patchVertex.xy + instanceData.xy) * instanceData.z; // (xy + float2(xBase,yBase)) * skipScale
    float height = UnpackHeightmap(_TerrainHeightmapTexture.Load(int3(sampleCoords, 0)));

    input.positionOS.xz = sampleCoords * _TerrainHeightmapScale.xz;
    input.positionOS.y = height * _TerrainHeightmapScale.y;
    
    #ifdef ATTRIBUTES_NEED_NORMAL
       input.normalOS = float3(0,1,0);
    #endif

    #if defined(VARYINGS_NEED_TEXCOORD0) || defined(VARYINGS_DS_NEED_TEXCOORD0)
       #ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
          input.uv0.xy = sampleCoords;
       #else
          input.uv0.xy = sampleCoords * _TerrainHeightmapRecipSize.zw;
       #endif
    #endif
#endif


    #ifdef ATTRIBUTES_NEED_TANGENT
       #if !_MICROMESH && !_MICROMESHTERRAIN && !_MICROVERTEXMESH && !_MICROPOLARISMESH
           input.tangentOS = ConstructTerrainTangent(input.normalOS, float3(0, 0, 1));
       #endif
    #endif

    return input;
}

        
                    

                    

      // dynamic branching helpers, for regular and aggressive branching
      // debug mode shows how many samples using branching will save us. 
      //
      // These macros are always used instead of the UNITY_BRANCH macro
      // to maintain debug displays and allow branching to be disabled
      // on as granular level as we want. 
      
      #if _BRANCHSAMPLES
         #if _DEBUG_BRANCHCOUNT_WEIGHT || _DEBUG_BRANCHCOUNT_TOTAL
            float _branchWeightCount;
            #define MSBRANCH(w) if (w > 0) _branchWeightCount++; if (w > 0)
         #else
            #define MSBRANCH(w) UNITY_BRANCH if (w > 0)
         #endif
      #else
         #if _DEBUG_BRANCHCOUNT_WEIGHT || _DEBUG_BRANCHCOUNT_TOTAL
            float _branchWeightCount;
            #define MSBRANCH(w) if (w > 0) _branchWeightCount++;
         #else
            #define MSBRANCH(w) 
         #endif
      #endif
      
      #if _BRANCHSAMPLESAGR
         #if _DEBUG_BRANCHCOUNT_TRIPLANAR || _DEBUG_BRANCHCOUNT_CLUSTER || _DEBUG_BRANCHCOUNT_OTHER ||_DEBUG_BRANCHCOUNT_TOTAL
            float _branchTriplanarCount;
            float _branchClusterCount;
            float _branchOtherCount;
            #define MSBRANCHTRIPLANAR(w) if (w > 0.001) _branchTriplanarCount++; if (w > 0.001)
            #define MSBRANCHCLUSTER(w) if (w > 0.001) _branchClusterCount++; if (w > 0.001)
            #define MSBRANCHOTHER(w) if (w > 0.001) _branchOtherCount++; if (w > 0.001)
         #else
            #define MSBRANCHTRIPLANAR(w) UNITY_BRANCH if (w > 0.001)
            #define MSBRANCHCLUSTER(w) UNITY_BRANCH if (w > 0.001)
            #define MSBRANCHOTHER(w) UNITY_BRANCH if (w > 0.001)
         #endif
      #else
         #if _DEBUG_BRANCHCOUNT_TRIPLANAR || _DEBUG_BRANCHCOUNT_CLUSTER || _DEBUG_BRANCHCOUNT_OTHER || _DEBUG_BRANCHCOUNT_TOTAL
            float _branchTriplanarCount;
            float _branchClusterCount;
            float _branchOtherCount;
            #define MSBRANCHTRIPLANAR(w) if (w > 0.001) _branchTriplanarCount++;
            #define MSBRANCHCLUSTER(w) if (w > 0.001) _branchClusterCount++;
            #define MSBRANCHOTHER(w) if (w > 0.001) _branchOtherCount++;
         #else
            #define MSBRANCHTRIPLANAR(w)
            #define MSBRANCHCLUSTER(w)
            #define MSBRANCHOTHER(w)
         #endif
      #endif

      #if _DEBUG_SAMPLECOUNT
         int _sampleCount;
         #define COUNTSAMPLE { _sampleCount++; }
      #else
         #define COUNTSAMPLE
      #endif

      #if _DEBUG_PROCLAYERS
         int _procLayerCount;
         #define COUNTPROCLAYER { _procLayerCount++; }
      #else
         #define COUNTPROCLAYER
      #endif


      #if _DEBUG_USE_TOPOLOGY
         UNITY_DECLARE_TEX2D_NOSAMPLER(_DebugWorldPos);
         UNITY_DECLARE_TEX2D_NOSAMPLER(_DebugWorldNormal);
      #endif
      

      // splat
      UNITY_DECLARE_TEX2DARRAY(_Diffuse);
      float4 _Diffuse_TexelSize;
      UNITY_DECLARE_TEX2DARRAY(_NormalSAO);
      float4 _NormalSAO_TexelSize;

      #if _CONTROLNOISEUV || _GLOBALNOISEUV
         UNITY_DECLARE_TEX2D_NOSAMPLER(_NoiseUV);
      #endif

      #if _PACKINGHQ
         UNITY_DECLARE_TEX2DARRAY(_SmoothAO);
         float4 _SmoothAO_TexelSize;
      #endif

      #if _USESPECULARWORKFLOW
         UNITY_DECLARE_TEX2DARRAY(_Specular);
         float4 _Specular_TexelSize;
      #endif

      #if _USEEMISSIVEMETAL
         UNITY_DECLARE_TEX2DARRAY(_EmissiveMetal);
         float4 _EmissiveMetal_TexelSize;
      #endif

      
      UNITY_DECLARE_TEX2D_NOSAMPLER(_PerPixelNormal);
      
      UNITY_DECLARE_TEX2D(_Control0);
      #if _CUSTOMSPLATTEXTURES
         UNITY_DECLARE_TEX2D(_CustomControl0);
         #if !_MAX4TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl1);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl2);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl3);
         #endif
         #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl4);
         #endif
         #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl5);
         #endif
         #if _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl6);
         #endif
         #if _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_CustomControl7);
         #endif
      #else
         #if !_MAX4TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control1);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control2);
         #endif
         #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control3);
         #endif
         #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control4);
         #endif
         #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control5);
         #endif
         #if _MAX28TEXTURES || _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control6);
         #endif
         #if _MAX32TEXTURES
         UNITY_DECLARE_TEX2D_NOSAMPLER(_Control7);
         #endif
      #endif

      sampler2D_float _PerTexProps;
   



      struct TriGradMipFormat
      {
         float4 d0;
         float4 d1;
         float4 d2;
      };

      half InverseLerp(half x, half y, half v) { return (v-x)/max(y-x, 0.001); }
      half2 InverseLerp(half2 x, half2 y, half2 v) { return (v-x)/max(y-x, half2(0.001, 0.001)); }
      half3 InverseLerp(half3 x, half3 y, half3 v) { return (v-x)/max(y-x, half3(0.001, 0.001, 0.001)); }
      half4 InverseLerp(half4 x, half4 y, half4 v) { return (v-x)/max(y-x, half4(0.001, 0.001, 0.001, 0.001)); }
      

      // 2019.3 holes
      #ifdef _ALPHATEST_ON
          UNITY_DECLARE_TEX2D(_TerrainHolesTexture);

          void ClipHoles(float2 uv)
          {
              float hole = UNITY_SAMPLE_TEX2D(_TerrainHolesTexture, uv).r;
              COUNTSAMPLE
              clip(hole < 0.5f ? -1 : 1);
          }
      #endif

      
      #if _TRIPLANAR
         #if _USEGRADMIP
            #define MIPFORMAT TriGradMipFormat
            #define INITMIPFORMAT (TriGradMipFormat)0;
            #define MIPFROMATRAW float4
         #else
            #define MIPFORMAT float3
            #define INITMIPFORMAT 0;
            #define MIPFROMATRAW float3
         #endif
      #else
         #if _USEGRADMIP
            #define MIPFORMAT float4
            #define INITMIPFORMAT 0;
            #define MIPFROMATRAW float4
         #else
            #define MIPFORMAT float
            #define INITMIPFORMAT 0;
            #define MIPFROMATRAW float
         #endif
      #endif

      float2 RotateUV(float2 uv, float amt)
      {
         uv -=0.5;
         float s = sin ( amt);
         float c = cos ( amt );
         float2x2 mtx = float2x2( c, -s, s, c);
         mtx *= 0.5;
         mtx += 0.5;
         mtx = mtx * 2-1;
         uv = mul ( uv, mtx );
         uv += 0.5;
         return uv;
      }

      float4 DecodeToFloat4(float v)
      {
         uint vi = (uint)(v * (256.0f * 256.0f * 256.0f * 256.0f));
         int ex = (int)(vi / (256 * 256 * 256) % 256);
         int ey = (int)((vi / (256 * 256)) % 256);
         int ez = (int)((vi / (256)) % 256);
         int ew = (int)(vi % 256);
         float4 e = float4(ex / 255.0, ey / 255.0, ez / 255.0, ew / 255.0);
         return e;
      }

      struct Input 
      {
         float2 uv_Control0;
         #if (_MICROMESH && _MESHUV2)
         float2 uv2_Diffuse;
         #endif

         float3 viewDir;
         float3 worldPos;
         float3 worldNormal;
         #if _TERRAINBLENDING
         float4 color : COLOR;
         #endif
         #if _MSRENDERLOOP_SURFACESHADER
         INTERNAL_DATA
         #else
         float3x3 TBN;
         #endif

         #if _MICRODIGGERMESH || _MICROVERTEXMESH
            half4 w0;
            #if !_MAX4TEXTURES
               half4 w1;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES
               half4 w2;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
               half4 w3;
            #endif
            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               half4 w4;
            #endif
            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               half4 w5;
            #endif
            #if (_MAX28TEXTURES || _MAX32TEXTURES) && !_STREAMS && !_LAVA && !_WETNESS && !_PUDDLES
               half4 w6;
            #endif

            #if _STEAMS || _WETNESS || _LAVA || _PUDDLES
               half4 s0;
            #endif

         #endif
      };
      
      struct TriplanarConfig
      {
         float3x3 uv0;
         float3x3 uv1;
         float3x3 uv2;
         float3x3 uv3;
         half3 pN;
         half3 pN0;
         half3 pN1;
         half3 pN2;
         half3 pN3;
         half3 axisSign;
         Input IN;
      };


      struct Config
      {
         float2 uv;
         float3 uv0;
         float3 uv1;
         float3 uv2;
         float3 uv3;

         half4 cluster0;
         half4 cluster1;
         half4 cluster2;
         half4 cluster3;

      };


      struct MicroSplatLayer
      {
         half3 Albedo;
         half3 Normal;
         half Smoothness;
         half Occlusion;
         half Metallic;
         half Height;
         half3 Emission;
         #if _USESPECULARWORKFLOW
         half3 Specular;
         #endif
         half Alpha;
         
      };


      struct appdata 
      {
         float4 vertex : POSITION;
         float4 tangent : TANGENT;
         float3 normal : NORMAL;
         float2 texcoord : TEXCOORD0;
         float4 texcoord1 : TEXCOORD1;
         float4 texcoord2 : TEXCOORD2;
         #if _TERRAINBLENDING || _MICRODIGGERMESH || _MICROVERTEXMESH
         half4 color : COLOR;
         #endif
         UNITY_VERTEX_INPUT_INSTANCE_ID
         UNITY_VERTEX_OUTPUT_STEREO
      };


      // raw, unblended samples from arrays
      struct RawSamples
      {
         half4 albedo0;
         half4 albedo1;
         half4 albedo2;
         half4 albedo3;
         half4 normSAO0;
         half4 normSAO1;
         half4 normSAO2;
         half4 normSAO3;
         #if _USEEMISSIVEMETAL || _GLOBALEMIS || _GLOBALSMOOTHAOMETAL || _PERTEXSSS
            half4 emisMetal0;
            half4 emisMetal1;
            half4 emisMetal2;
            half4 emisMetal3;
         #endif
         #if _USESPECULARWORKFLOW
            half3 specular0;
            half3 specular1;
            half3 specular2;
            half3 specular3;
         #endif
      };

      void InitRawSamples(inout RawSamples s)
      {
         s.normSAO0 = half4(0,0,0,1);
         s.normSAO1 = half4(0,0,0,1);
         s.normSAO2 = half4(0,0,0,1);
         s.normSAO3 = half4(0,0,0,1);
      }

       float3 GetGlobalLightDir(Input i)
      {
         float3 lightDir = float3(1,0,0);

         #if _MSRENDERLOOP_UNITYHD || PASS_DEFERRED
            lightDir = normalize(_gGlitterLightDir.xyz);
         #elif _MSRENDERLOOP_UNITYLD
            lightDir = GetMainLight().direction;
         #else
            #ifndef USING_DIRECTIONAL_LIGHT
               lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
            #else
               lightDir = normalize(_WorldSpaceLightPos0.xyz);
            #endif
         #endif
         return lightDir;
      }

      float3 GetGlobalLightDirTS(Input i)
      {
         float3 lightDirWS = GetGlobalLightDir(i);
        
         #if _MSRENDERLOOP_UNITYHD || _MSRENDERLOOP_UNITYLD
            return mul( i.TBN, lightDirWS).xyz;
         #else
            float3 t2w0 = WorldNormalVector(i, float3(1,0,0));
            float3 t2w1 = WorldNormalVector(i, float3(0,1,0));
            float3 t2w2 = WorldNormalVector(i, float3(0,0,1));
            float3x3 t2w = float3x3(t2w0, t2w1, t2w2);
            return mul( t2w, lightDirWS).xyz;
         #endif
      }
      
      half3 GetGlobalLightColor()
      {
         #if _MSRENDERLOOP_UNITYHD || PASS_DEFERRED
            return _gGlitterLightColor;
         #elif _MSRENDERLOOP_UNITYLD
            return normalize(GetMainLight().color);
         #else
            return _LightColor0.rgb;
         #endif
      }



      half3 FuzzyShade(half3 color, half3 normal, half coreMult, half edgeMult, half power, float3 viewDir)
      {
         half dt = saturate(dot(viewDir, normal));
         half dark = 1.0 - (coreMult * dt);
         half edge = pow(1-dt, power) * edgeMult;
         return color * (dark + edge);
      }

      half3 ComputeSSS(Input i, float3 V, float3 N, half3 tint, half thickness, half distortion, half scale, half power)
      {
         float3 L = GetGlobalLightDir(i);
         half3 lightColor = GetGlobalLightColor();
         float3 H = normalize(L + N * distortion);
         float VdotH = pow(saturate(dot(V, -H)), power) * scale;
         float3 I =  (VdotH) * thickness;
         return lightColor * I * tint;
      }


      #if _MAX2LAYER
         inline half BlendWeights(half s1, half s2, half s3, half s4, half4 w)      { return s1 * w.x + s2 * w.y; }
         inline half2 BlendWeights(half2 s1, half2 s2, half2 s3, half2 s4, half4 w) { return s1 * w.x + s2 * w.y; }
         inline half3 BlendWeights(half3 s1, half3 s2, half3 s3, half3 s4, half4 w) { return s1 * w.x + s2 * w.y; }
         inline half4 BlendWeights(half4 s1, half4 s2, half4 s3, half4 s4, half4 w) { return s1 * w.x + s2 * w.y; }
      #elif _MAX3LAYER
         inline half BlendWeights(half s1, half s2, half s3, half s4, half4 w)      { return s1 * w.x + s2 * w.y + s3 * w.z; }
         inline half2 BlendWeights(half2 s1, half2 s2, half2 s3, half2 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z; }
         inline half3 BlendWeights(half3 s1, half3 s2, half3 s3, half3 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z; }
         inline half4 BlendWeights(half4 s1, half4 s2, half4 s3, half4 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z; }
      #else
         inline half BlendWeights(half s1, half s2, half s3, half s4, half4 w)      { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
         inline half2 BlendWeights(half2 s1, half2 s2, half2 s3, half2 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
         inline half3 BlendWeights(half3 s1, half3 s2, half3 s3, half3 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
         inline half4 BlendWeights(half4 s1, half4 s2, half4 s3, half4 s4, half4 w) { return s1 * w.x + s2 * w.y + s3 * w.z + s4 * w.w; }
      #endif

      #if _MAX3LAYER
         #define SAMPLE_PER_TEX(varName, pixel, config, defVal) \
            half4 varName##0 = defVal; \
            half4 varName##1 = defVal; \
            half4 varName##2 = defVal; \
            half4 varName##3 = defVal; \
            varName##0 = tex2Dlod(_PerTexProps, float4(config.uv0.z/32, pixel/32, 0, 0)); \
            varName##1 = tex2Dlod(_PerTexProps, float4(config.uv1.z/32, pixel/32, 0, 0)); \
            varName##2 = tex2Dlod(_PerTexProps, float4(config.uv2.z/32, pixel/32, 0, 0)); \

      #elif _MAX2LAYER
         #define SAMPLE_PER_TEX(varName, pixel, config, defVal) \
            half4 varName##0 = defVal; \
            half4 varName##1 = defVal; \
            half4 varName##2 = defVal; \
            half4 varName##3 = defVal; \
            varName##0 = tex2Dlod(_PerTexProps, float4(config.uv0.z/32, pixel/32, 0, 0)); \
            varName##1 = tex2Dlod(_PerTexProps, float4(config.uv1.z/32, pixel/32, 0, 0)); \

      #else
         #define SAMPLE_PER_TEX(varName, pixel, config, defVal) \
            half4 varName##0 = tex2Dlod(_PerTexProps, float4(config.uv0.z/32, pixel/32, 0, 0)); \
            half4 varName##1 = tex2Dlod(_PerTexProps, float4(config.uv1.z/32, pixel/32, 0, 0)); \
            half4 varName##2 = tex2Dlod(_PerTexProps, float4(config.uv2.z/32, pixel/32, 0, 0)); \
            half4 varName##3 = tex2Dlod(_PerTexProps, float4(config.uv3.z/32, pixel/32, 0, 0)); \

      #endif
      
      half3 BlendNormal3(half3 n1, half3 n2)
      {
         n1.z += 1;
         n2.xy = -n2.xy;

         return n1 * dot(n1, n2) / n1.z - n2;
      }
      
      half2 TransformTriplanarNormal(Input IN, float3x3 t2w, half3 axisSign, half3 absVertNormal,
               half3 pN, half2 a0, half2 a1, half2 a2)
      {
         a0 = a0 * 2 - 1;
         a1 = a1 * 2 - 1;
         a2 = a2 * 2 - 1;
         
         a0.x *= axisSign.x;
         a1.x *= axisSign.y;
         a2.x *= axisSign.z;
         
         half3 n0 = half3(a0.xy, 1);
         half3 n1 = half3(a1.xy, 1);
         half3 n2 = half3(a2.xy, 1);
         
         n0 = BlendNormal3(half3(IN.worldNormal.zy, absVertNormal.x), n0);
         n1 = BlendNormal3(half3(IN.worldNormal.xz, absVertNormal.y), n1);
         n2 = BlendNormal3(half3(IN.worldNormal.xy, absVertNormal.z), n2);
  
         n0.z *= axisSign.x;
         n1.z *= axisSign.y;
         n2.z *= -axisSign.z;
  
         half3 worldNormal = (n0.zyx * pN.x + n1.xzy * pN.y + n2.xyz * pN.z );
         return mul(t2w, worldNormal).xy;
      }
      
      // funcs
      
      inline half MSLuminance(half3 rgb)
      {
         #ifdef UNITY_COLORSPACE_GAMMA
            return dot(rgb, half3(0.22, 0.707, 0.071));
         #else
            return dot(rgb, half3(0.0396819152, 0.458021790, 0.00609653955));
         #endif
      }
      
      
      float2 Hash2D( float2 x )
      {
          float2 k = float2( 0.3183099, 0.3678794 );
          x = x*k + k.yx;
          return -1.0 + 2.0*frac( 16.0 * k*frac( x.x*x.y*(x.x+x.y)) );
      }

      float Noise2D(float2 p )
      {
         float2 i = floor( p );
         float2 f = frac( p );
         
         float2 u = f*f*(3.0-2.0*f);

         return lerp( lerp( dot( Hash2D( i + float2(0.0,0.0) ), f - float2(0.0,0.0) ), 
                           dot( Hash2D( i + float2(1.0,0.0) ), f - float2(1.0,0.0) ), u.x),
                      lerp( dot( Hash2D( i + float2(0.0,1.0) ), f - float2(0.0,1.0) ), 
                           dot( Hash2D( i + float2(1.0,1.0) ), f - float2(1.0,1.0) ), u.x), u.y);
      }
      
      float FBM2D(float2 uv)
      {
         float f = 0.5000*Noise2D( uv ); uv *= 2.01;
         f += 0.2500*Noise2D( uv ); uv *= 1.96;
         f += 0.1250*Noise2D( uv ); 
         return f;
      }
      
      float3 Hash3D( float3 p )
      {
         p = float3( dot(p,float3(127.1,311.7, 74.7)),
                 dot(p,float3(269.5,183.3,246.1)),
                 dot(p,float3(113.5,271.9,124.6)));

         return -1.0 + 2.0*frac(sin(p)*437.5453123);
      }

      float Noise3D( float3 p )
      {
         float3 i = floor( p );
         float3 f = frac( p );
         
         float3 u = f*f*(3.0-2.0*f);

         return lerp( lerp( lerp( dot( Hash3D( i + float3(0.0,0.0,0.0) ), f - float3(0.0,0.0,0.0) ), 
                                dot( Hash3D( i + float3(1.0,0.0,0.0) ), f - float3(1.0,0.0,0.0) ), u.x),
                           lerp( dot( Hash3D( i + float3(0.0,1.0,0.0) ), f - float3(0.0,1.0,0.0) ), 
                                dot( Hash3D( i + float3(1.0,1.0,0.0) ), f - float3(1.0,1.0,0.0) ), u.x), u.y),
                      lerp( lerp( dot( Hash3D( i + float3(0.0,0.0,1.0) ), f - float3(0.0,0.0,1.0) ), 
                                dot( Hash3D( i + float3(1.0,0.0,1.0) ), f - float3(1.0,0.0,1.0) ), u.x),
                           lerp( dot( Hash3D( i + float3(0.0,1.0,1.0) ), f - float3(0.0,1.0,1.0) ), 
                                dot( Hash3D( i + float3(1.0,1.0,1.0) ), f - float3(1.0,1.0,1.0) ), u.x), u.y), u.z );
      }
      
      float FBM3D(float3 uv)
      {
         float f = 0.5000*Noise3D( uv ); uv *= 2.01;
         f += 0.2500*Noise3D( uv ); uv *= 1.96;
         f += 0.1250*Noise3D( uv ); 
         return f;
      }
      
      half2 BlendNormal2(half2 base, half2 blend) { return normalize(half3(base.xy + blend.xy, 1)).xy; } 
      half3 BlendOverlay(half3 base, half3 blend) { return (base < 0.5 ? (2.0 * base * blend) : (1.0 - 2.0 * (1.0 - base) * (1.0 - blend))); }
      half3 BlendMult2X(half3  base, half3 blend) { return (base * (blend * 2)); }
      half3 BlendLighterColor(half3 s, half3 d) { return (s.x + s.y + s.z > d.x + d.y + d.z) ? s : d; } 
      
      float GetSaturation(float3 c)
      {
         float mi = min(min(c.x, c.y), c.z);
         float ma = max(max(c.x, c.y), c.z);
         return (ma - mi)/(ma + 1e-7);
      }

      // Better Color Lerp, does not have darkening issue
      float3 BetterColorLerp(float3 a, float3 b, float x)
      {
         float3 ic = lerp(a, b, x) + float3(1e-6,0.0,0.0);
         float sd = abs(GetSaturation(ic) - lerp(GetSaturation(a), GetSaturation(b), x));
    
         float3 dir = normalize(float3(2.0 * ic.x - ic.y - ic.z, 2.0 * ic.y - ic.x - ic.z, 2.0 * ic.z - ic.y - ic.x));
         float lgt = dot(float3(1.0, 1.0, 1.0), ic);
    
         float ff = dot(dir, normalize(ic));
    
         const float dsp_str = 1.5;
         ic += dsp_str * dir * sd * ff * lgt;
         return saturate(ic);
      }
      
      
      half4 ComputeWeights(half4 iWeights, half h0, half h1, half h2, half h3, half contrast)
      {
          #if _DISABLEHEIGHTBLENDING
             return iWeights;
          #else
             // compute weight with height map
             //half4 weights = half4(iWeights.x * h0, iWeights.y * h1, iWeights.z * h2, iWeights.w * h3);
             half4 weights = half4(iWeights.x * max(h0,0.001), iWeights.y * max(h1,0.001), iWeights.z * max(h2,0.001), iWeights.w * max(h3,0.001));
             
             // Contrast weights
             half maxWeight = max(max(weights.x, max(weights.y, weights.z)), weights.w);
             half transition = max(contrast * maxWeight, 0.0001);
             half threshold = maxWeight - transition;
             half scale = 1.0 / transition;
             weights = saturate((weights - threshold) * scale);
             // Normalize weights.
             half weightScale = 1.0f / (weights.x + weights.y + weights.z + weights.w);
             weights *= weightScale;
             return weights;
          #endif
      }

      half HeightBlend(half h1, half h2, half slope, half contrast)
      {
         #if _DISABLEHEIGHTBLENDING
            return slope;
         #else
            h2 = 1 - h2;
            half tween = saturate((slope - min(h1, h2)) / max(abs(h1 - h2), 0.001)); 
            half blend = saturate( ( tween - (1-contrast) ) / max(contrast, 0.001));
            return blend;
         #endif
      }

      #if _MAX4TEXTURES
         #define TEXCOUNT 4
      #elif _MAX8TEXTURES
         #define TEXCOUNT 8
      #elif _MAX12TEXTURES
         #define TEXCOUNT 12
      #elif _MAX20TEXTURES
         #define TEXCOUNT 20
      #elif _MAX24TEXTURES
         #define TEXCOUNT 24
      #elif _MAX28TEXTURES
         #define TEXCOUNT 28
      #elif _MAX32TEXTURES
         #define TEXCOUNT 32
      #else
         #define TEXCOUNT 16
      #endif


      void Setup(out half4 weights, float2 uv, out Config config, half4 w0, half4 w1, half4 w2, half4 w3, half4 w4, half4 w5, half4 w6, half4 w7, float3 worldPos)
      {
         config = (Config)0;
         half4 indexes = 0;

         config.uv = uv;

         #if _WORLDUV
         uv = worldPos.xz;
         #endif

         #if _DISABLESPLATMAPS
            float2 scaledUV = uv;
         #else
            float2 scaledUV = uv * _UVScale.xy + _UVScale.zw;
         #endif

         // if only 4 textures, and blending 4 textures, skip this whole thing..
         // this saves about 25% of the ALU of the base shader on low end. However if
         // we rely on sorted texture weights (distance resampling) we have to sort..
         float4 defaultIndexes = float4(0,1,2,3);
         #if _MESHSUBARRAY
            defaultIndexes = _MeshSubArrayIndexes;
         #endif

         #if _MESHSUBARRAY || (_MAX4TEXTURES && !_MAX3LAYER && !_MAX2LAYER && !_DISTANCERESAMPLE && !_POM)
            weights = w0;
            config.uv0 = float3(scaledUV, defaultIndexes.x);
            config.uv1 = float3(scaledUV, defaultIndexes.y);
            config.uv2 = float3(scaledUV, defaultIndexes.z);
            config.uv3 = float3(scaledUV, defaultIndexes.w);
            return;
         #endif

         #if _DISABLESPLATMAPS
            weights = float4(1,0,0,0);
            return;
         #else
            half splats[TEXCOUNT];

            splats[0] = w0.x;
            splats[1] = w0.y;
            splats[2] = w0.z;
            splats[3] = w0.w;
            #if !_MAX4TEXTURES
               splats[4] = w1.x;
               splats[5] = w1.y;
               splats[6] = w1.z;
               splats[7] = w1.w;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES
               splats[8] = w2.x;
               splats[9] = w2.y;
               splats[10] = w2.z;
               splats[11] = w2.w;
            #endif
            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
               splats[12] = w3.x;
               splats[13] = w3.y;
               splats[14] = w3.z;
               splats[15] = w3.w;
            #endif
            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               splats[16] = w4.x;
               splats[17] = w4.y;
               splats[18] = w4.z;
               splats[19] = w4.w;
            #endif
            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
               splats[20] = w5.x;
               splats[21] = w5.y;
               splats[22] = w5.z;
               splats[23] = w5.w;
            #endif
            #if _MAX28TEXTURES || _MAX32TEXTURES
               splats[24] = w6.x;
               splats[25] = w6.y;
               splats[26] = w6.z;
               splats[27] = w6.w;
            #endif
            #if _MAX32TEXTURES
               splats[28] = w7.x;
               splats[29] = w7.y;
               splats[30] = w7.z;
               splats[31] = w7.w;
            #endif



            weights[0] = 0;
            weights[1] = 0;
            weights[2] = 0;
            weights[3] = 0;
            indexes[0] = 0;
            indexes[1] = 0;
            indexes[2] = 0;
            indexes[3] = 0;

            int i = 0;
            for (i = 0; i < TEXCOUNT; ++i)
            {
               half w = splats[i];
               if (w >= weights[0])
               {
                  weights[3] = weights[2];
                  indexes[3] = indexes[2];
                  weights[2] = weights[1];
                  indexes[2] = indexes[1];
                  weights[1] = weights[0];
                  indexes[1] = indexes[0];
                  weights[0] = w;
                  indexes[0] = i;
               }
               else if (w >= weights[1])
               {
                  weights[3] = weights[2];
                  indexes[3] = indexes[2];
                  weights[2] = weights[1];
                  indexes[2] = indexes[1];
                  weights[1] = w;
                  indexes[1] = i;
               }
               else if (w >= weights[2])
               {
                  weights[3] = weights[2];
                  indexes[3] = indexes[2];
                  weights[2] = w;
                  indexes[2] = i;
               }
               else if (w >= weights[3])
               {
                  weights[3] = w;
                  indexes[3] = i;
               }
            }

            // clamp and renormalize
            #if _MAX2LAYER
            weights.zw = 0;
            weights.xy *= (1.0 / (weights.x + weights.y));
            #elif _MAX3LAYER
            weights.w = 0;
            weights.xyz *= (1.0 / (weights.x + weights.y + weights.z));
            #elif !_DISABLEHEIGHTBLENDING || _NORMALIZEWEIGHTS // prevents black when painting, which the unity shader does not prevent.
            weights = normalize(weights);
            #endif

            config.uv0 = float3(scaledUV, indexes.x);
            config.uv1 = float3(scaledUV, indexes.y);
            config.uv2 = float3(scaledUV, indexes.z);
            config.uv3 = float3(scaledUV, indexes.w);


         #endif //_DISABLESPLATMAPS


      }
      
      float ComputeMipLevel(float2 uv, float2 textureSize)
      {
         uv *= textureSize;
         float2  dx_vtc        = ddx(uv);
         float2  dy_vtc        = ddy(uv);
         float delta_max_sqr   = max(dot(dx_vtc, dx_vtc), dot(dy_vtc, dy_vtc));
         return 0.5 * log2(delta_max_sqr);
      }

      inline half2 UnpackNormal2(half4 packednormal)
      {
          return packednormal.wy * 2 - 1;
         
      }

      half3 TriplanarHBlend(half h0, half h1, half h2, half3 pN, half contrast)
      {
         half3 blend = pN / dot(pN, half3(1,1,1));
         float3 heights = float3(h0, h1, h2) + (blend * 3.0);
         half height_start = max(max(heights.x, heights.y), heights.z) - contrast;
         half3 h = max(heights - height_start.xxx, half3(0,0,0));
         blend = h / dot(h, half3(1,1,1));
         return blend;
      }
      

      void ClearAllButAlbedo(inout MicroSplatLayer o, half3 display)
      {
         o.Albedo = display.rgb;
         o.Normal = half3(0, 0, 1);
         o.Smoothness = 0;
         o.Occlusion = 1;
         o.Emission = 0;
         o.Metallic = 0;
         o.Height = 0;
         #if _USESPECULARWORKFLOW
         o.Specular = 0;
         #endif

      }

      void ClearAllButAlbedo(inout MicroSplatLayer o, half display)
      {
         o.Albedo = half3(display, display, display);
         o.Normal = half3(0, 0, 1);
         o.Smoothness = 0;
         o.Occlusion = 1;
         o.Emission = 0;
         o.Metallic = 0;
         o.Height = 0;
         #if _USESPECULARWORKFLOW
         o.Specular = 0;
         #endif

      }

     

      half MicroShadow(float3 lightDir, half3 normal, half ao, half strength)
      {
         half shadow = saturate(abs(dot(normal, lightDir)) + (ao * ao * 2.0) - 1.0);
         return 1 - ((1-shadow) * strength);
      }
      

      void DoDebugOutput(inout MicroSplatLayer l)
      {
         #if _DEBUG_OUTPUT_ALBEDO
            ClearAllButAlbedo(l, l.Albedo);
         #elif _DEBUG_OUTPUT_NORMAL
            // oh unit shader compiler normal stripping, how I hate you so..
            // must multiply by albedo to stop the normal from being white. Why, fuck knows?
            ClearAllButAlbedo(l, float3(l.Normal.xy * 0.5 + 0.5, l.Normal.z * saturate(l.Albedo.z+1)));
         #elif _DEBUG_OUTPUT_SMOOTHNESS
            ClearAllButAlbedo(l, l.Smoothness.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_METAL
            ClearAllButAlbedo(l, l.Metallic.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_AO
            ClearAllButAlbedo(l, l.Occlusion.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_EMISSION
            ClearAllButAlbedo(l, l.Emission * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_HEIGHT
            ClearAllButAlbedo(l, l.Height.xxx * saturate(l.Albedo.z+1));
         #elif _DEBUG_OUTPUT_SPECULAR && _USESPECULARWORKFLOW
            ClearAllButAlbedo(l, l.Specular * saturate(l.Albedo.z+1));
         #elif _DEBUG_BRANCHCOUNT_WEIGHT
            ClearAllButAlbedo(l, _branchWeightCount / 12 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_TRIPLANAR
            ClearAllButAlbedo(l, _branchTriplanarCount / 24 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_CLUSTER
            ClearAllButAlbedo(l, _branchClusterCount / 12 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_OTHER
            ClearAllButAlbedo(l, _branchOtherCount / 8 * saturate(l.Albedo.z + 1));
         #elif _DEBUG_BRANCHCOUNT_TOTAL
            l.Albedo.r = _branchWeightCount / 12;
            l.Albedo.g = _branchTriplanarCount / 24;
            l.Albedo.b = _branchClusterCount / 12;
            ClearAllButAlbedo(l, (l.Albedo.r + l.Albedo.g + l.Albedo.b + (_branchOtherCount / 8)) / 4); 
         #elif _DEBUG_OUTPUT_MICROSHADOWS
            ClearAllButAlbedo(l,l.Albedo); 
         #elif _DEBUG_SAMPLECOUNT
            float sdisp = (float)_sampleCount / max(_SampleCountDiv, 1);
            half3 sdcolor = float3(sdisp, sdisp > 1 ? 1 : 0, 0);
            ClearAllButAlbedo(l, sdcolor * saturate(l.Albedo.z + 1));
         #elif _DEBUG_PROCLAYERS
            ClearAllButAlbedo(l, (float)_procLayerCount / (float)_PCLayerCount * saturate(l.Albedo.z + 1));
         #endif
      }


      // man I wish unity would wrap everything instead of only what they use. Just seems like a landmine for
      // people like myself.. especially as they keep changing things around and I have to figure out all the new defines
      // and handle changes across Unity versions, which would be automatically handled if they just wrapped these themselves without
      // as much complexity..

      #if (UNITY_VERSION >= 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (SHADER_TARGET_SURFACE_ANALYSIS && !SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))) || (UNITY_VERSION < 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL))) 
           #define MICROSPLAT_SAMPLE_TEX2D_LOD(tex,coord, lod) tex.SampleLevel (sampler##tex,coord, lod)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(tex,samplertex,coord, lod) tex.SampleLevel (sampler##samplertex,coord, lod)
        #else
           #define MICROSPLAT_SAMPLE_TEX2D_LOD(tex,coord,lod) tex2D (tex,coord,0,lod)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(tex,samplertex,coord,lod) tex2D (tex,coord,0,lod)
        #endif
     


        #if (UNITY_VERSION >= 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (SHADER_TARGET_SURFACE_ANALYSIS && !SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))) || (UNITY_VERSION < 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL))) 
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) tex.SampleGrad (sampler##tex,coord,dx,dy)
        #elif defined(SHADER_API_D3D9)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(0,1,0,0) 
        #elif defined(UNITY_COMPILER_HLSL2GLSL) || defined(SHADER_TARGET_SURFACE_ANALYSIS)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) texCUBEgrad (tex,coord,float3(dx.x,dx.y,0),float3(dy.x,dy.y,0))
        #elif defined(SHADER_API_GLES)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(1,1,0,0)
        #elif defined(SHADER_API_D3D11_9X)
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(0,1,1,0) 
        #else
           #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy) half4(0,0,1,0) 
        #endif
        
        #if (UNITY_VERSION >= 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (SHADER_TARGET_SURFACE_ANALYSIS && !SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))) || (UNITY_VERSION < 201810 && (defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL))) 
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) tex.SampleGrad (sampler##samp,coord,dx,dy)
        #elif defined(SHADER_API_D3D9)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(0,1,0,0) 
        #elif defined(UNITY_COMPILER_HLSL2GLSL) || defined(SHADER_TARGET_SURFACE_ANALYSIS)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(1,0,1,0)
        #elif defined(SHADER_API_GLES)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(1,1,0,0)
        #elif defined(SHADER_API_D3D11_9X)
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(0,1,1,0) 
        #else
           #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy) half4(0,0,1,0) 
        #endif
      

      #if _USELODMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY_LOD(tex, u, l.x)
      #elif _USEGRADMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex, u, l.xy, l.zw)
      #else
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY(tex, u)
      #endif

      #if _USELODMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY_LOD(tex, u, l.x)
      #elif _USEGRADMIP
         #define MICROSPLAT_SAMPLE(tex, u, l) MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex, u, l.xy, l.zw)
      #else
         #define MICROSPLAT_SAMPLE(tex, u, l) UNITY_SAMPLE_TEX2DARRAY(tex, u)
      #endif


      #define MICROSPLAT_SAMPLE_DIFFUSE(u, cl, l) MICROSPLAT_SAMPLE(_Diffuse, u, l)
      #define MICROSPLAT_SAMPLE_EMIS(u, cl, l) MICROSPLAT_SAMPLE(_EmissiveMetal, u, l)
      #define MICROSPLAT_SAMPLE_DIFFUSE_LOD(u, cl, l) UNITY_SAMPLE_TEX2DARRAY_LOD(_Diffuse, u, l)
      

      #if _PACKINGHQ
         #define MICROSPLAT_SAMPLE_NORMAL(u, cl, l) half4(MICROSPLAT_SAMPLE(_NormalSAO, u, l).ga, MICROSPLAT_SAMPLE(_SmoothAO, u, l).ga).brag
      #else
         #define MICROSPLAT_SAMPLE_NORMAL(u, cl, l) MICROSPLAT_SAMPLE(_NormalSAO, u, l)
      #endif

      #if _USESPECULARWORKFLOW
         #define MICROSPLAT_SAMPLE_SPECULAR(u, cl, l) MICROSPLAT_SAMPLE(_Specular, u, l)
      #endif
      




                    
      #undef MICROSPLAT_SAMPLE_TEX2D_LOD
      #undef MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD
      #undef MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD
      #undef MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD

      #define MICROSPLAT_SAMPLE_TEX2D_LOD(tex,coord,lod)                    SAMPLE_TEXTURE2D_LOD(tex,sampler_##tex, coord, lod)
      #define MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(tex,coord,dx,dy)                 SAMPLE_TEXTURE2D_GRAD(tex,sampler_##tex,coord,dx,dy)
      #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_GRAD(tex,samp,coord,dx,dy)    SAMPLE_TEXTURE2D_GRAD(tex,sampler_##samp,coord,dx,dy)
      #define MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(tex, samp, coord, lod)    SAMPLE_TEXTURE2D_LOD(tex, sampler_##samp, coord, lod)

      inline half3 UnpackNormal(half4 packednormal)
      {
         half3 normal;
         normal.xy = packednormal.wy * 2 - 1;
         normal.z = sqrt(1 - normal.x*normal.x - normal.y * normal.y);
         return normal;
      }
      

      #undef WorldNormalVector
      #define WorldNormalVector(data, normal) mul(data.TBN, normal)





      #define UnityObjectToWorldNormal(normal) mul(GetObjectToWorldMatrix(), normal)
      
      


      Input DescToInput(SurfaceDescriptionInputs IN)
      {
        Input s = (Input)0;
        s.TBN = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        s.worldNormal = IN.WorldSpaceNormal;
        #if !_SRPTERRAINBLEND
           s.worldPos = GetAbsolutePositionWS(IN.WorldSpacePosition);
        #else
           s.worldPos = IN.WorldSpacePosition;
        #endif
        s.viewDir = IN.TangentSpaceViewDirection;
        s.uv_Control0 = IN.uv0.xy;
        

        #if _MICROMESH && _MESHUV2
            s.uv_Diffuse = IN.uv.xy1;
        #endif

        #if _SRPTERRAINBLEND
            s.color = IN.VertexColor;
        #endif
        return s;
     }

     #define TESSELLATION_INTERPOLATE_BARY(name, bary) output.name = input0.name * bary.x +  input1.name * bary.y +  input2.name * bary.z
     

     // Stochastic shared code

// Compute local triangle barycentric coordinates and vertex IDs
void TriangleGrid(float2 uv, float scale,
   out float w1, out float w2, out float w3,
   out int2 vertex1, out int2 vertex2, out int2 vertex3)
{
   // Scaling of the input
   uv *= 3.464 * scale; // 2 * sqrt(3)

   // Skew input space into simplex triangle grid
   const float2x2 gridToSkewedGrid = float2x2(1.0, 0.0, -0.57735027, 1.15470054);
   float2 skewedCoord = mul(gridToSkewedGrid, uv);

   // Compute local triangle vertex IDs and local barycentric coordinates
   int2 baseId = int2(floor(skewedCoord));
   float3 temp = float3(frac(skewedCoord), 0);
   temp.z = 1.0 - temp.x - temp.y;
   if (temp.z > 0.0)
   {
      w1 = temp.z;
      w2 = temp.y;
      w3 = temp.x;
      vertex1 = baseId;
      vertex2 = baseId + int2(0, 1);
      vertex3 = baseId + int2(1, 0);
   }
   else
   {
      w1 = -temp.z;
      w2 = 1.0 - temp.y;
      w3 = 1.0 - temp.x;
      vertex1 = baseId + int2(1, 1);
      vertex2 = baseId + int2(1, 0);
      vertex3 = baseId + int2(0, 1);
   }
}

// Fast random hash function
float2 SimpleHash2(float2 p)
{
   return frac(sin(mul(float2x2(127.1, 311.7, 269.5, 183.3), p)) * 43758.5453);
}


half3 BaryWeightBlend(half3 iWeights, half tex0, half tex1, half tex2, half contrast)
{
    // compute weight with height map
    const half epsilon = 1.0f / 1024.0f;
    half3 weights = half3(iWeights.x * (tex0 + epsilon), 
                             iWeights.y * (tex1 + epsilon),
                             iWeights.z * (tex2 + epsilon));

    // Contrast weights
    half maxWeight = max(weights.x, max(weights.y, weights.z));
    half transition = contrast * maxWeight;
    half threshold = maxWeight - transition;
    half scale = 1.0f / transition;
    weights = saturate((weights - threshold) * scale);
    // Normalize weights.
    half weightScale = 1.0f / (weights.x + weights.y + weights.z);
    weights *= weightScale;
    return weights;
}

void PrepareStochasticUVs(float scale, float3 uv, out float3 uv1, out float3 uv2, out float3 uv3, out half3 weights)
{
   // Get triangle info
   float w1, w2, w3;
   int2 vertex1, vertex2, vertex3;
   TriangleGrid(uv.xy, scale, w1, w2, w3, vertex1, vertex2, vertex3);

   // Assign random offset to each triangle vertex
   uv1 = uv;
   uv2 = uv;
   uv3 = uv;
   
   uv1.xy += SimpleHash2(vertex1);
   uv2.xy += SimpleHash2(vertex2);
   uv3.xy += SimpleHash2(vertex3);
   weights = half3(w1, w2, w3);
   
}

void PrepareStochasticUVs(float scale, float2 uv, out float2 uv1, out float2 uv2, out float2 uv3, out half3 weights)
{
   // Get triangle info
   float w1, w2, w3;
   int2 vertex1, vertex2, vertex3;
   TriangleGrid(uv, scale, w1, w2, w3, vertex1, vertex2, vertex3);

   // Assign random offset to each triangle vertex
   uv1 = uv;
   uv2 = uv;
   uv3 = uv;
   
   uv1.xy += SimpleHash2(vertex1);
   uv2.xy += SimpleHash2(vertex2);
   uv3.xy += SimpleHash2(vertex3);
   weights = half3(w1, w2, w3);
   
}


      #if _ALPHAHOLETEXTURE
         sampler2D _AlphaHoleTexture;   // must declare with a sampler or windows throws an error, which seems like a compiler bug
      #endif



      void ClipWaterLevel(float3 worldPos)
      {
         clip(worldPos.y - _AlphaData.y);
      }

      void ClipAlphaHole(inout Config c, inout half4 weights)
      {
      #if _ALPHAHOLETEXTURE
         clip(tex2D(_AlphaHoleTexture, c.uv).r - 0.5);
      #else
         if ((int)round(c.uv0.z ) == (int)round(_AlphaData.x))
         {
            clip(-1);
         }
         else if ((int)round(c.uv1.z ) == (int)round(_AlphaData.x) && weights.y > 0)
         {
            weights.y = 0;
            weights = normalize(weights);
         }
         else if ((int)round(c.uv2.z ) == (int)round(_AlphaData.x) && weights.z > 0)
         {
            weights.z = 0;
            weights = normalize(weights);
         }
         else if ((int)round(c.uv3.z ) == (int)round(_AlphaData.x) && weights.w > 0)
         {
            weights.w = 0;
            weights = normalize(weights);
         }
         
      #endif
      }





     
    




   

                    



      void SampleAlbedo(inout Config config, inout TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
         return;
         #endif
         #if _TRIPLANAR
            #if _USEGRADMIP
               float4 d0 = mipLevel.d0;
               float4 d1 = mipLevel.d1;
               float4 d2 = mipLevel.d2;
            #elif _USELODMIP
               float d0 = mipLevel.x;
               float d1 = mipLevel.y;
               float d2 = mipLevel.z;
            #else
               MIPFORMAT d0 = mipLevel;
               MIPFORMAT d1 = mipLevel;
               MIPFORMAT d2 = mipLevel;
            #endif
         
            half4 contrasts = _Contrast.xxxx;
            #if _PERTEXTRIPLANARCONTRAST
               SAMPLE_PER_TEX(ptc, 5.5, config, half4(1,0.5,0,0));
               contrasts = half4(ptc0.y, ptc1.y, ptc2.y, ptc3.y);
            #endif


            #if _PERTEXTRIPLANAR
               SAMPLE_PER_TEX(pttri, 9.5, config, half4(0,0,0,0));
            #endif

            {
               // For per-texture triplanar, we modify the view based blending factor of the triplanar
               // such that you get a pure blend of either top down projection, or with the top down projection
               // removed and renormalized. This causes dynamic flow control optimizations to kick in and avoid
               // the extra texture samples while keeping the code simple. Yay..

               // We also only have to do this in the Albedo, because the pN values will be adjusted after the
               // albedo is sampled, causing future samples to use this data. 
              
               #if _PERTEXTRIPLANAR
                  if (pttri0.x > 0.66)
                  {
                     tc.pN0 = half3(0,1,0);
                  }
                  else if (pttri0.x > 0.33)
                  {
                     tc.pN0.y = 0;
                     tc.pN0.xz = normalize(tc.pN0.xz);
                  }
               #endif


               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN0.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv0[0], config.cluster0, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN0.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv0[1], config.cluster0, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN0.z)
               {
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv0[2], config.cluster0, d2);
                  COUNTSAMPLE
               }

               half3 bf = tc.pN0;
               #if _TRIPLANARHEIGHTBLEND
                  bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN0, contrasts.x);
                  tc.pN0 = bf;
               #endif

               s.albedo0 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            MSBRANCH(weights.y)
            {
               #if _PERTEXTRIPLANAR
                  if (pttri1.x > 0.66)
                  {
                     tc.pN1 = half3(0,1,0);
                  }
                  else if (pttri1.x > 0.33)
                  {
                     tc.pN1.y = 0;
                     tc.pN1.xz = normalize(tc.pN1.xz);
                  }
               #endif

               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN1.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv1[0], config.cluster1, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv1[1], config.cluster1, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.z)
               {
                  COUNTSAMPLE
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv1[2], config.cluster1, d2);
               }
               half3 bf = tc.pN1;
               #if _TRIPLANARHEIGHTBLEND
                  bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN1, contrasts.x);
                  tc.pN1 = bf;
               #endif


               s.albedo1 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            #if !_MAX2LAYER
            MSBRANCH(weights.z)
            {
               #if _PERTEXTRIPLANAR
                  if (pttri2.x > 0.66)
                  {
                     tc.pN2 = half3(0,1,0);
                  }
                  else if (pttri2.x > 0.33)
                  {
                     tc.pN2.y = 0;
                     tc.pN2.xz = normalize(tc.pN2.xz);
                  }
               #endif

               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN2.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv2[0], config.cluster2, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv2[1], config.cluster2, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.z)
               {
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv2[2], config.cluster2, d2);
                  COUNTSAMPLE
               }

               half3 bf = tc.pN2;
               #if _TRIPLANARHEIGHTBLEND
                  bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN2, contrasts.x);
                  tc.pN2 = bf;
               #endif
               

               s.albedo2 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
            MSBRANCH(weights.w)
            {

               #if _PERTEXTRIPLANAR
                  if (pttri3.x > 0.66)
                  {
                     tc.pN3 = half3(0,1,0);
                  }
                  else if (pttri3.x > 0.33)
                  {
                     tc.pN3.y = 0;
                     tc.pN3.xz = normalize(tc.pN3.xz);
                  }
               #endif

               half4 a0 = half4(0,0,0,0);
               half4 a1 = half4(0,0,0,0);
               half4 a2 = half4(0,0,0,0);
               MSBRANCHTRIPLANAR(tc.pN3.x)
               {
                  a0 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv3[0], config.cluster3, d0);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.y)
               {
                  a1 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv3[1], config.cluster3, d1);
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.z)
               {
                  a2 = MICROSPLAT_SAMPLE_DIFFUSE(tc.uv3[2], config.cluster3, d2);
                  COUNTSAMPLE
               }

               half3 bf = tc.pN3;
               #if _TRIPLANARHEIGHTBLEND
               bf = TriplanarHBlend(a0.a, a1.a, a2.a, tc.pN3, contrasts.x);
               tc.pN3 = bf;
               #endif

               s.albedo3 = a0 * bf.x + a1 * bf.y + a2 * bf.z;
            }
            #endif

         #else
            s.albedo0 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv0, config.cluster0, mipLevel);
            COUNTSAMPLE

            MSBRANCH(weights.y)
            {
               s.albedo1 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv1, config.cluster1, mipLevel);
               COUNTSAMPLE
            }
            #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  s.albedo2 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv2, config.cluster2, mipLevel);
                  COUNTSAMPLE
               } 
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  s.albedo3 = MICROSPLAT_SAMPLE_DIFFUSE(config.uv3, config.cluster3, mipLevel);
                  COUNTSAMPLE
               }
            #endif
         #endif

         #if _PERTEXHEIGHTOFFSET || _PERTEXHEIGHTCONTRAST
            SAMPLE_PER_TEX(ptHeight, 10.5, config, 1);

            #if _PERTEXHEIGHTOFFSET
               s.albedo0.a = saturate(s.albedo0.a + ptHeight0.b - 1);
               s.albedo1.a = saturate(s.albedo1.a + ptHeight1.b - 1);
               s.albedo2.a = saturate(s.albedo2.a + ptHeight2.b - 1);
               s.albedo3.a = saturate(s.albedo3.a + ptHeight3.b - 1);
            #endif
            #if _PERTEXHEIGHTCONTRAST
               s.albedo0.a = saturate(pow(s.albedo0.a + 0.5, abs(ptHeight0.a)) - 0.5);
               s.albedo1.a = saturate(pow(s.albedo1.a + 0.5, abs(ptHeight1.a)) - 0.5);
               s.albedo2.a = saturate(pow(s.albedo2.a + 0.5, abs(ptHeight2.a)) - 0.5);
               s.albedo3.a = saturate(pow(s.albedo3.a + 0.5, abs(ptHeight3.a)) - 0.5);
            #endif
         #endif
      }
      
      
      
      void SampleNormal(Config config, TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
         return;
         #endif

         #if _NONOMALMAP
            s.normSAO0 = half4(0,0, 0, 1);
            s.normSAO1 = half4(0,0, 0, 1);
            s.normSAO2 = half4(0,0, 0, 1);
            s.normSAO3 = half4(0,0, 0, 1);
            return;
         #endif
         
         #if _TRIPLANAR
            #if _USEGRADMIP
               float4 d0 = mipLevel.d0;
               float4 d1 = mipLevel.d1;
               float4 d2 = mipLevel.d2;
            #elif _USELODMIP
               float d0 = mipLevel.x;
               float d1 = mipLevel.y;
               float d2 = mipLevel.z;
            #else
               MIPFORMAT d0 = mipLevel;
               MIPFORMAT d1 = mipLevel;
               MIPFORMAT d2 = mipLevel;
            #endif
            
            half3 absVertNormal = abs(tc.IN.worldNormal);
            float3 t2w0 = WorldNormalVector(tc.IN, float3(1,0,0));
            float3 t2w1 = WorldNormalVector(tc.IN, float3(0,1,0));
            float3 t2w2 = WorldNormalVector(tc.IN, float3(0,0,1));
            float3x3 t2w = float3x3(t2w0, t2w1, t2w2);
            
            
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);
               MSBRANCHTRIPLANAR(tc.pN0.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv0[0], config.cluster0, d0).garb;
                  COUNTSAMPLE
               }            
               MSBRANCHTRIPLANAR(tc.pN0.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv0[1], config.cluster0, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN0.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv0[2], config.cluster0, d2).garb;
                  COUNTSAMPLE
               }
               

               s.normSAO0.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN0, a0.xy, a1.xy, a2.xy);
               s.normSAO0.zw = a0.zw * tc.pN0.x + a1.zw * tc.pN0.y + a2.zw * tc.pN0.z;
            }
            MSBRANCH(weights.y)
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);
               MSBRANCHTRIPLANAR(tc.pN1.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv1[0], config.cluster1, d0).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv1[1], config.cluster1, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN1.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv1[2], config.cluster1, d2).garb;
                  COUNTSAMPLE
               }
               

               s.normSAO1.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN1, a0.xy, a1.xy, a2.xy);
               s.normSAO1.zw = a0.zw * tc.pN1.x + a1.zw * tc.pN1.y + a2.zw * tc.pN1.z;
            }
            #if !_MAX2LAYER
            MSBRANCH(weights.z)
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);

               MSBRANCHTRIPLANAR(tc.pN2.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv2[0], config.cluster2, d0).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv2[1], config.cluster2, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN2.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv2[2], config.cluster2, d2).garb;
                  COUNTSAMPLE
               }
               

               s.normSAO2.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN2, a0.xy, a1.xy, a2.xy);
               s.normSAO2.zw = a0.zw * tc.pN2.x + a1.zw * tc.pN2.y + a2.zw * tc.pN2.z;
            }
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
            MSBRANCH(weights.w)
            {
               half4 a0 = half4(0.5, 0.5, 0, 1);
               half4 a1 = half4(0.5, 0.5, 0, 1);
               half4 a2 = half4(0.5, 0.5, 0, 1);
               MSBRANCHTRIPLANAR(tc.pN3.x)
               {
                  a0 = MICROSPLAT_SAMPLE_NORMAL(tc.uv3[0], config.cluster3, d0).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.y)
               {
                  a1 = MICROSPLAT_SAMPLE_NORMAL(tc.uv3[1], config.cluster3, d1).garb;
                  COUNTSAMPLE
               }
               MSBRANCHTRIPLANAR(tc.pN3.z)
               {
                  a2 = MICROSPLAT_SAMPLE_NORMAL(tc.uv3[2], config.cluster3, d2).garb;
                  COUNTSAMPLE
               }

               s.normSAO3.xy = TransformTriplanarNormal(tc.IN, t2w, tc.axisSign, absVertNormal, tc.pN3, a0.xy, a1.xy, a2.xy);
               s.normSAO3.zw = a0.zw * tc.pN3.x + a1.zw * tc.pN3.y + a2.zw * tc.pN3.z;
            }
            #endif

         #else
            s.normSAO0 = MICROSPLAT_SAMPLE_NORMAL(config.uv0, config.cluster0, mipLevel).garb;
            COUNTSAMPLE
            s.normSAO0.xy = s.normSAO0.xy * 2 - 1;
            MSBRANCH(weights.y)
            {
               s.normSAO1 = MICROSPLAT_SAMPLE_NORMAL(config.uv1, config.cluster1, mipLevel).garb;
               COUNTSAMPLE
               s.normSAO1.xy = s.normSAO1.xy * 2 - 1;
            }
            #if !_MAX2LAYER
            MSBRANCH(weights.z)
            {
               s.normSAO2 = MICROSPLAT_SAMPLE_NORMAL(config.uv2, config.cluster2, mipLevel).garb;
               COUNTSAMPLE
               s.normSAO2.xy = s.normSAO2.xy * 2 - 1;
            }
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
            MSBRANCH(weights.w)
            {
               s.normSAO3 = MICROSPLAT_SAMPLE_NORMAL(config.uv3, config.cluster3, mipLevel).garb;
               COUNTSAMPLE
               s.normSAO3.xy = s.normSAO3.xy * 2 - 1;
            }
            #endif
         #endif
      }

      void SampleEmis(Config config, TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
            return;
         #endif
         #if _USEEMISSIVEMETAL
            #if _TRIPLANAR
            
               #if _USEGRADMIP
                  float4 d0 = mipLevel.d0;
                  float4 d1 = mipLevel.d1;
                  float4 d2 = mipLevel.d2;
               #elif _USELODMIP
                  float d0 = mipLevel.x;
                  float d1 = mipLevel.y;
                  float d2 = mipLevel.z;
               #else
                  MIPFORMAT d0 = mipLevel;
                  MIPFORMAT d1 = mipLevel;
                  MIPFORMAT d2 = mipLevel;
               #endif
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN0.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv0[0], config.cluster0, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv0[1], config.cluster0, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv0[2], config.cluster0, d2);
                     COUNTSAMPLE
                  }
                  s.emisMetal0 = a0 * tc.pN0.x + a1 * tc.pN0.y + a2 * tc.pN0.z;
               }
               MSBRANCH(weights.y)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN1.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv1[0], config.cluster1, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv1[1], config.cluster1, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv1[2], config.cluster1, d2);
                     COUNTSAMPLE
                  }

                  s.emisMetal1 = a0 * tc.pN1.x + a1 * tc.pN1.y + a2 * tc.pN1.z;
               }
               #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN2.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv2[0], config.cluster2, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv2[1], config.cluster2, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv2[2], config.cluster2, d2);
                     COUNTSAMPLE
                  }
                  
                  s.emisMetal2 = a0 * tc.pN2.x + a1 * tc.pN2.y + a2 * tc.pN2.z;
               }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN3.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_EMIS(tc.uv3[0], config.cluster3, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_EMIS(tc.uv3[1], config.cluster3, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_EMIS(tc.uv3[2], config.cluster3, d2);
                     COUNTSAMPLE
                  }
                  
                  s.emisMetal3 = a0 * tc.pN3.x + a1 * tc.pN3.y + a2 * tc.pN3.z;
               }
               #endif

            #else
               s.emisMetal0 = MICROSPLAT_SAMPLE_EMIS(config.uv0, config.cluster0, mipLevel);
               COUNTSAMPLE

               MSBRANCH(weights.y)
               {
                  s.emisMetal1 = MICROSPLAT_SAMPLE_EMIS(config.uv1, config.cluster1, mipLevel);
                  COUNTSAMPLE
               }
               #if !_MAX2LAYER
                  MSBRANCH(weights.z)
                  {
                     s.emisMetal2 = MICROSPLAT_SAMPLE_EMIS(config.uv2, config.cluster2, mipLevel);
                     COUNTSAMPLE
                  }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  MSBRANCH(weights.w)
                  {
                     s.emisMetal3 = MICROSPLAT_SAMPLE_EMIS(config.uv3, config.cluster3, mipLevel);
                     COUNTSAMPLE
                  }
               #endif
            #endif
         #endif
      }
      
      void SampleSpecular(Config config, TriplanarConfig tc, inout RawSamples s, MIPFORMAT mipLevel, half4 weights)
      {
         #if _DISABLESPLATMAPS
            return;
         #endif
         #if _USESPECULARWORKFLOW
            #if _TRIPLANAR

               #if _USEGRADMIP
                  float4 d0 = mipLevel.d0;
                  float4 d1 = mipLevel.d1;
                  float4 d2 = mipLevel.d2;
               #elif _USELODMIP
                  float d0 = mipLevel.x;
                  float d1 = mipLevel.y;
                  float d2 = mipLevel.z;
               #else
                  MIPFORMAT d0 = mipLevel;
                  MIPFORMAT d1 = mipLevel;
                  MIPFORMAT d2 = mipLevel;
               #endif
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN0.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv0[0], config.cluster0, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv0[1], config.cluster0, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN0.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv0[2], config.cluster0, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular0 = a0 * tc.pN0.x + a1 * tc.pN0.y + a2 * tc.pN0.z;
               }
               MSBRANCH(weights.y)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN1.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv1[0], config.cluster1, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv1[1], config.cluster1, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN1.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv1[2], config.cluster1, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular1 = a0 * tc.pN1.x + a1 * tc.pN1.y + a2 * tc.pN1.z;
               }
               #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN2.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv2[0], config.cluster2, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv2[1], config.cluster2, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN2.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv2[2], config.cluster2, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular2 = a0 * tc.pN2.x + a1 * tc.pN2.y + a2 * tc.pN2.z;
               }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  half4 a0 = half4(0, 0, 0, 0);
                  half4 a1 = half4(0, 0, 0, 0);
                  half4 a2 = half4(0, 0, 0, 0);
                  MSBRANCHTRIPLANAR(tc.pN3.x)
                  {
                     a0 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv3[0], config.cluster3, d0);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.y)
                  {
                     a1 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv3[1], config.cluster3, d1);
                     COUNTSAMPLE
                  }
                  MSBRANCHTRIPLANAR(tc.pN3.z)
                  {
                     a2 = MICROSPLAT_SAMPLE_SPECULAR(tc.uv3[2], config.cluster3, d2);
                     COUNTSAMPLE
                  }
                  
                  s.specular3 = a0 * tc.pN3.x + a1 * tc.pN3.y + a2 * tc.pN3.z;
               }
               #endif

            #else
               s.specular0 = MICROSPLAT_SAMPLE_SPECULAR(config.uv0, config.cluster0, mipLevel);
               COUNTSAMPLE

               MSBRANCH(weights.y)
               {
                  s.specular1 = MICROSPLAT_SAMPLE_SPECULAR(config.uv1, config.cluster1, mipLevel);
                  COUNTSAMPLE
               }
               #if !_MAX2LAYER
               MSBRANCH(weights.z)
               {
                  s.specular2 = MICROSPLAT_SAMPLE_SPECULAR(config.uv2, config.cluster2, mipLevel);
                  COUNTSAMPLE
               }
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
               MSBRANCH(weights.w)
               {
                  s.specular3 = MICROSPLAT_SAMPLE_SPECULAR(config.uv3, config.cluster3, mipLevel);
                  COUNTSAMPLE
               }
               #endif
            #endif
         #endif
      }

      MicroSplatLayer Sample(Input i, half4 weights, inout Config config, float camDist, float3 worldNormalVertex)
      {
         MicroSplatLayer o = (MicroSplatLayer)0;
         UNITY_INITIALIZE_OUTPUT(MicroSplatLayer,o);

         RawSamples samples = (RawSamples)0;
         InitRawSamples(samples);

         half4 albedo = 0;
         half4 normSAO = half4(0,0,0,1);
         half4 emisMetal = 0;
         half3 specular = 0;
         
         float worldHeight = i.worldPos.y;
         float3 upVector = float3(0,1,0);

         #if _PLANETVECTORS
            upVector = worldNormalVertex;
            worldHeight = distance(i.worldPos, float3(0,0,0));
         #endif

         #if _GLOBALTINT || _GLOBALNORMALS || _GLOBALSMOOTHAOMETAL || _GLOBALEMIS || _GLOBALSPECULAR
            float globalSlopeFilter = 1;
            #if _GLOBALSLOPEFILTER
               float2 gfilterUV = float2(1 - saturate(dot(worldNormalVertex, upVector) * 0.5 + 0.49), 0.5);
               globalSlopeFilter = UNITY_SAMPLE_TEX2D_SAMPLER(_GlobalSlopeTex, _Diffuse, gfilterUV).a;
            #endif
         #endif

         // declare outside of branchy areas..
         half4 fxLevels = half4(0,0,0,0);
         half burnLevel = 0;
         half wetLevel = 0;
         half3 waterNormalFoam = half3(0, 0, 0);
         half porosity = 0.4;
         float streamFoam = 1.0f;
         half pud = 0;
         half snowCover = 0;
         half SSSThickness = 0;
         half3 SSSTint = half3(1,1,1);
         float traxBuffer = 0;
         float3 traxNormal = 0;
         float2 noiseUV = 0;
         
         

         #if _SPLATFADE
         MSBRANCHOTHER(1 - saturate(camDist - _SplatFade.y))
         {
         #endif

         #if _TRAXSINGLE || _TRAXARRAY || _TRAXNOTEXTURE || _SNOWFOOTSTEPS
            traxBuffer = SampleTraxBuffer(i.worldPos, traxNormal);
         #endif
         
         #if _WETNESS || _PUDDLES || _STREAMS || _LAVA
            #if _MICROMESH
               fxLevels = SampleFXLevels(InverseLerp(_UVMeshRange.xy, _UVMeshRange.zw, config.uv), wetLevel, burnLevel, traxBuffer);
            #elif _MICROVERTEXMESH || _MICRODIGGERMESH 
               fxLevels = ProcessFXLevels(i.s0, traxBuffer);
            #else
               fxLevels = SampleFXLevels(config.uv, wetLevel, burnLevel, traxBuffer);
            #endif
         #endif

         TriplanarConfig tc = (TriplanarConfig)0;
         UNITY_INITIALIZE_OUTPUT(TriplanarConfig,tc);
         

         MIPFORMAT albedoLOD = INITMIPFORMAT
         MIPFORMAT normalLOD = INITMIPFORMAT
         MIPFORMAT emisLOD = INITMIPFORMAT
         MIPFORMAT specLOD = INITMIPFORMAT

         #if _TRIPLANAR && !_DISABLESPLATMAPS
            PrepTriplanar(worldNormalVertex, i.worldPos, config, tc, weights, albedoLOD, normalLOD, emisLOD);
            tc.IN = i;
         #endif
         
         
         #if !_TRIPLANAR && !_DISABLESPLATMAPS
            #if _USELODMIP
               albedoLOD = ComputeMipLevel(config.uv0.xy, _Diffuse_TexelSize.zw);
               normalLOD = ComputeMipLevel(config.uv0.xy, _NormalSAO_TexelSize.zw);
               #if _USEEMISSIVEMETAL
                  emisLOD   = ComputeMipLevel(config.uv0.xy, _EmissiveMetal_TexelSize.zw);
               #endif
               #if _USESPECULARWORKFLOW
                  specLOD = ComputeMipLevel(config.uv0.xy, _Specular_TexelSize.zw);;
               #endif
            #elif _USEGRADMIP
               albedoLOD = float4(ddx(config.uv0.xy), ddy(config.uv0.xy));
               normalLOD = albedoLOD;
               #if _USESPECULARWORKFLOW
                  specLOD = albedoLOD;
               #endif
               #if _USEEMISSIVEMETAL
                  emisLOD = albedoLOD;
               #endif
            #endif
         #endif

         #if _PERTEXCURVEWEIGHT
           SAMPLE_PER_TEX(ptCurveWeight, 19.5, config, half4(0.5,1,1,1));
           weights.x = lerp(smoothstep(0.5 - ptCurveWeight0.r, 0.5 + ptCurveWeight0.r, weights.x), weights.x, ptCurveWeight0.r*2);
           weights.y = lerp(smoothstep(0.5 - ptCurveWeight1.r, 0.5 + ptCurveWeight1.r, weights.y), weights.y, ptCurveWeight1.r*2);
           weights.z = lerp(smoothstep(0.5 - ptCurveWeight2.r, 0.5 + ptCurveWeight2.r, weights.z), weights.z, ptCurveWeight2.r*2);
           weights.w = lerp(smoothstep(0.5 - ptCurveWeight3.r, 0.5 + ptCurveWeight3.r, weights.w), weights.w, ptCurveWeight3.r*2);
           weights = normalize(weights);
         #endif
         

         // uvScale before anything
         #if _PERTEXUVSCALEOFFSET && !_TRIPLANAR && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptUVScale, 0.5, config, half4(1,1,0,0));
            config.uv0.xy = config.uv0.xy * ptUVScale0.rg + ptUVScale0.ba;
            config.uv1.xy = config.uv1.xy * ptUVScale1.rg + ptUVScale1.ba;
            #if !_MAX2LAYER
               config.uv2.xy = config.uv2.xy * ptUVScale2.rg + ptUVScale2.ba;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               config.uv3.xy = config.uv3.xy * ptUVScale3.rg + ptUVScale3.ba;
            #endif

            // fix for pertex uv scale using gradient sampler and weight blended derivatives
            #if _USEGRADMIP
               albedoLOD = albedoLOD * ptUVScale0.rgrg * weights.x + 
                           albedoLOD * ptUVScale1.rgrg * weights.y + 
                           albedoLOD * ptUVScale2.rgrg * weights.z + 
                           albedoLOD * ptUVScale3.rgrg * weights.w;
               normalLOD = albedoLOD;
               #if _USEEMISSIVEMETAL
                  emisLOD = albedoLOD;
               #endif
               #if _USESPECULARWORKFLOW
                  specLOD = albedoLOD;
               #endif
            #endif
         #endif

         #if _PERTEXUVROTATION && !_TRIPLANAR && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptUVRot, 16.5, config, half4(0,0,0,0));
            config.uv0.xy = RotateUV(config.uv0.xy, ptUVRot0.x);
            config.uv1.xy = RotateUV(config.uv1.xy, ptUVRot1.x);
            #if !_MAX2LAYER
               config.uv2.xy = RotateUV(config.uv2.xy, ptUVRot2.x);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               config.uv3.xy = RotateUV(config.uv3.xy, ptUVRot0.x);
            #endif
         #endif

         
         o.Alpha = 1;

         
         #if _POM && !_DISABLESPLATMAPS
            DoPOM(i, config, tc, albedoLOD, weights, camDist, worldNormalVertex);
         #endif
         

         SampleAlbedo(config, tc, samples, albedoLOD, weights);

         #if _NOISEHEIGHT
            ApplyNoiseHeight(samples, config.uv, config, i.worldPos, worldNormalVertex);
         #endif
         
         #if _STREAMS || (_PARALLAX && !_DISABLESPLATMAPS)
         half earlyHeight = BlendWeights(samples.albedo0.w, samples.albedo1.w, samples.albedo2.w, samples.albedo3.w, weights);
         #endif

         
         #if _STREAMS
         waterNormalFoam = GetWaterNormal(i, config.uv, worldNormalVertex);
         DoStreamRefract(config, tc, waterNormalFoam, fxLevels.b, earlyHeight);
         #endif

         #if _PARALLAX && !_DISABLESPLATMAPS
            DoParallax(i, earlyHeight, config, tc, samples, weights, camDist);
         #endif


         // Blend results
         #if _PERTEXINTERPCONTRAST && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptContrasts, 1.5, config, 0.5);
            half4 contrast = 0.5;
            contrast.x = ptContrasts0.a;
            contrast.y = ptContrasts1.a;
            #if !_MAX2LAYER
               contrast.z = ptContrasts2.a;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               contrast.w = ptContrasts3.a;
            #endif
            contrast = clamp(contrast + _Contrast, 0.0001, 1.0); 
            half cnt = contrast.x * weights.x + contrast.y * weights.y + contrast.z * weights.z + contrast.w * weights.w;
            half4 heightWeights = ComputeWeights(weights, samples.albedo0.a, samples.albedo1.a, samples.albedo2.a, samples.albedo3.a, cnt);
         #else
            half4 heightWeights = ComputeWeights(weights, samples.albedo0.a, samples.albedo1.a, samples.albedo2.a, samples.albedo3.a, _Contrast);
         #endif


         #if _PARALLAX || _STREAMS
            SampleAlbedo(config, tc, samples, albedoLOD, heightWeights);
         #endif


         SampleNormal(config, tc, samples, normalLOD, heightWeights);

         #if _USEEMISSIVEMETAL
            SampleEmis(config, tc, samples, emisLOD, heightWeights);
         #endif

         #if _USESPECULARWORKFLOW
            SampleSpecular(config, tc, samples, specLOD, heightWeights);
         #endif

         #if _DISTANCERESAMPLE && !_DISABLESPLATMAPS
            DistanceResample(samples, config, tc, camDist, i.viewDir, fxLevels, albedoLOD, i.worldPos, heightWeights, worldNormalVertex);
         #endif

         // PerTexture sampling goes here, passing the samples structure
         
         #if _PERTEXMICROSHADOWS || _PERTEXFUZZYSHADE
            SAMPLE_PER_TEX(ptFuzz, 17.5, config, half4(0, 0, 1, 1));
         #endif

         #if _PERTEXMICROSHADOWS
            #if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_DEFERRED) || (defined(_MSRENDERLOOP_UNITYLD) && defined(_PASSFORWARD) || _MSRENDERLOOP_UNITYHD)
            {
               half3 lightDir = GetGlobalLightDirTS(i);
               half4 microShadows = half4(1,1,1,1);
               microShadows.x = MicroShadow(lightDir, half3(samples.normSAO0.xy, 1), samples.normSAO0.a, ptFuzz0.a);
               microShadows.y = MicroShadow(lightDir, half3(samples.normSAO1.xy, 1), samples.normSAO1.a, ptFuzz1.a);
               microShadows.z = MicroShadow(lightDir, half3(samples.normSAO2.xy, 1), samples.normSAO2.a, ptFuzz2.a);
               microShadows.w = MicroShadow(lightDir, half3(samples.normSAO3.xy, 1), samples.normSAO3.a, ptFuzz3.a);
               samples.normSAO0.a *= microShadows.x;
               samples.normSAO1.a *= microShadows.y;
               #if !_MAX2LAYER
                  samples.normSAO2.a *= microShadows.z;
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  samples.normSAO3.a *= microShadows.w;
               #endif

               
               #if _DEBUG_OUTPUT_MICROSHADOWS
               o.Albedo = BlendWeights(microShadows.x, microShadows.y, microShadows.z, microShadows.a, heightWeights);
               return o;
               #endif

            }
            #endif

         #endif // _PERTEXMICROSHADOWS


         #if _PERTEXFUZZYSHADE
            
            samples.albedo0.rgb = FuzzyShade(samples.albedo0.rgb, half3(samples.normSAO0.rg, 1), ptFuzz0.r, ptFuzz0.g, ptFuzz0.b, i.viewDir);
            samples.albedo1.rgb = FuzzyShade(samples.albedo1.rgb, half3(samples.normSAO1.rg, 1), ptFuzz1.r, ptFuzz1.g, ptFuzz1.b, i.viewDir);
            #if !_MAX2LAYER
               samples.albedo2.rgb = FuzzyShade(samples.albedo2.rgb, half3(samples.normSAO2.rg, 1), ptFuzz2.r, ptFuzz2.g, ptFuzz2.b, i.viewDir);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb = FuzzyShade(samples.albedo3.rgb, half3(samples.normSAO3.rg, 1), ptFuzz3.r, ptFuzz3.g, ptFuzz3.b, i.viewDir);
            #endif
         #endif

         #if _PERTEXSATURATION && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptSaturattion, 9.5, config, half4(1, 1, 1, 1));
            samples.albedo0.rgb = lerp(MSLuminance(samples.albedo0.rgb), samples.albedo0.rgb, ptSaturattion0.a);
            samples.albedo1.rgb = lerp(MSLuminance(samples.albedo1.rgb), samples.albedo1.rgb, ptSaturattion1.a);
            #if !_MAX2LAYER
               samples.albedo2.rgb = lerp(MSLuminance(samples.albedo2.rgb), samples.albedo2.rgb, ptSaturattion2.a);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb = lerp(MSLuminance(samples.albedo3.rgb), samples.albedo3.rgb, ptSaturattion3.a);
            #endif
         
         #endif
         
         #if _PERTEXTINT && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptTints, 1.5, config, half4(1, 1, 1, 1));
            samples.albedo0.rgb *= ptTints0.rgb;
            samples.albedo1.rgb *= ptTints1.rgb;
            #if !_MAX2LAYER
               samples.albedo2.rgb *= ptTints2.rgb;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb *= ptTints3.rgb;
            #endif
         #endif
         
         #if _PCHEIGHTGRADIENT || _PCHEIGHTHSV || _PCSLOPEGRADIENT || _PCSLOPEHSV
            ProceduralGradients(i, samples, config, worldHeight, worldNormalVertex);
         #endif

         
         

         #if _WETNESS || _PUDDLES || _STREAMS
         porosity = _GlobalPorosity;
         #endif


         #if _PERTEXCOLORINTENSITY
            SAMPLE_PER_TEX(ptCI, 23.5, config, half4(1, 1, 1, 1));
            samples.albedo0.rgb = saturate(samples.albedo0.rgb * (1 + ptCI0.rrr));
            samples.albedo1.rgb = saturate(samples.albedo1.rgb * (1 + ptCI1.rrr));
            #if !_MAX2LAYER
               samples.albedo2.rgb = saturate(samples.albedo2.rgb * (1 + ptCI2.rrr));
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.albedo3.rgb = saturate(samples.albedo3.rgb * (1 + ptCI3.rrr));
            #endif
         #endif

         #if (_PERTEXBRIGHTNESS || _PERTEXCONTRAST || _PERTEXPOROSITY || _PERTEXFOAM) && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(ptBC, 3.5, config, half4(1, 1, 1, 1));
            #if _PERTEXCONTRAST
               samples.albedo0.rgb = saturate(((samples.albedo0.rgb - 0.5) * ptBC0.g) + 0.5);
               samples.albedo1.rgb = saturate(((samples.albedo1.rgb - 0.5) * ptBC1.g) + 0.5);
               #if !_MAX2LAYER
                 samples.albedo2.rgb = saturate(((samples.albedo2.rgb - 0.5) * ptBC2.g) + 0.5);
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  samples.albedo3.rgb = saturate(((samples.albedo3.rgb - 0.5) * ptBC3.g) + 0.5);
               #endif
            #endif
            #if _PERTEXBRIGHTNESS
               samples.albedo0.rgb = saturate(samples.albedo0.rgb + ptBC0.rrr);
               samples.albedo1.rgb = saturate(samples.albedo1.rgb + ptBC1.rrr);
               #if !_MAX2LAYER
                  samples.albedo2.rgb = saturate(samples.albedo2.rgb + ptBC2.rrr);
               #endif
               #if !_MAX3LAYER || !_MAX2LAYER
                  samples.albedo3.rgb = saturate(samples.albedo3.rgb + ptBC3.rrr);
               #endif
            #endif
            #if _PERTEXPOROSITY
            porosity = BlendWeights(ptBC0.b, ptBC1.b, ptBC2.b, ptBC3.b, heightWeights);
            #endif

            #if _PERTEXFOAM
            streamFoam = BlendWeights(ptBC0.a, ptBC1.a, ptBC2.a, ptBC3.a, heightWeights);
            #endif

         #endif

         #if (_PERTEXNORMSTR || _PERTEXAOSTR || _PERTEXSMOOTHSTR || _PERTEXMETALLIC) && !_DISABLESPLATMAPS
            SAMPLE_PER_TEX(perTexMatSettings, 2.5, config, half4(1.0, 1.0, 1.0, 0.0));
         #endif

         #if _PERTEXNORMSTR && !_DISABLESPLATMAPS
            samples.normSAO0.xy *= perTexMatSettings0.r;
            samples.normSAO1.xy *= perTexMatSettings1.r;
            #if !_MAX2LAYER
               samples.normSAO2.xy *= perTexMatSettings2.r;
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.normSAO3.xy *= perTexMatSettings3.r;
            #endif
         #endif

         #if _PERTEXAOSTR && !_DISABLESPLATMAPS
            samples.normSAO0.a = pow(samples.normSAO0.a, abs(perTexMatSettings0.b));
            samples.normSAO1.a = pow(samples.normSAO1.a, abs(perTexMatSettings1.b));
            #if !_MAX2LAYER
               samples.normSAO2.a = pow(samples.normSAO2.a, abs(perTexMatSettings2.b));
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.normSAO3.a = pow(samples.normSAO3.a, abs(perTexMatSettings3.b));
            #endif
         #endif

         #if _PERTEXSMOOTHSTR && !_DISABLESPLATMAPS
            samples.normSAO0.b += perTexMatSettings0.g;
            samples.normSAO1.b += perTexMatSettings1.g;
            samples.normSAO0.b = saturate(samples.normSAO0.b);
            samples.normSAO1.b = saturate(samples.normSAO1.b);
            #if !_MAX2LAYER
               samples.normSAO2.b += perTexMatSettings2.g;
               samples.normSAO2.b = saturate(samples.normSAO2.b);
            #endif
            #if !_MAX3LAYER || !_MAX2LAYER
               samples.normSAO3.b += perTexMatSettings3.g;
               samples.normSAO3.b = saturate(samples.normSAO3.b);
            #endif
         #endif

         
         #if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_DEFERRED) || (defined(_MSRENDERLOOP_UNITYLD) && defined(_PASSFORWARD) || _MSRENDERLOOP_UNITYHD) 
          #if _PERTEXSSS
          {
            SAMPLE_PER_TEX(ptSSS, 18.5, config, half4(1, 1, 1, 1)); // tint, thickness
            
            half4 vals = ptSSS0 * heightWeights.x + ptSSS1 * heightWeights.y + ptSSS2 * heightWeights.z + ptSSS3 * heightWeights.w;
            SSSThickness = vals.a;
            SSSTint = vals.rgb;
          }
          #endif
         #endif

         #if (((_DETAILNOISE && _PERTEXDETAILNOISESTRENGTH) || (_DISTANCENOISE && _PERTEXDISTANCENOISESTRENGTH)) || (_NORMALNOISE && _PERTEXNORMALNOISESTRENGTH)) && !_DISABLESPLATMAPS
         ApplyDetailDistanceNoisePerTex(samples, config, camDist, i.worldPos, worldNormalVertex);
         #endif

         
         #if _GLOBALNOISEUV
            // noise defaults so that a value of 1, 1 is 4 pixels in size and moves the uvs by 1 pixel max.
            #if _CUSTOMSPLATTEXTURES
               noiseUV = (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, config.uv * _CustomControl0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _CustomControl0_TexelSize.xy * _NoiseUVParams.y;
            #else
               noiseUV = (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, config.uv * _Control0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _Control0_TexelSize.xy * _NoiseUVParams.y;
            #endif
         #endif

         
         #if _TRAXSINGLE || _TRAXARRAY || _TRAXNOTEXTURE
            ApplyTrax(samples, config, i.worldPos, traxBuffer, traxNormal);
         #endif

         #if (_ANTITILEARRAYDETAIL || _ANTITILEARRAYDISTANCE || _ANTITILEARRAYNORMAL) && !_DISABLESPLATMAPS
         ApplyAntiTilePerTex(samples, config, camDist, i.worldPos, worldNormalVertex, heightWeights);
         #endif

         #if _GEOMAP && !_DISABLESPLATMAPS
         GeoTexturePerTex(samples, i.worldPos, worldHeight, config, worldNormalVertex, upVector);
         #endif
         
         #if _GLOBALTINT && _PERTEXGLOBALTINTSTRENGTH && !_DISABLESPLATMAPS
         GlobalTintTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALNORMALS && _PERTEXGLOBALNORMALSTRENGTH && !_DISABLESPLATMAPS
         GlobalNormalTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALSMOOTHAOMETAL && _PERTEXGLOBALSAOMSTRENGTH && !_DISABLESPLATMAPS
         GlobalSAOMTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _GLOBALEMIS && _PERTEXGLOBALEMISSTRENGTH && !_DISABLESPLATMAPS
         GlobalEmisTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _GLOBALSPECULAR && _PERTEXGLOBALSPECULARSTRENGTH && !_DISABLESPLATMAPS && _USESPECULARWORKFLOW
         GlobalSpecularTexturePerTex(samples, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _PERTEXMETALLIC && !_DISABLESPLATMAPS
            half metallic = BlendWeights(perTexMatSettings0.a, perTexMatSettings1.a, perTexMatSettings2.a, perTexMatSettings3.a, heightWeights);
            o.Metallic = metallic;
         #endif

         #if _GLITTER && !_DISABLESPLATMAPS
            DoGlitter(i, samples, config, camDist, worldNormalVertex, i.worldPos);
         #endif
         
         // Blend em..
         #if _DISABLESPLATMAPS
            // If we don't sample from the _Diffuse, then the shader compiler will strip the sampler on
            // some platforms, which will cause everything to break. So we sample from the lowest mip
            // and saturate to 1 to keep the cost minimal. Annoying, but the compiler removes the texture
            // and sampler, even though the sampler is still used.
            albedo = saturate(UNITY_SAMPLE_TEX2DARRAY_LOD(_Diffuse, float3(0,0,0), 12) + 1);
            albedo.a = 0.5; // make height something we can blend with for the combined mesh mode, since it still height blends.
            normSAO = half4(0,0,0,1);
         #else
            albedo = BlendWeights(samples.albedo0, samples.albedo1, samples.albedo2, samples.albedo3, heightWeights);
            normSAO = BlendWeights(samples.normSAO0, samples.normSAO1, samples.normSAO2, samples.normSAO3, heightWeights);
            #if _USEEMISSIVEMETAL && !_DISABLESPLATMAPS
               emisMetal = BlendWeights(samples.emisMetal0, samples.emisMetal1, samples.emisMetal2, samples.emisMetal3, heightWeights);
            #endif

            #if _USESPECULARWORKFLOW && !_DISABLESPLATMAPS
               specular = BlendWeights(samples.specular0, samples.specular1, samples.specular2, samples.specular3, heightWeights);
            #endif
         #endif

         
         // ADVANCEDTERRAIN_ENTRYPOINT 


         #if _MESHOVERLAYSPLATS || _MESHCOMBINED
            o.Alpha = 1.0;
            if (config.uv0.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.x;
            else if (config.uv1.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.y;
            else if (config.uv2.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.z;
            else if (config.uv3.z == _MeshAlphaIndex)
               o.Alpha = 1 - heightWeights.w;
         #endif



         // effects which don't require per texture adjustments and are part of the splats sample go here. 
         // Often, as an optimization, you can compute the non-per tex version of above effects here..


         #if ((_DETAILNOISE && !_PERTEXDETAILNOISESTRENGTH) || (_DISTANCENOISE && !_PERTEXDISTANCENOISESTRENGTH) || (_NORMALNOISE && !_PERTEXNORMALNOISESTRENGTH))
            ApplyDetailDistanceNoise(albedo.rgb, normSAO, config, camDist, i.worldPos, worldNormalVertex);
         #endif

         #if _SPLATFADE
         }
         #endif

         #if _SPLATFADE
            // blend in uniform texture over splat fade range
            // only for planets? Fine on terrain, but may want a switch for this..
            #if _TRIPLANAR && (_PLANETNORMAL || _PLANETNORMAL2)
               

               float3 pN = pow(abs(worldNormalVertex), 0.7);
               pN = pN / (pN.x + pN.y + pN.z);
            
               half3 axisSign = sign(worldNormalVertex);

               float2 uv0 = i.worldPos.zy * axisSign.x * _TriplanarUVScale.xy;
               float2 uv1 = i.worldPos.xz * axisSign.y * _TriplanarUVScale.xy;
               float2 uv2 = i.worldPos.xy * axisSign.z * _TriplanarUVScale.xy;

               float2 sfDX = ddx(uv0);
               float2 sfDY = ddy(uv0);

               MSBRANCHOTHER(camDist - _SplatFade.x)
               {
                  float falloff = saturate(InverseLerp(_SplatFade.x, _SplatFade.y, camDist));
                  half4 sfalb0 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(uv0, _SplatFade.z), sfDX, sfDY);
                  half4 sfalb1 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(uv1, _SplatFade.z), sfDX, sfDY);
                  half4 sfalb2 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(uv2, _SplatFade.z), sfDX, sfDY);
                  COUNTSAMPLE
                  COUNTSAMPLE
                  COUNTSAMPLE
                  albedo.rgb = lerp(albedo.rgb, sfalb0.rgb * pN.x + sfalb1 * pN.y + sfalb2 * pN.z, falloff);

                  #if !_NONOMALMAP
                     half4 sfnormSAO0 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(uv0, _SplatFade.z), sfDX, sfDY).garb;
                     half4 sfnormSAO1 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(uv1, _SplatFade.z), sfDX, sfDY).garb;
                     half4 sfnormSAO2 = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(uv2, _SplatFade.z), sfDX, sfDY).garb;
                     COUNTSAMPLE
                     COUNTSAMPLE
                     COUNTSAMPLE
                     half4 sfnormSAO = sfnormSAO0 * pN.x + sfnormSAO1 * pN.y + sfnormSAO2 * pN.z;
                     sfnormSAO.xy = sfnormSAO.xy * 2 - 1;

                     normSAO = lerp(normSAO, sfnormSAO, falloff);
                  #endif
              
               }
            #else // _TRIPLANAR && (_PLANETNORMAL || _PLANETNORMAL2)
            float2 sfDX = ddx(config.uv * _UVScale);
            float2 sfDY = ddy(config.uv * _UVScale);

            MSBRANCHOTHER(camDist - _SplatFade.x)
            {
               float falloff = saturate(InverseLerp(_SplatFade.x, _SplatFade.y, camDist));
               half4 sfalb = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_Diffuse, float3(config.uv * _UVScale, _SplatFade.z), sfDX, sfDY);
               COUNTSAMPLE
               albedo.rgb = lerp(albedo.rgb, sfalb.rgb, falloff);

               #if !_NONOMALMAP
                  half4 sfnormSAO = MICROSPLAT_SAMPLE_TEX2DARRAY_GRAD(_NormalSAO, float3(config.uv * _UVScale, _SplatFade.z), sfDX, sfDY).garb;
                  COUNTSAMPLE
                  sfnormSAO.xy = sfnormSAO.xy * 2 - 1;

                  normSAO = lerp(normSAO, sfnormSAO, falloff);
               #endif
              
            }
            #endif
         #endif


         #if _MESHCOMBINED
            SampleMeshCombined(albedo, normSAO, emisMetal, specular, o.Alpha, SSSThickness, SSSTint, config, heightWeights);
         #endif
         
         #if _SCATTER
            ApplyScatter(i, albedo, normSAO, config.uv, camDist);
         #endif

         #if _GEOMAP
            GeoTexture(albedo.rgb, normSAO, i.worldPos, worldHeight, config, worldNormalVertex, upVector);
         #endif

         #if _PLANETALBEDO || _PLANETNORMAL || _PLANETALBEDO2 || _PLANETNORMAL2
            ApplyPlanet(i, albedo, normSAO, config, camDist, i.worldPos, worldNormalVertex);
         #endif


         #if _GLOBALTINT && !_PERTEXGLOBALTINTSTRENGTH
            GlobalTintTexture(albedo.rgb, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _VSGRASSMAP
            VSGrassTexture(albedo.rgb, config, camDist);
         #endif

         #if _GLOBALNORMALS && !_PERTEXGLOBALNORMALSTRENGTH
            GlobalNormalTexture(normSAO, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALSMOOTHAOMETAL && !_PERTEXGLOBALSAOMSTRENGTH
            GlobalSAOMTexture(normSAO, emisMetal, config, camDist, globalSlopeFilter, noiseUV);
         #endif
         
         #if _GLOBALEMIS && !_PERTEXGLOBALEMISSTRENGTH
            GlobalEmisTexture(emisMetal, config, camDist, globalSlopeFilter, noiseUV);
         #endif

         #if _GLOBALSPECULAR && !_PERTEXGLOBALSPECULARSTRENGTH && _USESPECULARWORKFLOW
            GlobalSpecularTexture(specular.rgb, config, camDist, globalSlopeFilter, noiseUV);
         #endif

        
         
         o.Albedo = albedo.rgb;
         o.Height = albedo.a;
         o.Normal = half3(normSAO.xy, 1);
         o.Smoothness = normSAO.b;
         o.Occlusion = normSAO.a;

         #if _USEEMISSIVEMETAL || _GLOBALSMOOTHAOMETAL || _GLOBALEMIS 
         o.Emission = emisMetal.rgb;
         o.Metallic = emisMetal.a;
	        #if _USEEMISSIVEMETAL
	        o.Emission *= _EmissiveMult;
	        #endif
         #endif

         #if _USESPECULARWORKFLOW
            o.Specular = specular;
         #endif


         


         #if _WETNESS || _PUDDLES || _STREAMS || _LAVA
         pud = DoStreams(i, o, fxLevels, config.uv, porosity, waterNormalFoam, worldNormalVertex, streamFoam, wetLevel, burnLevel, i.worldPos);
         #endif

         
         #if _SNOW
         snowCover = DoSnow(o, config.uv, WorldNormalVector(i, o.Normal), worldNormalVertex, i.worldPos, pud, porosity, camDist, 
            config, weights, SSSTint, SSSThickness, traxBuffer, traxNormal);
         #endif

         #if _PERTEXSSS || _MESHCOMBINEDUSESSS || (_SNOW && _SNOWSSS)
         {
            half3 worldView = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

            o.Emission += ComputeSSS(i, worldView, WorldNormalVector(i, half3(normSAO.xy, 1)),
               SSSTint, SSSThickness, _SSSDistance, _SSSScale, _SSSPower);
         }
         #endif
         
         #if _SNOWGLITTER
            DoSnowGlitter(i, config, o, camDist, worldNormalVertex, snowCover);
         #endif

         #if _WINDPARTICULATE || _SNOWPARTICULATE
         DoWindParticulate(i, o, config, weights, camDist, worldNormalVertex, snowCover);
         #endif

         o.Normal.z = sqrt(1 - saturate(dot(o.Normal.xy, o.Normal.xy)));

         #if _SPECULARFADE
         {
            float specFade = saturate((i.worldPos.y - _SpecularFades.x) / max(_SpecularFades.y - _SpecularFades.x, 0.0001));
            o.Metallic *= specFade;
            o.Smoothness *= specFade;
         }
         #endif

         #if _VSSHADOWMAP
         VSShadowTexture(o, i, config, camDist);
         #endif
         
         #if _TOONWIREFRAME
         ToonWireframe(config.uv, o.Albedo);
         #endif

         #if _DEBUG_TRAXBUFFER
            ClearAllButAlbedo(o, half3(traxBuffer, 0, 0) * saturate(o.Albedo.z+1));
         #elif _DEBUG_WORLDNORMALVERTEX
            ClearAllButAlbedo(o, worldNormalVertex * saturate(o.Albedo.z+1));
         #elif _DEBUG_WORLDNORMAL
            ClearAllButAlbedo(o,  WorldNormalVector(i, o.Normal) * saturate(o.Albedo.z+1));
         #endif

         return o;
      }
      
      void SampleSplats(float2 controlUV, inout half4 w0, inout half4 w1, inout half4 w2, inout half4 w3, inout half4 w4, inout half4 w5, inout half4 w6, inout half4 w7)
      {
         #if _CUSTOMSPLATTEXTURES
            #if !_MICROMESH
            controlUV = (controlUV * (_CustomControl0_TexelSize.zw - 1.0f) + 0.5f) * _CustomControl0_TexelSize.xy;
            #endif

            #if  _CONTROLNOISEUV
               controlUV += (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, controlUV * _CustomControl0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _CustomControl0_TexelSize.xy * _NoiseUVParams.y;
            #endif

            w0 = UNITY_SAMPLE_TEX2D(_CustomControl0, controlUV);
            COUNTSAMPLE

            #if !_MAX4TEXTURES
            w1 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl1, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES
            w2 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl2, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
            w3 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl3, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w4 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl4, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w5 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl5, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX28TEXTURES || _MAX32TEXTURES
            w6 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl6, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX32TEXTURES
            w7 = UNITY_SAMPLE_TEX2D_SAMPLER(_CustomControl7, _CustomControl0, controlUV);
            COUNTSAMPLE
            #endif
         #else
            #if !_MICROMESH
            controlUV = (controlUV * (_Control0_TexelSize.zw - 1.0f) + 0.5f) * _Control0_TexelSize.xy;
            #endif

            #if  _CONTROLNOISEUV
               controlUV += (UNITY_SAMPLE_TEX2D_SAMPLER(_NoiseUV, _Diffuse, controlUV * _Control0_TexelSize.zw * 0.2 * _NoiseUVParams.x).ga - 0.5) * _Control0_TexelSize.xy * _NoiseUVParams.y;
            #endif

            w0 = UNITY_SAMPLE_TEX2D(_Control0, controlUV);
            COUNTSAMPLE

            #if !_MAX4TEXTURES
            w1 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control1, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES
            w2 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control2, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if !_MAX4TEXTURES && !_MAX8TEXTURES && !_MAX12TEXTURES
            w3 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control3, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX20TEXTURES || _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w4 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control4, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX24TEXTURES || _MAX28TEXTURES || _MAX32TEXTURES
            w5 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control5, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX28TEXTURES || _MAX32TEXTURES
            w6 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control6, _Control0, controlUV);
            COUNTSAMPLE
            #endif

            #if _MAX32TEXTURES
            w7 = UNITY_SAMPLE_TEX2D_SAMPLER(_Control7, _Control0, controlUV);
            COUNTSAMPLE
            #endif
         #endif
      }   


      

      MicroSplatLayer SurfImpl(Input i, float3 worldNormalVertex)
      {
         // with DrawInstanced on, view dir is incorrect, so we compute it here. Thanks Obama..
         #if _MSRENDERLOOP_SURFACESHADER && !_DEBUG_USE_TOPOLOGY &&!_TERRAINBLENDABLESHADER && !_MICROMESH && !_MICROMESHTERRAIN && !_MICROPOLARISMESH &&!_MICRODIGGERMESH && !_MICROVERTEXMESH && defined(UNITY_INSTANCING_ENABLED)
            float3 t2w0 = WorldNormalVector(i, float3(1,0,0));
            float3 t2w1 = WorldNormalVector(i, float3(0,1,0));
            float3 t2w2 = WorldNormalVector(i, float3(0,0,1));
            float3x3 t2w = float3x3(t2w0, t2w1, t2w2);
            i.viewDir = normalize(mul(t2w, (_WorldSpaceCameraPos - i.worldPos)));
         #elif !_MSRENDERLOOP_SURFACESHADER
            // tangent space view dir is just not correct in URP
            i.viewDir = normalize( mul(i.TBN, (_WorldSpaceCameraPos - i.worldPos)) );
         #endif


         #if _TERRAINBLENDABLESHADER && _TRIPLANAR
            worldNormalVertex = WorldNormalVector(i, float3(0,0,1));
         #endif
         
         float camDist = distance(_WorldSpaceCameraPos, i.worldPos);
          
         #if _FORCELOCALSPACE
            #if _PLANETVECTORS
                worldNormalVertex = mul(_PQSToLocal, float4(worldNormalVertex, 1)).xyz;
                i.worldPos = i.worldPos + mul(_PQSToLocal, float4(0,0,0,1)).xyz;
             #else
                worldNormalVertex = mul((float3x3)GetWorldToObjectMatrix(), worldNormalVertex).xyz;
                i.worldPos = i.worldPos -  mul(GetObjectToWorldMatrix(), float4(0,0,0,1)).xyz;
             #endif
         #endif

         #if _ORIGINSHIFT
             //worldNormalVertex = mul(_GlobalOriginMTX, float4(worldNormalVertex, 1)).xyz;
             i.worldPos = i.worldPos + mul(_GlobalOriginMTX, float4(0,0,0,1)).xyz;
         #endif

         #if _DEBUG_USE_TOPOLOGY
            i.worldPos = UNITY_SAMPLE_TEX2D_SAMPLER(_DebugWorldPos, _Diffuse, i.uv_Control0);
            worldNormalVertex = UNITY_SAMPLE_TEX2D_SAMPLER(_DebugWorldNormal, _Diffuse, i.uv_Control0);
         #endif

         #if _ALPHABELOWHEIGHT && !_TBDISABLEALPHAHOLES
            ClipWaterLevel(i.worldPos);
         #endif

         #if !_TBDISABLEALPHAHOLES && defined(_ALPHATEST_ON)
            // UNITY 2019.3 holes
            ClipHoles(i.uv_Control0);
         #endif


         float2 origUV = i.uv_Control0;

         #if _MICROMESH && _MESHUV2
         float2 controlUV = i.uv2_Diffuse;
         #else
         float2 controlUV = i.uv_Control0;
         #endif


         #if _MICROMESH
            controlUV = InverseLerp(_UVMeshRange.xy, _UVMeshRange.zw, controlUV);
         #endif

         half4 weights = half4(1,0,0,0);

         Config config = (Config)0;
         UNITY_INITIALIZE_OUTPUT(Config,config);
         config.uv = origUV;

         #if _SPLATFADE
         MSBRANCHOTHER(_SplatFade.y - camDist)
         #endif // _SPLATFADE
         {
            #if !_DISABLESPLATMAPS

               // Sample the splat data, from textures or vertices, and setup the config..
               #if _MICRODIGGERMESH
                  DiggerSetup(i, weights, origUV, config, i.worldPos);
               #elif _MICROVERTEXMESH
                  VertexSetup(i, weights, origUV, config, i.worldPos);
               #elif !_PROCEDURALTEXTURE || _PROCEDURALBLENDSPLATS
                  half4 w0 = 0; half4 w1 = 0; half4 w2 = 0; half4 w3 = 0; half4 w4 = 0; half4 w5 = 0; half4 w6 = 0; half4 w7 = 0;
                  SampleSplats(controlUV, w0, w1, w2, w3, w4, w5, w6, w7);
                  Setup(weights, origUV, config, w0, w1, w2, w3, w4, w5, w6, w7, i.worldPos);
               #endif

               #if _PROCEDURALTEXTURE
                  float3 up = float3(0,1,0);
                  float3 procNormal = worldNormalVertex;
                  float height = i.worldPos.y;
                  ProceduralSetup(i, i.worldPos, height, procNormal, up, weights, origUV, config, ddx(origUV), ddy(origUV), ddx(i.worldPos), ddy(i.worldPos));

                  #if _PLANETNORMAL2 || _PLANETNORMAL
                     config.uv = origUV;
                     float2 pnorm = GetPlanetTangentNormal(i, config, camDist, worldNormalVertex);
                     procNormal.xy = pnorm;
                     procNormal.z = sqrt(1 - procNormal.x * procNormal.x - procNormal.y * procNormal.y);
                     procNormal = WorldNormalVector(i, procNormal);
                     up = worldNormalVertex;
                     float3 center = mul(GetWorldToObjectMatrix(), float3(0,0,0));
                     height = distance(i.worldPos, center); 
                  #endif
               #endif
            #else // _DISABLESPLATMAPS
                Setup(weights, origUV, config, half4(1,0,0,0), 0, 0, 0, 0, 0, 0, 0, i.worldPos);
            #endif
         } // _SPLATFADE else case

         
         #if _TOONFLATTEXTURE
            float2 quv = floor(origUV * _ToonTerrainSize);
            float2 fuv = frac(origUV * _ToonTerrainSize);
            #if !_TOONFLATTEXTUREQUAD
               quv = Hash2D((fuv.x > fuv.y) ? quv : quv * 0.333);
            #endif
            float2 uvq = quv / _ToonTerrainSize;
            config.uv0.xy = uvq;
            config.uv1.xy = uvq;
            config.uv2.xy = uvq;
            config.uv3.xy = uvq;
         #endif
         
         #if (_TEXTURECLUSTER2 || _TEXTURECLUSTER3) && !_DISABLESPLATMAPS
            PrepClusters(origUV, config, i.worldPos, worldNormalVertex);
         #endif

         #if (_ALPHAHOLE || _ALPHAHOLETEXTURE) && !_DISABLESPLATMAPS && !_TBDISABLEALPHAHOLES
         ClipAlphaHole(config, weights);
         #endif


 
         MicroSplatLayer l = Sample(i, weights, config, camDist, worldNormalVertex);

         
         // HI, this is the section where we hack around various Unity and compiler bugs..

         // Unity has a compiler bug with surface shaders where in some situations it will strip/fuckup
         // i.worldPos or i.viewDir thinking your not using them when you are inside a function. I have
         // fought with this bug so many times it's crazy, reported it and provided repros, and nothing has
         // been done about it. So, make sure these are used, and look like they could have an effect on the final
         // output so the compiler doesn't fuck them up.
         
         // Oh, nice, and it turns out that doing this in the base map shader breaks GI, so only do it in the main
         // shader, which is where we're using i.viewDir for parallax. Fucking hell..

         // AND if triplanar is on, this needs to be run otherwise the UV scale is fucked. I feel like I'm just
         // pushing compiler errors around at this point.. And this breaks render baking, so not then either.
         //
         // And sometimes VD is INF or NAN, so we copy it (make sure the compiler knows we are using) and
         // test for a value, and if it's not 1 we make it 1, so it doesn't make albedo black.
         //
         // Jusus fucking christ already..
         #if (!_MICROSPLATBASEMAP || _TRIPLANAR) && !_RENDERBAKE
            float3 vd = i.viewDir;
            if (vd.x != 1)
               vd = 1;
            l.Albedo *= saturate(vd + i.worldPos + 9999);
         #endif

         // Further, on windows, sometimes the diffuse sampler gets stripped, so we have to do this crap.
         // We sample from the lowest mip, so it shouldn't cost much, but still, I hate this, wtf..
         l.Albedo *= saturate(UNITY_SAMPLE_TEX2DARRAY_LOD(_Diffuse, config.uv0, 11).r + 2);
         // same for the control sampler.
         l.Albedo *= saturate(MICROSPLAT_SAMPLE_TEX2D_SAMPLER_LOD(_Control0, _Control0, config.uv, 11).r + 2);

         #if _PROCEDURALTEXTURE
            ProceduralTextureDebugOutput(l, weights, config);
         #endif
         


         return l;

      }



   


                    //MS_BLENDABLE

                    






    
    MicroSplatLayer DoMicroSplat(inout SurfaceDescriptionInputs IN)
    {
       SurfaceDescription surface = (SurfaceDescription)0;
       Input i = DescToInput(IN);
       float3 worldNormalVertex = IN.WorldSpaceNormal;

        #if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL) && !_MICROMESH && !_MICROMESHTERRAIN && !_MICROPOLARISMESH && !_MICRODIGGERMESH && !_MICROVERTEXMESH
            float2 terrainNormalMapUV = (i.uv_Control0.xy + 0.5f) * _TerrainHeightmapRecipSize.xy;
            i.uv_Control0.xy *= _TerrainHeightmapRecipSize.zw;
            

            #if _TOONHARDEDGENORMAL
               terrainNormalMapUV = ToonEdgeUV(terrainNormalMapUV);
            #endif
            float3 geomNormal = normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, terrainNormalMapUV).xyz * 2 - 1);

            worldNormalVertex = mul((float3x3)GetObjectToWorldMatrix(), geomNormal);
            IN.WorldSpaceNormal = worldNormalVertex;
            float4 tangentWS = ConstructTerrainTangent(IN.WorldSpaceNormal, GetObjectToWorldMatrix()._13_23_33);
            IN.WorldSpaceTangent = tangentWS.xyz;
            i.TBN = BuildTangentToWorld(tangentWS, IN.WorldSpaceNormal.xyz);
            IN.WorldSpaceBiTangent = i.TBN[1].xyz;
        #elif _PERPIXNORMAL
            float2 perPixUV = i.uv_Control0;
            #if _TOONHARDEDGENORMAL
               perPixUV = ToonEdgeUV(perPixUV);
            #endif
            float3 geomNormal = (UnpackNormal(UNITY_SAMPLE_TEX2D_SAMPLER(_PerPixelNormal, _Diffuse, perPixUV))).xzy;
            worldNormalVertex = geomNormal;
        #endif    
        
         
         #if _SRPTERRAINBLEND
            SurfaceOutputCustom soc = (SurfaceOutputCustom)0;
            soc.input = i;
            float3 sh = 0;
            BlendWithTerrainSRP(soc, IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);

            MicroSplatLayer l = (MicroSplatLayer)0;
            l.Albedo = soc.Albedo;
            l.Normal = mul(float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal), soc.Normal);
            l.Emission = soc.Emission;
            l.Metallic = soc.Metallic;
            l.Smoothness = soc.Smoothness;
            #if _USESPECULARWORKFLOW
               l.Specular = soc.Specular;
            #endif
            l.Occlusion = soc.Occlusion;
            l.Alpha = soc.Alpha;

         #else
            MicroSplatLayer l = SurfImpl(i, worldNormalVertex);
         #endif


       // per pixel normal
        #if ((defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)) && !_MICROMESHTERRAIN && !_MICROMESH && !_MICROVERTEXMESH && !_MICRODIGGERMESH && !_MICROPOLARISMESH) || (_MICROMESHTERRAIN && _PERPIXNORMAL)
            float3 geomTangent = normalize(cross(geomNormal, float3(0, 0, 1)));
            float3 geomBitangent = normalize(cross(geomTangent, geomNormal));
            l.Normal = l.Normal.x * geomTangent + l.Normal.y * geomBitangent + l.Normal.z * geomNormal;
            l.Normal = l.Normal.xzy;
        #endif

        DoDebugOutput(l);


        return l;
    }



        

                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        MicroSplatLayer l = DoMicroSplat(IN);

                        SurfaceDescription surface = (SurfaceDescription)0;
                        surface.Albedo = l.Albedo;
                        surface.Normal = l.Normal;
                        surface.BentNormal = IN.TangentSpaceNormal;
                        surface.CoatMask = 0;
                        surface.Smoothness = l.Smoothness;
                        #if _USESPECULARWORKFLOW
                           surface.Specular = l.Specular;
                        #endif
                        surface.Metallic = l.Metallic;
                        surface.Occlusion = l.Occlusion;
                        surface.Emission = l.Emission;
                        surface.Alpha = l.Alpha;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    output.texCoord0 = input.texCoord0;
                    output.texCoord1 = input.texCoord1;
                    output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    //output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    // output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    output.WorldSpaceNormal =            normalize(input.tangentToWorld[2].xyz);
                    // output.ObjectSpaceNormal =           mul(output.WorldSpaceNormal, (float3x3) GetObjectToWorldMatrix());           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    // output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // specularOcclusion need to be init ahead of decal to quiet the compiler that modify the SurfaceData struct
                // however specularOcclusion can come from the graph, so need to be init here so it can be override.
                surfaceData.specularOcclusion = 1.0;
        
                // copy across graph values, if defined
                surfaceData.baseColor =                 surfaceDescription.Albedo;
                surfaceData.perceptualSmoothness =      surfaceDescription.Smoothness;
                surfaceData.ambientOcclusion =          surfaceDescription.Occlusion;
                // surfaceData.specularOcclusion =         surfaceDescription.SpecularOcclusion;
                surfaceData.metallic =                  surfaceDescription.Metallic;
                // surfaceData.subsurfaceMask =            surfaceDescription.SubsurfaceMask;
                // surfaceData.thickness =                 surfaceDescription.Thickness;
                // surfaceData.diffusionProfileHash =      asuint(surfaceDescription.DiffusionProfileHash);
                #if _USESPECULARWORKFLOW
                   surfaceData.specularColor =             surfaceDescription.Specular;
                #endif
                surfaceData.coatMask =                  surfaceDescription.CoatMask;
                // surfaceData.anisotropy =                surfaceDescription.Anisotropy;
                // surfaceData.iridescenceMask =           surfaceDescription.IridescenceMask;
                // surfaceData.iridescenceThickness =      surfaceDescription.IridescenceThickness;
        
        #ifdef _HAS_REFRACTION
                if (_EnableSSRefraction)
                {
                    // surfaceData.ior =                       surfaceDescription.RefractionIndex;
                    // surfaceData.transmittanceColor =        surfaceDescription.RefractionColor;
                    // surfaceData.atDistance =                surfaceDescription.RefractionDistance;
        
                    surfaceData.transmittanceMask = (1.0 - surfaceDescription.Alpha);
                    surfaceDescription.Alpha = 1.0;
                }
                else
                {
                    surfaceData.ior = 1.0;
                    surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                    surfaceData.atDistance = 1.0;
                    surfaceData.transmittanceMask = 0.0;
                    surfaceDescription.Alpha = 1.0;
                }
        #else
                surfaceData.ior = 1.0;
                surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                surfaceData.atDistance = 1.0;
                surfaceData.transmittanceMask = 0.0;
        #endif
                
                // These static material feature allow compile time optimization
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
                // surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_CLEAR_COAT;
        
        #ifdef _MATERIAL_FEATURE_IRIDESCENCE
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
        #endif
        #ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
        #endif
        
        #if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
                // Require to have setup baseColor
                // Reproduce the energy conservation done in legacy Unity. Not ideal but better for compatibility and users can unchek it
                surfaceData.baseColor *= (1.0 - Max3(surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b));
        #endif
        
        #ifdef _DOUBLESIDED_ON
            float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
        #else
            float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        #endif
        
                // tangent-space normal
                float3 normalTS = float3(0.0f, 0.0f, 1.0f);
                normalTS = surfaceDescription.Normal;
        
                // compute world space normal
                GetNormalWS(fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants);
        
                surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];
        
                surfaceData.tangentWS = normalize(fragInputs.tangentToWorld[0].xyz);    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
                // surfaceData.tangentWS = TransformTangentToWorld(surfaceDescription.Tangent, fragInputs.tangentToWorld);
        
        #if HAVE_DECALS
                if (_EnableDecals)
                {
                    // Both uses and modifies 'surfaceData.normalWS'.
                    DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
                    ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
                }
        #endif
        
                bentNormalWS = surfaceData.normalWS;
                // GetNormalWS(fragInputs, surfaceDescription.BentNormal, bentNormalWS, doubleSidedConstants);
        
                surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);
        
        
                // By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion.
                // If user provide bent normal then we process a better term
        #if defined(_SPECULAR_OCCLUSION_CUSTOM)
                // Just use the value passed through via the slot (not active otherwise)
        #elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
                // If we have bent normal and ambient occlusion, process a specular occlusion
                surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO(V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness(surfaceData.perceptualSmoothness));
        #elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
                surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
        #endif
        
        #ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
                surfaceData.perceptualSmoothness = GeometricNormalFiltering(surfaceData.perceptualSmoothness, fragInputs.tangentToWorld[2], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold);
        #endif
        
        #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO: need to update mip info
                    surfaceData.metallic = 0;
                }
        
                // We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
                // as it can modify attribute use for static lighting
                ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
        #ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
                uint3 fadeMaskSeed = asuint((int3)(V * _ScreenSize.xyx)); // Quantize V to _ScreenSize values
                LODDitheringTransition(fadeMaskSeed, unity_LODFade.x);
        #endif
        
        #ifdef _DOUBLESIDED_ON
            float3 doubleSidedConstants = _DoubleSidedConstants.xyz;
        #else
            float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        #endif
        
                ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdDepthPrepass);
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdDepthPostpass);
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThresholdShadow);
                
                // ApplyDepthOffsetPositionInput(V, surfaceDescription.DepthOffset, GetViewForwardDir(), GetWorldToHClipMatrix(), posInput);
        
                float3 bentNormalWS;
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS);
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal 
                InitBuiltinData(posInput, surfaceDescription.Alpha, bentNormalWS, -fragInputs.tangentToWorld[2], fragInputs.texCoord1, fragInputs.texCoord2, builtinData);
        
                // override sampleBakedGI:
                // builtinData.bakeDiffuseLighting = surfaceDescription.BakedGI;
                // builtinData.backBakeDiffuseLighting = surfaceDescription.BakedBackGI;
        
                builtinData.emissiveColor = surfaceDescription.Emission;
        
                // builtinData.depthOffset = surfaceDescription.DepthOffset;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #else
                builtinData.distortion = float2(0.0, 0.0);
                builtinData.distortionBlur = 0.0;
        #endif
        
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassForward.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }

        

      }
   Dependency "AddPassShader" = "Hidden/MicroSplat/AddPass"
   Dependency "BaseMapShader" = "Hidden/MicroSplat/Example_AlphaHole_Base-200695922"
   CustomEditor "MicroSplatShaderGUI"
   Fallback "Nature/Terrain/Diffuse"
}
