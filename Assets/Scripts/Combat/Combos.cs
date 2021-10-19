using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*---------------------------------------------------------------------------------------------------
*--------------------------------------------- Combos -----------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* Give enemy combo attacks.
* ----------
* How to Use: 
* Just *&cking use it.
*----------------------------------------------------------------------------------------------------*/

[System.Serializable]
public class Combos
{
    /*-----------------------------------------------------------------
    *----------------------- Public Parameters ------------------------
    *------------------------------------------------------------------*/
    [Header("__ Stats __")]
    public float power;

    [Header("__ Combos __")]
    [Tooltip("How much time does the player have to wait before attacking again after completing a ground combo?")]
    [Range(0, 5)] public float cooldownAfterComboEndGround = 1.5f;

    [Tooltip("How much time does the player have to wait before attacking again after completing an air combo?")]
    [Range(0, 5)] public float cooldownAfterComboEndAir = 2.5f;

    [Tooltip("How much time AFTER attack animation does enemy have to input another attack to continue combo?")]
    [Range(-50, 200)] public float comboBufferTimePercentage = 99.9f;

    [Tooltip("How much time BEFORE attack animation ends does enemy have to input another attack to queue the next attack?")]
    [Range(-50, 100)] public float queueAttackBufferTimePercentage = 99.9f;

    [Header("__ Combos __")]
    public CombosArray[] combosArray;
}
