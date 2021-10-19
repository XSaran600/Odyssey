using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MoreMountains.InventoryEngine;

public class ArmorVisualDisplay : MonoBehaviour
{

    [Header("All Player Armors")]
    public GameObject[] armor;

    public int previousArmorIndex;
    public int currentArmorIndexEquipped;


    private void Update() 
    {
        currentArmorIndexEquipped = PlayerGlobals.player.GetComponent<InventoryDemoCharacter>()._currentArmorIndex;

        if (previousArmorIndex != currentArmorIndexEquipped)
        {
            //currentArmorIndexEquipped--; // fix index (subtract 1 since it was added earlier on equip, as index 0 means nothing equipped)

            if (currentArmorIndexEquipped <= 0) // negative index is an unequip action
            {
                Debug.Log("unequipping");
                armor[(currentArmorIndexEquipped-1) * -1].SetActive(false); // reverse the negative index and set its object active to false (unequip)
            } else { // otherwise equip action
            Debug.Log("equipping");
                if (armor[currentArmorIndexEquipped] != null)
                    armor[currentArmorIndexEquipped].SetActive(true);
            }
            previousArmorIndex = currentArmorIndexEquipped;
            //PlayerGlobals.UpdatePlayerGlobalWeapon();
        }
            
    }


}
