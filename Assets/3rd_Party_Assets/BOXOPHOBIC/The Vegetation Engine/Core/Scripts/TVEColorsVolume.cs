// Cristian Pop - https://boxophobic.com/

//#define THE_VEGETATION_ENGINE_HD

using UnityEngine;
using Boxophobic.StyledGUI;

#if THE_VEGETATION_ENGINE_UNIVERSAL
using UnityEngine.Rendering.Universal;
#endif

#if THE_VEGETATION_ENGINE_HD
using UnityEngine.Rendering.HighDefinition;
#endif

namespace TheVegetationEngine
{
    [ExecuteInEditMode]
    [AddComponentMenu("BOXOPHOBIC/The Vegetation Engine/TVE Colors Volume")]
    public class TVEColorsVolume : StyledMonoBehaviour
    {
        [StyledBanner(0.890f, 0.745f, 0.309f, "Colors Volume", "", "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.x0vwa8kwumd")]
        public bool styledBanner;

        [StyledMessage("Error", "The Render Layer cannot be set to Default. Please choose an empty layer for elements rendering!")]
        public bool infoLayer = false;

        [StyledMessage("Info", "Use the Baked Render option if you don't want to update Seasons or Color elements in realtime! Set the Render Resolution to small values for minimal performance impact!", 0, 5)]
        public bool infoBaked = false;
        [StyledMessage("Info", "Use the Realtime Render option if you want to update the Color elements in realtime.", 0, 5)]
        public bool infoRealtime = false;

        [Range(0.0f, 1.0f)]
        public float volumeVisibility = 0.5f;

        [Space(10)]
        public float volumeSize = 100.0f;
        public float volumeHeight = 50.0f;

        [Space(10)]
        public RenderMode renderMode = RenderMode.Realtime;

        [Space(10)]
        [StyledPopupLayers]
        public int renderLayer;

        public TextureSizes renderResolution = TextureSizes._512;
        [HideInInspector]
        public TextureSizes renderResolutionOld = TextureSizes._512;

        public TextureWrapMode renderWrapMode = TextureWrapMode.Repeat;
        [HideInInspector]
        public TextureWrapMode renderWrapModeOld = TextureWrapMode.Repeat;

        public bool renderEdgeFade = false;

        public bool renderHDRColors = false;
        [HideInInspector]
        public bool renderHDRColorsOld = false;

        [Space(10)]
        [StyledTexturePreview]
        public Texture previewTex;

        [StyledSpace(10)]
        public bool styledSpace0;

        [HideInInspector]
        public GameObject camGO;
        [HideInInspector]
        public GameObject edgeGO;
        [HideInInspector]
        public Material edgeMaterial;

        RenderTexture renderTex;
        Texture2D bakedTex;
        Camera cam;

#if THE_VEGETATION_ENGINE_UNIVERSAL
        UniversalAdditionalCameraData camUniversal;
#endif

#if THE_VEGETATION_ENGINE_HD
        HDAdditionalCameraData camHD;
#endif

        void Start()
        {
            gameObject.name = "Colors Volume";

            if (camGO == null)
            {
                CreateCameraGameObject();
            }

            if (edgeGO == null)
            {
                CreateEdgeGameObject();
            }

            InitCameraParameters();
            InitCameraUniversalParameters();
            InitCameraHDParameters();
            UpdateCameraParameters();

            CreateRenderTexture();
            AssignRenderTexture();

            if (Application.isPlaying && renderMode == RenderMode.Baked)
            {
                CreateBakedTexture();
                ReleaseRenderTexture();
                cam.enabled = false;
            }

            SetGlobalShaderParameters();
        }

        //void OnDisable()
        //{
        //    ReleaseRenderTexture();
        //}

        //void OnDestroy()
        //{
        //    cam.targetTexture = null;

        //    ReleaseRenderTexture();
        //    DestroyImmediate(renderTex);
        //}

