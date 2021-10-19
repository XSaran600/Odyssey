using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.AI;
using UnityStandardAssets.Characters.ThirdPerson;
/*
Slashes once with a horizontal attack, pauses and proceeds to spin with another horizontal slash before ending the attack with a final downward slash at the end of spin.
    After the attack is performed, Heracles will side step around the player and perform another attack 
    This attack will be performed 2 times 
After the 2 attacks, Heracles jumps backward and is vulnerable for a short amount of time 
    Can be blocked
    Can be countered
 */

public class HydraBarrage : State
{
    bool comboDone = false;
    bool canAttack = false;
    public bool facingPlayer = false;
    public Odyssey.Combat.EnemyInput enemyInput;
    public bool isBossGrounded = false;

    public List<string> comboAnim;
    [SerializeField]
    private int comboIndex;

    Rigidbody rb;

    bool sideStep, backStep = false;    // Apply forces once

    [SerializeField]
    Transform sideStepPos, backStepPos;

    public NavMeshAgent agent;
    public ThirdPersonCharacter character;
    public float jumpStrength = 1;
    public float jumpTimer = 2;
    private float jumpTimerBuffer = 2;
    private float timeBuffer = 0.5f;
    private bool bufferStart = false;

    public HydraBarrage(StateHandler user) : base(user)
    {
    }
    //needs to happen after enemy input is initalized and unity is dum
    protected void Start()
    {
        if (agent == null)
            agent = GetComponent<NavMeshAgent>();
        if (character == null)
            character = GetComponent<ThirdPersonCharacter>();

        rb = user.gameObject.GetComponent<Rigidbody>();

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
        facingPlayer = false;
        agent.enabled = true;
    }
    public override void OnStateExit()
    {
        sideStep = false;
        backStep = false;
        comboDone = false;      // Reset combo counter
        shouldTick = false;
        isFinished = true;
        canAttack = false;
        character.Move(new Vector3(0f, 0f, 0f), false, false);
        comboIndex = 0;
        agent.enabled = true;
        finished.Invoke();
    }
    public override void Tick()
    {
        // Do nothing if sholuldn't tick
        if (!shouldTick)
            return;

        // Check if all the animations are played and combo is done
        if ((comboIndex >= comboAnim.Count && enemyInput.comboFin && canAttack && facingPlayer))
        {
            comboDone = true;
            character.Move(new Vector3(0f, 0f, 0f), false, false);
            if (agent.hasPath)
                agent.ResetPath();
        }
        // End state once combo is done
        if (comboDone)
        {
            if (agent.desiredVelocity == new Vector3(0,0,0))
            {
                shouldTick = false;
                GetComponent<Rigidbody>().useGravity = true;
                OnStateExit();
            }
            return;
        }
        isBossGrounded = character.IsGrounded();

        // List of Animation for combo
        // Hydra Barrage
        // Side Step
        // Hydra Barrage
        // Back Step

        if (!agent.enabled)
        {
            if (comboIndex == 1) // Side Step
            {
                if (!sideStep)
                {
                    // user.gameObject.transform.DOMove(sideStepPos.position, 1f);
                    jumpTimerBuffer = jumpTimer;
                    sideStep = true;
                    GetComponent<Rigidbody>().AddForce((transform.up * 0.5f + transform.right *-1.5f) * jumpStrength* GetComponent<Rigidbody>().mass, ForceMode.Impulse);
                }
            }
            else if (comboIndex == 3) // Back Step
            {
                if (!backStep)
                {
                    // user.gameObject.transform.DOMove(backStepPos.position, 1f);
                    jumpTimerBuffer = jumpTimer;
                    backStep = true;
                    GetComponent<Rigidbody>().AddForce((transform.up * 0.5f + transform.forward * -1.5f) * jumpStrength* GetComponent<Rigidbody>().mass, ForceMode.Impulse);
                }
            }
            else
            {
                if (jumpTimerBuffer >= 0)
                {
                    GetComponent<Rigidbody>().useGravity = true;
                    jumpTimerBuffer -= Time.deltaTime;
                }
                else if (isBossGrounded)
                    agent.enabled = true;
            }
        }
        else
        {
            if (!facingPlayer && canAttack)
            {
                Vector3 target = PlayerGlobals.player.transform.position - transform.position;
                if ((target.normalized - transform.forward).magnitude < 0.5f && !bufferStart)
                {
                    bufferStart = true;
                    character.Move(new Vector3(0f, 0f, 0f), false, false);
                    agent.ResetPath();
                }
                else if (!bufferStart)
                {
                    target = target.normalized;
                    agent.SetDestination((target.normalized + transform.position));
                    character.Move(agent.desiredVelocity, false, false);
                }
                else if (timeBuffer >= 0.0f)
                {
                    timeBuffer -= Time.deltaTime;
                }
                else
                {
                    facingPlayer = true;
                }
            }
        }
        // Plays the combo
        if (enemyInput.comboFin && comboIndex < comboAnim.Count && canAttack && facingPlayer)
        {
            character.Move(new Vector3(0f, 0f, 0f), false, false);
            bufferStart = false;

            if (comboIndex == 1 || comboIndex == 3)
            {
                agent.enabled = false;
                agent.updatePosition = false;
            }
            else
            {
                agent.enabled = true;
                agent.updatePosition = true;
            }
            facingPlayer = false;
            // do move
            enemyInput.SetComboSet(comboAnim[comboIndex]); // 0
            enemyInput.DoEnemyCombo();
            canAttack = false;
        }

    }

    public void CanDoCombo()
    {
        canAttack = true;
        timeBuffer = 0.5f;
        comboIndex++; // get the next move ready
    }
}
