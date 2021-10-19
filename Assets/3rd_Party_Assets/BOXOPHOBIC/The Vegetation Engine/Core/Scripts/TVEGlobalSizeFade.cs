// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using Boxophobic.StyledGUI;

namespace TheVegetationEngine
{
    [ExecuteInEditMode]
    [AddComponentMenu("BOXOPHOBIC/The Vegetation Engine/TVE Global Size Fade")]
    public class TVEGlobalSizeFade : StyledMonoBehaviour
    {
        [StyledBanner(0.890f, 0.745f, 0.309f, "Global Size Fade", "", "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.q3sme6mi00gy")]
        public bool styledBanner;

        //public UpdateMode updateMode = UpdateMode.OnLoad;

        //[Space(10)]
        //public float sizeMin = 0.0f;
        //public float sizeMax = 1.0f;

        //[Space(10)]
        public float sizeFadeStart = 75.0f;
        public float sizeFadeEnd = 100.0f;

        [StyledSpace(10)]
        public bool styledSpace0;

        void Start()
        {
            gameObject.name = "Global Size Fade";

            SetGlobalShaderProperties();
        }

        void Update()
        {
            //if (Application.isPlaying == false || updateMode == UpdateMode.Realtime)
            //{
            //    SetGlobalShaderProperties();
            //}

            SetGlobalShaderProperties();
        }

        void SetGlobalShaderProperties()
        {
            Shader.SetGlobalFloat("TVE_SizeFadeStart", sizeFadeStart);
            Shader.SetGlobalFloat("TVE_SizeFadeEnd", sizeFadeEnd);
           //Shader.SetGlobalFloat("TVE_Amplitude3", Mathf.Lerp(0.25f, 1f, windPower) * 0.01f);
            //Shader.SetGlobalFloat("TVE_Amplitude3", Mathf.Lerp(0.25f, 1f, windPower) * 0.01f);
        }
    }
}
