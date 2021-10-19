using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    // Terrain
    public GameObject[] terrains;

    [Header("Terrain Run-time Settings")]
    [Tooltip("Hide trees painted by terrain during run-time?")] 
    public bool hideTerrainTrees;

    private float[] defaultDetailObjectDistance = new float[5];
    private float[] defaultTreeDistance         = new float[5];
    private bool previous;  // Previous toggle state
    // ---------------------------------------------------------  
    
    void Start()
    {
        for (int i = 0; i < terrains.Length; i++)
        {
            defaultDetailObjectDistance[i] = terrains[i].GetComponent<Terrain>().detailObjectDistance;
            defaultTreeDistance[i] = terrains[i].GetComponent<Terrain>().treeDistance;  
        }
    }

    void Update()
    {
        if (previous != hideTerrainTrees)
            CheckTerrainTrees();
        previous = hideTerrainTrees;
    }

    void CheckTerrainTrees()
    {
        if (hideTerrainTrees)
        {
            for (int i = 0; i < terrains.Length; i++) 
            {
                if (terrains[i].activeInHierarchy)
                {
                    terrains[i].GetComponent<Terrain>().detailObjectDistance = 0f;
                    terrains[i].GetComponent<Terrain>().treeDistance = 0f;
                }
            }
        } else {
            for (int i = 0; i < terrains.Length; i++) 
            {
                if (terrains[i].activeInHierarchy)
                {
                    terrains[i].GetComponent<Terrain>().detailObjectDistance = defaultDetailObjectDistance[i];
                    terrains[i].GetComponent<Terrain>().treeDistance = defaultTreeDistance[i];
                }
            }
        }
    }
}