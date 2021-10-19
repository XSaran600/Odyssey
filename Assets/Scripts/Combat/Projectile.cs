using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*---------------------------------------------------------------------------------------------------
*------------------------------------------- Projectile ---------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* Projectile class to be attached to any projectile object. Deals with power, speed, collision, etc.
* ----------
* How to Use: 
* Attach script to any projectile object.
*----------------------------------------------------------------------------------------------------*/
namespace Odyssey.Projectiles
{
    public class Projectile : MonoBehaviour
    {
        private IsCombatable hittable;
        public BaseSpell projectileStats;

        public float power;
        public float speed;
        public float castTime;
        public float knockbackForce;
        [Tooltip("Does an enemy own this projectile? This can be set in the CreateProjectile function as well")] public bool enemyProjectile;

        private void Awake()
        {
            /*
            power = projectileStats.spellStats.power;
            speed = projectileStats.spellStats.speed;
            castTime = projectileStats.spellStats.castTime;
            knockbackForce = projectileStats.spellStats.knockbackForce;
            */
            //Destroy(gameObject, 1f);

        }

        void OnTriggerEnter(Collider collider)
        {
            if (collider.gameObject != gameObject)
            {
                hittable = collider.GetComponent<IsCombatable>();

                if (hittable != null && collider.tag.Equals("Enemy") || (hittable != null && collider.tag.Equals("Player") && enemyProjectile))
                {
                    // Knockback (parent or child depending whichever has rigidbody)
                    if (collider.GetComponent<Rigidbody>() != null)
                        collider.GetComponent<Rigidbody>().AddForce((collider.transform.position - gameObject.transform.position).normalized * knockbackForce * 5f, ForceMode.Impulse);
                    else
                        collider.transform.parent.GetComponent<Rigidbody>().AddForce((collider.transform.parent.position - gameObject.transform.position).normalized * knockbackForce * 5f, ForceMode.Impulse);

                    // Deal Damage
                    hittable.TakePhysicalDamage(power);

                    //Destroy(gameObject);
                }
            }
        }

    }
}
