using Invector.vMelee;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using Odyssey.Projectiles;

/*
    Whenever a significant distance is placed between the boss and the player, 
    Heracles charges a bow and arrow attack, taking aim into the air and firing. 
    Shortly afterward, a barrage of arrows falls from Heracles’ position. From the area that Heracles originally fires upon, 
    a ring of falling arrows quickly expands and envelops the entire area.  
*/

public class StymphalianSnipe : State
{
    bool comboDone = false;
    bool canAttack = false;
    public Odyssey.Combat.EnemyInput enemyInput;

    public List<string> comboAnim;
    private int comboIndex;

    public GameObject target;

    Vector3 spawnPos, endPos;

    bool shoot = false;
    public float arrowSpeed = 10f;

    [SerializeField]
    private GameObject arrow;
    [SerializeField]
    private GameObject arrowImpact;

    public StymphalianSnipe(StateHandler user) : base(user)
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
        return StatesPossible.StymphalianSnipe;
    }
    public override void OnStateEnter()
    {
        shouldTick = true;
        isFinished = false;
        comboIndex = 0;
        canAttack = true;
        shoot = false;
    }
    public override void OnStateExit()
    {
        comboDone = false;      // Reset combo counter
        shouldTick = false;
        isFinished = true;
        canAttack = false;
        shoot = false;
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
        // Charge Bow
        // Release Bow

        if(comboIndex == 1)
        {
            // Charge Bow

            //****************
            // Spawn Particles
            //****************
        }

        if (comboIndex == 2)
        {
            if(!shoot)
            {
                for (int i = 0; i < 25; i++)
                {
                    spawnPos = target.gameObject.transform.position;
                    spawnPos = new Vector3(spawnPos.x + Random.Range(-2f, 2f), 30f, spawnPos.z + Random.Range(-2f, 2f));

                    endPos = new Vector3 (spawnPos.x, target.gameObject.transform.position.y + 1.0f, spawnPos.z);

                    ProjectileCore.CreateProjectile(spawnPos, endPos, arrowSpeed, arrow, arrowImpact, true);
                }
                shoot = true;
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
}
