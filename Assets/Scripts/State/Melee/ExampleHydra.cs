using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*
Slashes once with a horizontal attack, pauses and proceeds to spin with another horizontal slash before ending the attack with a final downward slash at the end of spin.
    After the attack is performed, Heracles will side step around the player and perform another attack 
    This attack will be performed 2 times 
After the 2 attacks, Heracles jumps backward and is vulnerable for a short amount of time 
    Can be blocked
    Can be countered
 */

public class ExampleHydra : State
{
    bool comboDone = false;
    bool canAttack = false;
    public Odyssey.Combat.EnemyInput enemyInput;

    public List<string> comboAnim;
    private int comboIndex;



    public ExampleHydra(StateHandler user) : base(user)
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
        return StatesPossible.HydraBarrage;
    }
    public override void OnStateEnter()
    {
        shouldTick = true;
        isFinished = false;
        comboIndex = 0;
        canAttack = true;
    }
    public override void OnStateExit()
    {
        comboDone = false;      // Reset combo counter
        shouldTick = false;
        isFinished = true;
        canAttack = false;
        comboIndex = 0;
        finished.Invoke();
    }
    public override void Tick()
    {
        // Do nothing if sholuldn't tick
        if (!shouldTick)
            return;
        

        if (comboIndex >= comboAnim.Count && enemyInput.comboFin && canAttack)
            comboDone = true;

        if (comboDone)
        {
            shouldTick = false;
            OnStateExit();
            return;
        }

        /*
         * if you want to do something outisde of animations
         * you can just see where in the index you want to stop playing combos
         * like if(combo inex = 1 && enemyInput.comboFin ) do set position or something
         * then return to the combos
         */
        // If an attack is possible (it's reversed because of Jon)
        if (enemyInput.comboFin && comboIndex < comboAnim.Count && canAttack)
        {
            // do move
            enemyInput.SetComboSet(comboAnim[comboIndex]); // 0
            enemyInput.DoEnemyCombo();
            comboIndex++; // get the next move ready
            canAttack = false;
        }
    }

    public void CanDoCombo()
    {
        canAttack = true;
    }


}
