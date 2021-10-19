using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Retreat : State
{
    public GameObject target;
    public float safeDistance;
    public Retreat(StateHandler user): base(user)
    {
    }
    public override StatesPossible StateName()
    {
        return StatesPossible.retreat;
    }
    public override void SetTarget(GameObject target)
    {
        if (target != null)
            this.target = target;
        else
            this.target = PlayerGlobals.player;
    }
    public override void OnStateEnter()
    {
        shouldTick = true;
        isFinished = false;
        if (target == null)
            this.target = PlayerGlobals.player;
    }
    public override void Tick()
    {
        // Do nothing if sholuldn't tick
        if (!shouldTick)
            return;
        if (user.gameObject.GetComponent<MeshRenderer>() != null)
            user.gameObject.GetComponent<MeshRenderer>().material.SetColor("_BaseColor", Color.green);
        user.transform.position = Vector3.MoveTowards(user.transform.position, target.transform.position, -Time.deltaTime);

        if (AwayFromPlayer())
        {
            shouldTick = false;
            OnStateExit();
        }
    }

    public bool AwayFromPlayer()
    {
        return Vector3.Distance(user.transform.position, target.transform.position) > safeDistance;
    }

    public override void OnStateExit()
    {
        if (user.gameObject.GetComponent<MeshRenderer>() != null)
            user.gameObject.GetComponent<MeshRenderer>().material.SetColor("_BaseColor", Color.white);
        shouldTick = false;
        isFinished = true;
        finished.Invoke();
    }
}
