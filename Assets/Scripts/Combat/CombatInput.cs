using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.UI;
using System;
using Invector.vCharacterController;
using Odyssey.Combat;
using Odyssey.Projectiles;
using MoreMountains.InventoryEngine;
using MoreMountains.Tools;

/*---------------------------------------------------------------------------------------------------
*------------------------------------------- CombatInput --------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* Handles input controls for [Attack], [Item], or [Magic].
* ----------
* How to Use: 
* Attach this script to the player.
* [WARNING: At the moment, this script must be attached to each weapon. TO-DO: Generalize the script, move it to CombatCore and attach to Player only]
* ----------
* Requires:
* [CombatCore], [PlayerGlobals], [vThirdPersonInput], [GetAnimationLengths], [TimeManager]
*----------------------------------------------------------------------------------------------------*/
namespace Odyssey.Combat
{
    public class CombatInput : MonoBehaviour
    {
        /*-----------------------------------------------------------------
        *----------------------- Public Parameters ------------------------
        *------------------------------------------------------------------*/

        public Weapon weapon;                   // Scriptable Object
        public AbilityManager playerAM;         // Found on player
        // ---------------------------

        [HideInInspector]
        public CombatCore combat;

        [HideInInspector]
        public bool attackingOrCasting;

        [HideInInspector]
        public bool nextAttackIsQueued;

        public bool[] spellsQueued = new bool[4];

        [HideInInspector]
        public bool blockQueued;

        [HideInInspector]
        public bool blocking;

        public GameObject slashFX;

        public float playerRotateTime = 0.1f; 

        /*-----------------------------------------------------------------
        *------------------------ Private Variables -----------------------
        *------------------------------------------------------------------*/
        private float attackingTime;                        // Decremental counter
        private float comboEndCooldownTime;                 // Decremental counter
        private Animator anim;
        private GameObject player;
        private bool attackingDelayed;                      // Delayed attacking bool (allows attack collision detection soon after attacking begins)
        private GameObject[] enemies;
        private ComboState comboState;
        private vThirdPersonController cc;                  // For checking if player is grounded (cc.grounded)
        private int currentCombo = 0;
        private float timeSinceLastAttack = 0;              // Determine if combo continues
        private bool status_staggered;
        private bool rotatePlayer;

        /*-----------------------------------------------------------------
        *----------------------- Combo State Enums ------------------------
        *------------------------------------------------------------------*/
        public enum ComboState
        {
            notEndOfCombo,
            endedComboButAttackOnCooldown,
            endedComboAttackIsAvailable
        };

        /*-----------------------------------------------------------------
        *-------------------------- Command Enums -------------------------
        *------------------------------------------------------------------*/
        public enum CommandTypes
        {
            attack,
            spell1,
            spell2,
            spell3,
            spell4,
            item1,
            item2, 
            item3
        };

        /*-----------------------------------------------------------
        /*------------------- PROJECTILE TEST -----------------------
        *-----------------------------------------------------------*/
        [Space]

        private GameObject playerObj;
        private GameObject targetObj;

        /*-----------------------------------------------------------
        /*------------------- SPELL ENUMS TEST ----------------------
        *-----------------------------------------------------------*/
        public enum SpellNames
        {
            spell_fireball,
            spell_icefield,
            spell_windblade
        };

        /*-----------------------------------------------------------
        /*------------------------ AWAKE ----------------------------
        *-----------------------------------------------------------*/
        void Awake()
        {
            Cursor.visible = false;                                 // Make cursor invisible

            if (player == null)                                     // Get Invector's Input
                player = GameObject.FindWithTag("Player");

            if (player.TryGetComponent(out CombatCore cb))
                combat = cb;                                        // Get Combat Core (avoids mem alloc if null)

            if (player.TryGetComponent(out AbilityManager atks))
                playerAM = atks;                                        // Get Combat Core (avoids mem alloc if null)

            anim = player.GetComponent<Animator>();                 // Get animator

            cc = player.GetComponent<vThirdPersonController>();     // Get Invector's locomotion

            currentCombo = 0;                                       // Reset combo

        }
        //------------------------------------------------------------------

