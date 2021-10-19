using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Odyssey.Combat;

/*---------------------------------------------------------------------------------------------------
*---------------------------------------- SetLockOnTarget --------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* [SetLockOnTarget] finds combatable objects and adds/removes them to a list based on visibility.
* This allows iteration through the objects and to move the UI lock-on elements accordingly.
*----------------------------------------------------------------------------------------------------*/
public class SetLockOnTarget : MonoBehaviour
{
    [HideInInspector]
    public CombatCore playerCombat;

    [Range(-5,5)] public float uiOffset;

    void Start()
    {
        playerCombat = PlayerGlobals.GetPlayerCombatCore();
    }

    // private void Update() {
    //     if (!targets.screenTargets.Contains(transform)) {
    //         Debug.Log("FOUND!!");
    //         targets.screenTargets.Add(transform);      
    //     }   
    // }

    private void OnBecameVisible()
    {
        if (!playerCombat.screenTargets.Contains(gameObject))
            playerCombat.screenTargets.Add(gameObject);
    }

    private void OnBecameInvisible()
    {
        if(playerCombat.screenTargets.Contains(gameObject))
            playerCombat.screenTargets.Remove(gameObject);
    }
}
