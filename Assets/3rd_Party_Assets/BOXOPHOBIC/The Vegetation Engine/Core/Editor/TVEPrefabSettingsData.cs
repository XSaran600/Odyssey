// Cristian Pop - https://boxophobic.com/

using UnityEngine;

namespace TheVegetationEngine
{
    [System.Serializable]
    public class TVEMaterialData
    {
        // 0 = simple float 
        // 1 = range 
        // 2 = vector 
        // 3 = color
        public int type;
        public string prop;
        public string name;
        public float value;
        public float min;
        public float max;
        public bool snap;
        public Vector4 vector;
        public Color color;
        public bool hdr;
        public bool space;

        public TVEMaterialData(string prop, string name, float val, int min, int max, bool snap, bool space)
        {
            this.type = 1;
            this.prop = prop;
            this.value = val;
            this.name = name;
            this.min = min;
            this.max = max;
            this.snap = snap;
            this.space = space;
        }

        public TVEMaterialData(string prop, string name, Color color, bool hdr, bool space)
        {
            this.type = 3;
            this.prop = prop;
            this.color = color;
            this.hdr = hdr;
            this.name = name;
            this.space = space;
        }
    }
}