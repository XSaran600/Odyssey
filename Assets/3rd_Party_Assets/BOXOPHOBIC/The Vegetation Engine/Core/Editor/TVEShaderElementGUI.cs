//Cristian Pop - https://boxophobic.com/

using UnityEngine;
using UnityEditor;

public class TVEShaderElementGUI : ShaderGUI
{
    Material material;

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        base.OnGUI(materialEditor, props);

        material = materialEditor.target as Material;

        SetPipelineQueue();
    }

    void SetPipelineQueue()
    {
        int priority = material.GetInt("_render_priority");
        int queueOffsetRange = 0;

        if (material.HasProperty("_IsUniversalPipeline"))
        {
            queueOffsetRange = 50;
        }

        // HD Render Pipeline
        material.SetInt("_TransparentSortPriority", priority);

        material.renderQueue = 3000 + queueOffsetRange + priority;
    }
}

