//Cristian Pop - https://boxophobic.com/

using UnityEngine;

namespace TheVegetationEngine
{
    public class TVEShaderUtils
    {
        public static void SetRenderSettings(Material material)
        {
            // Set Quality Mode
            if (material.HasProperty("_render_quality"))
            {
                int quality = material.GetInt("_render_quality");

                if (quality == 20)
                {
                    material.DisableKeyword("_SHADING_MODE_1");
                    material.EnableKeyword("_SHADING_MODE_2");
                    material.DisableKeyword("_SHADING_MODE_3");
                }
                else if (quality == 30)
                {
                    material.DisableKeyword("_SHADING_MODE_1");
                    material.DisableKeyword("_SHADING_MODE_2");
                    material.EnableKeyword("_SHADING_MODE_3");
                }
            }

            // Set Render Mode
            if (material.HasProperty("_render_mode") && material.HasProperty("_render_blend"))
            {
                int surface = material.GetInt("_render_mode");
                int blend = material.GetInt("_render_blend");
                int zwrite = material.GetInt("_render_zw");

                if (surface == 0)
                {
                    material.SetOverrideTag("RenderType", "Opaque");
                    material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Geometry;

                    // Standard and Universal Render Pipeline
                    material.SetInt("_render_src", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_render_dst", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_render_zw", 1);
                    material.SetInt("_render_blend", 0);
                    material.SetInt("_render_premul", 0);

                    // HD Render Pipeline
                    material.DisableKeyword("_SURFACE_TYPE_TRANSPARENT");
                    material.DisableKeyword("_ENABLE_FOG_ON_TRANSPARENT");

                    material.DisableKeyword("_BLENDMODE_ALPHA");
                    material.DisableKeyword("_BLENDMODE_ADD");
                    material.DisableKeyword("_BLENDMODE_PRE_MULTIPLY");

                    material.SetInt("_RenderQueueType", 1);
                    material.SetInt("_SurfaceType", 0);
                    material.SetInt("_BlendMode", 0);
                    material.SetInt("_SrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_DstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_AlphaSrcBlend", (int)UnityEngine.Rendering.BlendMode.One);
                    material.SetInt("_AlphaDstBlend", (int)UnityEngine.Rendering.BlendMode.Zero);
                    material.SetInt("_ZWrite", zwrite);
                    material.SetInt("_TransparentZWrite", zwrite);
                    material.SetInt("_ZTestDepthEqualForOpaque", 3);
                    material.SetInt("_ZTestGBuffer", 3);
                    material.SetInt("_ZTestTransparent", 4);
                }
                else
                {
                    material.SetOverrideTag("RenderType", "Transparent");
                    material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Transparent;

                    // Alpha Blend
                    if (blend == 0)
                    {
                        // Standard and Universal Render Pipeline
                        material.SetInt("_render_src", (int)UnityEngine.Rendering.BlendMode.SrcAlpha);
                        material.SetInt("_render_dst", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                        material.SetInt("_render_premul", 0);

                        // HD Render Pipeline
                        material.EnableKeyword("_SURFACE_TYPE_TRANSPARENT");
                        material.EnableKeyword("_ENABLE_FOG_ON_TRANSPARENT");

                        material.EnableKeyword("_BLENDMODE_ALPHA");
                        material.DisableKeyword("_BLENDMODE_ADD");
                        material.DisableKeyword("_BLENDMODE_PRE_MULTIPLY");

                        material.SetInt("_RenderQueueType", 5);
                        material.SetInt("_SurfaceType", 1);
                        material.SetInt("_BlendMode", 0);
                        material.SetInt("_SrcBlend", 1);
                        material.SetInt("_DstBlend", 10);
                        material.SetInt("_AlphaSrcBlend", 1);
                        material.SetInt("_AlphaDstBlend", 10);
                        material.SetInt("_ZWrite", zwrite);
                        material.SetInt("_TransparentZWrite", zwrite);
                        material.SetInt("_ZTestDepthEqualForOpaque", 4);
                        material.SetInt("_ZTestGBuffer", 3);
                        material.SetInt("_ZTestTransparent", 4);
                    }
                    // Premultiply Blend
                    else if (blend == 1)
                    {
                        // Standard and Universal Render Pipeline
                        material.SetInt("_render_src", (int)UnityEngine.Rendering.BlendMode.One);
                        material.SetInt("_render_dst", (int)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                        material.SetInt("_render_premul", 1);

                        // HD Render Pipeline
                        material.EnableKeyword("_SURFACE_TYPE_TRANSPARENT");
                        material.EnableKeyword("_ENABLE_FOG_ON_TRANSPARENT");

                        material.DisableKeyword("_BLENDMODE_ALPHA");
                        material.DisableKeyword("_BLENDMODE_ADD");
                        material.EnableKeyword("_BLENDMODE_PRE_MULTIPLY");

                        material.SetInt("_RenderQueueType", 5);
                        material.SetInt("_SurfaceType", 1);
                        material.SetInt("_BlendMode", 4);
                        material.SetInt("_SrcBlend", 1);
                        material.SetInt("_DstBlend", 10);
                        material.SetInt("_AlphaSrcBlend", 1);
                        material.SetInt("_AlphaDstBlend", 10);
                        material.SetInt("_ZWrite", zwrite);
                        material.SetInt("_TransparentZWrite", zwrite);
                        material.SetInt("_ZTestDepthEqualForOpaque", 4);
                        material.SetInt("_ZTestGBuffer", 3);
                        material.SetInt("_ZTestTransparent", 4);
                    }
                    // Deprecated
                    //else if (blend == 2)
                    //{
                    //    material.SetInt("__src", (int)UnityEngine.Rendering.BlendMode.One);
                    //    material.SetInt("__dst", (int)UnityEngine.Rendering.BlendMode.One);
                    //    material.DisableKeyword("_ALPHAPREMULTIPLY_ON");
                    //    material.SetInt("__premul", 0);
                    //}
                    //else if (blend == 3)
                    //{
                    //    material.SetInt("__src", (int)UnityEngine.Rendering.BlendMode.DstColor);
                    //    material.SetInt("__dst", (int)UnityEngine.Rendering.BlendMode.Zero);
                    //    material.DisableKeyword("_ALPHAPREMULTIPLY");
                    //    material.SetInt("__premul", 0);
                    //}
                }
            }

            // Set Cull Mode
            if (material.HasProperty("_render_cull"))
            {
                int cull = material.GetInt("_render_cull");

                material.SetInt("_CullMode", cull);
                material.SetInt("_TransparentCullMode", cull);
                material.SetInt("_CullModeForward", cull);

                // Needed for HD Render Pipeline
                material.DisableKeyword("_DOUBLESIDED_ON");
            }

            // Set Clip Mode
            if (material.HasProperty("_render_clip"))
            {
                int clip = material.GetInt("_render_clip");
                float cutoff = material.GetFloat("_Cutoff");

                //material.SetFloat("_Cutoff", cutoff * clip);

                if (clip == 0)
                {
                    material.DisableKeyword("_ALPHATEST_ON");

                    // HD Render Pipeline
                    material.SetInt("_AlphaCutoffEnable", 0);
                }
                else
                {
                    material.EnableKeyword("_ALPHATEST_ON");

                    // HD Render Pipeline
                    material.SetInt("_AlphaCutoffEnable", 1);
                }

                // HD Render Pipeline
                material.SetFloat("_AlphaCutoff", cutoff);
                material.SetFloat("_AlphaCutoffPostpass", cutoff);
                material.SetFloat("_AlphaCutoffPrepass", cutoff);
                material.SetFloat("_AlphaCutoffShadow", cutoff);
            }

            // Set Render Queue Offset
            if (material.HasProperty("_render_priority"))
            {
                int priority = material.GetInt("_render_priority");
                int queueOffsetRange = 0;

                if (material.HasProperty("_IsUniversalPipeline"))
                {
                    queueOffsetRange = 50;
                }

                // HD Render Pipeline
                material.SetInt("_TransparentSortPriority", priority);

                material.renderQueue = material.renderQueue + queueOffsetRange + priority;
            }

            // Set Normals Mode
            if (material.HasProperty("_render_normals"))
            {
                int normals = material.GetInt("_render_normals");

                // Standard, Universal, HD Render Pipeline
                // Flip 0
                if (normals == 0)
                {
                    material.SetVector("_render_normals_options", new Vector4(-1, -1, -1, 0));
                    material.SetVector("_DoubleSidedConstants", new Vector4(-1, -1, -1, 0));
                }
                // Mirror 1
                else if (normals == 1)
                {
                    material.SetVector("_render_normals_options", new Vector4(1, 1, -1, 0));
                    material.SetVector("_DoubleSidedConstants", new Vector4(1, 1, -1, 0));
                }
                // None 2
                else if (normals == 2)
                {
                    material.SetVector("_render_normals_options", new Vector4(1, 1, 1, 0));
                    material.SetVector("_DoubleSidedConstants", new Vector4(1, 1, 1, 0));
                }
            }

            // Set Batching Mode
            if (material.HasProperty("_material_batching"))
            {
                int batching = material.GetInt("_material_batching");

                if (batching == 0)
                {
                    material.DisableKeyword("MATERIAL_USE_WORLD_DATA");
                    material.EnableKeyword("MATERIAL_USE_OBJECT_DATA");
                    material.SetOverrideTag("DisableBatching", "True");
                }
                else if (batching == 1)
                {
                    material.EnableKeyword("MATERIAL_USE_WORLD_DATA");
                    material.DisableKeyword("MATERIAL_USE_OBJECT_DATA");
                    material.SetOverrideTag("DisableBatching", "False");
                }
            }

            // Set Normals to 0 if no texture is used
            if (material.HasProperty("_MainNormalTex"))
            {
                if (material.GetTexture("_MainNormalTex") == null)
                {
                    material.SetFloat("_MainNormalValue", 0);
                }
            }

            // Set Normals to 0 if no texture is used
            if (material.HasProperty("_SecondNormalTex"))
            {
                if (material.GetTexture("_SecondNormalTex") == null)
                {
                    material.SetFloat("_SecondNormalValue", 0);
                }
            }

            // Assign Default HD Foliage profile
            if (material.HasProperty("_SubsurfaceDiffusion"))
            {
                if (material.GetFloat("_SubsurfaceDiffusion") == 0)
                {                    
                    material.SetFloat("_SubsurfaceDiffusion", 3.5648174285888672f);
                    material.SetVector("_SubsurfaceDiffusion_asset", new Vector4(228889264007084710000000000000000000000f, 0.000000000000000000000000012389357880079404f, 0.00000000000000000000000000000000000076932702684439582f, 0.00018220426863990724f));
                }
            }

            // Set Detail Mode
            if (material.HasProperty("_DetailMode"))
            {
                if (material.GetInt("_DetailMode") == 0)
                {
                    material.EnableKeyword("MATERIAL_USE_DETAIL_OFF");
                    material.DisableKeyword("MATERIAL_USE_DETAIL_OVERLAY");
                    material.DisableKeyword("MATERIAL_USE_DETAIL_HEIGHT");
                }
                else if (material.GetInt("_DetailMode") == 1)
                {
                    material.DisableKeyword("MATERIAL_USE_DETAIL_OFF");
                    material.EnableKeyword("MATERIAL_USE_DETAIL_OVERLAY");
                    material.DisableKeyword("MATERIAL_USE_DETAIL_HEIGHT");
                }
                else if (material.GetInt("_DetailMode") == 2)
                {
                    material.DisableKeyword("MATERIAL_USE_DETAIL_OFF");
                    material.DisableKeyword("MATERIAL_USE_DETAIL_OVERLAY");
                    material.EnableKeyword("MATERIAL_USE_DETAIL_HEIGHT");
                }
            }

            // Enable Nature Rendered support
            material.SetOverrideTag("NatureRendererInstancing", "True");
        }
    }
}
