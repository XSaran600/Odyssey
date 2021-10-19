using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Odyssey.Combat;
using UnityEngine.AI;

/*---------------------------------------------------------------------------------------------------
*---------------------------------------------- Enemy -----------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* Creates an enemy with stats.
* ----------
* How to Use: 
* Attach this script to an enemy object. Then attach the EnemyStats scriptable object to it.
* ----------
* Requires:
* IsCombatable functions, [TimeManager].
*----------------------------------------------------------------------------------------------------*/
public class Enemy : MonoBehaviour, IsCombatable
{
    // Copy SO over for use
    public EnemyStats enemyStats;

    public float health, maxHP, power, iFramesLength, iFramesLeft;

    public Combos comboAttacks;

    [SerializeField]
    private bool iFramesOn;
    public bool isPhysicalDamageable;

    private CombatCore combat;
    private Player playerScript;
    private GameObject player;

    Transform follow;
    NavMeshAgent agent;
    private Animator animator = null;

    public EnemyInput enemyInput;

    // How to make another listener on finish action!
    //void OnEnable()
    //{
    //    enemyInput.finishedActionEvent.AddListener(ActionKompleted);
    //}

    void Awake()
    {
        // Copy stats from Scriptable object
        maxHP = enemyStats.MaxHP;
        health = enemyStats.Health;
        iFramesLength = enemyStats.IFramesLength;
        power = enemyStats.Power;
        comboAttacks = enemyStats.ComboAttacks;

        // Get Player object and scripts
        player = GameObject.FindGameObjectWithTag("Player");
        combat = player.GetComponent<CombatCore>();
        playerScript = player.GetComponent<Player>();

        // Get Animator and Player transform and agent for following the player
        animator = GetComponent<Animator>();
        if (follow == null)
            follow = player.GetComponent<Transform>();
        agent = GetComponent<NavMeshAgent>();

        enemyInput = GetComponent<EnemyInput>();

    }

    // Get function
    public float GetHealth()
    {
        return health;
    }

    public float GetMaxHP()
    {
        return maxHP;
    }

    // Is physically damageable (once per hit)
    public bool IsPhysicalDamageable()
    {
        return isPhysicalDamageable;
    }

    public void SetPhysicalDamageable(bool isDamageable)
    {
        isPhysicalDamageable = isDamageable;
    }

    // Combat functions
    public void TakePhysicalDamage(float damage)
    {
        if (!iFramesOn)
        {
            health -= damage;
            iFramesOn = true;
            iFramesLeft = iFramesLength;
        }

        if (health < 0.405)
        {
            health = 0;
            combat.screenTargets.Remove(gameObject); // Remove from lock on target
            Color c = Color.clear;
            combat.aim.color = c;   // Make lock on icon clear (remove)
            Destroy(gameObject);    // Destroy
            TimeManager.SlowMotion(0.06f, 1.33f); // [TEST] Slow motion test!
        }

        isPhysicalDamageable = false;
    }

    public void TakeMagicDamage(float damage, int type = 0)
    {
        if (!iFramesOn)
        {
            health -= damage;
            iFramesOn = true;
            iFramesLeft = iFramesLength;
        }

        if (health < 0.405)
        {
            health = 0;
        }
    }

    void Update()
    {
        // iFramesOn
        if (iFramesOn)
        {
            iFramesLeft -= Time.deltaTime;
            if(iFramesLeft <= 0)
            {
                iFramesLeft = 0;
                iFramesOn = false;
            }

        }

       // FollowPlayer();
    }

    /*
    void FollowPlayer()
    {
        if ((transform.position - follow.position).sqrMagnitude < 3)
        {
            // the player is within a radius of 3 units to this game object
            if (enemyInput.finishedAction) // Attack if finished with current attack
            {
                enemyInput.QueueEnemyAction(EnemyInput.CommandTypes.attack); // Exaxmple of enemy attacking
            }

        }
        else
        {
            if (!enemyInput.attackingOrCasting)
            {
                agent.destination = follow.position;
                animator.Play("runWeapon", 0);      
            }            

        }
    }
    */
    // This is currently being called on action complete using listener & event, if you want to use it.
    public void ActionKompleted()
    {
        //Debug.Log("Action completed");
    }

}
