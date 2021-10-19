// Cristian Pop - https://boxophobic.com/

using UnityEngine;

namespace TheVegetationEngine
{
    [System.Serializable]
    public class TVEElementData
    {
        public Shader elementShader;

        public float elementIntensity = 1;
        public float elementMode = 0;

        public Texture mainTex;
        public Vector4 mainUVs = new Vector4(1, 1, 0, 0);

        public Vector4 main = new Vector4(0.5f, 0.5f, 0.5f, 1f);
        public Vector4 winter = new Vector4(0.5f, 0.5f, 0.5f, 1f);
        public Vector4 spring = new Vector4(0.5f, 0.5f, 0.5f, 1f);
        public Vector4 summer = new Vector4(0.5f, 0.5f, 0.5f, 1f);
        public Vector4 autumn = new Vector4(0.5f, 0.5f, 0.5f, 1f);

        public float priority = 0;

        public TVEElementData(Shader elementShader, float elementIntensity, float elementMode, Vector4 main, Vector4 winter, Vector4 spring, Vector4 summer, Vector4 autumn, float priority)
        {
            this.elementShader = elementShader;
            this.elementIntensity = elementIntensity;
            this.elementMode = elementMode;
            this.main = main;
            this.winter = winter;
            this.spring = spring;
            this.summer = summer;
            this.autumn = autumn;
            this.priority = priority;
        }
    }
}