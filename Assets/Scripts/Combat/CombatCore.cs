using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.UI;
using System;

// using UnityEngine.Rendering.PostProcessing;

/*---------------------------------------------------------------------------------------------------
*------------------------------------------ Combat Core ---------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* [Combat Core] applies attacks which deals damage, knockback, effects, and so on.
* ----------
* How to Use: 
* Attach this script to the player.
* ----------
* Requires:
* [PlayerGlobals] -> [vThirdPersonInput]
* ----------
* [TO-DO]: Making combat core static.
*----------------------------------------------------------------------------------------------------*/
namespace Odyssey.Combat
{
    /// <summary>
    /// Combat core class attached to player that allows the player to deal damage, knockback, and effects.
    /// </summary>
    public class CombatCore : MonoBehaviour
    {

        /*-----------------------------------------------------------------
        *----------------------- Public Parameters ------------------------
        *------------------------------------------------------------------*/
        [Space]
        [Header("__ Lock-On UI __")]
        [Tooltip("Map player's aim UI sprite here")]
        public Image aim;
        [Tooltip("Map player's lockon UI sprite here")] 
        public Image lockAim;
        [Tooltip("UI lockon icon positional offset from enemy transform")] 
        public Vector2 uiOffset;

        [Space]
        [Header("__ Skill: Dash __")]
        [Range(0, 30)] public float dashMinDistance = 2.0f;
        [Range(0, 30)] public float dashMaxDistance = 15.0f;
        // ---------------------------

        [HideInInspector]
        public List<GameObject> screenTargets = new List<GameObject>();

        [HideInInspector]
        public GameObject targetObject;

        [HideInInspector]
        public bool enemyWasHitInPreviousAttack; // Determine if enemy was hit in the previous attack (to decide if the combo will continue)

        [HideInInspector]
        public float timeUntilGravityEnabled;

        [HideInInspector]
        public bool dashing;

        /*-----------------------------------------------------------------
        *------------------------ Private Variables -----------------------
        *------------------------------------------------------------------*/
        private bool _attacking;            // Is the player attacking right now?
        private bool isLocked;              // Lock player cursor
        private float dist;                 // Distance from player
        private GameObject playerWeapon;    // Player weapon (which allows combat input)
        private CombatInput combatInput;    // Player's combat input

        void Awake()
        {
            Cursor.visible = false;
        }
        private void OnEnable()
        {

        }
        void Update()
        {

            // ----------------------------------------------------------------------------------------------------------------------------
            // ---- TIME UNTIL GRAVITY RE-ENABLED (player floats while doing aerial attacks, and regains gravity after done attacking) ----
            // ----------------------------------------------------------------------------------------------------------------------------
            timeUntilGravityEnabled -= Time.deltaTime;

            if (timeUntilGravityEnabled <= 0)
            {
                gameObject.GetComponent<Rigidbody>().useGravity = true;
            }

            // ---------------------------------------
            // ------------ Set Weapon ---------------
            // ---------------------------------------
            // Only the player weapon's hitbox should have this tag
            if (playerWeapon == null)
                playerWeapon = GameObject.FindWithTag("PlayerWeapon");

            // Get player's combat input from the WEAPON'S HITBOX
            if (combatInput == null && playerWeapon)
                combatInput = playerWeapon.GetComponent<CombatInput>();

            // ---------------------------------------
            // --------------- Lock On ---------------
            // ---------------------------------------

            // Is player attacking update (make player face enemy if attacking)
            if (combatInput != null)
            {
                _attacking = combatInput.attackingOrCasting;
            }

            // Stop if no targets
            if (screenTargets.Count < 1)
                return;

            // Show aim and lock-on UI
            if (targetObject != null)
            {
                aim.transform.position = Camera.main.WorldToScreenPoint(targetObject.transform.position + new Vector3 (0f, screenTargets[targetIndex()].GetComponent<SetLockOnTarget>().uiOffset, 0f));
                Color c = screenTargets.Count < 1 ? Color.clear : Color.white;
                aim.color = c;
            }

            // Get lock on targets
            if (!isLocked)
                targetObject = screenTargets[targetIndex()];

            // --------------------------------------------
            // --------------- Attack Timer ---------------
            // --------------------------------------------
            
            /*
            // Make player face target
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
            */

            // [TEST]
            // if (cc.isGrounded) // Re-enable gravity
            //     cc.EnableGravityAndCollision(0.01f);

        }
        //------------------------------------------------------------------

