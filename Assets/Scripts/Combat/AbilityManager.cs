using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using MoreMountains.InventoryEngine;

public class AbilityManager : MonoBehaviour
{
    public int pointsUsed;
    public int pointsAvailable;
    private bool finisherEnabled;

    [Header("Do Not Touch PlayerCombo")]
    public List<Attack> playerCombo;
    /// <summary>
    /// abilites for wepAttack
    /// </summary>
    public List<Ability_SO> weaponAbility;
    /// <summary>
    /// abilites for movbility
    /// </summary>
    public List<Ability_SO> mobilityAbility;

    // Maybe UI can use this to know which ones should be highlighted
    private List<bool> weponAbilitesAvailable;
    private List<bool> mobilityAbilitesAvailable;

    private void Awake()
    {
    }
    // Does not matter if it is run after or before enabled
    private void AbilityManagerInit()
    {
            weponAbilitesAvailable = new List<bool>();
        for (int i = 0; i < weaponAbility.Count; i++)
            weponAbilitesAvailable.Add(false);
        mobilityAbilitesAvailable = new List<bool>();
        for (int i = 0; i < mobilityAbility.Count; i++)
            mobilityAbilitesAvailable.Add(false);
     //   SortAbilityList();

        //For wepon ability
        for (int i = 0; i < weponAbilitesAvailable.Count; i++)
        {
            if (weaponAbility[i].inUse)
            {
                pointsUsed += weaponAbility[i].pointCost;
                if (weaponAbility[i].attackInfo.isFinisher)
                    finisherEnabled = true;
            }
        }
        // For mobility ability
        for (int i = 0; i < mobilityAbilitesAvailable.Count; i++)
        {
            if (mobilityAbility[i].inUse)
            {
                pointsUsed += mobilityAbility[i].pointCost;
                if (mobilityAbility[i].attackInfo.isFinisher)
                    finisherEnabled = true;
            }
        }
        CheckAbilityAvailability();
        pointsAvailable -= pointsUsed;

        ResetPlayerComboList();
    }
    private void OnDisable()
    {
        PlayerGlobals.lateInitComplete.RemoveListener(AbilityManagerInit);
    }
    private void OnEnable()    
    {
        // if player is not ready, then wait
        if (!PlayerGlobals.initLateFinished)
        {
            PlayerGlobals.lateInitComplete.AddListener(AbilityManagerInit);
            return;
        }
        AbilityManagerInit();
    }
    // Check to see which abilites you can afford and if any =finisher is enabled
    public void CheckAbilityAvailability()
    {
        /* false if: 
             in use
             or is a finisher while a finisher is equipeed
             cost > points available
         true if:
             cost < points available
             other false conditions not met
        */

        // For wepon Ability
        for (int i = 0; i < weponAbilitesAvailable.Count; i++)
        {
            if (weaponAbility[i].inUse)
                weponAbilitesAvailable[i] = false;
            else if (weaponAbility[i].attackInfo.isFinisher && finisherEnabled)
                weponAbilitesAvailable[i] = false;
            else if (weaponAbility[i].pointCost >= pointsAvailable)
                weponAbilitesAvailable[i] = false;
            else if (weaponAbility[i].pointCost <= pointsAvailable)
                weponAbilitesAvailable[i] = true;
        }
        // For mobility Ability
        for (int i = 0; i < mobilityAbilitesAvailable.Count; i++)
        {
            if (mobilityAbility[i].inUse)
                mobilityAbilitesAvailable[i] = false;
            else if (mobilityAbility[i].attackInfo.isFinisher && finisherEnabled)
                mobilityAbilitesAvailable[i] = false;
            else if (mobilityAbility[i].pointCost >= pointsAvailable)
                mobilityAbilitesAvailable[i] = false;
            else if (mobilityAbility[i].pointCost <= pointsAvailable)
                mobilityAbilitesAvailable[i] = true;
        }
    }

    public void ToggleWeaponAbility(int index)
    {
        if (index >= weaponAbility.Count || index < 0)
        {
            Debug.LogError("Wep Ability index out of bound");
            return;
        }
        CheckAbilityAvailability();
        // Enable
        if (!weaponAbility[index].inUse && weponAbilitesAvailable[index])
        {
            weaponAbility[index].inUse = true;
            pointsUsed += weaponAbility[index].pointCost;
            pointsAvailable -= weaponAbility[index].pointCost;
        }
        // Disable
        else if (weaponAbility[index].inUse)
        {
            weaponAbility[index].inUse = false;
            pointsUsed -= weaponAbility[index].pointCost;
            pointsAvailable += weaponAbility[index].pointCost;

            if (weaponAbility[index].attackInfo.isFinisher)
                finisherEnabled = false;
        }
        else
        {
            Debug.LogError("Ability failed to change");
        }
        CheckAbilityAvailability();
        ResetPlayerComboList();
    }
    public void ToggleMobilityAbility(int index)
    {
        if (index >= mobilityAbility.Count || index < 0)
        {
            Debug.LogError("Mob Ability index out of bound");
            return;
        }
        CheckAbilityAvailability();
        // Enable
        if (!mobilityAbility[index].inUse && weponAbilitesAvailable[index])
        {
            mobilityAbility[index].inUse = true;
            pointsUsed += mobilityAbility[index].pointCost;
            pointsAvailable -= mobilityAbility[index].pointCost;
        }
        // Disable
        else if (mobilityAbility[index].inUse)
        {
            mobilityAbility[index].inUse = false;
            pointsUsed -= mobilityAbility[index].pointCost;
            pointsAvailable += mobilityAbility[index].pointCost;
        }
        else
        {
            Debug.LogError("Ability failed to change");
        }
        CheckAbilityAvailability();
    }

    /// <summary>
    /// Only for AWAKE!!!!
    /// </summary>
    private void SortAbilityList()
    {
        weaponAbility = weaponAbility.OrderBy(x => x.attackInfo.comboPriority).ToList();
        CheckAbilityAvailability();
    }

    public void ResetPlayerComboList()
    {
        playerCombo.Clear();

        // add player's wepon atk based abilities
        for (int i = 0; i < weaponAbility.Count; i++)
        {
            if (weaponAbility[i].inUse)
                playerCombo.Add(weaponAbility[i].attackInfo);
        }
        // add attacks from weapon
        playerCombo.AddRange(PlayerGlobals.combatInput.weapon.Attacks.ToList());
        playerCombo = playerCombo.OrderBy(x => x.comboPriority).ToList();

        for(int i = 0; i < playerCombo.Count; i++)
        {
            if (playerCombo[i].isFinisher)
            {
                for(int j = i ; j < playerCombo.Count -1;)
                {
                    playerCombo.RemoveAt(j+1);
                }
            }
        }

    }

    public Attack[] GetPlayerCombo()
    {
        return playerCombo.ToArray();
    }

    public bool[] GetWeaponAbilitiesAvailable()
    {
        return weponAbilitesAvailable.ToArray();
    }
    public bool[] GetMobilityAbilitiesAvailable()
    {
        return mobilityAbilitesAvailable.ToArray();
    }

}