        /*-----------------------------------------------------------
        /*------------------------ UPDATE ---------------------------
        *-----------------------------------------------------------*/
        void Update()
        {
            ListenForSpellCastsThenCast();      // Listen for spell casts
            ListenForAttacksThenAttack();       // Listen for attacks
            ListenForBlocking();                // Listen for blocks
            AttackTimerDecrement();             // Attack timer

            // Unlock and show cursor if player presses ESC
            if (Input.GetKeyDown(KeyCode.Escape))
                Cursor.visible = false;

            // if (rotatePlayer)
            // {
            //     Debug.Log("Facing");
            //     var rotationAngle = Quaternion.LookRotation ( combat.targetObject.transform.position - player.transform.position);    // We get the angle has to be rotated
            //     rotationAngle.x = 0; // Fix rotation angle
            //     rotationAngle.z = 0; // Fix rotation angle
            //     player.transform.rotation = rotationAngle;
            //     //player.transform.rotation = Quaternion.Lerp(transform.rotation, rotationAngle, Time.deltaTime * 10f);        // we rotate the rotationAngle 
            // }
        }
        //------------------------------------------------------------------

        /// <summary>
        /// [TEST] This needs to go into separate Status.cs system eventually.
        /// </summary>
        public void Stagger(float duration)
        {
            status_staggered = true;
            // Disable player movement
            PlayerGlobals.invectorInput.SetLockBasicInput(true);
            //Invoke("LockInput", 0.05f); // Failsafe double lock input (the instant call above is usually reverted from invector)

            // Play stagger animation, index 7 is the combat animation layer for player
            anim.Play("Stagger", 7);

            Invoke("StaggerEnd", duration);
        }

        private void StaggerEnd()
        {
            PlayerGlobals.invectorInput.SetLockBasicInput(false);
            status_staggered = false;
        }

        /// <summary>
        /// Listen for attacks from Command Menu then apply attack.
        /// </summary>
        private void ListenForAttacksThenAttack()
        {
            // Listen for attack inputs
            if ( (nextAttackIsQueued) && !attackingOrCasting && comboState == ComboState.notEndOfCombo && !status_staggered)
            {

                SetAttackBooleanFlags();

                RefreshEnemyAttackableStatus(); // [TEST] Make enemy attackable (once per attack animation). TO-DO: Just enable/disable weapon collider on attack animation instead.

                // How long attack animation lasts (after modifiers)
                float modifiedAttackTime = GetAttackAnimTimeLength();
                
                // Buffer time before/after combo ends
                float comboBufferTime = weapon.ComboBufferTimePercentage * 0.01f * modifiedAttackTime;

                // Reset or add to combo
                if (timeSinceLastAttack > modifiedAttackTime + comboBufferTime || timeSinceLastAttack < 0 || !combat.enemyWasHitInPreviousAttack) 
                    currentCombo = 0;
                else
                    currentCombo++;

                // Disable player movement inputs temporarily while the player attacks
                PlayerGlobals.invectorInput.SetLockBasicInput(true);

                // Update to current combo
                modifiedAttackTime = GetAttackAnimTimeLength();

                // Set attack time (10% buffer to immediately attack. Are you a pro? Easter egg time it to hit up to 10% faster :D)
                attackingTime = modifiedAttackTime * 0.9f; 

                //DisableGravity(modifiedAttackTime); // Disable gravity

                combat.DashToTarget(1, 0, 0.35f);    // [TEST] Dash skill to target
                
                CheckComboEndAndApplyCooldown();                    // If combo finish, add cooldown
                SetDamageableAnimationFrames(modifiedAttackTime);   // Delay attack damage frames


                PlayAttackAnimations();                             // Play attack animation if not dashing

                // rotatePlayer = true; // Rotate during first 0.1 secs before the attack animation and attack
                //Invoke("PlayAttackAnimations", playerRotateTime);   // Play attack anim mid-dash
                //Invoke("SetAttackingTime", playerRotateTime);       // Correctly set the attack time again
                // CancelInvoke("RotatePlayerEnd");
                // Invoke("RotatePlayerEnd", playerRotateTime);

                // Rotate Player To Enemy Instantly (lerp buggy)
                var rotationAngle = Quaternion.LookRotation ( combat.targetObject.transform.position - player.transform.position);    // We get the angle has to be rotated
                rotationAngle.x = 0; // Fix rotation angle
                rotationAngle.z = 0; // Fix rotation angle
                player.transform.rotation = rotationAngle;

                ResetAttackParameters();            // Reset parameters

                if (playerAM.playerCombo[currentCombo].fxAttackPrefab != null)
                {
                    if (currentCombo == 0)
                        Invoke("SpawnSlashEffect", 0.1f);
                    else
                        Invoke("SpawnSlashEffect", 0.25f);
                }

            }
        }