        void Update()
        {
            LimitTransforms();

            UpdateCameraParameters();

            UpdateEdgeTransform();

            SetGlobalShaderParameters();

            SetEdgeRenderLayer();

            ToggleEdgeVisibility();

            if (renderResolutionOld != renderResolution || renderWrapModeOld != renderWrapMode || renderHDRColors != renderHDRColorsOld)
            {
                ReleaseRenderTexture();

                CreateRenderTexture();
                AssignRenderTexture();

                renderResolutionOld = renderResolution;
                renderWrapModeOld = renderWrapMode;
                renderHDRColorsOld = renderHDRColors;
            }

            ShowInspectorInfo();
        }

        void OnDrawGizmos()
        {
            if (camGO != null)
            {
                Gizmos.color = new Color(1f, 0f, 0f, volumeVisibility);
                Gizmos.DrawWireCube(new Vector3(camGO.transform.position.x, camGO.transform.position.y - (volumeHeight / 2.0f), camGO.transform.position.z), new Vector3(volumeSize, volumeHeight, volumeSize));
            }
        }

        void LimitTransforms()
        {
            transform.localScale = Vector3.one;

            if (volumeSize < 1.0f)
            {
                volumeSize = 1.0f;
            }

            if (volumeHeight < 1.0f)
            {
                volumeHeight = 1.0f;
            }
        }

        void CreateCameraGameObject()
        {
            camGO = new GameObject();
            camGO.name = "Colors Camera";
            camGO.transform.parent = gameObject.transform;
            camGO.transform.localPosition = Vector3.zero;
            camGO.transform.eulerAngles = new Vector3(90, 0, 0);
            camGO.transform.localScale = Vector3.one;

            camGO.AddComponent<Camera>();
        }

        void InitCameraParameters()
        {
            cam = camGO.GetComponent<Camera>();
            cam.enabled = true;

            cam.clearFlags = CameraClearFlags.SolidColor;
            cam.backgroundColor = new Color(0.5f, 0.5f, 0.5f, 1.0f);

            cam.orthographic = true;
            cam.orthographicSize = volumeSize / 2.0f;

            cam.nearClipPlane = 0.0f;
            cam.farClipPlane = volumeHeight;

            cam.renderingPath = RenderingPath.Forward;

            cam.useOcclusionCulling = false;
            cam.allowHDR = false;
            cam.allowMSAA = false;
            cam.allowDynamicResolution = false;

            cam.stereoTargetEye = StereoTargetEyeMask.None;
        }

        void InitCameraUniversalParameters()
        {
#if THE_VEGETATION_ENGINE_UNIVERSAL

            if (camGO.GetComponent<UniversalAdditionalCameraData>() == null)
            {
                camGO.AddComponent<UniversalAdditionalCameraData>();
            }

            camUniversal = camGO.GetComponent<UniversalAdditionalCameraData>();
            camUniversal.volumeLayerMask = 0;
            camUniversal.renderPostProcessing = false;
            camUniversal.antialiasing = AntialiasingMode.None;
            camUniversal.stopNaN = false;
            camUniversal.dithering = false;
            camUniversal.renderShadows = false;
            camUniversal.requiresColorTexture = false;
            camUniversal.requiresDepthTexture = false;

#endif
        }

        void InitCameraHDParameters()
        {
#if THE_VEGETATION_ENGINE_HD

            if (camGO.GetComponent<HDAdditionalCameraData>() == null)
            {
                camGO.AddComponent<HDAdditionalCameraData>();
            }

            camHD = camGO.GetComponent<HDAdditionalCameraData>();
            camHD.volumeLayerMask = 0;
            camHD.backgroundColorHDR = new Color(0.5f, 0.5f, 0.5f, 1.0f).linear;

#endif
        }

        void UpdateCameraParameters()
        {
            cam.orthographicSize = volumeSize / 2.0f;
            cam.farClipPlane = volumeHeight;
            cam.cullingMask = (int)Mathf.Pow(2, renderLayer);
        }

