// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using Boxophobic.StyledGUI;

namespace TheVegetationEngine
{
    [ExecuteInEditMode]
    [AddComponentMenu("BOXOPHOBIC/The Vegetation Engine/TVE Global Motion")]
    public class TVEGlobalMotion : StyledMonoBehaviour
    {
        [StyledBanner(0.890f, 0.745f, 0.309f, "Global Motion", "", "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.czf8ud5bmaq2")]
        public bool styledBanner;

        //public UpdateMode updateMode = UpdateMode.OnLoad;

        //[Space(10)]
        [StyledRangeOptions(0,1, "Wind Power", new string[] { "Calm", "Windy", "Strong" })]
        public float windPower = 0.5f;

        [Space(10)]
        public Texture2D noiseTexture;
        public float noiseSpeed = 1.0f;
        public float noiseSize = 50.0f;

        [StyledSpace(10)]
        public bool styledSpace0;

        void Start()
        {
            // Disable Arrow in play mode
            if (Application.isPlaying == true)
            {
                gameObject.GetComponent<MeshRenderer>().enabled = false;
            }
            else
            {
                gameObject.GetComponent<MeshRenderer>().enabled = true;
            }

            gameObject.name = "Global Motion";

            if (noiseTexture == null)
            {
                noiseTexture = Resources.Load<Texture2D>("TVE Noise");
            }

            SetGlobalShaderProperties();
        }

        void Update()
        {
            gameObject.transform.eulerAngles = new Vector3(0, gameObject.transform.eulerAngles.y, 0);

            //if (Application.isPlaying == false || updateMode == UpdateMode.Realtime)
            //{
            //    SetGlobalShaderProperties();
            //}

            SetGlobalShaderProperties();
        }

        void SetGlobalShaderProperties()
        {
            Shader.SetGlobalFloat("TVE_Amplitude1", Mathf.Lerp(0.1f, 1f, windPower));
            Shader.SetGlobalFloat("TVE_Amplitude2", Mathf.Lerp(0.25f, 1f, windPower));
            Shader.SetGlobalFloat("TVE_Amplitude3", Mathf.Lerp(0.25f, 1f, windPower));

            Shader.SetGlobalTexture("TVE_NoiseTex", noiseTexture);
            Shader.SetGlobalFloat("TVE_NoiseContrast", Mathf.Lerp(0.25f, 2.5f, 1 - windPower));
            Shader.SetGlobalFloat("TVE_NoiseSpeed", noiseSpeed * 0.1f);
            Shader.SetGlobalFloat("TVE_NoiseSize", 1.0f / noiseSize);
        }
    }
}
