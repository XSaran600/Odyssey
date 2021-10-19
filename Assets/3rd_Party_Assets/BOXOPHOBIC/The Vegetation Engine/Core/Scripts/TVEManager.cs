// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using Boxophobic.StyledGUI;
#if UNITY_EDITOR
using UnityEngine.SceneManagement;
#endif

namespace TheVegetationEngine
{
    [ExecuteInEditMode]
    public class TVEManager : StyledMonoBehaviour
    {
        [StyledBanner(0.890f, 0.745f, 0.309f, "The Vegetation Engine", "", "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.hbq3w8ae720x")]
        public bool styledBanner;

        [HideInInspector]
        public bool isInitialized = false;

        [HideInInspector]
        public TVEGlobalMotion globalMotion;
        [HideInInspector]
        public TVEGlobalSeasons globalSeasons;
        [HideInInspector]
        public TVEGlobalOverlay globalOverlay;
        [HideInInspector]
        public TVEGlobalWetness globalWetness;
        [HideInInspector]
        public TVEGlobalSizeFade globalSizeFade;
        [HideInInspector]
        public TVEMotionVolume motionVolume;
        [HideInInspector]
        public TVEColorsVolume colorsVolume;
        [HideInInspector]
        public TVEExtrasVolume extrasVolume;

#if !UNITY_2019_3_OR_NEWER
        [StyledSpace(5)]
        public bool styledSpace0;
#endif

        void Awake()
        {
//#if UNITY_EDITOR
//            if (SceneManager.GetActiveScene().name == "")
//            {
//                DestroyImmediate(gameObject);
//                TVEConsole.StyledWarning("The Scene must be saved in order to use The Vegetation Engine!");
//                return;
//            }
//#endif

            if (globalMotion == null)
            {
                GameObject go = new GameObject();

                go.AddComponent<MeshFilter>();
                go.GetComponent<MeshFilter>().mesh = Resources.Load<Mesh>("ArrowMesh");

                go.AddComponent<MeshRenderer>();
                go.GetComponent<MeshRenderer>().sharedMaterial = Resources.Load<Material>("ArrowMotion");

                go.AddComponent<TVEGlobalMotion>();

                SetParent(go);

                go.transform.localPosition = new Vector3(0, 2f, 0);

                globalMotion = go.GetComponent<TVEGlobalMotion>();
            }

            if (globalSeasons == null)
            {
                GameObject go = new GameObject();
                go.AddComponent<TVEGlobalSeasons>();
                SetParent(go);

                globalSeasons = go.GetComponent<TVEGlobalSeasons>();
            }

            if (globalOverlay == null)
            {
                GameObject go = new GameObject();

                go.AddComponent<MeshFilter>();
                go.GetComponent<MeshFilter>().mesh = Resources.Load<Mesh>("ArrowMesh");

                go.AddComponent<MeshRenderer>();
                go.GetComponent<MeshRenderer>().sharedMaterial = Resources.Load<Material>("ArrowOverlay");

                go.AddComponent<TVEGlobalOverlay>();

                SetParent(go);

                go.transform.localPosition = new Vector3(0, 1.8f, 0);
                go.transform.localEulerAngles = new Vector3(90, 0, 0);

                globalOverlay = go.GetComponent<TVEGlobalOverlay>();
            }

            if (globalWetness == null)
            {
                GameObject go = new GameObject();
                go.AddComponent<TVEGlobalWetness>();
                SetParent(go);

                globalWetness = go.GetComponent<TVEGlobalWetness>();
            }

            if (globalSizeFade == null)
            {
                GameObject go = new GameObject();
                go.AddComponent<TVEGlobalSizeFade>();
                SetParent(go);

                globalSizeFade = go.GetComponent<TVEGlobalSizeFade>();
            }

            if (motionVolume == null)
            {
                GameObject go = new GameObject();
                go.AddComponent<TVEMotionVolume>();
                SetParentAndYOffset(go);

                motionVolume = go.GetComponent<TVEMotionVolume>();

                if (LayerMask.NameToLayer("TVE Motion") > 0)
                {
                    motionVolume.renderLayer = LayerMask.NameToLayer("TVE Motion");
                }

                motionVolume.globalMotion = globalMotion.gameObject;
            }

            if (colorsVolume == null)
            {
                GameObject go = new GameObject();
                go.AddComponent<TVEColorsVolume>();
                SetParentAndYOffset(go);

                colorsVolume = go.GetComponent<TVEColorsVolume>();

                if (LayerMask.NameToLayer("TVE Colors") > 0)
                {
                    colorsVolume.renderLayer = LayerMask.NameToLayer("TVE Colors");
                }
            }

            if (extrasVolume == null)
            {
                GameObject go = new GameObject();
                go.AddComponent<TVEExtrasVolume>();
                SetParentAndYOffset(go);

                extrasVolume = go.GetComponent<TVEExtrasVolume>();

                if (LayerMask.NameToLayer("TVE Extras") > 0)
                {
                    extrasVolume.renderLayer = LayerMask.NameToLayer("TVE Extras");
                }
            }

            if (isInitialized == false)
            {
                Debug.Log("[The Vegetation Engine] " + "The Vegetation Engine is set in the current scene! Check the Documentation for the next steps!");
                isInitialized = true;
            }
        }

        void Update()
        {
            if (gameObject.name != "The Vegetation Engine")
            {
                gameObject.name = "The Vegetation Engine";
            }
        }

        void SetParent(GameObject go)
        {
            go.transform.parent = gameObject.transform;
            go.transform.localPosition = Vector3.zero;
            go.transform.eulerAngles = Vector3.zero;
            go.transform.localScale = Vector3.one;
        }

        void SetParentAndYOffset(GameObject go)
        {
            go.transform.parent = gameObject.transform;
            go.transform.localPosition = new Vector3(0, 25, 0);
            go.transform.eulerAngles = Vector3.zero;
            go.transform.localScale = Vector3.one;
        }
    }
}