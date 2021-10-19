using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*---------------------------------------------------------------------------------------------------
*----------------------------------------- IsCombatable ---------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* IsCombatable is an interface. It has functions that a class can and must implement.
* This allows any class such as Enemy.cs, or Destructables.cs, or Player.cs, to extend IsCombatable.
* This class allows multiple classes and objects to be combatable.
* It is like polymorphism but the IsCombatable functions must be declared in any class that extends it.
* It can give different behaviors to these classes.
* For example, in Enemy.cs, TakePhysicalDamage(float damage) may calculate damage and apply damage.
* On the contrary, in Destructables.cs, TakePhysicalDamage(float damage) may simply destroy the object.
* ----------
* How to Use: 
* ie. Include all of the functions below in a class that extends IsCombatable. Refer to Enemy.cs.
*----------------------------------------------------------------------------------------------------*/
public interface IsCombatable
{
    bool IsPhysicalDamageable();
    void SetPhysicalDamageable(bool isDamageable);
    float GetHealth();
    float GetMaxHP();
    void TakePhysicalDamage(float damage);
    void TakeMagicDamage(float damage, int type = 0);
}

