using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Odyssey.Projectiles;

[System.Serializable]
public class BaseSpell : MonoBehaviour
{
    // Spell scriptable object which includes ID, description, icon, mana cost, projectile, etc.
    public SpellStats spellStats;

    public void CastSpell()
    {
        if ( spellStats.isSpellProjectile )
        {
            PlayerGlobals.playerAnim.SetFloat(spellStats.playerAnimationSpeedMultiplierParameterStringName, spellStats.playerAnimationSpeedMultiplier);
            PlayerGlobals.playerAnim.Play(spellStats.playerAnimationStringName, 7);
            PlayerGlobals.combatInput.Invoke("CastCooldown", spellStats.castTime);
            ProjectileCore.CreateNonHomingProjectilePlayerToTarget(spellStats.speed, spellStats.projectileModel, spellStats.projectileImpact);
        }
    }

}
