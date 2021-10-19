using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.AI;
public class Chase : State
{

    public GameObject target;
    public float distanceFromTarget;
    public NavMeshAgent agent;
    public AIWalkManager walkAnimManager;
    private bool shouldExit = false;
    private float timeBuffer = 0.5f;


    public Chase(StateHandler user) : base(user)
    {
    }
    //needs to happen after enemy input is initalized and unity is dum
    protected void Start()
    {
        if (agent == null)
            agent = GetComponent<NavMeshAgent>();

        if (target == null)
            target = PlayerGlobals.player;
        if (walkAnimManager == null)
            walkAnimManager = GetComponent<AIWalkManager>();

        agent.updateRotation = true;
    }


    public override StatesPossible StateName()
    {
        return StatesPossible.chase;
    }
    public override void OnStateEnter()
    {
        shouldTick = true;
        isFinished = false;
        shouldExit = false;
        timeBuffer = 0.5f;
        agent.isStopped = false;
    }
    public override void OnStateExit()
    {   shouldTick = false;
        isFinished = true;
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
        if (shouldExit)
            timeBuffer -= Time.deltaTime;
        if (timeBuffer <= 0.0f)
            OnStateExit();

        if (!ReachedTarget())
        {
            agent.SetDestination(target.transform.position);            
            shouldExit = false;
        }
        else
        {
            agent.ResetPath();
            agent.velocity = new Vector3(0,0,0);
            shouldExit = true;

        }

        if ((agent.destination - agent.transform.position).magnitude > .75)
            walkAnimManager.SetMovementSpeeds(agent.transform.forward, agent.transform.right, agent.desiredVelocity.normalized, agent.desiredVelocity.magnitude);
        else
            walkAnimManager.SetMovementSpeeds(agent.transform.forward, agent.transform.right, agent.desiredVelocity *0.0f, 0.0f);
        transform.rotation = agent.transform.rotation;
    }

    public bool ReachedTarget()
    {
        return Vector3.Distance(user.transform.position, target.transform.position) < distanceFromTarget;
    }
}
