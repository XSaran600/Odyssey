// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using Boxophobic.StyledGUI;

namespace TheVegetationEngine
{
    [ExecuteInEditMode]
    [AddComponentMenu("BOXOPHOBIC/The Vegetation Engine/TVE Global Seasons")]
    public class TVEGlobalSeasons : StyledMonoBehaviour
    {
        [StyledBanner(0.890f, 0.745f, 0.309f, "Global Seasons", "", "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.969g8bl1p3qo")]
        public bool styledBanner;

        //public UpdateMode updateMode = UpdateMode.OnLoad;

        //[Space(10)]
        //public bool snapInSceneView = true;

        //[Space(10)]
        [StyledRangeOptions(0, 4, "Season", new string[] { "Winter", "Spring", "Summer", "Autumn", "Winter"})]
        public float season = 2f;

        [StyledSpace(10)]
        public bool styledSpace0;

        void Start()
        {
            gameObject.name = "Global Seasons";

            SetGlobalShaderProperties();
        }

        void Update()
        {
            //if (Application.isPlaying == false)
            //{
            //    SnapInSceneView();
            //}

            //if (Application.isPlaying == false || updateMode == UpdateMode.Realtime)
            //{
            //    SetGlobalShaderProperties();
            //}

            SetGlobalShaderProperties();
        }

        void SnapInSceneView()
        {
            if (season < 0.15f)
                season = 0.0f;
            else if (season > 0.85f && season < 1.15f)
                season = 1.0f;
            else if (season > 1.85f && season < 2.15f)
                season = 2.0f;
            else if (season > 2.85f && season < 3.15f)
                season = 3.0f;
            else if (season > 3.85f)
                season = 4.0f;
        }

        void SetGlobalShaderProperties()
        {
            var seasonLerp = 0.0f;

            if (season >= 0 && season < 1)
            {
                seasonLerp = season;
                Shader.SetGlobalVector("TVE_SeasonOptions", new Vector4(1, 0, 0, 0));
                Shader.SetGlobalFloat("TVE_SeasonLerp", seasonLerp);
            }
            else if (season >= 1 && season < 2)
            {
                seasonLerp = season - 1.0f;
                Shader.SetGlobalVector("TVE_SeasonOptions", new Vector4(0, 1, 0, 0));
                Shader.SetGlobalFloat("TVE_SeasonLerp", seasonLerp);
            }
            else if (season >= 2 && season < 3)
            {
                seasonLerp = season - 2.0f;
                Shader.SetGlobalVector("TVE_SeasonOptions", new Vector4(0, 0, 1, 0));
                Shader.SetGlobalFloat("TVE_SeasonLerp", seasonLerp);
            }
            else if (season >= 3 && season <= 4)
            {
                seasonLerp = season - 3.0f;
                Shader.SetGlobalVector("TVE_SeasonOptions", new Vector4(0, 0, 0, 1));
                Shader.SetGlobalFloat("TVE_SeasonLerp", seasonLerp);
            }
        }
    }
}
