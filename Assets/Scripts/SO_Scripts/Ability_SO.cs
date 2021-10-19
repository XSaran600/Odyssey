using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[CreateAssetMenu(fileName = "New Ability", menuName = "Ability")]
/// <summary>
/// Contains information on of the ability attack as well if the player can use them and when
/// </summary>
public class Ability_SO : ScriptableObject
{
    public int pointCost;

    public bool inUse;
    public uint comboLengthMod;
    public Attack attackInfo;

    [TextArea]
    public string Notes = "Comment Here."; 
}
