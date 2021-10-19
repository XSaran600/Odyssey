using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Odyssey.Combat;
using Invector.vCharacterController;
using UnityEngine.Events;

/*---------------------------------------------------------------------------------------------------
*---------------------------------------- Player Globals --------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* [Player Globals] allows any programmers to more easily get player or game parameters.
* While some parameters like player or locked on target can be accessed through various systems,
* [Player Globals] provides getters to access them without instantiating a duplicate instance class.
* ----------
* How to Use: 
* ie. GameObject currentLockedOnTarget = PlayerGlobals.currentLockedOnTarget();
*
* [WARNING] This fetches objects hard-coded by object name, if object is renamed, update here too.
*----------------------------------------------------------------------------------------------------*/
public class PlayerGlobals
{
    [Header("Globals")]
    public static GameObject player;
    public static CombatInput combatInput;
    public static CombatCore combat;
    public static vThirdPersonInput invectorInput;
    public static vThirdPersonController charController;
    public static GameObject postProcessing;
    public static Invector.vFootStep footTrigger;
    public static GameObject playerExplodeFX;
    public static GameObject playerMesh;
    public static GameObject playerArmature;
    public static GameObject explodeSmokePrefab;
    public static GameObject gameInitObject;
    public static Animator playerAnim;

    // Variables for scripts waiting on init
    public static UnityEvent initComplete = new UnityEvent();
    public static UnityEvent lateInitComplete = new UnityEvent();
    public static bool initFinished = false;
    public static bool initLateFinished = false;

    public static void Init()
    {
        if (player == null)
            player = GameObject.FindWithTag("Player");

        // TryGetComponent safer than "if (combat == null) combat = player.GetComponent<CombatCore>();" as it avoids mem alloc if null (editor problem only)
        if (player.TryGetComponent(out CombatCore cb))
            combat = cb;

        if (player.TryGetComponent(out vThirdPersonInput ii))
            invectorInput = ii;

        if (player.TryGetComponent(out vThirdPersonController cc))
            charController = cc;

        if (postProcessing == null)
            postProcessing = GameObject.Find("PostProcessing");

        if (player.TryGetComponent(out Invector.vFootStep footTriggerOut))
            footTrigger = footTriggerOut;

        if (playerExplodeFX == null) {
            playerExplodeFX = GameObject.Find("Death_Player_Explosion");
            playerExplodeFX.SetActive(false);
        }

        if (playerMesh == null) {
            playerMesh = GameObject.Find("VBOT_:VBOT_LOD0");
        }

        if (explodeSmokePrefab == null) {
            explodeSmokePrefab = GameObject.Find("Red_Explode_Prefab");
            explodeSmokePrefab.SetActive(false);
        }

        if (gameInitObject == null)
            gameInitObject = GameObject.Find("GameInit & GameManager");

        if (player.TryGetComponent(out Animator aa))
            playerAnim = aa;

        if (initComplete == null)
            initComplete = new UnityEvent();

        if (lateInitComplete == null)
            lateInitComplete = new UnityEvent();

        initFinished = true;
        initComplete.Invoke();
    }

    public static void LateInit()
    {
        if (GameObject.FindWithTag("PlayerWeapon").TryGetComponent(out CombatInput ci))
            combatInput = ci;

        if (playerArmature == null) {
            playerArmature = PlayerGlobals.player.transform.GetChild(0).gameObject;
        }

        initLateFinished = true;
        lateInitComplete.Invoke();
//        player.GetComponent<AbilityManager>().enabled = true;

    }

    public static void UpdatePlayerGlobalWeapon()
    {
        Debug.Log("updating weapon");
        if (GameObject.FindWithTag("PlayerWeapon").TryGetComponent(out CombatInput ci))
        {
            combatInput = ci;
            Debug.Log("updateing weapon success: " + combatInput.gameObject.name);
        } else {
            Debug.Log("updating weapon failed");
        }
    }

    public static GameObject GetPlayer()
    {
        return GameObject.FindWithTag("Player"); // Get again, assuming the player could possibly change
    }

    public static GameObject GetCurrentLockedOnTarget()
    {
        return combat.targetObject;
    }

    public static bool IsPlayerGrounded()
    {
        return charController.isGrounded;
    }

    public static CombatCore GetPlayerCombatCore()
    {
        return combat;
    }

    public static bool GetStepTrigger()
    {
        return footTrigger.spawnParticle;
    }
}
