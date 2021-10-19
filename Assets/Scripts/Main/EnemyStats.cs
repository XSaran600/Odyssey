using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*
 * Use: Enemy Stats for Scriptable objects
 * Needs: Attach Enemy.cs for functionality
 */

[CreateAssetMenu(fileName = "New Enemy", menuName = "Enemy Stats SO")]

public class EnemyStats : ScriptableObject
{
    // Public Parameters
    [SerializeField]
    private float _health;
    [SerializeField]
    private float _maxHP;
    [SerializeField]
    private float _power;
    [SerializeField]
    private float _iFramesLength;
    [SerializeField]
    private Combos _comboAttacks;

    public float Health { get => _health; }
    public float MaxHP { get => _maxHP; }
    public float Power { get => _power; }
    public float IFramesLength { get => _iFramesLength; }
    public Combos ComboAttacks { get => _comboAttacks; }
}
