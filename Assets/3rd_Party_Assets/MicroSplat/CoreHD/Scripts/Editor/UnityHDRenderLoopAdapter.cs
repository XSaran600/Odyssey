using UnityEngine;
using System.Collections;
using UnityEditor;
using System.Text;
using JBooth.MicroSplat;
using System.Collections.Generic;
using System.Linq;

namespace JBooth.MicroSplat
{
   public class UnityHDRenderLoopAdapter : IRenderLoopAdapter
   {
      static TextAsset template;
      static TextAsset adapter;
      static TextAsset sharedInc;
      static TextAsset terrainBody;
      static TextAsset terrainBlendBody;
      static TextAsset terrainBlendCBuffer;
      static TextAsset sharedHD;
      static TextAsset properties;
      static TextAsset vertex;
      static TextAsset mainFunc;
      static TextAsset templateDecal;

      public string GetDisplayName()
      {
         return "Unity HD";
      }

      public string GetRenderLoopKeyword()
      {
         return "_MSRENDERLOOP_UNITYHD";
      }

      public int GetNumPasses() { return 1; }

      public void WriteShaderHeader(string[] features, StringBuilder sb, MicroSplatShaderGUI.MicroSplatCompiler compiler, bool blend)
      {
         sb.AppendLine("   SubShader {");


         sb.Append("      Tags{\"RenderPipeline\"=\"HDRenderPipeline\" \"RenderType\" = \"HDLitShader\" \"Queue\" = \"Geometry+100\" ");


         if (features.Contains("_MAX4TEXTURES"))
         {
            sb.Append("\"SplatCount\" = \"4\"");
         }
         else if (features.Contains("_MAX8TEXTURES"))
         {
            sb.Append("\"SplatCount\" = \"8\"");
         }
         else if (features.Contains("_MAX12TEXTURES"))
         {
            sb.Append("\"SplatCount\" = \"12\"");
         }
         else if (features.Contains("_MAX20TEXTURES"))
         {
            sb.Append("\"SplatCount\" = \"20\"");
         }
         else if (features.Contains("_MAX24TEXTURES"))
         {
            sb.Append("\"SplatCount\" = \"24\"");
         }
         else if (features.Contains("_MAX28TEXTURES"))
         {
            sb.Append("\"SplatCount\" = \"28\"");
         }
         else if (features.Contains("_MAX32TEXTURES"))
         {
            sb.Append("\"SplatCount\" = \"32\"");
         }
         else
         {
            sb.Append ("\"SplatCount\" = \"16\"");
         }
         sb.AppendLine("}");


      }

      public bool UseReplaceMethods()
      {
         return true;
      }

      public void WritePassHeader(string[] features, StringBuilder sb, MicroSplatShaderGUI.MicroSplatCompiler compiler, int pass, bool blend)
      {

      }


      public void WriteVertexFunction(string[] features, StringBuilder sb, MicroSplatShaderGUI.MicroSplatCompiler compiler, int pass, bool blend)
      {

      }

      public void WriteFragmentFunction(string[] features, StringBuilder sb, MicroSplatShaderGUI.MicroSplatCompiler compiler, int pass, bool blend)
      {


      }

      public void WritePerMaterialCBuffer(string[] functions, StringBuilder sb, bool blend)
      {

      }


      public void WriteShaderFooter(string[] features, StringBuilder sb, MicroSplatShaderGUI.MicroSplatCompiler compiler, bool blend, string baseName)
      {
         sb.AppendLine("      }");
         if (blend)
         {
            sb.AppendLine("   CustomEditor \"MicroSplatBlendableMaterialEditor\"");
         }
         else if (baseName != null)
         {
            if (!features.Contains ("_MICROMESH"))
            {
               sb.AppendLine ("   Dependency \"AddPassShader\" = \"Hidden/MicroSplat/AddPass\"");
               sb.AppendLine ("   Dependency \"BaseMapShader\" = \"" + baseName + "\"");
               //sb.AppendLine ("   Dependency \"BaseMapGenShader\" = \"" + baseName + "\"");
            }
            sb.AppendLine("   CustomEditor \"MicroSplatShaderGUI\"");
         }
         sb.AppendLine("   Fallback \"Nature/Terrain/Diffuse\"");
         sb.Append("}");
      }

