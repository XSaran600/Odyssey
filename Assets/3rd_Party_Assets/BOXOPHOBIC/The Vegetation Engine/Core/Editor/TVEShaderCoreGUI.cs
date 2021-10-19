//Cristian Pop - https://boxophobic.com/

using UnityEngine;
using UnityEditor;

public class TVEShaderCoreGUI : ShaderGUI
{
    Material material;

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        base.OnGUI(materialEditor, props);

        material = materialEditor.target as Material;

        // Set Base render settings
        TheVegetationEngine.TVEShaderUtils.SetRenderSettings(material);

        SetLegacyProps();

        materialEditor.LightmapEmissionProperty(0);
        foreach (Material target in materialEditor.targets)
            target.globalIlluminationFlags &= ~MaterialGlobalIlluminationFlags.EmissiveIsBlack;
    }

    void SetLegacyProps()
    {
        if (material.HasProperty("_MainAlbedoTex"))
        {
            material.SetColor("_Color", material.GetColor("_MainColor"));
            material.SetTexture("_MainTex", material.GetTexture("_MainAlbedoTex"));
            material.SetTextureScale("_MainTex", new Vector2(material.GetVector("_MainUVs").x, material.GetVector("_MainUVs").y));
            material.SetTextureOffset("_MainTex", new Vector2(material.GetVector("_MainUVs").z, material.GetVector("_MainUVs").w));
        }
    }
}