        // private void RotatePlayerEnd()
        // {
        //     rotatePlayer = false;
        //     player.transform.rotation = new Quaternion(0, player.transform.rotation.y, 0, player.transform.rotation.w);
        // }

        private void SpawnSlashEffect()
        {
            // Stab effect
            if (currentCombo == 0)
            {
                GameObject slashSFX = Instantiate(playerAM.playerCombo[currentCombo].fxAttackPrefab, gameObject.transform.position, new Quaternion(0.3f, 0, 0, 0));
                slashSFX.transform.SetParent(PlayerGlobals.player.transform, true);

                Vector3 eulerRotation = new Vector3(slashSFX.transform.eulerAngles.x, PlayerGlobals.player.transform.eulerAngles.y, slashSFX.transform.eulerAngles.z);
                slashSFX.transform.rotation = Quaternion.Euler(eulerRotation);

                Destroy(slashSFX, 0.4f);
            }

            // Slash effect is attached on weapon (the ScriptableObject parameter is currently not in use except for stab effect)
            if (currentCombo > 0 && slashFX != null)
            {
                slashFX.SetActive(true); // Activate FX attached to weapon

                slashFX.transform.localScale = new Vector3(1f,1f,1.5f);
                
                // [WARNING][TEST] Hard-coded combo finisher fix rotation
                if (currentCombo > 3)
                {
                    Quaternion rot = Quaternion.Euler(-90f, 0f, 270f);
                    slashFX.transform.localRotation = rot;
                }

                slashFX.transform.SetParent(null, true); // Un-parent


                Invoke("DisableSlashEffect", 0.4f);
            }

            
        }

        private void DisableSlashEffect()
        {
            if (slashFX != null)
            {
                slashFX.transform.SetParent(gameObject.transform, true); // Re-parent

                // Set local position back to default
                slashFX.transform.localPosition = new Vector3(0f,0f,0f);

                // Set local rotation back to default
                Quaternion localRot = Quaternion.Euler(-90f, 0f, 90f);
                slashFX.transform.localRotation = localRot;

                // Set local scale back to default
                slashFX.transform.localScale = new Vector3(1f,1f,1.5f);

                slashFX.SetActive(false);
            }
        }

        /// <summary>
        /// Listens to player blocking. This action allows player to block some attacks for a second.
        /// </summary>
        private void ListenForBlocking()
        {
            if (Input.GetMouseButtonDown(1) || Input.GetButtonDown("LB")) // Right Click or LB
            {
                blockQueued = true;
            }

            if (blockQueued && attackingOrCasting == false)
            {
                PlayerGlobals.invectorInput.SetLockBasicInput(true);
                anim.SetInteger("BlockState", 1);
                blockQueued = false;
                attackingOrCasting = true;
                blocking = true;
                //anim.Play("Block", 7);
                Invoke("EndOfBlock", 1.0f);
                
            }
        
        }

        private void EndOfBlock()
        {
            blocking = false;
            attackingOrCasting = false;
            anim.SetInteger("BlockState", 2);
            PlayerGlobals.invectorInput.SetLockBasicInput(false);
        }

