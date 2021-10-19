using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using Odyssey.Projectiles;

/*
    Dashes the player’s position with and shoots an arrow. Heracles spins on the ground with his knee and fires 6 arrows in a spread like manner, similar to a shotgun.
 */

public class HippolytaHunt : State
{
    bool comboDone = false;
    bool canAttack = false;
    public Odyssey.Combat.EnemyInput enemyInput;

    public List<string> comboAnim;
    private int comboIndex;

    public GameObject target;
    public float distanceFromTarget;
    public float dashSpeed = 1f;

    public float arrowSpeed = 10f;

    bool dash,shoot,shootx6 = false;

    [SerializeField]
    private GameObject arrow;
    [SerializeField]
    private GameObject arrowImpact;

    [SerializeField]
    List<Transform> arrowPos;

    public HippolytaHunt(StateHandler user) : base(user)
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
        return StatesPossible.HippolytaHunt;
    }
    public override void OnStateEnter()
    {
        shouldTick = true;
        isFinished = false;
        comboIndex = 0;
        canAttack = true;
        dash = false;
        shoot = false;
        shootx6 = false;
    }
    public override void OnStateExit()
    {
        comboDone = false;      // Reset combo counter
        shouldTick = false;
        isFinished = true;
        canAttack = false;
        dash = false;
        shoot = false;
        shootx6 = false;
        comboIndex = 0;
        finished.Invoke();
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
        // Charge Arrow
        // Shoot Arrow while spinning

        // Dash and shoot
        if (comboIndex == 1)
        {
            if (!dash)
            {
                Vector3 halfPos = transform.position + (target.transform.position - transform.position) / 2;
                user.gameObject.transform.DOMove(halfPos, 0.8f);
                dash = true;
            }
            if (!shoot)
            {
                Shoot();
                shoot = true;
            }
        }

        // Kneeling spin and shoot 6 arrows
        if (comboIndex == 2)
        {
            if (!shootx6)
            {
                ShootX6();
                shootx6 = true;
            }
        }

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

    public void CanDoCombo()
    {
        canAttack = true;
    }

    public bool ReachedTarget()
    {
        return Vector3.Distance(user.transform.position, target.transform.position) < distanceFromTarget;
    }

    void Shoot()
    {
        Vector3 spawnPos = new Vector3(transform.position.x, transform.position.y + 2f, transform.position.z);
        ProjectileCore.CreateProjectile(spawnPos, target.gameObject.transform.position, gameObject.transform.rotation, arrowSpeed, arrow, arrowImpact, true);
    }

    void ShootX6()
    {
        for (int i = 0; i < 6; i++)
        {
            Vector3 spawnPos = new Vector3(transform.position.x, transform.position.y + 2f, transform.position.z);

            ProjectileCore.CreateProjectile(spawnPos, arrowPos[i].position, gameObject.transform.rotation, arrowSpeed, arrow, arrowImpact, true);
        }
    }
}
