using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Allows the camera clipping planes 0.3 - 4000 to render the world tree while culling all other objects between 300-4000 distance.
/// </summary>
public class CameraFarClippingCulling : MonoBehaviour
{

    [Tooltip("This sets the clipping plane far distance for all objects other than the world tree.")]
    public float cullingFarDistance = 300f;

    void Start()
    {
        Camera camera = GetComponent<Camera>();
        float[] distances = new float[32];

        for (int i = 0; i < 22; i++)
        {
            distances[i] = cullingFarDistance;
        }
        camera.layerCullDistances = distances;
    }
}