      public void Init(string[] paths)
      {
         for (int i = 0; i < paths.Length; ++i)
         {
            string p = paths[i];
            if (p.EndsWith("microsplat_terrain_unityhd_template.txt"))
            {
               template = AssetDatabase.LoadAssetAtPath<TextAsset>(p);
            }
            if (p.EndsWith("microsplat_terrain_unityhd_template_decal.txt"))
            {
               templateDecal = AssetDatabase.LoadAssetAtPath<TextAsset>(p);
            }
            if (p.EndsWith("microsplat_terrain_unityhd_adapter.txt"))
            {
               adapter = AssetDatabase.LoadAssetAtPath<TextAsset>(p);
            }
            if (p.EndsWith("microsplat_terrainblend_body.txt"))
            {
               terrainBlendBody = AssetDatabase.LoadAssetAtPath<TextAsset>(p);
            }
            if (p.EndsWith("microsplat_terrainblend_cbuffer.txt"))
            {
                terrainBlendCBuffer = AssetDatabase.LoadAssetAtPath<TextAsset>(p);
            }

            if (p.EndsWith("microsplat_terrain_body.txt"))
            {
               terrainBody = AssetDatabase.LoadAssetAtPath<TextAsset>(p);
            }
            if (p.EndsWith("microsplat_shared.txt"))
            {
               sharedInc = AssetDatabase.LoadAssetAtPath<TextAsset>(p);
            }
            if (p.EndsWith("microsplat_terrain_unityhd_shared.txt"))
            {
               sharedHD = AssetDatabase.LoadAssetAtPath<TextAsset>(p);
            }
            if (p.EndsWith("microsplat_terrain_unityhd_properties.txt"))
            {
               properties = AssetDatabase.LoadAssetAtPath<TextAsset>(p);
            }
            if (p.EndsWith("microsplat_terrain_unityhd_vertex.txt"))
            {
               vertex = AssetDatabase.LoadAssetAtPath<TextAsset>(p);
            }
            if (p.EndsWith("microsplat_terrain_unityhd_mainfunc.txt"))
            {
               mainFunc = AssetDatabase.LoadAssetAtPath<TextAsset>(p);
            }
         }
      }

      public void WriteProperties(string[] features, StringBuilder sb, bool blend)
      {
         sb.AppendLine(properties.text);
      }

