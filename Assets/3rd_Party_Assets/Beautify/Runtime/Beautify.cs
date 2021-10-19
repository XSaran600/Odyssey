using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.HighDefinition;
using System;

namespace BeautifyHDRP {

    [Serializable, VolumeComponentMenu("Post-processing/Beautify")]
    public sealed class Beautify : CustomPostProcessVolumeComponent, IPostProcessComponent {
        [Tooltip("Global Beautify intensity")]
        [Header("Global Intensity")]
        public ClampedFloatParameter intensity = new ClampedFloatParameter(0f, 0f, 1f);

        [Header("Sharpen Options")]
        [Tooltip("Controls the intensity of the effect.")]
        public ClampedFloatParameter sharpen = new ClampedFloatParameter(2f, 0f, 12f);
        [Tooltip("Minimum depth to apply sharpen"), ]
        public ClampedFloatParameter sharpenMinDepth = new ClampedFloatParameter(0f, 0f, 1f);
        [Tooltip("Maximum depth to apply sharpen")]
        public ClampedFloatParameter sharpenMaxDepth = new ClampedFloatParameter(0.999f, 0f, 1f);
        [Tooltip("Min/max depth range falloff.")]
        public ClampedFloatParameter sharpenMinMaxDepthFallOff = new ClampedFloatParameter(0f, 0f, 1f);
        [Tooltip("Depth difference sensibility. Avoids artifacts on geometry edges.")]
        public ClampedFloatParameter sharpenDepthThreshold = new ClampedFloatParameter(0.035f, 0f, 0.05f);
        [Tooltip("Attenuates sharpen effect on bright areas to reduce artifacts.")]
        public ClampedFloatParameter sharpenRelaxation = new ClampedFloatParameter(0.08f, 0f, 0.2f);
        [Tooltip("Limits final sharpen to be applied.")]
        public ClampedFloatParameter sharpenClamp = new ClampedFloatParameter(0.45f, 0f, 1f);
        [Tooltip("Reduces sharpen effect while camera is moving to reduce flickering.")]
        public ClampedFloatParameter sharpenMotionSensibility = new ClampedFloatParameter(0.5f, 0f, 1f);

        [Header("Dithering")]
        [Tooltip("Controls the intensity of the dithering to reduce banding.")]
        public ClampedFloatParameter ditherStrength = new ClampedFloatParameter(0.015f, 0f, 0.03f);

        [Header("Color Tweaks")]
        [Tooltip("Increase to make colors more vivid. Reduce to desaturate colors.")]
        public ClampedFloatParameter saturate = new ClampedFloatParameter(0.5f, -2f, 3f);
        public ClampedFloatParameter contrast = new ClampedFloatParameter(1.02f, 0.5f, 1.5f);
        public ClampedFloatParameter brightness = new ClampedFloatParameter(1.05f, 0f, 2f);
        [Tooltip("Boosts primary colors to compensate daltonism.")]
        public ClampedFloatParameter daltonize = new ClampedFloatParameter(0f, 0f, 2f);


        Material m_Material;
        Vector3 camPrevForward, camPrevPos;
        float currSens;

        public bool IsActive() => m_Material != null && intensity.value > 0f;

        // Do not forget to add this post process in the Custom Post Process Orders list (Project Settings > HDRP Default Settings).
        public override CustomPostProcessInjectionPoint injectionPoint => CustomPostProcessInjectionPoint.AfterPostProcess;

        const string kShaderName = "Hidden/Shader/Beautify";

        public override void Setup() {
            if (Shader.Find(kShaderName) != null)
                m_Material = new Material(Shader.Find(kShaderName));
            else
                Debug.LogError($"Unable to find shader '{kShaderName}'. Post Process Volume Beautify is unable to load.");
        }

        public override void Render(CommandBuffer cmd, HDCamera camera, RTHandle source, RTHandle destination) {
            if (m_Material == null)
                return;

            float power = intensity.value;
            // Motion sensibility
            if (Application.isPlaying)
            {
                Transform camTransform = camera.camera.transform;
                Vector3 camForward = camTransform.forward;
                Vector3 camPos = camTransform.position;
                float angleDiff = Vector3.Angle(camPrevForward, camForward) * sharpenMotionSensibility.value;
                float posDiff = (camPos - camPrevPos).sqrMagnitude * 10f * sharpenMotionSensibility.value;

                float diff = angleDiff + posDiff;
                if (diff > 0.1f)
                {
                    camPrevForward = camForward;
                    camPrevPos = camPos;
                    if (diff > sharpenMotionSensibility.value)
                        diff = sharpenMotionSensibility.value;
                    currSens += diff;
                    float min = sharpen.value * sharpenMotionSensibility.value * 0.75f;
                    float max = sharpen.value * (1f + sharpenMotionSensibility.value) * 0.5f;
                    currSens = Mathf.Clamp(currSens, min, max);
                }
                else
                {
                    currSens *= 0.75f;
                }
            }

            float tempSharpen = Mathf.Clamp(sharpen.value - currSens, 0, sharpen.value) * power;
            Vector4 sharpenData = new Vector4(tempSharpen, sharpenDepthThreshold.value, sharpenClamp.value, sharpenRelaxation.value);
            m_Material.SetVector("_Sharpen", sharpenData);
            m_Material.SetVector("_DepthParams", new Vector4(sharpenMinMaxDepthFallOff.value, (sharpenMaxDepth.value + sharpenMinDepth.value) * 0.5f, Mathf.Abs(sharpenMaxDepth.value - sharpenMinDepth.value) * 0.5f, ditherStrength.value * power));

            float cont = 1.0f + (contrast.value - 1.0f) / 2.2f;
            float tempContrast = (1f - power) + cont * power;
            float tempSat = (1f - power) + saturate.value * power;
            float tempBrightness = (1f - power) + brightness.value * power;
            m_Material.SetVector("_ColorBoost", new Vector4(tempBrightness, tempContrast, tempSat, daltonize.value * 10f * power));

            m_Material.SetTexture("_InputTexture", source);
            HDUtils.DrawFullScreen(cmd, m_Material, destination);
        }

        public override void Cleanup() {
            CoreUtils.Destroy(m_Material);
        }
    }

}