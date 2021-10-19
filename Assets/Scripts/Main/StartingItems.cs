using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MoreMountains.InventoryEngine;

public class StartingItems : MonoBehaviour
{

    public InventoryItem[] Item;
    public int[] Quantity;
    protected Inventory _targetInventory;
    protected int _pickedQuantity;

    void Awake()
    {
        Invoke("GiveItems", 0.1f);
    }

    void GiveItems()
    {
        for (int i = 0 ; i < Item.Length; i++)
        {
            Pick(Item[i].TargetInventoryName, i);
        }
    }


    /// <summary>
    /// Picks this item and adds it to its target inventory
    /// </summary>
    public virtual void Pick(int index)
    {
        Pick(Item[index].TargetInventoryName, index);
    }

    /// <summary>
    /// Picks this item and adds it to the target inventory specified as a parameter
    /// </summary>
    /// <param name="targetInventoryName">Target inventory name.</param>
    public virtual void Pick(string targetInventoryName, int index)
    {
        FindTargetInventory (targetInventoryName);
        if (_targetInventory==null)
        {
            return;
        }

        if (!Pickable()) 
        {
            PickFail ();
            return;
        }

        DetermineMaxQuantity (index);
        if (!Application.isPlaying)
        {
            _targetInventory.AddItem(Item[index], 1);
        }				
        else
        {
            MMInventoryEvent.Trigger(MMInventoryEventType.Pick, null, Item[index].TargetInventoryName, Item[index], _pickedQuantity, 0);
        }				
        if (Item[index].Pick())
        {
            Quantity[index] = Quantity[index] - _pickedQuantity;
            PickSuccess();
            DisableObjectIfNeeded();
        }			
    }

    /// <summary>
    /// Describes what happens when the object is successfully picked
    /// </summary>
    protected virtual void PickSuccess()
    {
        
    }

    /// <summary>
    /// Describes what happens when the object fails to get picked (inventory full, usually)
    /// </summary>
    protected virtual void PickFail()
    {

    }

    /// <summary>
    /// Disables the object if needed.
    /// </summary>
    protected virtual void DisableObjectIfNeeded()
    {
        // // we desactivate the gameobject
        // if (Quantity <= 0)
        // {
        //     gameObject.SetActive(false);	
        // }
    }

    /// <summary>
    /// Determines the max quantity of item that can be picked from this
    /// </summary>
    protected virtual void DetermineMaxQuantity(int i)
    {
        _pickedQuantity = _targetInventory.NumberOfStackableSlots (Item[i].ItemID, Item[i].MaximumStack);
        if (Quantity[i] < _pickedQuantity)
        {
            _pickedQuantity = Quantity[i];
        }
    }

    /// <summary>
    /// Returns true if this item can be picked, false otherwise
    /// </summary>
    public virtual bool Pickable()
    {
        if (_targetInventory.NumberOfFreeSlots == 0)
        {
            return false;
        }

        return true;
    }

    /// <summary>
    /// Finds the target inventory based on its name
    /// </summary>
    /// <param name="targetInventoryName">Target inventory name.</param>
    public virtual void FindTargetInventory(string targetInventoryName)
    {
        _targetInventory = null;
        if (targetInventoryName==null)
        {
            return;
        }
        foreach (Inventory inventory in UnityEngine.Object.FindObjectsOfType<Inventory>())
        {				
            if (inventory.name==targetInventoryName)
            {
                _targetInventory = inventory;
            }
        }
    }

}
