using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Sometimes wonky, but this class is so clothes can bend and stay on the char by copying their armature to the players. 
/// For some reason, the player has weird offsets with the armature and the actual player mesh, so this is the easiest way to get clothes the bend properly.
/// </summary>
public class Clothes : MonoBehaviour
{
    [Header("Player bone pos")]
    public SkeletonBone hips;
    [Header("Player Bone Parts to lead")]
    public List<Transform> targetSkeleton;
    [Header("Clothes Bone Parts to follow")]
    public List<Transform> clothSkeleton;

    public bool updateTransform;

    [Header("Body Parts to cover")]
    public bool isHead;
    public bool isChest;
    public bool isLeftArm;
    public bool isRightArm;
    public bool isLeftLeg;
    public bool isRightLeg;
    public bool isLeftHand;
    public bool isRightHand;
    public bool isLeftFoot;
    public bool isRightFoot;


    public void CopyPlayerSkelTrans()
    {
        for (int i = 0; i < targetSkeleton.Count; i++)
        {
                clothSkeleton[i].position = targetSkeleton[i].position;
                clothSkeleton[i].rotation = targetSkeleton[i].rotation;
        }
    }

    private void  Update()
    {
        if (updateTransform)
            CopyPlayerSkelTrans();
    }


}
