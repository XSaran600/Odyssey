using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*---------------------------------------------------------------------------------------------------
*---------------------------------------- Attribute Types -------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* Scriptable object with all element types as float values.
* ----------
* How to Use: 
* Right-click in Unity's file explorer and go to Create -> 'Elemental Stats'.
* Drag this scriptable object into any projectile or weapon to define its elemental parameters.
* As an example, creating ElementTypes scriptable object and filling with values 0.5,0.5,0,0,0,0,0
* and attaching it to a weapon will give it 50% physical and 50% fire damage.
*----------------------------------------------------------------------------------------------------*/

[System.Serializable]
[CreateAssetMenu(fileName = "New Elemental Types", menuName = "Elemental Stats")]

public class AttributeTypes : ScriptableObject
{
    // Public Parameters
    [SerializeField]
    private float _physical;
    [SerializeField]
    private float _fire;
    [SerializeField]
    private float _ice;
    [SerializeField]
    private float _lightning;
    [SerializeField]
    private float _darkness;
    [SerializeField]
    private float _piercing;

    [SerializeField]
    private List<float> _types;


    [SerializeField]
    private GameObject _model;

    public float Physical { get => _physical; }
    public float Fire { get => _fire; }
    public float Ice { get => _ice; }
    public float Lightning { get => _lightning; }
    public float Darkness { get => _darkness; }
    public float Piercing { get => _piercing; }
    public List<float> Types { get => _types; }
    //public dropdownAttackType attackType;

}
