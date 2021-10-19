// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using Boxophobic.StyledGUI;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace TheVegetationEngine
{
#if UNITY_EDITOR
    [ExecuteInEditMode]
    [AddComponentMenu("BOXOPHOBIC/The Vegetation Engine/TVE Element")]
#endif
    public class TVEElement : StyledMonoBehaviour
    {
#if UNITY_EDITOR
        [StyledBanner(0.890f, 0.745f, 0.309f, "Element", "", "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.fd5y8rbb7aia")]
        public bool styledBanner;

        [StyledMessage("Info", "Saving non Shared Elements as prefabs or using non Shared Elements in prefabs is not supported!")]
        public bool styledPrefabMessage;

        [StyledMessage("Info", "Use the Shared Mode if you want to assign the same materials on multiple Elements to optimize drawcalls! Shared Elements can be used in prefabs!")]
        public bool styledCustomMessage;

        [StyledSpace(5)]
        public bool styledSpaceMessage;

        public ElementMode elementMode = ElementMode.Colors;
        [HideInInspector]
        public ElementMode elementModeOld = ElementMode.Colors;

        [StyledSpace(5)]
        public bool styledSpace1;
#endif
        [HideInInspector]
        public TVEElementData data;
        [HideInInspector]
        public Material material;
        [HideInInspector]
        public bool isCustom = false;

#if UNITY_EDITOR
        MeshRenderer meshRenderer;
        TVEColorsVolume colorsVolume;
        TVEMotionVolume motionVolume;
        TVEExtrasVolume extrasVolume;
#endif

        void Start()
        {

#if UNITY_EDITOR

            if (GameObject.Find("The Vegetation Engine") == null)
            {
                Debug.Log("[Warning][The Vegetation Engine] " + "The Vegetation Engine manager is missing from your scene. Make sure setup it up!");
            }
            else
            {
                colorsVolume = GameObject.Find("The Vegetation Engine").GetComponent<TVEManager>().colorsVolume;
                motionVolume = GameObject.Find("The Vegetation Engine").GetComponent<TVEManager>().motionVolume;
                extrasVolume = GameObject.Find("The Vegetation Engine").GetComponent<TVEManager>().extrasVolume;
            }
#endif

            // Upgrade element to 1.0.0
            if (material != null && material.name.StartsWith("Element - "))
            {
                SaveMaterialToData();
            }

#if UNITY_EDITOR
            meshRenderer = gameObject.GetComponent<MeshRenderer>();
#endif

            // Always create a new material since it is not saved
            if (data.elementShader != null)
            {
                material = new Material(data.elementShader);
            }
            else
            {
                material = new Material(Shader.Find("BOXOPHOBIC/The Vegetation Engine/Elements/Colors Element"));
            }

            material.name = "Element";

            LoadMaterialFromData();

            // If the element is not custom, assign the element material
            if (isCustom == false)
            {
                gameObject.GetComponent<MeshRenderer>().sharedMaterial = material;
            }

            // Set Material render priority
            //int priority = material.GetInt("_render_priority");
            //int queueOffsetRange = 0;

            //if (material.HasProperty("_IsUniversalPipeline"))
            //{
            //    queueOffsetRange = 50;
            //}

            //// HD Render Pipeline
            //material.SetInt("_TransparentSortPriority", priority);

            //int renderQueue = 3000 + queueOffsetRange + priority;

            //material.renderQueue = renderQueue;

            //if (gameObject.GetComponent<MeshRenderer>().sharedMaterial != null)
            //{
            //    gameObject.GetComponent<MeshRenderer>().sharedMaterial.renderQueue = renderQueue;
            //}
        }

        void Update()
        {
            gameObject.transform.eulerAngles = new Vector3(0, gameObject.transform.eulerAngles.y, 0);

#if UNITY_EDITOR            

            if (Application.isPlaying)
            {
                return;
            }

            if (elementMode == ElementMode.Shared)
            {
                styledCustomMessage = true;
                styledPrefabMessage = false;
            }
            else
            {
                styledCustomMessage = false;
                styledPrefabMessage = true;
            }

            // Detect if a custom material is assigned
            if (meshRenderer.sharedMaterial != material && isCustom == false)
            {
                elementMode = ElementMode.Shared;
                isCustom = true;
            }

            if (elementModeOld != elementMode)
            {
                if (elementMode != ElementMode.Shared)
                {
                    gameObject.GetComponent<MeshRenderer>().sharedMaterial = material;
                    isCustom = false;
                }
                else
                {
                    gameObject.GetComponent<MeshRenderer>().sharedMaterial = null;
                    isCustom = true;
                }

                if (elementMode == ElementMode.Colors)
                {
                    material.shader = Shader.Find("BOXOPHOBIC/The Vegetation Engine/Elements/Colors Element");
                    material.SetTexture("_MainTex", Resources.Load<Texture2D>("TVE Alpha Default"));
                }
                else if (elementMode == ElementMode.ColorsHDR)
                {
                    material.shader = Shader.Find("BOXOPHOBIC/The Vegetation Engine/Elements/Colors HDR Element");
                    material.SetTexture("_MainTex", Resources.Load<Texture2D>("TVE Alpha Round"));
                }
                else if (elementMode == ElementMode.Healthiness)
                {
                    material.shader = Shader.Find("BOXOPHOBIC/The Vegetation Engine/Elements/Healthiness Element");
                    material.SetTexture("_MainTex", Resources.Load<Texture2D>("TVE Mask Default"));
                }
                else if (elementMode == ElementMode.Size)
                {
                    material.shader = Shader.Find("BOXOPHOBIC/The Vegetation Engine/Elements/Size Element");
                    material.SetTexture("_MainTex", Resources.Load<Texture2D>("TVE Mask Default"));
                }
                else if (elementMode == ElementMode.Leaves)
                {
                    material.shader = Shader.Find("BOXOPHOBIC/The Vegetation Engine/Elements/Leaves Element");
                    material.SetTexture("_MainTex", Resources.Load<Texture2D>("TVE Mask Default"));
                }
                else if (elementMode == ElementMode.Overlay)
                {
                    material.shader = Shader.Find("BOXOPHOBIC/The Vegetation Engine/Elements/Overlay Element");
                    material.SetTexture("_MainTex", Resources.Load<Texture2D>("TVE Mask Default"));
                }
                else if (elementMode == ElementMode.Wetness)
                {
                    material.shader = Shader.Find("BOXOPHOBIC/The Vegetation Engine/Elements/Wetness Element");
                    material.SetTexture("_MainTex", Resources.Load<Texture2D>("TVE Mask Round"));
                }
                //else if (elementMode == ElementMode.MotionFlow)
                //{
                //    material.shader = Shader.Find("BOXOPHOBIC/The Vegetation Engine/Elements/Motion Flow Element");
                //    material.SetTexture("_MainTex", Resources.Load<Texture2D>("TVE Mask"));
                //}
                else if (elementMode == ElementMode.MotionInteraction)
                {
                    material.shader = Shader.Find("BOXOPHOBIC/The Vegetation Engine/Elements/Motion Interaction Element");
                    material.SetTexture("_MainTex", Resources.Load<Texture2D>("TVE Interaction Default"));
                }

                gameObject.name = name.Replace(elementModeOld.ToString(), elementMode.ToString());

                elementModeOld = elementMode;
            }

            if (UnityEditor.SceneManagement.EditorSceneManager.GetActiveScene().isDirty || Selection.Contains(gameObject))
            {
                if (meshRenderer.sharedMaterial != null)
                {
                    var material = meshRenderer.sharedMaterial;

                    if (colorsVolume != null && material.HasProperty("_IsColorsShader"))
                    {
                        gameObject.layer = colorsVolume.renderLayer;
                    }

                    if (colorsVolume != null && material.HasProperty("_IsMotionShader"))
                    {
                        gameObject.layer = motionVolume.renderLayer;
                    }

                    if (colorsVolume != null && material.HasProperty("_IsExtrasShader"))
                    {
                        gameObject.layer = extrasVolume.renderLayer;
                    }
                }
            }

            if (Selection.Contains(gameObject) && isCustom == false)
            {
                SaveMaterialToData();
            }
#endif
        }

        void SaveMaterialToData()
        {
            data.elementShader = material.shader;

            data.elementIntensity = material.GetFloat("_ElementIntensity");

            if (material.HasProperty("_ElementMode"))
            {
                data.elementMode = material.GetFloat("_ElementMode");

                if (material.HasProperty("_WinterColor"))
                {
                    data.winter = material.GetColor("_WinterColor");
                    data.spring = material.GetColor("_SpringColor");
                    data.summer = material.GetColor("_SummerColor");
                    data.autumn = material.GetColor("_AutumnColor");
                }
                else
                {
                    data.winter.w = material.GetFloat("_WinterValue");
                    data.spring.w = material.GetFloat("_SpringValue");
                    data.summer.w = material.GetFloat("_SummerValue");
                    data.autumn.w = material.GetFloat("_AutumnValue");
                }
            }

            data.mainTex = material.GetTexture("_MainTex");
            data.mainUVs = material.GetVector("_MainUVs");

            if (material.HasProperty("_MainColor"))
            {
                data.main = material.GetColor("_MainColor");
            }
            else if (material.HasProperty("_MainColorHDR"))
            {
                data.main = material.GetColor("_MainColorHDR");
            }
            else if (material.HasProperty("_MainValue"))
            {
                data.main.w = material.GetFloat("_MainValue");
            }

            data.priority = material.GetFloat("_render_priority");
        }

        void LoadMaterialFromData()
        {
            material.shader = data.elementShader;

            material.SetFloat("_ElementIntensity", data.elementIntensity);
            material.SetFloat("_ElementMode", data.elementMode);

            material.SetTexture("_MainTex", data.mainTex);
            material.SetVector("_MainUVs", data.mainUVs);

            material.SetColor("_MainColor", data.main);
            material.SetColor("_MainColorHDR", data.main);
            material.SetColor("_WinterColor", data.winter);
            material.SetColor("_SpringColor", data.spring);
            material.SetColor("_SummerColor", data.summer);
            material.SetColor("_AutumnColor", data.autumn);

            material.SetFloat("_MainValue", data.main.w);
            material.SetFloat("_WinterValue", data.winter.w);
            material.SetFloat("_SpringValue", data.spring.w);
            material.SetFloat("_SummerValue", data.summer.w);
            material.SetFloat("_AutumnValue", data.autumn.w);

            material.SetFloat("_render_priority", data.priority);
        }

        void OnDrawGizmosSelected()
        {
            Gizmos.color = new Color(0.890f, 0.745f, 0.309f, 0.5f);
            Gizmos.DrawWireCube(transform.position, new Vector3(transform.lossyScale.x, 0, transform.lossyScale.z));
        }
    }
}
