using UnityEngine;
using UnityEngine.Events;

/*---------------------------------------------------------------------------------------------------
*------------------------------------------- EnemyInput ---------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* Handles enemy input controls for [Attack], [Item], or [Magic].
* ----------
* How to Use: 
* Attach this script to the enemy weapon.
* -----
* Reference currentComboSetIndex or Call GetComboSet to get currently active combo set.
* -----
* 
* =========================================================================================================================================================
* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! THERE ARE 4 FUNCTIONS YOU MAY USE FOR YOUR ENEMY AI SO FAR: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
* =========================================================================================================================================================
* TO CALL: using Odyssey.Combat
*
* 1. Call SetComboSet("ComboName")         to change active combo set alternatively.                   [DONE, IMPLEMENTED]
* 2. Call SetComboSet(int index)           to change active combo set alternatively.                   [DONE, IMPLEMENTED]
* 3. Call DoEnemyAttack()                  to attack once (will not run or queue if currently busy)    [DONE, IMPLEMENTED]
* 4. Call DoEnemyCombo()                   to play entire combo once based on active combo set.        [DONE, IMPLEMENTED]    
* 
* ie.
* enemyInput.SetComboSet("Wrath of the Lion");  // This will change the combo set.
* enemyInput.DoEnemyAttack();                   // This will do an attack (it can be stringed for combo). It will not interrupt the current action.
* enemyInput.DoEnemyCombo();                    // This will play the entire combo. It will not interrupt the current action.
* =========================================================================================================================================================
* 
* 
* Call DoEnemyAttack()                  to attack once (will not run or queue if currently busy)    [TO-DO] NOT IMPLEMENTED YET.
* Call DoEnemyAttacks(int repeatCount)  to attack n times.                                          [TO-DO] NOT IMPLEMENTED YET.
* 
* Call DoEnemyCombo(int repeatCount)    to play entire combo n times based on active combo set.     [TO-DO] NOT IMPLEMENTED YET.
* Call DoEnemyCombo("ComboName", int repeatCount)   to play specific combo set based on name.       [TO-DO] NOT IMPLEMENTED YET.
* Call DoEnemyCombo(int index, int repeatCount)     to play specific combo set based on index.      [TO-DO] NOT IMPLEMENTED YET.
* -----
* Requires:
* [CombatCore], [PlayerGlobals], [vThirdPersonInput], [GetAnimationLengths], [TimeManager]
*----------------------------------------------------------------------------------------------------*/
namespace Odyssey.Combat
{
    public class EnemyInput : MonoBehaviour
    {
        /*-----------------------------------------------------------------
        *----------------------- Public Parameters ------------------------
        *------------------------------------------------------------------*/

        // ---------------------------
        public bool dashSkillEnabled = true;

        [HideInInspector]
        public int currentComboSetIndex = 0;

        //[SerializeField]
        //private Combos _comboAttacks;
        [HideInInspector]
        public Enemy enemy;

        [HideInInspector]
        public EnemyCombatCore combat;

        [HideInInspector]
        public bool attackingOrCasting;

        [HideInInspector]
        public bool nextAttackIsQueued;

        [HideInInspector]
        public bool[] spellsQueued = new bool[3];

        [HideInInspector]
        public bool finishedAction = true;

        public ComboState comboState;
        // Listener

        public UnityEvent finishedActionEvent;
        public UnityEvent finishedComboEvent;

        [HideInInspector]
        public bool attackingDelayed;                      // Delayed attacking bool (allows attack collision detection soon after attacking begins)

        [HideInInspector]
        public bool canHit;

        [HideInInspector]
        public bool comboFin;
        
        [HideInInspector]
        public bool doCombo;
        
        /*-----------------------------------------------------------------
        *------------------------ Private Variables -----------------------
        *------------------------------------------------------------------*/
        private float attackingTime;                        // Decremental counter
        private float comboEndCooldownTime;                 // Decremental counter
        [SerializeField]
        private Animator anim;
        private GameObject player;

