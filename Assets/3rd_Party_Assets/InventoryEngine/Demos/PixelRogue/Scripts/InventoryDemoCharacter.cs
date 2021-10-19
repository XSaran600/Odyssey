using UnityEngine;
using System.Collections;
using MoreMountains.Tools;

namespace MoreMountains.InventoryEngine
{	

	//[RequireComponent(typeof(Rigidbody2D))]
	/// <summary>
	/// Demo character controller, very basic stuff
	/// </summary>
	public class InventoryDemoCharacter : MonoBehaviour, MMEventListener<MMInventoryEvent>
	{
		[MMInformation("Handles weapon equipment handling. Checks which weapon user is equipping and swaps them.",MMInformationAttribute.InformationType.Info,false)]

		[Header("Inventory Setup")]
		/// the armor inventory
		public Inventory ArmorInventory;
		/// the weapon inventory
		public Inventory WeaponInventory;

		[HideInInspector]
		public int _currentArmorIndex =0;

		[HideInInspector]
		public int _currentConsumableIndex =0;

	    protected int _currentArmor=0;

		[HideInInspector]
	    public int _currentWeapon=0;

	    protected Animator _animator;
	    protected bool _isFacingRight = true;

		[Header("Weapon Equipment Handling")]
		public string[] weaponNameList;

		[Header("Armor Equipment Handling")]
		public string[] armorNameList;

		[Header("Consumable Equipment Handling")]
		public string[] consumableNameList;

		/// <summary>
		/// On Start, we store the character's animator and rigidbody
		/// </summary>
	    protected virtual void Start()
	    {
	        _animator = GetComponent<Animator>();
	    }

		/// <summary>
		/// On fixed update we move the character and update its animator
		/// </summary>
	    protected virtual void FixedUpdate()
	    {
	        //Movement();
	        //UpdateAnimator();
	    }

		/// <summary>
		/// Sets the current armor. (or consumable)
		/// </summary>
		/// <param name="index">Index.</param>
	    public virtual void SetArmor(string armorName, int index, bool isConsumable)
	    {
	    	_currentArmor = index; // Inventory management stuff

			// Find the darn game object
			if (armorName == null)
				_currentArmorIndex = 0;

			for (int i = 0; i < armorNameList.Length; i++)
			{
				if (armorName == armorNameList[i])
				{
					_currentArmorIndex = i+1;
					Debug.Log("Matched armor equip: " + armorName);
				} else if (armorName == consumableNameList[i])
				{
					_currentConsumableIndex += 1;
					Debug.Log("Matched consumable: " + armorName);
				}
			}

			// Unequip detection
			if (index == 0 && !isConsumable) // 0 is passed if unequipping
				_currentArmorIndex = index * -1; // negative index is unequipping it, ie. armor of index id 3 equip = 3, unequip = -3
			
			// Unequip consumable
			if (index == 0 && isConsumable)
				_currentConsumableIndex = index -= 1;

			if ( !isConsumable)
				Debug.Log("Armor: " + armorName + " | " + _currentArmorIndex);
			else 
				Debug.Log("Consumable: " + armorName + " | " + _currentConsumableIndex);
	    }

		/// <summary>
		/// Sets the current weapon sprite
		/// </summary>
		/// <param name="newSprite">New sprite.</param>
		/// <param name="item">Item.</param>
	    public virtual void SetWeapon(string newWeaponName, InventoryItem item)
	    {
			//WeaponSprite.sprite = newSprite;
			GameObject weaponPrefab = GameObject.Find(newWeaponName);

			// Find the darn game object
			if (newWeaponName == null)
				_currentWeapon = 0;
			
			for (int i = 0; i < weaponNameList.Length; i++)
			{
				if (newWeaponName == weaponNameList[i])
					_currentWeapon = i+1;
			}
	    }

		/// <summary>
		/// Catches MMInventoryEvents and if it's an "inventory loaded" one, equips the first armor and weapon stored in the corresponding inventories
		/// </summary>
		/// <param name="inventoryEvent">Inventory event.</param>
		public virtual void OnMMEvent(MMInventoryEvent inventoryEvent)
		{
			if (inventoryEvent.InventoryEventType == MMInventoryEventType.InventoryLoaded)
			{
				if (inventoryEvent.TargetInventoryName == "ArmorInv")
				{
					if (ArmorInventory != null)
					{
						if (!InventoryItem.IsNull(ArmorInventory.Content [0]))
						{
							ArmorInventory.Content [0].Equip ();	
						}
					}
				}
				if (inventoryEvent.TargetInventoryName == "WeaponInv")
				{
					if (WeaponInventory != null)
					{
						if (!InventoryItem.IsNull (WeaponInventory.Content [0]))
						{
							WeaponInventory.Content [0].Equip ();
						}
					}
				}
			}
		}

		/// <summary>
		/// On Enable, we start listening to MMInventoryEvents
		/// </summary>
		protected virtual void OnEnable()
		{
			this.MMEventStartListening<MMInventoryEvent>();
		}


		/// <summary>
		/// On Disable, we stop listening to MMInventoryEvents
		/// </summary>
		protected virtual void OnDisable()
		{
			this.MMEventStopListening<MMInventoryEvent>();
		}
	}
}