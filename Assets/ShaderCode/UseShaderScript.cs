using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UseShaderScript : MonoBehaviour
{
    public Material mat;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        // src is the fully rendered scene

        Graphics.Blit(source, destination, mat);
    }
}