        /// <summary>
        /// Dashes to target on attack (dashType 1 = in front, 2 = behind, always set dashCounter = 0)
        /// </summary>
        public void DashToTarget(int dashType, int dashCounter, float dashTime) // 1 = in front, 2 = behind
        {
            dashing = false; 

            if (screenTargets.Count < 1)
                return;

            targetObject = screenTargets[targetIndex()];        // Get target

            // Dash if within dash range
            dist = Vector3.Distance(gameObject.transform.position, targetObject.transform.position);

            //if (dist < dashMaxDistance && dist > dashMinDistance)
            if (dist < dashMaxDistance*999)
            {

                // Dash in front of enemy
                Vector3 inFrontOfEnemy;
                inFrontOfEnemy = targetObject.transform.position - gameObject.transform.position;

                // Aerial Attack
                if (dashType == 1 && PlayerGlobals.charController.isGrounded == false && dist > dashMinDistance)
                {
                    dashing = true;
                    if (targetObject.transform.position.y > gameObject.transform.position.y)
                        transform.DOMove((targetObject.transform.position - inFrontOfEnemy.normalized * 1.2f) + new Vector3(0f, 0.3f, 0f), dashTime).SetEase(Ease.InExpo).OnComplete(() => FinishDash());
                    else if (targetObject.transform.position.y < gameObject.transform.position.y)
                        transform.DOMove((targetObject.transform.position - inFrontOfEnemy.normalized * 1.2f) + new Vector3(0f, -0.3f, 0f), dashTime).SetEase(Ease.InExpo).OnComplete(() => FinishDash());
                    else
                        transform.DOMove((targetObject.transform.position - inFrontOfEnemy.normalized * 1.2f), dashTime).SetEase(Ease.InExpo).OnComplete(() => FinishDash());
                }
                // Ground Attack
                else if (dashType == 1 && dist > dashMinDistance && dist < dashMaxDistance)
                {
                    dashing = true;
                    transform.DOMove(targetObject.transform.position - inFrontOfEnemy.normalized * 0.3f, dashTime).SetEase(Ease.InExpo).OnComplete(() => FinishDash());
                }
                // Dash Behind Target
                else if (dashType == 2)
                {
                    dashing = true;
                    transform.DOMove(gameObject.transform.position + inFrontOfEnemy.normalized * 2.0f, dashTime).SetEase(Ease.InExpo).OnComplete(() => FinishDash());
                }
           }

            // Update Dash (Enemy may have moved mid-dash, so update again)
            if (dashCounter == 0)
               Invoke("DashUpdate", 0.3f);
        }
        //------------------------------------------------------------------

        // Stop current dash and update dash position
        private void DashUpdate()
        {
            transform.DOKill(false);
            DashToTarget(1, 1, 0.05f);
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Applies an attack on a combatable object.
        /// </summary>
        public void ApplyBasicAttack(IsCombatable hittable, float damage, float knockbackForce, float knockupForce, int combo, bool dash, GameObject fxImpact) // TO-DO: This will soon take more parameters (ApplyBasicAttack(damage, damageType, knockbackForce, statusEffect, impactFX, etc))
        {
                // Continue if target found (soft lock-on)
                if (screenTargets.Count < 1)
                    return;

                targetObject = screenTargets[targetIndex()];        // Get target

                // Add force to object, if object has no rigidbody, add to parent
                ApplyKnockback(knockbackForce, knockupForce);

                // Add FX effect
                if (fxImpact != null)
                    Destroy((Instantiate(fxImpact, targetObject.transform.position, gameObject.transform.rotation)), 3);

                // Deal Damage
                //float dmg = 0f;
                //dmg = DamageCalculation.Damage(combatInput.playerObj, targetObject, attackTypes, damage);
                hittable.TakePhysicalDamage(damage);

                // [TEST] Audio!
                //JSAM.AudioManager.PlaySound(JSAM.Sounds.CoolSound);

                // Give buffer time until player gravity is re-enabled in the case of aerial attacks
                // timeUntilGravityEnabled = 0.5f;

                // Enemy is hit (to determine if next attack will continue combo)
                enemyWasHitInPreviousAttack = true;
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Applies an area attack at a point with a specified radius.
        /// </summary>
        public void ApplyAOEAttack(Transform origin, float radius, float damage, float knockbackForce, GameObject fxImpact, float fxDuration)
        {

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

                        // [DEBUG] [TEST] Stagger
                        enemy.GetComponent<EnemyInput>().Stagger(3.0f);

                        // Add FX effect
                        Destroy((Instantiate(fxImpact, enemy.transform)), fxDuration);
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
        //------------------------------------------------------------------

        void LockInterface(bool state)
        {
            float size = state ? 1 : 2;
            float fade = state ? 1 : 0;
            lockAim.DOFade(fade, .15f);
            lockAim.transform.DOScale(size, .15f).SetEase(Ease.OutBack);
            lockAim.transform.DORotate(Vector3.forward * 180, .15f, RotateMode.FastBeyond360).From();
            aim.transform.DORotate(Vector3.forward * 90, .15f, RotateMode.LocalAxisAdd);
        }
        //------------------------------------------------------------------

        void FinishDash()
        {
            isLocked = false;
            LockInterface(false);
            aim.color = Color.clear;
        }
        //------------------------------------------------------------------

        void DistortionAmount(float x)
        {
            // postProfile.GetSetting<LensDistortion>().intensity.value = x;
        }
        //------------------------------------------------------------------

        void ScaleAmount(float x)
        {
            // postProfile.GetSetting<LensDistortion>().scale.value = x;
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Get soft lock-on target based on camera look-at ([TO-DO]: do player directional lock-on option)
        /// </summary>
        public int targetIndex()
        {
            float[] distances = new float[screenTargets.Count];

            for (int i = 0; i < screenTargets.Count; i++)
            {
                distances[i] = Vector2.Distance(Camera.main.WorldToScreenPoint(screenTargets[i].transform.position), new Vector2(Screen.width / 2, Screen.height / 2));
            }

            float minDistance = Mathf.Min(distances);
            int index = 0;

            for (int i = 0; i < distances.Length; i++)
            {
                if (minDistance == distances[i])
                    index = i;
            }
            return index;
        }
        //------------------------------------------------------------------

    }
}
