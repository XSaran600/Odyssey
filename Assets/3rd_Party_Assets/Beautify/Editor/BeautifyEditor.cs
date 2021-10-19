using UnityEditor.Rendering;
using UnityEngine;
using UnityEngine.Rendering.HighDefinition;
using UnityEditor;

namespace BeautifyHDRP
{
    [VolumeComponentEditor(typeof(Beautify))]
    sealed class BeautifyEditor : VolumeComponentEditor

    {

        SerializedDataParameter intensity;
        SerializedDataParameter sharpen, sharpenMinDepth, sharpenMaxDepth, sharpenMinMaxDepthFallOff, sharpenDepthThreshold, sharpenRelaxation, sharpenClamp, sharpenMotionSensibility;
        SerializedDataParameter ditherStrength;
        SerializedDataParameter saturate, contrast, brightness, daltonize;

        public override bool hasAdvancedMode => false;

        public override void OnEnable()
        {
            base.OnEnable();

            var o = new PropertyFetcher<Beautify>(serializedObject);

            intensity = Unpack(o.Find(x => x.intensity));

            sharpen = Unpack(o.Find(x => x.sharpen));
            sharpenMinDepth = Unpack(o.Find(x => x.sharpenMinDepth));
            sharpenMaxDepth = Unpack(o.Find(x => x.sharpenMaxDepth));
            sharpenMinMaxDepthFallOff = Unpack(o.Find(x => x.sharpenMinMaxDepthFallOff));
            sharpenDepthThreshold = Unpack(o.Find(x => x.sharpenDepthThreshold));
            sharpenRelaxation = Unpack(o.Find(x => x.sharpenRelaxation));
            sharpenClamp = Unpack(o.Find(x => x.sharpenClamp));
            sharpenMotionSensibility = Unpack(o.Find(x => x.sharpenMotionSensibility));

            ditherStrength = Unpack(o.Find(x => x.ditherStrength));

            saturate = Unpack(o.Find(x => x.saturate));
            contrast = Unpack(o.Find(x => x.contrast));
            brightness = Unpack(o.Find(x => x.brightness));
            daltonize = Unpack(o.Find(x => x.daltonize));

        }

        public override void OnInspectorGUI()

        {

            PropertyField(intensity);

            PropertyField(sharpen, new GUIContent("Sharpen"));
            PropertyField(sharpenMinDepth, new GUIContent("Min Depth", "Applies sharpen beyond certain depth in the scene"));
            PropertyField(sharpenMaxDepth, new GUIContent("Max Depth", "Applies sharpen until certain depth in the scene"));
            PropertyField(sharpenMinMaxDepthFallOff, new GUIContent("Min/Max FallOff", "Sharpen falloff around min/max limits"));
            PropertyField(sharpenDepthThreshold, new GUIContent("Depth Threshold", "Limits sharpen depending on depth difference around pixels"));
            PropertyField(sharpenRelaxation, new GUIContent("Relaxation", "Limits sharpen on bright areas"));
            PropertyField(sharpenClamp, new GUIContent("Sharpen Clamp", "Limits (clamps) final sharpen modifier so small sharpen occurs but high sharpen will be limited to this intensity."));
            PropertyField(sharpenMotionSensibility, new GUIContent("Motion Sensibility", "Reduces sharpen while camera moves/rotates to reduce flickering and contribute to motion blur effect"));

            PropertyField(ditherStrength, new GUIContent("Dither Strength", "Fast dithering that reduces banding artifacts in scene"));

            PropertyField(saturate, new GUIContent("Saturate", "Positive value increases color saturation making the scene more vivid. Negative value desaturares the colors towards grayscale"));
            PropertyField(contrast);
            PropertyField(brightness);
            PropertyField(daltonize, new GUIContent("Daltonize", "Boosts primary colors to compensate daltonism"));

        }

    }
}