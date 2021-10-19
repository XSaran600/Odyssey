using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Idle : State
{
    public float timePassed;
    public float timeUntilNextState;

    public Idle(StateHandler user) : base(user)
    {
    }

    public override StatesPossible StateName()
    {
        return StatesPossible.idle;
    }
    public override void OnStateEnter()
    {
        shouldTick = true;
        isFinished = false;
    }

    public override void Tick()
    {        
        // Do nothing if sholuldn't tick
        if (!shouldTick)
            return;

        timePassed += Time.deltaTime;

        if (timePassed > timeUntilNextState)
        {
            shouldTick = false;
            OnStateExit();
        }
        if (user.gameObject.GetComponent<MeshRenderer>() != null)
        {
            if ((int)timePassed % 2 == 1)
            {
                user.gameObject.GetComponent<MeshRenderer>().material.SetColor("_BaseColor", Color.red);
            }
            else
            {
                user.gameObject.GetComponent<MeshRenderer>().material.SetColor("_BaseColor", Color.cyan);
            }
        }
 

    }

    public override void OnStateExit()
    {
        if (user.gameObject.GetComponent<MeshRenderer>() != null)
        {
            user.gameObject.GetComponent<MeshRenderer>().material.SetColor("_BaseColor", Color.white);
        }
        shouldTick = false;
        isFinished = true;
        timePassed = 0;
        finished.Invoke();
    }
}