        private void LockInput()
        {
            PlayerGlobals.invectorInput.SetLockBasicInput(true);
        }

        // Sets attacking time
        private void SetAttackingTime()
        {
            attackingTime = GetAttackAnimTimeLength() * 0.9f; 
        }

        /// <summary>
        /// Get attack time (from animation) in seconds.
        /// </summary>
        private float GetAttackAnimTimeLength()
        {
            float value;
            if (player.GetComponent<GetAnimationLengths>().attackTimes.TryGetValue(playerAM.playerCombo[currentCombo].animationName, out value))
            {
                return value / playerAM.playerCombo[currentCombo].animationSpeedMultiplier;
            }
            else
            {
                Debug.LogError(playerAM.playerCombo[currentCombo].animationName + " is not a valid Key, Says Nathan");
            }
            return player.GetComponent<GetAnimationLengths>().attackTimes[playerAM.playerCombo[currentCombo].animationName] / playerAM.playerCombo[currentCombo].animationSpeedMultiplier;
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Makes enemies damageable once per normal attack.
        /// </summary>
        private void RefreshEnemyAttackableStatus()
        {
            // Each enemy can be hit again (set damageable parameter of each enemy to true, ensuring each enemy can be hit only once per attack)
            enemies = GameObject.FindGameObjectsWithTag("Enemy");

            foreach (GameObject enemy in enemies)
            {
                IsCombatable hittable = enemy.GetComponent<IsCombatable>();
                hittable.SetPhysicalDamageable(true);
            }
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Set bool flags on attack.
        /// </summary>
        private void SetAttackBooleanFlags()
        {
            // Reset queued attack
            nextAttackIsQueued = false;

            // Reset collision detection attack
            attackingDelayed = false;

            // Set flag to true for attack checks, set a delayed flag check (so each attack animation is non-damageable within the first 0.xx seconds)
            attackingOrCasting = true;
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Set damageable frames such that attack animations can only deal damage 20% into the animation, or 40% for combo finisher.
        /// </summary>
        private void SetDamageableAnimationFrames(float modifiedAttackTime)
        {
            //Debug.Log(currentCombo + " | " + weapon.Attacks.Length);
            if (currentCombo < playerAM.playerCombo.Count - 1)
                Invoke("DelayedAttacking", modifiedAttackTime * 0.20f);
            else
                Invoke("DelayedAttacking", modifiedAttackTime * 0.40f);            
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Check if combo end and apply cooldown to it.
        /// </summary>
        private void CheckComboEndAndApplyCooldown()
        {
            if (currentCombo >= playerAM.playerCombo.Count - 1)
            {
                if (cc.isGrounded)
                    comboEndCooldownTime = weapon.CooldownAfterComboEndGround;
                else
                    comboEndCooldownTime = weapon.CooldownAfterComboEndAir;
                comboState = ComboState.endedComboButAttackOnCooldown;
            }
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Temporarily disable player's gravity during attack and reset velocity (aerial).
        /// </summary>
        private void DisableGravity(float modifiedAttackTime)
        {
            player.gameObject.GetComponent<Rigidbody>().useGravity = false;
            if (combat.targetObject != null && modifiedAttackTime > 0.01f && modifiedAttackTime < 10.0f)
                combat.timeUntilGravityEnabled = modifiedAttackTime - modifiedAttackTime*0.15f - 0.15f;
            else
                combat.timeUntilGravityEnabled = 0.01f;
            player.gameObject.GetComponent<Rigidbody>().velocity = new Vector3(0f,0f,0f); // Reset velocity
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Reset parameters after attack input.
        /// </summary>
        private void ResetAttackParameters() 
        {
            // Reset time since last attack
            timeSinceLastAttack = 0f;

            // Reset enemy was hit (to determine if attack will continue combo, based on if previous attack successfully connected to an enemy)
            combat.enemyWasHitInPreviousAttack = false;
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Plays attack animation and sets speed accordingly.
        /// </summary>
        private void PlayAttackAnimations()
        {

            // Set the animation speed multiplier specified in the Inspector
            anim.SetFloat(playerAM.playerCombo[currentCombo].attackSpeedParameterName, playerAM.playerCombo[currentCombo].animationSpeedMultiplier);

            // Play attack animation according to current combo, index 7 is the attack animation layer in the player animator
            anim.Play(playerAM.playerCombo[currentCombo].attackAnimationName, 7);
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Decrement attack timer to determine if next hit is within combo.
        /// </summary>
        private void AttackTimerDecrement()
        {
            // Add to time since previous attack
            timeSinceLastAttack += Time.deltaTime;

            // Subtract attacking time (player stops rotating toward target and regains movement and control after it reaches 0)
            if (attackingTime >= 0)
            {
                attackingTime -= Time.deltaTime;
                if (currentCombo >= playerAM.playerCombo.Count - 1 && comboState == ComboState.endedComboButAttackOnCooldown)
                {
                    InvokeRepeating("ComboEndTimeLoop", 0.02f, 0.02f);
                    comboState = ComboState.endedComboAttackIsAvailable;
                }
            } 
            else if (attackingTime < 0 && attackingTime > -1)
            {
                // Unlock input
                if (!status_staggered)
                {
                    PlayerGlobals.invectorInput.SetLockBasicInput(false);
                }

                // Fix player rotation
                //rotatePlayer = true; // Rotate during first 0.1 secs before the attack animation and attack
                // CancelInvoke("RotatePlayerEnd");
                // Invoke("RotatePlayerEnd", playerRotateTime);
                // Rotate Player To Enemy Instantly (lerp buggy)
                // var rotationAngle = Quaternion.LookRotation ( combat.targetObject.transform.position - player.transform.position);    // We get the angle has to be rotated
                // rotationAngle.x = 0; // Fix rotation angle
                // rotationAngle.z = 0; // Fix rotation angle
                // player.transform.rotation = rotationAngle;

                attackingOrCasting = false;
                attackingDelayed = false;

                // Make this run only once by subtracting 1
                attackingTime -= 1.0f;

                // Reset combo if combo ended
                if (currentCombo == playerAM.playerCombo.Count - 1)
                {
                    currentCombo = 0;
                    timeSinceLastAttack = -1000f; // Reset time since last attack
                }
            }
        }
        //------------------------------------------------------------------

        /// <summary>
        /// [TEST] Listens for spell cast inputs from the Command Menu.
        /// </summary>
        private void ListenForSpellCastsThenCast() 
        {
            // Spell 1 (TO-DO: Move to Spell Casting System when it is ready)
            if ( (spellsQueued[0]) && attackingOrCasting == false)
            {
                //SpellLockInputs(0);     // Now called in Grimoire
                player.GetComponent<Grimoire>().CastSpell(0);
            } else if ( (spellsQueued[1]) && attackingOrCasting == false && cc.isGrounded)
            { // Spell 2
                player.GetComponent<Grimoire>().CastSpell(1);
            } else if ( (spellsQueued[2]) && attackingOrCasting == false)
            { // Spell 3
                player.GetComponent<Grimoire>().CastSpell(2);
            } else if ( (spellsQueued[3]) && attackingOrCasting == false)
            { // Spell 4
                player.GetComponent<Grimoire>().CastSpell(3);
            }
        }
        //------------------------------------------------------------------

        /// <summary>
        /// [TEST] Set bools and lock inputs.
        /// </summary>
        public void SpellLockInputs(int spellID)
        {
            spellsQueued[spellID] = false; // Reset queued attack
            PlayerGlobals.invectorInput.SetLockBasicInput(true); // Lock motion
            attackingOrCasting = true; // Player is now busy
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Cooldown counter before player can attack again after finishing an attack combo.
        /// </summary>
        private void ComboEndTimeLoop()
        {
            comboEndCooldownTime -= Time.deltaTime;
            if (comboEndCooldownTime <= 0.0f)
            {
                comboState = ComboState.notEndOfCombo;
                CancelInvoke("ComboEndTimeLoop");
            }
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Manages cooldown time of spells (player cannot attack or cast other spells during downtime).
        /// </summary>
        public void CastCooldown()
        {
            for (int i = 0; i < spellsQueued.Length; i++)
                spellsQueued[i] = false;
            if (!status_staggered)
                PlayerGlobals.invectorInput.SetLockBasicInput(false);
            attackingOrCasting = false;
        }
        //------------------------------------------------------------------

        /// <summary>
        /// QUEUE THE NEXT COMMAND (COMMAND MENU CALLS THIS TO ATTEMPT ATTACKS)
        /// </summary>
        public void QueueNextCommand(CommandTypes type)
        {
            if (type == CommandTypes.attack)
            {

                float value;
                if (player.GetComponent<GetAnimationLengths>().attackTimes.TryGetValue(playerAM.playerCombo[currentCombo].animationName, out value))
                {
                }
                else
                {
                    Debug.LogError(playerAM.playerCombo[currentCombo].animationName + " is not a valid Key, Says Nathan");
                }

                float modifiedAttackTime = player.GetComponent<GetAnimationLengths>().attackTimes[playerAM.playerCombo[currentCombo].animationName] / playerAM.playerCombo[currentCombo].animationSpeedMultiplier;
                float queueBufferTime = weapon.QueueAttackBufferTimePercentage * 0.01f * modifiedAttackTime;
                if ((timeSinceLastAttack > modifiedAttackTime - queueBufferTime && timeSinceLastAttack > 0) || attackingOrCasting == false)
                {
                    nextAttackIsQueued = true;
                }
            }
            else if (type == CommandTypes.spell1)
                spellsQueued[0] = true;
            else if (type == CommandTypes.spell2)
                spellsQueued[1] = true;
            else if (type == CommandTypes.spell3)
                spellsQueued[2] = true;
            else if (type == CommandTypes.spell4)
                spellsQueued[3] = true;
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Small delayed bool that activates to true soon after player starts attacking. This makes it so enemies can only be damaged 20-40% into the attack animation.
        /// </summary>
        private void DelayedAttacking()
        {
            attackingDelayed = true;
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Detects when Player Weapon comes into collision with enemy. TO-DO: change IsPhysicalDamageable to enable collider player attacks, disable after damage.
        /// </summary>
        void OnTriggerEnter(Collider enemyCollider)
        {
            IsCombatable hittable = enemyCollider.GetComponent<IsCombatable>();

            if (hittable != null)
            {
                if (hittable.IsPhysicalDamageable())
                {
                    if (attackingDelayed)
                    {
                        if (enemyCollider.GetComponent<EnemyInput>().attackingOrCasting)
                            enemyCollider.GetComponent<EnemyCombatCore>().bothAttacking = true;
                        else
                            enemyCollider.GetComponent<EnemyCombatCore>().bothAttacking = false;

                        if (!enemyCollider.GetComponent<EnemyCombatCore>().bothAttacking)
                        {
                            if (currentCombo < playerAM.playerCombo.Count - 1)
                                combat.ApplyBasicAttack(hittable, weapon.Power * playerAM.playerCombo[currentCombo].attackMultiplier, playerAM.playerCombo[currentCombo].knockbackForce, playerAM.playerCombo[currentCombo].knockupForce, currentCombo, true, playerAM.playerCombo[currentCombo].fxImpactPrefab); // Damage, knockback force, combo count, dash
                            else
                            {
                                combat.ApplyAOEAttack(enemyCollider.transform, 5.0f, weapon.Power * playerAM.playerCombo[currentCombo].attackMultiplier, 10.0f, playerAM.playerCombo[currentCombo].fxImpactPrefab, 3.0f);
                                enemyCollider.GetComponent<EnemyInput>().Stagger(2.5f); // [TEST] Stagger ENEMY
                            }
                        }   
                    }
                }
            }
        }
        //------------------------------------------------------------------

    }
}