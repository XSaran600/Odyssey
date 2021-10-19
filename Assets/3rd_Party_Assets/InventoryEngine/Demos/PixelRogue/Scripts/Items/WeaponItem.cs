using UnityEngine;
using System.Collections;
using MoreMountains.Tools;
using System;

namespace MoreMountains.InventoryEngine
{	
	[CreateAssetMenu(fileName = "WeaponItem", menuName = "MoreMountains/InventoryEngine/WeaponItem", order = 2)]
	[Serializable]
	/// <summary>
	/// Demo class for a weapon item
	/// </summary>
	public class WeaponItem : InventoryItem 
	{
		[Header("Weapon")]
		/// the sprite to use to show the weapon when equipped
		[Tooltip("Does a search for the weapon object name in scene. Please do not change the weapon object name after.")]
		public string weaponName;

		/// <summary>
		/// What happens when the object is used 
		/// </summary>
		public override bool Equip()
		{
			base.Equip();
			InventoryDemoGameManager.Instance.Player.SetWeapon(weaponName,this);
            return true;
		}

		/// <summary>
		/// What happens when the object is used 
		/// </summary>
		public override bool UnEquip()
		{
			base.UnEquip();
			InventoryDemoGameManager.Instance.Player.SetWeapon(null,this);
            return true;
        }
		
	}
}