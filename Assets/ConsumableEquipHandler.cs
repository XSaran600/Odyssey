using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MoreMountains.InventoryEngine;

public class ConsumableEquipHandler : MonoBehaviour
{
    [Header("All Player Consumables (add here)")]
    public string[] consumablesNameList;
    public string[] equippedConsumablesByName;

    public int previousConsumableIndex;
    public int currentConsumableIndexEquipped;

    [Header("MAP INVENTORIES (manual)")]
    public InventoryInputManager inventoryInputManager;
    public Inventory consumableInventory;

    [SerializeField] private bool[] match = new bool[8];
    [SerializeField] private int consumableSlotCount = 8;

    private void Update() 
    {
        currentConsumableIndexEquipped = inventoryInputManager.equippedConsumableCurrentIndex;

        if (previousConsumableIndex != currentConsumableIndexEquipped)
        {
            for (int k = 0; k < 8; k++)
                match[k] = false;

            // Iterate through consumable names and see if it matches for equipping
            for (int i = 0; i < consumablesNameList.Length; i++)
            {
                // Iterate through each inventory slot
                for (int j = 0; j < consumableSlotCount; j++)
                {
                    if (!match[j] || currentConsumableIndexEquipped <= 0) // Continue if not match or unequipping
                    {
                        InventoryItem item = consumableInventory.Content[j];
                        if ((item != null && InventoryItem.GetItemName(item) != "null_item_name") || currentConsumableIndexEquipped <= 0)
                        {
                            Debug.Log("Comparing: " + InventoryItem.GetItemName(item) + "(actual) to " + consumablesNameList[i] + "(consumableDict)");
                            if (InventoryItem.GetItemName(item).Equals(consumablesNameList[i]))
                            {
                                match[j] = true;
                                equippedConsumablesByName[j] = InventoryItem.GetItemName(item);
                            }
                            if (!match[j])
                            {
                                Debug.Log("Unmatched " + j);
                                equippedConsumablesByName[j] = null;
                            }
                        }
                    }
                }
            }
            previousConsumableIndex = currentConsumableIndexEquipped;
        }
    }


}
