using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

/*
Appears to provide an opening for the player to attack as Heracles walks towards the player. If the player were to attack Heracles, Heracles will sidestep and perform a quick uppercut at the player. This will occur 3 times. 
    If the player manages to avoid all 3 hits, a brief opening is available for the player to attack Heracles
    If the player does not attack Heracles during this time frame, or is hit by any of the attacks, the player is not given the opportunity to attack and Heracles will perform a different attack in response:
        Ceryneian Rush
        Diverging Alpheus
        Hydra Barrage

 */

public class WrathoftheLion : State
{
    bool comboDone = false;
    bool canAttack = false;
    public Odyssey.Combat.EnemyInput enemyInput;

    public List<string> comboAnim;
    private int comboIndex;

    public GameObject target;
    public float distanceFromTarget;

    Vector3 halfPos;
    bool once = false;

    [SerializeField]
    Transform sideStepPos;

    public WrathoftheLion(StateHandler user) : base(user)
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
        return StatesPossible.WrathoftheLion;
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
        // Walk
        // Side Step
        // Uppercut
        // Repeat X3

        // Sidestep
        if ((comboIndex == 2 || comboIndex == 5 || comboIndex == 8) && once == true)
        {
            user.gameObject.transform.DOMove(sideStepPos.position, 1f);
            Debug.Log("Sidestep");

            once = false;
        }
        // Walk
        if ((comboIndex == 1 || comboIndex == 4 || comboIndex == 7) && once == false)
        {
            //halfPos = transform.position + (target.transform.position - transform.position) / 2;
            user.gameObject.transform.DOMove(target.transform.position, 1f);
            Debug.Log("Walk");

            once = true;
        }

        /*
        if (ReachedTarget())
        {
            // Sidestep
            if(comboIndex == 2 || comboIndex == 5 || comboIndex == 8)
            {
                user.transform.position = Vector3.MoveTowards(user.transform.position, user.transform.position - Vector3.right * 20, Time.deltaTime);
                Debug.Log("Sidestep");
            }
        }
        else
        {
            // Walk
            if (comboIndex == 1 || comboIndex == 4 || comboIndex == 7)
            {
                user.transform.position = Vector3.MoveTowards(user.transform.position, target.transform.position, Time.deltaTime);
                Debug.Log("Walk");

            }
        }
        */


        // Plays the combo
        if (enemyInput.comboFin && comboIndex < comboAnim.Count && canAttack)
        {
            // do move
            enemyInput.SetComboSet(comboAnim[comboIndex]); // 0
            enemyInput.DoEnemyCombo();
            comboIndex++; // get the next move ready
            canAttack = false;
        }
    }

    public bool ReachedTarget()
    {
        return Vector3.Distance(user.transform.position, target.transform.position) < distanceFromTarget;
    }

    public void CanDoCombo()
    {
        canAttack = true;
    }
}
