using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*  Touched by: Nathab Alphonse
 *  Use: This scipt will handle how the states changes by using stateHandler
 * 
 * Notes:
 *  You cannot add the same type of state as the current state into the queue
 *  However, you can add the current state after another state
 * 
 */

public class AI_Monster : MonoBehaviour
{
    [SerializeField]
    private StateHandler stateHandler;
    public StatesPossible currentStateEnum;

    // variables for AI
    [SerializeField]
    private float timer;
    [SerializeField]
    private float strafeTime;
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
    public void ClearAIValues()
    {
        timer = 0;
    }


    // Update is called once per frame
    void Update()
    {
        DetermineNextState();
        currentStateEnum = stateHandler.currentState.StateName();
        timer += Time.deltaTime;
        if (currentStateEnum == StatesPossible.chase)
        {
            if ( ((Chase)stateHandler.stateDict[StatesPossible.chase]).ReachedTarget())
            {
                stateHandler.currentState.OnStateExit(); // this will tell state it's finished within exit call
            }
        }
        else if (currentStateEnum == StatesPossible.strafe)
        {
            if (timer > strafeTime)
            {
                stateHandler.currentState.OnStateExit();
            }

        }

    }


    public void DetermineNextState()
    {

        if (stateHandler.currentState.GetIsFinished())
        {
            ClearAIValues();
            // If there is no more states in queue, add a new one
            if (stateHandler.nextStates.Count == 0)
            {
                // Alternate for using get component for states: 
                // ((Chase)stateHandler.stateDict[StatesPossible.chase]).ReachedTarget()
                // stateHandler.gameObject.GetComponent<Chase>().ReachedTarget()

                // The current logic is if they chased for too long, idle then chase or retreat
                if (!((Chase)stateHandler.stateDict[StatesPossible.chase]).ReachedTarget())
                {
                    if (Random.Range(0, 2) > 0)
                    {
                    stateHandler.AddNextState(StatesPossible.idle);
                    stateHandler.AddNextState(StatesPossible.chase);
                    }
                    else
                    {
                        stateHandler.AddNextState(StatesPossible.idle);
                        stateHandler.AddNextState(StatesPossible.HydraBarrage);
                    }
                }
                else
                {
                    if (Random.Range(0, 2) > 0)
                    {
                        stateHandler.AddNextState(StatesPossible.idle);
                        stateHandler.AddNextState(StatesPossible.retreat);
                    }
                    {
                        stateHandler.AddNextState(StatesPossible.strafe);
                    }
                }
            }
            if (stateHandler.nextStates.Count > 0)
                stateHandler.SetState();
        }


    }

}
