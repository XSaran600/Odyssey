using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.UI;
using System;
// using UnityEngine.Rendering.PostProcessing;

/*---------------------------------------------------------------------------------------------------
*--------------------------------------- Enemy Combat Core ------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* [Enemy Combat Core] allows enemy to deal damage, knockback, effects, and so on.
* ----------
* How to Use: 
* Attach this script to the enemy.
* ----------
* Requires:
*
*----------------------------------------------------------------------------------------------------*/
namespace Odyssey.Combat
{
    /// <summary>
    /// Allows enemy to deal damage, knockback, and effects.
    /// </summary>
    public class EnemyCombatCore : MonoBehaviour
    {

        /*-----------------------------------------------------------------
        *----------------------- Public Parameters ------------------------
        *------------------------------------------------------------------*/
        // public GameObject enemyWeapon;

        [HideInInspector]
        public GameObject targetObject;

        [HideInInspector]
        public EnemyInput enemyInput;

        [HideInInspector]
        public GameObject enemyWeapon;

        [HideInInspector]
        public bool enemyWasHitInPreviousAttack; // Determine if enemy was hit in the previous attack (to decide if the combo will continue)

        [HideInInspector]
        public float timeUntilGravityEnabled;

        //[HideInInspector]
        public bool bothAttacking;         // Both player and enemy attacking?

        /*-----------------------------------------------------------------
        *------------------------ Private Variables -----------------------
        *------------------------------------------------------------------*/
        private bool _attacking;            // Is the enemy attacking right now?
        private float dist;                 // Distance from player
        

        private void Start()
        {
            // Get target (player)

            targetObject = PlayerGlobals.player;

        }
        void Update()
        {

            // ----------------------------------------------------------------------------------------------------------------------------
            // ---- TIME UNTIL GRAVITY RE-ENABLED (enemy floats while doing aerial attacks, and regains gravity after done attacking) ----
            // ----------------------------------------------------------------------------------------------------------------------------
            /*
            timeUntilGravityEnabled -= Time.deltaTime;

            if (timeUntilGravityEnabled <= 0)
            {
                gameObject.GetComponent<Rigidbody>().useGravity = true;
            }
            */
            // ---------------------------------------
            // ------------ Set Weapon ---------------
            // ---------------------------------------
            // Only the enemy weapon's hitbox should have this tag
            // if (enemyWeapon == null)
            //     enemyWeapon = GameObject.FindWithTag("EnemyWeapon");

            // Get player's combat input
            if (gameObject.TryGetComponent(out EnemyInput i))
                enemyInput = i;                                          // Get Enemy Input (avoids mem alloc if null)

            // Is player attacking update (make player face enemy if attacking)
            if (enemyInput != null)
               _attacking = enemyInput.attackingOrCasting;

            // --------------------------------------------
            // --------------- Attack Timer ---------------
            // --------------------------------------------

            // Make enemy face player
            if (_attacking)
            {
                // to do - lock Y rotation
                var rotationAngle = Quaternion.LookRotation ( targetObject.transform.position - transform.position);    // We get the angle has to be rotated
                rotationAngle.x = 0; // Fix rotation angle
                rotationAngle.z = 0; // Fix rotation angle
                transform.rotation = Quaternion.Lerp(transform.rotation, rotationAngle, Time.deltaTime * 10f);        // we rotate the rotationAngle 
                //Debug.Log(transform.rotation.x);
            } else {
                // End animation
            }

        }
        //------------------------------------------------------------------

        /// <summary>
        /// Dashes to target on attack (dashType 1 = in front, 2 = behind, always set dashCounter = 0)
        /// </summary>
        /*
        public void DashToTarget(int dashType, int dashCounter, float dashTime) // 1 = in front, 2 = behind
        {
            // Dash if within dash range
            dist = Vector3.Distance(gameObject.transform.position, targetObject.transform.position);

            //if (dist < dashMaxDistance && dist > dashMinDistance)
            if (dist < 15)
            {
                // Dash in front of enemy
                Vector3 inFrontOfEnemy;
                inFrontOfEnemy = targetObject.transform.position - gameObject.transform.position;

                // Aerial Attack
                if (dashType == 1 && PlayerGlobals.charController.isGrounded == false && dist > 2 && dist < 10)
                {
                    if (targetObject.transform.position.y > gameObject.transform.position.y)
                        transform.DOMove((targetObject.transform.position - inFrontOfEnemy.normalized * 1.2f) + new Vector3(0f, 0.3f, 0f), dashTime).SetEase(Ease.InExpo).OnComplete(() => FinishDash());
                    else if (targetObject.transform.position.y < gameObject.transform.position.y)
                        transform.DOMove((targetObject.transform.position - inFrontOfEnemy.normalized * 1.2f) + new Vector3(0f, -0.3f, 0f), dashTime).SetEase(Ease.InExpo).OnComplete(() => FinishDash());
                    else
                        transform.DOMove((targetObject.transform.position - inFrontOfEnemy.normalized * 1.2f), dashTime).SetEase(Ease.InExpo).OnComplete(() => FinishDash());
                }
                // Ground DASH Attack
                else if (dashType == 1 && dist > 2 && dist < 8)
                {
                    gameObject.GetComponent<Animator>().Play("Armature|running", 0);
                    transform.DOMove(targetObject.transform.position - inFrontOfEnemy.normalized * 1.2f, dashTime).SetEase(Ease.InExpo).OnComplete(() => FinishDash());
                    //transform.DOJump(targetObject.transform.position - inFrontOfEnemy.normalized * 1.2f, 3.0f, 1, 0.7f, false);
                }
                // Ground JUMP Attack
                else if (dashType == 1 && dist > 8 && dist < 15)
                {
                    //transform.DOMove(targetObject.transform.position - inFrontOfEnemy.normalized * 1.2f, dashTime).SetEase(Ease.InExpo).OnComplete(() => FinishDash());
                    transform.DOJump(targetObject.transform.position - inFrontOfEnemy.normalized * 1.2f, 3.0f, 1, 0.8f, false);
                }
                // Dash Behind Target
                else if (dashType == 2)
                    transform.DOMove(gameObject.transform.position + inFrontOfEnemy.normalized * 2.0f, dashTime).SetEase(Ease.InExpo).OnComplete(() => FinishDash());
            }

            // Update Dash (Enemy may have moved mid-dash, so update again)
            // if (dashCounter == 0)
            //    Invoke("DashUpdate", 0.3f);
        }
        
        //------------------------------------------------------------------

        // Stop current dash and update dash position
        private void DashUpdate()
        {
            transform.DOKill(false);
            DashToTarget(1, 1, 0.08f);
        }
        //------------------------------------------------------------------
        */

