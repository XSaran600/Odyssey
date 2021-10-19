using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*---------------------------------------------------------------------------------------------------
*---------------------------------------- DamageCalculation -----------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* This is the central class that handles all damage calculations.
* It takes in a damage value, types, resistances, and returns the resulting damage amount.
* It deals with all modifiers and allows for post-modification of damage.
* It has an OnDamage() listener which can be used, for example, to apply, say, bonus fire damage if
* the source of the damage event has an active fire buff.
* ----------
* How to Use: 
* ie. float dmg = DamageCalculation.Damage(sourceObj, targetObj, atkTypes, damage);
*----------------------------------------------------------------------------------------------------*/
class DamageCalculation
{
    /// <summary>
    /// Universal Damage Function
    /// </summary>
    /// <param name="source"></param>
    /// <param name="target"></param>
    /// <returns></returns>
    public static float DamageFormula(ElementTypes source, ElementTypes target, float damage, ElementTypes attribute)
    {        
        float totalDamage = 0;
        float modifier = 0;
        for(int i = 0; i< source.Types.Length; i++)
        {
            if (source.Types[i] > target.Types[i])
            {
                modifier += (source.Types[i] - target.Types[i]) * attribute.Types[i];
            }
        }
        totalDamage = damage * modifier * .01f;
        return totalDamage;
    }



    public static void Damage(float dmg)
    {
        // Deal atk - def
        Debug.Log("Damaged: " + dmg);
    }

    // Ta-da
    public static float Damage(GameObject source, GameObject target, float dmg)
    {
        // source is either the weapon or player we dont know yet
        return 1;
    }

}