      public void PostProcessShader(string[] features, StringBuilder sb, MicroSplatShaderGUI.MicroSplatCompiler compiler, bool blend)
      {
         StringBuilder temp = new StringBuilder();
         compiler.WriteFeatures(features, temp);
         if (blend)
         {
            temp.AppendLine("      #define _SRPTERRAINBLEND 1");
         }
         if (features.Contains("_TESSDISTANCE"))
         {
            temp.AppendLine("      #define TESSELLATION_ON");
            //temp.AppendLine("      #define HAVE_TESSELLATION_MODIFICATION");
            //temp.AppendLine("      #pragma shader_feature_local _ _TESSELLATION_DISPLACEMENT");
            //temp.AppendLine("      #include \"Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl\"");
            //temp.AppendLine("      #include \"Packages/com.unity.render-pipelines.core/ShaderLibrary/GeometricTools.hlsl\"");
            //temp.AppendLine("      #include \"Packages/com.unity.render-pipelines.core/ShaderLibrary/Tessellation.hlsl\"");
            //temp.AppendLine("      #include \"Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl\"");
           
            
            //temp.AppendLine("      #include \"Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl\"");
            //temp.AppendLine("      #include \"Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/VaryingMesh.hlsl\"");
         }

         StringBuilder cbuffer = new StringBuilder();
         compiler.WritePerMaterialCBuffer(features, cbuffer);
         if (blend)
         {
             cbuffer.AppendLine(terrainBlendCBuffer.text);
         }

         sb = sb.Replace("//MS_DEFINES", temp.ToString());

         sb = sb.Replace("//MS_ADAPTER", adapter.ToString());
         sb = sb.Replace("//MS_SHARED_INC", sharedInc.text);
         sb = sb.Replace("//MS_SHARED_HD", sharedHD.text);
         sb = sb.Replace("//MS_TERRAIN_BODY", terrainBody.text);
         sb = sb.Replace("//MS_VERTEXMOD", vertex.text);
         sb = sb.Replace("//MS_MAINFUNC", mainFunc.text);
         sb = sb.Replace("//MS_CBUFFER", cbuffer.ToString());


         if (blend)
         {
            sb = sb.Replace("//MS_BLENDABLE", terrainBlendBody.text);
            sb = sb.Replace("Blend [_SrcBlend] [_DstBlend], [_AlphaSrcBlend] [_AlphaDstBlend]", "Blend SrcAlpha OneMinusSrcAlpha");
         }

         // extentions
         StringBuilder ext = new StringBuilder();
         compiler.WriteExtensions(features, ext);
         foreach (var e in compiler.extensions)
         {
            e.WriteAfterVetrexFunctions(ext);
         }
         sb = sb.Replace("//MS_EXTENSIONS", ext.ToString());


         // HD fixup
         sb = sb.Replace("fixed", "half");
         sb = sb.Replace("unity_ObjectToWorld", "GetObjectToWorldMatrix()");
         sb = sb.Replace("unity_WorldToObject", "GetWorldToObjectMatrix()");
         sb = sb.Replace("_ObjectToWorld", "GetObjectToWorldMatrix()");
         sb = sb.Replace("_WorldToObject", "GetWorldToObjectMatrix()");

         sb = sb.Replace("UNITY_MATRIX_M", "GetObjectToWorldMatrix()");
         sb = sb.Replace("UNITY_MATRIX_I_M", "GetWorldToObjectMatrix()");
         sb = sb.Replace("UNITY_MATRIX_VP", "GetWorldToHClipMatrix()");
         sb = sb.Replace("UNITY_MATRIX_V", "GetWorldToViewMatrix()");
         sb = sb.Replace("UNITY_MATRIX_P", "GetViewToHClipMatrix()");

         if (features.Contains("_USESPECULARWORKFLOW"))
         {
            sb = sb.Replace("// #define _MATERIAL_FEATURE_SPECULAR_COLOR 1", "#define _MATERIAL_FEATURE_SPECULAR_COLOR 1");
         }

         if (features.Contains("_TESSDISTANCE"))
         {
            sb = sb.Replace("#pragma vertex Vert", "\n#pragma vertex Vert\n#pragma hull Hull\n#pragma domain Domain");
            //sb = sb.Replace("#pragma vertex Vert", "#pragma hull hull\n #pragma domain domain\n #pragma vertex tessvert\n#pragma require tessellation tessHW\n");
         }


      }

      public void WriteSharedCode(string[] features, StringBuilder sb, MicroSplatShaderGUI.MicroSplatCompiler compiler, int pass, bool blend)
      {
         if (blend)
         {
            sb.AppendLine(templateDecal.text);
         }
         else
         {
            sb.AppendLine(template.text);
         }
      }

      public void WriteTerrainBody(string[] features, StringBuilder sb, MicroSplatShaderGUI.MicroSplatCompiler compiler, int pass, bool blend)
      {


      }

      public MicroSplatShaderGUI.PassType GetPassType(int i)
      {
         return MicroSplatShaderGUI.PassType.Color;
      }

      public string GetVersion()
      {
         return "3.4";
      }
   }
}