        /// <summary>
        /// Applies an attack on a combatable object.
        /// </summary>
        public void ApplyBasicAttack(IsCombatable hittable, float damage, float knockbackForce, float knockupForce, int combo, bool dash, GameObject fxImpact) // TO-DO: This will soon take more parameters (ApplyBasicAttack(damage, damageType, knockbackForce, statusEffect, impactFX, etc))
        {
            if (PlayerGlobals.combatInput.attackingOrCasting)
                bothAttacking = true;

            // Stagger if both are attacking
            if (PlayerGlobals.combatInput.blocking)
            {
                gameObject.GetComponent<EnemyInput>().Stagger(2.5f); // [TEST] Stagger ENEMY
                DamageText.Instance.CreateFloatingDMGText("Blocked!", 1.0f);
                bothAttacking = false;
            }
            else if (bothAttacking) // Clash
            {
                PlayerGlobals.combatInput.Stagger(1.0f); // [DEBUG] [TEST] stagger the PLAYER
                gameObject.GetComponent<EnemyInput>().Stagger(2.5f); // [TEST] Stagger ENEMY
                DamageText.Instance.CreateFloatingDMGText("Clash!", 1.0f);
                bothAttacking = false;
            }
            else
            {
                DamageText.Instance.CreateFloatingDMGText(damage.ToString(), 1.0f);
                PlayerGlobals.combatInput.Stagger(1.0f); // [DEBUG] [TEST] stagger the PLAYER
                bothAttacking = false;

                // Add force to object, if object has no rigidbody, add to parent
                ApplyKnockback(knockbackForce, knockupForce);

                // Add FX effect
                if (fxImpact != null)
                    Destroy((Instantiate(fxImpact, targetObject.transform.position, targetObject.transform.rotation)), 3);

                // Deal Damage
                //dmg = DamageCalculation.Damage(combatInput.playerObj, targetObject, attackTypes, damage);
                hittable.TakePhysicalDamage(damage);

                // [TEST] Audio!
                //JSAM.AudioManager.PlaySound(JSAM.Sounds.CoolSound);

                // Enemy is hit (to determine if next attack will continue combo)
                enemyWasHitInPreviousAttack = true;
            }

        }
        //------------------------------------------------------------------

        /// <summary>
        /// Applies an area attack at a point with a specified radius.
        /// </summary>
        public void ApplyAOEAttack(Transform origin, float radius, float damage, float knockbackForce, GameObject fxImpact, float fxDuration)
        {
            // Add FX effect
            Destroy((Instantiate(fxImpact, origin)), fxDuration);

            // Find all combatable enemies
            GameObject[] enemies;
            enemies = GameObject.FindGameObjectsWithTag("Enemy");

            foreach (GameObject enemy in enemies)
            {
                IsCombatable hittable = enemy.GetComponent<IsCombatable>();
                // Combatable enemies
                if (hittable != null)
                {
                    // Enemies within AoE
                    if (GetDist(enemy, origin.gameObject) < radius)
                    {
                        // Knock away from impact point
                        enemy.GetComponent<Rigidbody>().AddForce((enemy.transform.position - gameObject.transform.position).normalized * knockbackForce * 2f, ForceMode.Impulse);

                        // Deal Damage
                        hittable.TakePhysicalDamage(damage);
                    }

                }
            }

            // Give buffer time until player gravity is re-enabled in the case of aerial attacks
            // timeUntilGravityEnabled = 0.5f;

            // Enemy is hit (to determine if next attack will continue combo)
            enemyWasHitInPreviousAttack = true;
        }
        //------------------------------------------------------------------

        private void ApplyKnockback(float knockbackForce, float knockupForce)
        {
            if (targetObject.GetComponent<Rigidbody>() != null)
            {
                // Knock away
                targetObject.GetComponent<Rigidbody>().AddForce((targetObject.transform.position - gameObject.transform.position).normalized * knockbackForce * 2f, ForceMode.Impulse);
                // Knock up
                targetObject.GetComponent<Rigidbody>().AddForce(targetObject.transform.up * knockupForce * 35f);
            }
            else {
                // Knock away
                targetObject.transform.root.GetComponent<Rigidbody>().AddForce((targetObject.transform.root.transform.position - gameObject.transform.position).normalized * knockbackForce * 2f, ForceMode.Impulse);
                // Knock up
                targetObject.transform.root.GetComponent<Rigidbody>().AddForce(transform.up * knockupForce * 35f);
            }
        }

        // Return distance (TO-DO: Optimize without using Distance(), no need for square-rooting!)
        private float GetDist(GameObject origin, GameObject target)
        {
            return Vector3.Distance(origin.transform.position, target.transform.position);
        }
        //----------------------------------------------------------------------------------------------------------------------------------

        void FinishDash()
        {

        }
        //------------------------------------------------------------------

    }
}
