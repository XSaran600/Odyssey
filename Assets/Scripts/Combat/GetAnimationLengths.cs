using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*---------------------------------------------------------------------------------------------------
*------------------------------------ Get Animation Lengths -----------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* Get player's attack animation time lengths accordingly. Required to assess attacking combo timings.
*----------------------------------------------------------------------------------------------------*/

public class GetAnimationLengths : MonoBehaviour
{
//    public float[] attackTimes = new float[20];
//    public float[] attackSpeeds = new float[20];
    public Dictionary<string, float> attackTimes;
    private Animator anim;
    // Use this for initialization
    void Start()
    {
        anim = GetComponent<Animator>();
        attackTimes = new Dictionary<string, float>();
        UpdateAnimClipTimes();
    }
    public void UpdateAnimClipTimes()
    {
        AnimationClip[] clips = anim.runtimeAnimatorController.animationClips;

        AnimParameter[] animParams = anim.GetBehaviours<AnimParameter>();

        int i = 0;
        foreach (AnimationClip clip in clips)
        {
            foreach (AnimParameter animParam in animParams)
            {
                //Debug.Log(clip.name);
                if (clip.name == animParam.animName)
                {
                    animParam.indexX = i;
                    float value;
                    if (attackTimes.TryGetValue(clip.name, out value))
                    {
                        Debug.LogWarning(clip.name + " is duplicated key, says Nathan");
                    }
                    else
                    {
                        attackTimes.Add(clip.name, clip.length);                        
                    }
//                    attackTimes[animParam.indexX] = clip.length;
//                    attackSpeeds[animParam.indexX] = anim.GetFloat(animParam.modifierName);
                    i++;
                }
            }

        }
        /*
        foreach (AnimationClip clip in clips)
        {
//            Debug.Log(clip.name);
            switch (clip.name)
            {
                case "Attack2Hand_C":
                    attackTimes[0] = clip.length;
                    attackSpeeds[0] = anim.GetFloat("Katana_AtkSpd_1");
                    break;
                case "Attack2Hand_B":
                    attackTimes[1] = clip.length;
                    attackSpeeds[1] = anim.GetFloat("Katana_AtkSpd_2");
                    break;
                case "Attack2Hand_A":
                    attackTimes[2] = clip.length;
                    attackSpeeds[2] = anim.GetFloat("Katana_AtkSpd_3");
                    break;
                case "Attack_3":
                    attackTimes[3] = clip.length;
                    attackSpeeds[3] = anim.GetFloat("Katana_AtkSpd_4");
                    break;
            }
        
        }
        */
    }

}
