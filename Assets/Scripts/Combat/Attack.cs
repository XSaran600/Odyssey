using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MyBox;

/*---------------------------------------------------------------------------------------------------
*--------------------------------------------- Attack -----------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* Defines the parameters of every attack. Attack array for each combo attack is used by Weapon.cs.
*----------------------------------------------------------------------------------------------------*/

[System.Serializable]
public class Attack
{
    [Range(0, 10)] public float animationSpeedMultiplier = 1.0f;
    [Range(0, 10)] public float defaultAttackSpeedMultiplier = 1.0f;

    [Tooltip("Does this attack deal damage? The 'attack' could be a non-attack movement. Currently affects enemy attacks only.")]
    public bool isAttack = true;

    [Tooltip("Multiplier on damage. Damage dealt takes into account player's attack power, weapon's power, multiplied by this attack multiplier.")]
    [ConditionalField("isAttack", false)] [Range(0, 10)] public float attackMultiplier = 1.0f;

    [ConditionalField("isAttack", false)] [Range(-50, 50)] public float knockbackForce;
    [ConditionalField("isAttack", false)] [Range(-50, 50)] public float knockupForce;

    [Tooltip("Attack Animation Names (Animator window, the grey box nodes). Must be mapped, check [Attacks] layer in player's Animator.")]
    public string attackAnimationName;

    [Tooltip("Animation Name (the animation in the fbx or w.e). Must be mapped")]
    public string animationName;
    [Tooltip("The parameter name for attack speed multiplier, allowing attack speed to be manipulated by buffs/debuffs/etc. Create one for each attack animation.")]
    public string attackSpeedParameterName;

    [Tooltip("The impact particles effect model/prefab.")]
    [ConditionalField("isAttack", false)] public GameObject fxImpactPrefab;

    [Tooltip("The slash/attack particles effect model/prefab.")]
    [ConditionalField("isAttack", false)] public GameObject fxAttackPrefab;

    [Tooltip("The attack number within the combo.")]
    public float comboPriority;

    [Tooltip("The attack ends.")]
    public bool isFinisher;

    [Tooltip("Skip Attack")]
    public bool skipAttack;

    [Tooltip("Set an override attack time length in seconds (tip: use for enemy as they currently cannot automatically assess correct length of attack)")]
    public float attackLengthOverride;

}