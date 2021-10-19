using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*---------------------------------------------------------------------------------------------------
*--------------------------------------------- Weapon -----------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* Weapon is a scriptable object attached to each Weapon.
* This holds all of the weapon data including its power, attacks, combos, etc.
* ----------
* How to Use: 
* Right-click in Unity's file explorer and go to Create -> 'Weapon PlaceHolder' to create a new weapon.
* Create a Weapon Object and create a hitbox child, and give it the script CombatInput.cs. 
* Drag in your Weapon scriptable object to CombatInput.cs for the field 'Weapon'.
* Give your weapon a model. See existing example for further help.
*----------------------------------------------------------------------------------------------------*/
[CreateAssetMenu(fileName = "New Weapon", menuName = "Weapon SO")]

public class Weapon : ScriptableObject
{
    /*-----------------------------------------------------------------
    *----------------------- Public Parameters ------------------------
    *------------------------------------------------------------------*/
    [Header("__ Weapon Stats __")]
    [SerializeField]
    private float _power;

    [Space]
    [Header("__ Combos __")]
    [Tooltip("How much time does the player have to wait before attacking again after completing a ground combo?")]
    [Range(0, 5)] [SerializeField] private float _cooldownAfterComboEndGround = 0.5f;

    [Tooltip("How much time does the player have to wait before attacking again after completing an air combo?")]
    [Range(0, 5)] [SerializeField] private float _cooldownAfterComboEndAir = 1.5f;

    [Tooltip("How much time AFTER attack animation does player have to input another attack to continue combo?")]
    [Range(-50, 100)] [SerializeField] private float _comboBufferTimePercentage = 25.0f;

    [Tooltip("How much time BEFORE attack animation ends does player have to input another attack to queue the next attack?")]
    [Range(-50, 100)] [SerializeField] private float _queueAttackBufferTimePercentage = 50.0f;

    [Space]
    [Header("__ Attacks __")]
    [SerializeField]
    private Attack[] _attacks;

    [Space]
    [Header("__ Air Attacks __")]
    [SerializeField]
    private Attack[] _airAttacks;

    //------------------------------------------------------------------

    // Getters
    public float Power { get => _power; }
    public float CooldownAfterComboEndGround { get => _cooldownAfterComboEndGround; }
    public float CooldownAfterComboEndAir { get => _cooldownAfterComboEndAir; }
    public float ComboBufferTimePercentage { get => _comboBufferTimePercentage; }
    public float QueueAttackBufferTimePercentage { get => _queueAttackBufferTimePercentage; }
    public Attack[] Attacks { get => _attacks; }
    public Attack[] AirAttacks { get => _airAttacks; }
}