        private GameObject[] enemies;
        [SerializeField]
        private int currentCombo = 0;
        [SerializeField]
        private float timeSinceLastAttack = 0;              // Determine if combo continues

        [SerializeField]
        private Combos comboAttacks;
        // [SerializeField]
        // private EnemyStats eStats;


        [SerializeField]
        private GameObject enemyObject;

        [SerializeField]
        private bool status_staggered;

        public bool nonAttackActionDone;

        private bool firstAttackDone = false;

        /*-----------------------------------------------------------------
        *----------------------- Combo State Enums ------------------------
        *------------------------------------------------------------------*/
        public enum ComboState
        {
            notEndOfCombo,
            endedComboButAttackOnCooldown,
            endedComboAttackIsAvailable
        };

        public enum CommandTypes
        {
            attack,
            spell1,
            spell2,
            spell3,
            item1,
            item2,
            item3
        };
        /*-----------------------------------------------------------
        /*------------------------ AWAKE ----------------------------
        *-----------------------------------------------------------*/
        void Awake()
        {
            //Invoke("LateAwake", 0.01f);
        }

        private void Start()
        {
            currentCombo = 0;                                       // Reset combo

            if (enemyObject.TryGetComponent(out EnemyCombatCore cb))
                combat = cb;                                        // Get Combat Core (avoids mem alloc if null)

            if (enemyObject.TryGetComponent(out Animator a))
                anim = a;                                           // Get Animator

            if (enemyObject.TryGetComponent(out Enemy e))
                enemy = e;                                          // Get Enemy Component

            // eStats = enemy.GetComponent<EnemyStats>();

            comboAttacks = enemy.comboAttacks;

            // Check the EnemyStats -> Combos -> AttackArray -> Attack -> Attack Stats/Names/Parameters
            for (int i = 0; i < comboAttacks.combosArray[0].attacks.Length; i++)
            {
                Debug.Log(comboAttacks.combosArray[0].attacks[i].attackAnimationName);
            }

            comboFin = true;
            doCombo = false;
        }

        private void OnEnable()
        {
            finishedActionEvent.AddListener(FinishedAction);
        }

        private void OnDisable()
        {
            finishedActionEvent.RemoveListener(FinishedAction);
        }

        public void FinishedAction()
        {
            finishedAction = true;
            enemy.ActionKompleted(); // Just in case you want to use it
            //enemy.transform.GetChild(2).GetComponent<Renderer>().material.color = Color.red; // .enabled = false;
            //Invoke("RevertColour", 0.25f);
        }

        private void RevertColour()
        {
            //enemy.GetComponent<Renderer>().material.color = Color.white;
            //enemy.transform.GetChild(2).GetComponent<Renderer>().material.color = Color.white; //.enabled = true;
        }

        //------------------------------------------------------------------

