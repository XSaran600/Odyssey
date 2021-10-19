using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

/*
Rushes the player’s position. Heracles then jumps into the air and performs a spinning strike downward that slightly homes onto the player’s position. 
    Can be blocked
    Can be countered
    Player must counter in order to make Heracles vulnerable to attacks
    If player fails to counter Heracles will respond
    If player is close: use Hydra Barrage
    If player is far: 
        Ceryneian Rush
        Diverging Alpheus
        Wrath of the Lion
        Run towards player position to perform Hydra Barrage

 */

public class CeryneianRush : State
{
    bool comboDone = false;
    bool canAttack = false;
    public Odyssey.Combat.EnemyInput enemyInput;

    public List<string> comboAnim;
    private int comboIndex;

    public GameObject target;

    bool dash, jump, attack = false;

    bool highPt = false;

    public CeryneianRush(StateHandler user) : base(user)
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
        return StatesPossible.CeryneianRush;
    }
    public override void OnStateEnter()
    {
        shouldTick = true;
        isFinished = false;
        comboIndex = 0;
        canAttack = true;
        highPt = false;
        dash = false;
        jump = false;
        attack = false;
    }
    public override void OnStateExit()
    {
        comboDone = false;      // Reset combo counter
        shouldTick = false;
        isFinished = true;
        canAttack = false;
        highPt = false;
        dash = false;
        jump = false;
        attack = false;
        comboIndex = 0;
        finished.Invoke();
    }
    public override void SetTarget(GameObject target)
    {
        if (target != null)
            this.target = target;
        else
            this.target = PlayerGlobals.player;
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

        // List of Animation for combo
        // Dash
        // Jump
        // Attack Down

        if (comboIndex == 1) // Dash
        {
            if(!dash)
            {
                Debug.Log("dash");

                Vector3 halfPos = transform.position + (target.transform.position - transform.position) / 2;
                user.gameObject.transform.DOMove(halfPos, 0.8f);
                
                dash = true;
            }
        }

        
        if (comboIndex == 2) // Jump
        {
            if (!jump)
            {
                Debug.Log("jump");
                // Jump up
                Vector3 inFrontOfEnemy;
                inFrontOfEnemy = target.transform.position - gameObject.transform.position;
                transform.DOJump(target.transform.position - inFrontOfEnemy.normalized * 1.2f, 5.0f, 1, 2f, false);


                jump = true;

            }
        }
        
        
        if (comboIndex == 3) // Attack Down
        {
            if (!attack)
            {
                Debug.Log("Attack");
                user.gameObject.transform.DOMove(target.transform.position, 0.8f);
                attack = true;
            }
        }
        

        // Plays the combo
        if (enemyInput.comboFin && comboIndex < comboAnim.Count && canAttack)
        {
            // do move
            if (comboIndex < comboAnim.Count)
            {
                Debug.Log("comboing " + comboIndex);
                enemyInput.SetComboSet(comboAnim[comboIndex]); // 0
                enemyInput.DoEnemyCombo();
                comboIndex++; // get the next move ready
                canAttack = false;
            }
        }
    }

    public void CanDoCombo()
    {
        canAttack = true;
    }

    void FinishDash()
    {

    }
}