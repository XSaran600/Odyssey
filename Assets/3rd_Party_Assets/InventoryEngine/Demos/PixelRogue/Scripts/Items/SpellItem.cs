using UnityEngine;
using System.Collections;
using MoreMountains.Tools;
using System;

namespace MoreMountains.InventoryEngine
{	
	[CreateAssetMenu(fileName = "SpellItem", menuName = "MoreMountains/InventoryEngine/SpellItem", order = 2)]
	[Serializable]
	/// <summary>
	/// Demo class for an example armor item
	/// </summary>
	public class SpellItem : InventoryItem 
	{
		[Header("Spell")]
		public int SpellIndex;

		/// <summary>
		/// What happens when the armor is equipped
		/// </summary>
		public override bool Equip()
		{
			base.Equip();
			InventoryDemoGameManager.Instance.Player.SetArmor(null, SpellIndex, false);

            return true;
        }	

		/// <summary>
		/// What happens when the armor is unequipped
		/// </summary>
		public override bool UnEquip()
		{
			base.UnEquip();
			InventoryDemoGameManager.Instance.Player.SetArmor(null, 0, false);
            return true;
        }		
	}
}