using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Odyssey.Projectiles;

/*
Heracles, swiper upward off the ground and into the air. The resulting force will create a large moving stalagmite and folds of earth that rushes the player’s position. 
    Can NOT be blocked
    Can NOT be countered

 */

public class DivergingAlpheus : State
{
    bool comboDone = false;
    bool canAttack = false;
    public Odyssey.Combat.EnemyInput enemyInput;

    public List<string> comboAnim;
    private int comboIndex;

    [SerializeField]
    private GameObject shockwave;
    [SerializeField]
    private GameObject shockwaveImpact;
    [SerializeField]
    private bool hasfired = false;
    public DivergingAlpheus(StateHandler user) : base(user)
    {
    }
    //needs to happen after enemy input is initalized and unity is dum
    protected void Start()
    {
        if (!enemyInput)
        {
            enemyInput = GetComponent<Odyssey.Combat.EnemyInput>();
            enemyInput.finishedComboEvent.AddListener(CanDoCombo);
        }
        else
        {
            Debug.Log("enemyInput for Example Hydra is set before start");
        }
    }

    private void OnEnable()
    {
        if (enemyInput != null)
            enemyInput.finishedComboEvent.AddListener(CanDoCombo);
        OnStateEnter();
    }

    private void OnDisable()
    {
        if (enemyInput != null)
            enemyInput.finishedComboEvent.RemoveListener(CanDoCombo);
        OnStateExit();
    }


    public override StatesPossible StateName()
    {
        return StatesPossible.DivergingAlpheus;
    }
    public override void OnStateEnter()
    {
        shouldTick = true;
        isFinished = false;
        comboIndex = 0;
        canAttack = true;
        hasfired = false;
    }
    public override void OnStateExit()
    {
        comboDone = false;      // Reset combo counter
        shouldTick = false;
        isFinished = true;
        canAttack = false;
        comboIndex = 0;
        hasfired = false;
        finished.Invoke();
    }
    public override void Tick()
    {
        // Do nothing if sholuldn't tick
        if (!shouldTick)
            return;
 
        // List of Animation for combo
        // Charge
        // Swipe Upwards

        if (comboIndex == 0)
        {
            // should spawn particles, i unno
        }

        if (comboIndex == 1 && !hasfired)
        {
            hasfired = true;
            ProjectileCore.CreateProjectile(transform.position, PlayerGlobals.player.transform.position, shockwave.GetComponent<Projectile>().speed, shockwave, shockwaveImpact, true);
        }

        // Check if all the animations are played and combo is done
        if (comboIndex >= comboAnim.Count && enemyInput.comboFin && canAttack)
            comboDone = true;

        // End state once combo is done
        if (comboDone)
        {
            shouldTick = false;
            OnStateExit();
            return;
        }


        // Plays the combo
        if (enemyInput.comboFin && comboIndex < comboAnim.Count && canAttack)
        {
            // do move
            enemyInput.SetComboSet(comboAnim[comboIndex]); // 0
            enemyInput.DoEnemyCombo();
            canAttack = false;
        }
    }

    public void CanDoCombo()
    {
        comboIndex++; // get the next move ready
        canAttack = true;
    }
}
