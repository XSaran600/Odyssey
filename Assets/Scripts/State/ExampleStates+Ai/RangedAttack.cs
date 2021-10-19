using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Odyssey.Projectiles;

public class RangedAttack : State
{
    public GameObject target;
    public float fireRate;
    private float timer;
    [SerializeField]
    private GameObject fireball;
    [SerializeField]
    private GameObject fireballImpact;

    public RangedAttack(StateHandler user) : base(user)
    {
    }
    public override StatesPossible StateName()
    {
        return StatesPossible.rangedAttack;
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
            user.gameObject.GetComponent<MeshRenderer>().material.SetColor("_BaseColor", Color.magenta);
        user.transform.position = Vector3.MoveTowards( user.transform.position, target.transform.position, Time.deltaTime);

        timer += Time.deltaTime;
        if (timer > (1/fireRate))
        {
            timer = 0;
            ProjectileCore.CreateProjectile(transform.position, target.transform.position, fireball.GetComponent<Projectile>().speed, fireball, fireballImpact, true);
        }

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
