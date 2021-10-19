using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*
Heracles immediately pulls the pelt of the Nemean lion in front of himself. 
    If the player were to use a melee attack, they would find themselves bouncing off the pelt and unbalanced. Heracles will then proceed to wail on the player with a frenzy of attacks. 
	If the player were to use a ranged attack (magic), Heracles swings the pelt in front of himself and a magical attack is launched towards the player.
 */

public class NemeanDefense : State
{
    bool comboDone = false;
    bool canAttack = false;
    public Odyssey.Combat.EnemyInput enemyInput;

    public List<string> comboAnim;
    private int comboIndex;

    public float blockTime;
    private float currentTime = 0f;

    public NemeanDefense(StateHandler user) : base(user)
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
        return StatesPossible.NemeanDefense;
    }
    public override void OnStateEnter()
    {
        shouldTick = true;
        isFinished = false;
        comboIndex = 0;
        canAttack = true;
        currentTime = 0f;
    }
    public override void OnStateExit()
    {
        comboDone = false;      // Reset combo counter
        shouldTick = false;
        isFinished = true;
        canAttack = false;
        comboIndex = 0;
        currentTime = 0f;
        finished.Invoke();
    }
    public override void Tick()
    {
        // Do nothing if sholuldn't tick
        if (!shouldTick)
            return;

        if (currentTime <= blockTime)
            currentTime += Time.deltaTime;
        else
            OnStateExit();

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

        Debug.Log("defense");

        if (comboIndex == 0)
        {
            // Should do a reflect thing
            // HELP
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
