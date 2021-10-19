using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class EnemyAI : MonoBehaviour
{
    [SerializeField]
    private StateHandler stateHandler;
    public StatesPossible currentStateEnum;

    private GameObject player;

    float currentHealth = 100;

    int phase = 1;
    float x;

    bool phaseChange = false;

    void Awake()
    {
        currentStateEnum = StatesPossible.missingState;
    }
    private void OnEnable()
    {
        stateHandler.SubscribeToStates(DetermineNextState);
    }
    private void OnDisable()
    {
        stateHandler.UnsubscribeToStates(DetermineNextState);
    }
    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.FindGameObjectWithTag("Player");
    }

    // Update is called once per frame
    void Update()
    {
        DetermineNextState();
        currentStateEnum = stateHandler.currentState.StateName();

        // Check if the Phase needs to change
        ChangePhase();

    }

    public void DetermineNextState()
    {
        if (stateHandler.currentState.GetIsFinished())
        {
            // If there is no more states in queue, add a new one
            if (stateHandler.nextStates.Count == 0)
            {

                if (CurrentPhase() == 1)
                {
                    //PhaseOne();
                    Test();

                }
                else if (CurrentPhase() == 2)
                {
                    if(!phaseChange)
                    {
                        stateHandler.AddNextState(StatesPossible.Rage);
                        phaseChange = true;
                    }
                    else
                    {
                        //PhaseTwo();
                        Test();
                    }
                }
                //stateHandler.AddNextState(StatesPossible.HydraBarrage);
            }
            if (stateHandler.nextStates.Count > 0)
                stateHandler.SetState();
        }


    }

    void Test()
    {
        if (currentStateEnum == StatesPossible.HydraBarrage)
            stateHandler.AddNextState(StatesPossible.CeryneianRush);
        if (currentStateEnum == StatesPossible.CeryneianRush)
            stateHandler.AddNextState(StatesPossible.HippolytaHunt);
        if (currentStateEnum == StatesPossible.HippolytaHunt)
            stateHandler.AddNextState(StatesPossible.StymphalianSnipe);
        if (currentStateEnum == StatesPossible.StymphalianSnipe)
            stateHandler.AddNextState(StatesPossible.WrathoftheLion);
        if (currentStateEnum == StatesPossible.WrathoftheLion)
            stateHandler.AddNextState(StatesPossible.HydraBarrage);
    }

    // Logic for Phase 1 AI
    void PhaseOne()
    {
        Debug.Log("PHASE ONE");
        // **********************************************************
        // HELP: Nemean Defense animation doesn't play due to first animation in combo doesnt play bug
        // **********************************************************
        /*
        if (false) // If player has player combo greater or equals to 9 or combo finisher is greater than 3
        {
            // Nemean Defense
            stateHandler.AddNextState(StatesPossible.NemeanDefense);
        }*/

        // If the player is out of range
        if (IsPlayerOutOfRange())
        {
            stateHandler.AddNextState(GuessNextState(0, 0, 0, 20, 0, 0, 0, 80));

        }
        else
        {
            Debug.Log("IN RANGE");
            // Figure out what move to do next depending on the previous move
            if(currentStateEnum == StatesPossible.CeryneianRush)
            {
                PhaseOneCeryneianRushLogic();
            }
            else if(currentStateEnum == StatesPossible.HydraBarrage)
            {
                PhaseOneHydraBarrage();
            }
            else if (currentStateEnum == StatesPossible.WrathoftheLion)
            {
                PhaseOneWrathoftheLion();
            }
            else if (currentStateEnum == StatesPossible.DivergingAlpheus)
            {
                PhaseOneDivergingAlpheus();
            }
        }
    }

    void PhaseOneCeryneianRushLogic()
    {
        // If the enemy is near the player
        if (IsPlayerNear())
        {
            stateHandler.AddNextState(GuessNextState(20, 50, 30));
        }
        else
        {
            /// ------------------------
            /// NOTE: Does NOT add to 100
            /// ------------------------
            stateHandler.AddNextState(GuessNextState(15, 0, 15, 35));
        }
    }

    void PhaseOneHydraBarrage()
    {
        stateHandler.AddNextState(GuessNextState(33, 0, 33, 33));
    }

    // **********************************************************
    // HELP: Diverging Alpheus animation doesn't play due to first animation in combo doesnt play bug
    // **********************************************************
    void PhaseOneDivergingAlpheus()
    {
        stateHandler.AddNextState(GuessNextState(35, 30, 10 ));
    }

    void PhaseOneWrathoftheLion()
    {
        stateHandler.AddNextState(GuessNextState(35, 35, 0, 30));
    }

    // Logic for Phase 2 AI
    void PhaseTwo()
    {
        // **********************************************************
        // HELP: Don't know how to know the players combo
        // **********************************************************
        if (false) // If player has player combo greater or equals to 9 or combo finisher is greater than 3
        {
            // Nemean Defense
            stateHandler.AddNextState(StatesPossible.NemeanDefense);
        }

        // If the player is out of range
        if (IsPlayerOutOfRange())
        {
            stateHandler.AddNextState(GuessNextState(0, 0, 0, 80, 0, 0, 0, 20));
        }
        else
        {
            // Figure out what move to do next depending on the previous move
            if (currentStateEnum == StatesPossible.CeryneianRush)
            {
                PhaseTwoCeryneianRushLogic();
            }
            else if (currentStateEnum == StatesPossible.HydraBarrage)
            {
                PhaseTwoHydraBarrage();
            }
            else if (currentStateEnum == StatesPossible.WrathoftheLion)
            {
                PhaseTwoWrathoftheLion();
            }
            else if (currentStateEnum == StatesPossible.StymphalianSnipe)
            {
                PhaseTwoStymphalianSnipe();
            }
            else if (currentStateEnum == StatesPossible.HippolytaHunt)
            {
                PhaseTwoHippolytaHunt();
            }
            else if (currentStateEnum == StatesPossible.DivergingAlpheus)
            {
                PhaseTwoDivergingAlpheus();
            }

        }
    }

    void PhaseTwoCeryneianRushLogic()
    {
        // If the enemy is near the player
        if (IsPlayerNear())
        {
            stateHandler.AddNextState(GuessNextState(20, 50, 30));
        }
        else
        {
            stateHandler.AddNextState(GuessNextState(0, 0, 0, 35, 55, 10));
        }
    }

    void PhaseTwoHydraBarrage()
    {
        stateHandler.AddNextState(GuessNextState(30, 0, 10, 30, 25, 5));
    }

    void PhaseTwoWrathoftheLion()
    {
        stateHandler.AddNextState(GuessNextState(20, 40, 0, 25, 10, 5));
    }

    void PhaseTwoDivergingAlpheus()
    {
        stateHandler.AddNextState(GuessNextState(35, 30, 10, 0, 20, 5));
    }

    void PhaseTwoStymphalianSnipe()
    {
        stateHandler.AddNextState(GuessNextState(30, 15, 5, 30, 20));        
    }

    void PhaseTwoHippolytaHunt()
    {
        stateHandler.AddNextState(GuessNextState(30, 15, 20, 30, 0, 5));
    }

    // Change the Phases
    void ChangePhase()
    {
        if(currentHealth <= currentHealth * 0.5f && phase == 1) // if less than 50% health go to phase 2
        {
            phase = 2;
        }
    }

    bool IsPlayerNear()
    {
        if ((transform.position - player.transform.position).sqrMagnitude < 3)
            return true;
        else
            return false;
    }

    bool IsPlayerOutOfRange()
    {
        if ((transform.position - player.transform.position).sqrMagnitude < 10)
            return true;
        else
            return false;
    }

    // Use in other classes to check what phase the boss is in
    public int CurrentPhase()
    {
        return phase;
    }

    /// <summary>
    /// It is reccomended to make the points = to 100 to make it easier to determine percent of each state
    /// </summary>
    /// <returns></returns>
    public StatesPossible GuessNextState(int ceryneianRushPoints = 0, int hydraBarragePoints = 0, int wrathoftheLionPoints = 0, int divergingAlpheusPoints = 0,
                                int hippolytaHuntPoints = 0, int stymphalianSnipePoints = 0, int nemeanDefensePoints = 0, int chasePoints = 0)
    {

        int totalPoints = ceryneianRushPoints + hydraBarragePoints + wrathoftheLionPoints + divergingAlpheusPoints +
            hippolytaHuntPoints + stymphalianSnipePoints + nemeanDefensePoints + chasePoints;

        int y = Random.Range(0, totalPoints);

        if (y <= ceryneianRushPoints)
            return StatesPossible.CeryneianRush;
        else if (y <= ceryneianRushPoints + hydraBarragePoints)
            return StatesPossible.HydraBarrage;
        else if (y <= ceryneianRushPoints + hydraBarragePoints + wrathoftheLionPoints)
            return StatesPossible.WrathoftheLion;
        else if (y <= ceryneianRushPoints + hydraBarragePoints + wrathoftheLionPoints + divergingAlpheusPoints)
            return StatesPossible.DivergingAlpheus;
        else if (y <= ceryneianRushPoints + hydraBarragePoints + wrathoftheLionPoints + divergingAlpheusPoints + hippolytaHuntPoints)
            return StatesPossible.HippolytaHunt;
        else if (y <= ceryneianRushPoints + hydraBarragePoints + wrathoftheLionPoints + divergingAlpheusPoints + hippolytaHuntPoints + stymphalianSnipePoints)
            return StatesPossible.StymphalianSnipe;
        else if (y <= ceryneianRushPoints + hydraBarragePoints + wrathoftheLionPoints + divergingAlpheusPoints + hippolytaHuntPoints + stymphalianSnipePoints + nemeanDefensePoints)
            return StatesPossible.NemeanDefense;
        else if (y <= ceryneianRushPoints + hydraBarragePoints + wrathoftheLionPoints + divergingAlpheusPoints + hippolytaHuntPoints + stymphalianSnipePoints + nemeanDefensePoints + chasePoints)
            return StatesPossible.chase;
                return StatesPossible.idle;
    }
}
