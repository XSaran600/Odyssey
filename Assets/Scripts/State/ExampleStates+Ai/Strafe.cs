using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Strafe : State
{
    public GameObject target;
    public float distanceFromTarget;
    public bool clockwise;
    public bool shouldCircle;
    public bool strafeNearby;
    [Header("Do not add prefab and targetOrbiter")]
    [SerializeField]
    private GameObject targetOrbiter;
    [SerializeField]
    private GameObject targetOrbiterPrefab;
    [SerializeField]
    private float angle;

    public Strafe(StateHandler user) : base(user)
    {
    }
    public override StatesPossible StateName()
    {
        return StatesPossible.strafe;
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
            target = PlayerGlobals.player;
        if (targetOrbiter == null)
        {
            targetOrbiter = Instantiate(targetOrbiterPrefab);
            targetOrbiter.transform.parent = transform;
        }
        targetOrbiter.transform.position = StrafePosition();
        targetOrbiter.SetActive(true);
    }

    public override void Tick()
    {
        // Do nothing if sholuldn't tick
        if (!shouldTick)
            return;
        if (user.gameObject.GetComponent<MeshRenderer>() != null)
            user.gameObject.GetComponent<MeshRenderer>().material.SetColor("_BaseColor", Color.yellow);

        user.transform.position = Vector3.MoveTowards( user.transform.position, targetOrbiter.transform.position, Time.deltaTime);

        OffsetCheck();

        if (ReachedTargetOrbit())
        {
            if (clockwise)
            {
                angle += 0.1f;
            }
            else
            {
                angle -= 0.1f;
            }
        }
        if (clockwise)
        {
            if (angle > Mathf.PI * 2)
                angle = 0;
        }
        else
        {
            if (angle < 0)
                angle = Mathf.PI * 2;
        }

        if (shouldCircle)
        {
            if (strafeNearby)
            {

                if (ReachedTarget())
                    targetOrbiter.transform.position = StrafePosition();
                else
                {
                    angle = InbewteenTarget();
                    targetOrbiter.transform.position = StrafePosition();
                }
            }
            else
            {
                targetOrbiter.transform.position = StrafeFarPosition();
            }
        }
        else
        {
            if (clockwise)
                targetOrbiter.transform.position = user.transform.position + user.transform.right;
            else
                targetOrbiter.transform.position = user.transform.position + (user.transform.right * - 1);            
        }

    }

    public bool ReachedTargetOrbit()
    {
        return Vector2.Distance( new Vector2(user.transform.position.x, user.transform.position.z), new Vector2(targetOrbiter.transform.position.x, targetOrbiter.transform.position.z) )< 1.0f;
    }
    public bool ReachedTarget()
    {
        return Vector3.Distance(user.transform.position, target.transform.position) < distanceFromTarget;
    }
    public float InbewteenTarget()
    {
        float x, z, angleXZ;
        x =  target.transform.position.x - user.transform.position.x;
        z = target.transform.position.z - user.transform.position.z ;
        angleXZ = Mathf.Atan(z/x);
        if (x > 0)
            angleXZ += Mathf.PI;
        return angleXZ;
    }

    public Vector3 StrafePosition()
    {
        float x, z;
        x = target.transform.position.x + distanceFromTarget * Mathf.Cos(angle);
        z = target.transform.position.z + distanceFromTarget * Mathf.Sin(angle);

        return new Vector3(x, target.transform.position.y, z);
    }
    public Vector3 StrafeFarPosition()
    {
        float x, z, dist;
        dist = Vector3.Distance(user.transform.position, target.transform.position);
        x = target.transform.position.x + dist * Mathf.Cos(angle);
        z = target.transform.position.z + dist * Mathf.Sin(angle);

        return new Vector3(x, target.transform.position.y, z);
    }

    public void OffsetCheck()
    {
        float targetToSphere = Vector3.Distance(user.transform.position, target.transform.position);

        if (targetToSphere < 1.5f)
            return;
         
        if(targetToSphere < Vector3.Distance(targetOrbiter.transform.position, user.transform.position))
        {
            float x, z;
            x = target.transform.position.x - user.transform.position.x;
            z = target.transform.position.z - user.transform.position.z;
            angle = Mathf.Atan(z / x);
            if (x > 0)
                angle += Mathf.PI;
        }
    }

    public override void OnStateExit()
    {
        if (user.gameObject.GetComponent<MeshRenderer>() != null)
            user.gameObject.GetComponent<MeshRenderer>().material.SetColor("_BaseColor", Color.white);
        shouldTick = false;
        isFinished = true;
        targetOrbiter.SetActive(false);
        finished.Invoke();
    }
}
