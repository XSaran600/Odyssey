using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "Clothes_SO", menuName = "Clothes")]
/// <summary>
/// Contains information on clothes as well as the skeleton needed to move them
/// </summary>

public class Clothes_SO : ScriptableObject
{
    [Header("Player Bone Parts to lead")]
    public List<Transform> playerSkeleton;
    [Header("Clothes Bone Parts to follow")]
    public List<Transform> clothSkeleton;

    bool hasSkeleton;

    [Header("Body Parts to cover")]
    bool isHead;
    bool isChest;
    bool isLeftArm;
    bool isRightArm;
    bool isleftLeg;
    bool isRightLeg;


    public void CopyPlayerSkelTrans()
    {
        for (int i = 0; i < playerSkeleton.Count; i++)
        {
            clothSkeleton[i].position = playerSkeleton[i].position;
            clothSkeleton[i].rotation = playerSkeleton[i].rotation;
        }
    }

}