        /*-----------------------------------------------------------
        /*------------------------ UPDATE ---------------------------
        *-----------------------------------------------------------*/
        void Update()
        {
            AttackTimerDecrement();             // Attack timer            
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Apply Enemy Attack.
        /// </summary>
        public void DoEnemyAttack()
        {
            //Debug.Log("Attack Is Called!");
            // Listen for attack inputs
            if ((nextAttackIsQueued) && !attackingOrCasting && comboState == ComboState.notEndOfCombo && !status_staggered && PlayerGlobals.player.GetComponent<Animator>().GetBool("Dead") == false)
            {
               // Debug.Log("ENEMY ATTACK!");

                // Player can now be hit
                // canHit = true;
                // comboFin = false;

                // [TEST] Moved from DoEnemyCombo
                if (comboAttacks.combosArray[currentComboSetIndex].attacks[currentCombo].isAttack) // Player is hittable if enemy attack flagged as attack
                    canHit = true;
                else
                    canHit = false;
                
                comboFin = false;
                doCombo = true;
                combat.bothAttacking = false; // Reset bool
                
                //Debug.Log("Successfully Attacking");
                SetAttackBooleanFlags();

                //RefreshEnemyAttackableStatus(); // [TEST] Make enemy attackable (once per attack animation). TO-DO: Just enable/disable weapon collider on attack animation instead.

                // How long attack animation lasts (after modifiers)
                float modifiedAttackTime = GetAttackAnimTimeLength();

                // Buffer time before/after combo ends
                float comboBufferTime = comboAttacks.comboBufferTimePercentage * 0.01f * modifiedAttackTime;

                // Reset or add to combo
                if (timeSinceLastAttack > modifiedAttackTime + comboBufferTime || timeSinceLastAttack < 0) // || !combat.enemyWasHitInPreviousAttack)
                {
                    currentCombo = 0;
                    firstAttackDone = false;
                }
                else if (firstAttackDone)
                {
                    currentCombo++;
                    modifiedAttackTime = GetAttackAnimTimeLength();
                }

                if (currentCombo < comboAttacks.combosArray[currentComboSetIndex].attacks.Length)
                {

                    // Update to current combo
                    modifiedAttackTime = GetAttackAnimTimeLength();

                    // Delay attack damage frames
                    SetDamageableAnimationFrames(modifiedAttackTime);

                    // Set attack time
                    attackingTime = modifiedAttackTime;
                }
                    if (dashSkillEnabled)
                        //combat.DashToTarget(1, 0, 0.6f);    // [TEST] Dash skill to target

                        //Debug.Log("End of attack");
                        CheckComboEndAndApplyCooldown();    // If combo finish, add cooldown

                    DisableGravity(modifiedAttackTime); // Disable gravity
                if (currentCombo < comboAttacks.combosArray[currentComboSetIndex].attacks.Length)
                {
                    //PlayAttackAnimations();             // Play attack animation
                    Invoke("PlayAttackAnimations", 0.1f); // play after delay (TESTING)
                }
                
                    ResetAttackParameters();            // Reset parameters

                    //                Invoke("EndOfAttack", modifiedAttackTime); // Invoke end of attack??! [TO-DO: get end of attack using better method later]
                    
            }

            // if (status_staggered)
            //     comboFin = true;

        }
        //------------------------------------------------------------------

        public void EndOfAttack()
        {
            firstAttackDone = true;
            finishedActionEvent.Invoke(); // Invoke at end of combo
            canHit = false; // Player can't be hit after the attack
            if (currentCombo >= comboAttacks.combosArray[currentComboSetIndex].attacks.Length - 1 && doCombo)
            {
                EndOfCombo();
                doCombo = false;
            }
            else if(doCombo)
            {
                QueueEnemyAction(CommandTypes.attack);
            }
        }
        public void EndOfCombo()
        {
            currentCombo = 0;
            firstAttackDone = false;
            finishedComboEvent.Invoke(); // Invoke at end of combo
            comboFin = true; // Player can't be hit after the attack

        }
        //------------------------------------------------------------------

        [ContextMenu("DO ENEMY COMBO")]
        public void DoEnemyCombo()
        {
            QueueEnemyAction(CommandTypes.attack);
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Queue the next action (ie. QueueEnemyAction(CommandTypes.attack))
        /// </summary>
        public void QueueEnemyAction(CommandTypes type)
        {
            //Debug.Log("Attempting Queue Attack");
            if (type == CommandTypes.attack)
            { // player.GetComponent<GetAnimationLengths>().attackTimes[currentCombo] / comboAttacks.combosArray[currentComboSetIndex].attacks[currentCombo].animationSpeedMultiplier;
                float modifiedAttackTime = GetAttackAnimTimeLength();
                float queueBufferTime = comboAttacks.queueAttackBufferTimePercentage * 0.01f * modifiedAttackTime;
                if ((timeSinceLastAttack > modifiedAttackTime - queueBufferTime && timeSinceLastAttack > 0) || attackingOrCasting == false)
                {
                    nextAttackIsQueued = true;
                    DoEnemyAttack(); // CALL IT
                    
                    //Debug.Log("Queue enemy action");
                }
            }
            else if (type == CommandTypes.spell1)
                spellsQueued[0] = true;
            else if (type == CommandTypes.spell2)
                spellsQueued[1] = true;
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Get attack time (from animation) in seconds.
        /// </summary>
        private float GetAttackAnimTimeLength() // To-do, change to enemy attack animation length
        { // _comboAttacks.Attacks[currentComboSetIndex,currentCombo].animationSpeedMultiplier
          // return player.GetComponent<GetAnimationLengths>().attackTimes[currentCombo] / comboAttacks.combosArray[currentComboSetIndex].attacks[currentCombo].animationSpeedMultiplier;
            if (comboAttacks.combosArray[currentComboSetIndex].attacks[currentCombo].attackLengthOverride > 0f)
                return comboAttacks.combosArray[currentComboSetIndex].attacks[currentCombo].attackLengthOverride;
            else
                return GetComponent<GetAnimationLengths>().attackTimes[comboAttacks.combosArray[currentComboSetIndex].attacks[currentCombo].animationName]; // [TEST] Enemy treats every animation as animation name in the attack Note: the animation state NEEDS to have animparameter script on it.
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Make damageable once per normal attack.
        /// </summary>
        //private void RefreshEnemyAttackableStatus()
        //{
        //    // Player can be hit again
        //    enemies = GameObject.FindGameObjectsWithTag("Player");

        //    foreach (GameObject enemy in enemies)
        //    {
        //        IsCombatable hittable = enemy.GetComponent<IsCombatable>();
        //        hittable.SetPhysicalDamageable(true);
        //    }
        //}
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
        /// Set damageable frames such that attack animations can only deal damage 15% into the animation, or 30% for combo finisher.
        /// </summary>
        private void SetDamageableAnimationFrames(float modifiedAttackTime)
        {
            //Debug.Log(comboAttacks.combosArray[0]);
            if (currentCombo < comboAttacks.combosArray[0].attacks.Length - 1)
            {
                Invoke("DelayedAttacking", modifiedAttackTime * 0.15f); // First 15% of animation is non-damageable (hard-coded LUL)
            }
            else
            {
                Invoke("DelayedAttacking", modifiedAttackTime * 0.30f); // First 30% of combo finisher anim is non-damageable ¯\_(ツ)_/¯
            }
        }
        //------------------------------------------------------------------

        private void EnableCollision()
        {
            enemyObject.GetComponent<Collider>().enabled = true;
        }
   
        //------------------------------------------------------------------


        /// <summary>
        /// Check if combo end and apply cooldown to it. THIS FUNCTION ONLY RUNS ON THE FINAL FINAL FINAL ATTACK OF THE COMBO.
        /// </summary>
        private void CheckComboEndAndApplyCooldown()
        {
            if (currentCombo >= comboAttacks.combosArray[currentComboSetIndex].attacks.Length - 1)
            {
                comboEndCooldownTime = comboAttacks.cooldownAfterComboEndGround;
                comboState = ComboState.endedComboButAttackOnCooldown;
            }
        }
        //------------------------------------------------------------------

        /// <summary>
        /// Temporarily disable player's gravity during attack and reset velocity (aerial).
        /// </summary>
        private void DisableGravity(float modifiedAttackTime)
        {
            enemyObject.GetComponent<Rigidbody>().useGravity = false;
            if (combat.targetObject != null && modifiedAttackTime > 0.01f && modifiedAttackTime < 10.0f)
                combat.timeUntilGravityEnabled = modifiedAttackTime - modifiedAttackTime * 0.15f - 0.15f;
            else
                combat.timeUntilGravityEnabled = 0.01f;
            enemyObject.GetComponent<Rigidbody>().velocity = new Vector3(0f, 0f, 0f); // Reset velocity
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
                // Disable player movement inputs temporarily while the player attacks
                // PlayerGlobals.invectorInput.SetLockBasicInput(true);

                // Set the animation speed multiplier specified in the Inspector
                anim.SetFloat(comboAttacks.combosArray[currentComboSetIndex].attacks[currentCombo].attackSpeedParameterName, comboAttacks.combosArray[currentComboSetIndex].attacks[currentCombo].animationSpeedMultiplier);
                // Play attack animation according to current combo, index 0 is the attack animation layer in the enemy animator
                anim.Play(comboAttacks.combosArray[currentComboSetIndex].attacks[currentCombo].attackAnimationName, 0);
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
                if (currentCombo >= comboAttacks.combosArray[currentComboSetIndex].attacks.Length - 1 && comboState == ComboState.endedComboButAttackOnCooldown)
                {
                    InvokeRepeating("ComboEndTimeLoop", 0.02f, 0.02f);
                    comboState = ComboState.endedComboAttackIsAvailable;
                }
            }
            else if (attackingTime < 0 && attackingTime > -1)
            {
                nonAttackActionDone = true;

                // Stop rotating towards enemy
                attackingOrCasting = false;
                attackingDelayed = false;

                // Make this run only once by subtracting 1
                attackingTime -= 10.0f;

                EndOfAttack();

                // Reset combo if combo ended
                if (currentCombo == comboAttacks.combosArray[currentComboSetIndex].attacks.Length - 1 && !doCombo)
                {
                    currentCombo = 0;
                    firstAttackDone = false;
                    timeSinceLastAttack = -1000f; // Reset time since last attack
                }
                else if (doCombo)
                    DoEnemyAttack();
            }
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
                DoEnemyAttack();
                CancelInvoke("ComboEndTimeLoop");
            }
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
        /// Get the combo set index.
        /// </summary>
        public int GetComboSet()
        {
            return currentComboSetIndex;
        }
        //------------------------------------------------------------------
        
        /// <summary>
        /// Set the combo set based on index.
        /// </summary>
        public void SetComboSet(int index)
        {
            currentComboSetIndex = index;
        }
        //------------------------------------------------------------------
                
        /// <summary>
        /// Set the combo set on based on string name.
        /// </summary>
        public void SetComboSet(string comboName)
        {
            for (int i = 0; i < comboAttacks.combosArray.Length; i++)
            {
                if (comboAttacks.combosArray[i].comboSetName.Equals(comboName))
                    currentComboSetIndex = i;
            }
        }
        //------------------------------------------------------------------
        public void EnemyAttackedPlayerWithWeapon(IsCombatable hittable)
        {
            if (currentCombo < comboAttacks.combosArray[currentComboSetIndex].attacks.Length)
            {
                combat.ApplyBasicAttack(hittable, comboAttacks.power * comboAttacks.combosArray[currentComboSetIndex].attacks[currentCombo].attackMultiplier, comboAttacks.combosArray[currentComboSetIndex].attacks[currentCombo].knockbackForce, comboAttacks.combosArray[currentComboSetIndex].attacks[currentCombo].knockupForce, currentCombo, true, comboAttacks.combosArray[currentComboSetIndex].attacks[currentCombo].fxImpactPrefab); // Damage, knockback force, combo count, dash
                Debug.Log("[Log] Player attacked! | Remaining HP: " + hittable.GetHealth());
                canHit = false;
            }
            //PlayerGlobals.combatInput.Stagger(); // [DEBUG] [TEST] stagger the PLAYER
        }

        // Stagger the enemy
        public void Stagger(float duration)
        {
            status_staggered = true;
            Invoke("EndStagger", duration);
            enemy.GetComponent<Animator>().Play("Recoil_Hard", 0);
            attackingTime = 0.05f; // Done attacking
        }

        private void EndStagger()
        {
            status_staggered = false;
            comboFin = true;                                    // combo is done because staggered
            enemy.GetComponent<ExampleHydra>().CanDoCombo();    // set can combo back to true
        }

    }
}