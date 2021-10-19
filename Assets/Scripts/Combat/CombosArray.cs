using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*---------------------------------------------------------------------------------------------------
*------------------------------------------ AttackArray ---------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* An Array of Attacks with the Array Name (roundabout 2D array since 2D arrays don't show in inspector),
* and we need 2D array to show in inspector so user can fill out Scriptable Object for combo attacks.
*----------------------------------------------------------------------------------------------------*/

[System.Serializable]
public class CombosArray
{
    public string comboSetName;
    public Attack[] attacks;
}