        void CreateBakedTexture()
        {
            RenderTexture.active = renderTex;

            cam.Render();

            TextureFormat format = TextureFormat.ARGB32;

            if (renderHDRColors == true)
            {
                format = TextureFormat.RGBAFloat;
            }

            bakedTex = new Texture2D((int)renderResolution, (int)renderResolution, format, false, false);
            bakedTex.name = "TVE Colors Tex";
            bakedTex.wrapMode = renderWrapMode;
            bakedTex.ReadPixels(new Rect(0, 0, (int)renderResolution, (int)renderResolution), 0, 0);
            bakedTex.Apply();

            previewTex = bakedTex;

            RenderTexture.active = null;
        }

        void CreateRenderTexture()
        {
            RenderTextureFormat format = RenderTextureFormat.Default;

            if (renderHDRColors == true)
            {
                format = RenderTextureFormat.ARGBHalf;
            }

            renderTex = new RenderTexture((int)renderResolution, (int)renderResolution, 0, format);
            renderTex.name = "TVE Colors Tex";
            renderTex.wrapMode = renderWrapMode;

            previewTex = renderTex;

            // Editor fix when rt is created
            SetGlobalShaderParameters();

            //Debug.Log("RT Created");
        }

        void ReleaseRenderTexture()
        {
            renderTex.Release();
            //Debug.Log("RT Released");
        }

        void AssignRenderTexture()
        {
            cam.targetTexture = renderTex;
        }

        void SetGlobalShaderParameters()
        {
            var globalUVsX = 1 / volumeSize * transform.position.x - 0.5f;
            var globalUVsY = 1 / volumeSize * transform.position.z - 0.5f;
            var globalUVsZ = 1 / volumeSize;

            Shader.SetGlobalVector("TVE_ColorsCoord", new Vector4(-globalUVsX, -globalUVsY, globalUVsZ, 0));
            Shader.SetGlobalTexture("TVE_ColorsTex", renderTex);

            if (Application.isPlaying && renderMode == RenderMode.Baked)
            {
                Shader.SetGlobalTexture("TVE_ColorsTex", bakedTex);
            }
            else
            {
                Shader.SetGlobalTexture("TVE_ColorsTex", renderTex);
            }
        }

        void CreateEdgeGameObject()
        {
            edgeGO = new GameObject();
            edgeGO.name = "Colors Edge";
            edgeGO.transform.parent = gameObject.transform;
            edgeGO.transform.localPosition = Vector3.zero;
            edgeGO.transform.eulerAngles = Vector3.zero;
            edgeGO.transform.localScale = Vector3.one;

            edgeGO.AddComponent<MeshFilter>();
            edgeGO.AddComponent<MeshRenderer>();

            edgeGO.GetComponent<MeshFilter>().sharedMesh = Resources.Load<Mesh>("QuadMesh");

            edgeMaterial = Resources.Load<Material>("EdgeFadeColors");
            edgeMaterial.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Transparent + 1;

            edgeGO.GetComponent<MeshRenderer>().sharedMaterial = edgeMaterial;
        }

        void UpdateEdgeTransform()
        {
            edgeGO.transform.localPosition = camGO.transform.localPosition;
            edgeGO.transform.localScale = new Vector3(volumeSize, 1.0f, volumeSize);
        }

        void SetEdgeRenderLayer()
        {
            edgeGO.layer = renderLayer;
        }

        void ToggleEdgeVisibility()
        {
            if (renderEdgeFade)
            {
                edgeGO.GetComponent<MeshRenderer>().enabled = true;
            }
            else
            {
                edgeGO.GetComponent<MeshRenderer>().enabled = false;
            }
        }

        void ShowInspectorInfo()
        {
            if (renderMode == RenderMode.Baked)
            {
                infoBaked = true;
                infoRealtime = false;
            }
            else
            {
                infoBaked = false;
                infoRealtime = true;
            }

            if (renderLayer == 0)
            {
                infoLayer = true;
            }
            else
            {
                infoLayer = false;
            }
        }
    }
}
