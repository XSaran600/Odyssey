using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using MyBox;

[CreateAssetMenu(fileName = "New Spell", menuName = "Spell Stats SO")]

public class SpellStats : ScriptableObject
{
    [Header("Spell Info")]
    [SerializeField]
    private float spellID;

    [SerializeField]
    private string spellName;

    [SerializeField]
    private string spellDescription;

    [SerializeField]
    private Sprite spellIcon;


    public float SpellID { get => spellID; }
    public string SpellName { get => spellName; }
    public string SpellDescription { get => spellDescription; }
    public Sprite SpellIcon { get => spellIcon; }

    [Header("Spell Parameters")]
    public float castTime;
    public float power;
    public float knockbackForce;
    public float manaCost;

    [Header("PROJECTILE")]
    // Public Parameters (PROJECTILE)
    [SerializeField]
    public bool isSpellProjectile;


    [ConditionalField("isSpellProjectile", false)]
    public float speed;

    [ConditionalField("isSpellProjectile", false)]
    public float projSpawnDelay;


    [ConditionalField("isSpellProjectile", false)]
    public GameObject projectileModel;

    [ConditionalField("isSpellProjectile", false)]
    public GameObject projectileImpact;

    [Tooltip("Enemy cannot use this yet")] [ConditionalField("isSpellProjectile", false)]
    public Vector3 projectileRotation;

    [ConditionalField("isSpellProjectile", false)]
    public Vector3 projectileOffset;

    [Tooltip("Enemy cannot use this yet")] [ConditionalField("isSpellProjectile", false)]
    public bool multipleProjectiles;

    [ConditionalField("multipleProjectiles", false)]
    public int projectileCount;

    [ConditionalField("multipleProjectiles", false)]
    public float projectileInterval;

    [ConditionalField("multipleProjectiles", false)]
    public bool projectileArc;


  
    [Header("AOE")]
    public bool isSpellInstantAOE;

    [ConditionalField("isSpellInstantAOE", false)]
    public float radius;

    [ConditionalField("isSpellInstantAOE", false)]
    public bool originIsPlayer;

    [ConditionalField("isSpellInstantAOE", false)]
    public bool originIsEnemy;

    [ConditionalField("isSpellInstantAOE", false)]
    public Transform origin;

    [ConditionalField("isSpellInstantAOE", false)]
    public GameObject sfxAoEImpact;


    [Header("BUFF")]
    public bool isBuff;

    [ConditionalField("isBuff", false)]
    public bool atkSpeedBuff;
    [ConditionalField("atkSpeedBuff", false)]
    public float atkSpeedModifier;
    [ConditionalField("atkSpeedBuff", false)]
    public GameObject buffFX;
    [ConditionalField("atkSpeedBuff", false)]
    public float buffDuration;
    
    [ConditionalField("isBuff", false)]
    public bool healSingle;
    [ConditionalField("healSingle", false)]
    public float healSingleAmount;

    [ConditionalField("isBuff", false)]
    public bool regenOverTime;
    [ConditionalField("regenOverTime", false)]
    public float regenOverTimeAmountPerSecond;
    [ConditionalField("regenOverTime", false)]
    public float regenDuration;



    [Header("EXTRA VISUAL/ANIMATION")]
    public bool extraVisual;
    [ConditionalField("extraVisual", false)]
    public string playerAnimationStringName;
    [ConditionalField("extraVisual", false)]
    public string playerAnimationSpeedMultiplierParameterStringName;
    [ConditionalField("extraVisual", false)]
    public float playerAnimationSpeedMultiplier = 1.0f;
    [ConditionalField("extraVisual", false)]
    public GameObject sfxOnPlayer;
    [ConditionalField("extraVisual", false)]
    public float sfxDuration;
    [ConditionalField("extraVisual", false)]
    public Vector3 sfxRotation;
    [ConditionalField("extraVisual", false)]
    public bool slowMotionEffect;
    

}