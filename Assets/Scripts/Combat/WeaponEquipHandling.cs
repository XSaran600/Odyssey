using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MoreMountains.InventoryEngine;

public class WeaponEquipHandling : MonoBehaviour
{

    [Header("All Player Weapons")]
    public GameObject[] weapon;

    public int previousWeaponIndex;
    public int currentWeaponIndexEquipped;


    private void Update() 
    {
        currentWeaponIndexEquipped = PlayerGlobals.player.GetComponent<InventoryDemoCharacter>()._currentWeapon;

        if (previousWeaponIndex != currentWeaponIndexEquipped)
        {
            for (int i = 0; i < weapon.Length; i++)
            {
                if (weapon[i] != null)
                    weapon[i].SetActive(false);
            }
            if (weapon[currentWeaponIndexEquipped] != null)
                weapon[currentWeaponIndexEquipped].SetActive(true);

            previousWeaponIndex = currentWeaponIndexEquipped;

            PlayerGlobals.UpdatePlayerGlobalWeapon();
            Invoke("UpdateWeapon", 0.01f);
        }
            
    }

    private void UpdateWeapon()
    {
        //PlayerGlobals.UpdatePlayerGlobalWeapon();
        PlayerGlobals.player.GetComponent<AbilityManager>().ResetPlayerComboList();
    }


}
