using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class Rage : State
{
    bool comboDone = false;
    bool canAttack = false;
    public Odyssey.Combat.EnemyInput enemyInput;

    public List<string> comboAnim;
    private int comboIndex;


    public Rage(StateHandler user) : base(user)
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
        return StatesPossible.Rage;
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
