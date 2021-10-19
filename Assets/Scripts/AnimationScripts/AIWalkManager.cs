using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class AIWalkManager : MonoBehaviour
{
    public NavMeshAgent host;
    public Animator anim;
    public float deadzone;

    private float maxSpeedFront;
    private float maxSpeedTurn;
    // Start is called before the first frame update
    void Start()
    {
        if (host == null)
            host = GetComponent<NavMeshAgent>();
        if (anim == null)
            anim = GetComponent<Animator>();

        maxSpeedFront = host.speed;
        maxSpeedTurn = host.angularSpeed;
    }
    // possible to try:
    // InverseTransformDirection
    // TransfromDirection

    public void SetMovementSpeeds(Vector3 forward, Vector3 right, Vector3 dir, float speed)
    {

        float x, z;
        float fSign;
        float rSign;
        x = Vector3.Dot(right.normalized, dir.normalized);
        z = Vector3.Dot(forward.normalized, dir.normalized);

        // see if new dir is right or left
        if (x > 0)
            rSign = 1;
        else if (x < 0)
            rSign = -1;
        else
            rSign = 0;
        // see if new dir is frwd or back
        if (z > 0)
            fSign = 1;
        else if (z < 0)
            fSign = -1;
        else
            fSign = 0;



        if (speed > .25)
        {
            anim.SetFloat("Forward", fSign * Mathf.Min(maxSpeedFront, speed * Mathf.Abs(z)));
            anim.SetFloat("Turn", rSign * Mathf.Min(maxSpeedTurn, speed * Mathf.Abs(x)));
        }
        else
        {
            anim.SetFloat("Forward", 0.0f);
            anim.SetFloat("Turn", 0.0f);
        }
    }

}
