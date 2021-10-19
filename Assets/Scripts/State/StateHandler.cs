using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

/*
 * Use: Manages other states attached to object
 * Tick function is essentailly the update function
 * States have a enterstate and a exit state
 * tickCurrentState makes sure if you want to update the current state
 * To change state, add a state to the queue, and end the 
 * 
 * WARNING: Prefabs want this script above AI_SCRIPTS FOR NO REAL REASON
 * IF YOU SOLVE THIS, PLEASE HELP ME
 */



/// <summary>
/// StateHandler will hold the current and other possible states
/// This will handle switching between states
/// </summary>
public class StateHandler : MonoBehaviour
{
    [Header("Prefabs want this script above AI_SCRIPTS FOR NO REAL REASON IF YOU SOLVE THIS, PLEASE HELP ME")]

    /// <summary>
    /// Event system for when enemy changes states
    /// </summary>
    public UnityEvent stateChanged;

    /// <summary>
    /// Cannot set outsite, only get
    /// </summary>
    [SerializeField]
    public State currentState { get; private set; }
    public StatesPossible startState;
    public Queue<State> nextStates;     // Loads the next state
    /// <summary>
    /// States within the object. Use TryGetValue() if you are unsure about the object having the state you want
    /// </summary>
    public Dictionary<StatesPossible,State> stateDict;


    [SerializeField]
    private StatesPossible currentStateCheck;

    /// <summary>
    /// DEBUGGING VARIABLE
    /// </summary>
    [SerializeField]
    private bool tickCurrentState = true;
    /// <summary>
    /// DEBUGGING VARIABLE DO NOT USE
    /// </summary>
    [SerializeField]
    private float nextStatesInQueue = 0;

    public delegate void StateFinishedListener();


    private void Awake()
    {

        // Adding Dictionary with the object's states
        FindPossibleStates();

        currentState = stateDict[startState];
        // make sure we start the state as well
        currentState.OnStateEnter();
        nextStates = new Queue<State>();
    }

    private void FindPossibleStates()
    {
        // Adding Dictionary with the object's states
        if (stateDict == null)
        {
            stateDict = new Dictionary<StatesPossible, State>();
            foreach (State entry in gameObject.GetComponents<State>())
            {
                stateDict.Add(entry.StateName(), entry);
            }
        }
    }

    public void SubscribeToStates(UnityAction listener)
    {
        if(stateDict == null)
        {
            FindPossibleStates();
        }
        foreach (KeyValuePair<StatesPossible, State> entry in stateDict)
        {
            entry.Value.finished.AddListener(listener);
        }
    }
    public void UnsubscribeToStates(UnityAction listener)
    {
        foreach (KeyValuePair<StatesPossible, State> entry in stateDict)
        {
            entry.Value.finished.RemoveListener(listener);
        }
    }
    private void Update()
    {
        nextStatesInQueue = nextStates.Count;

        //DEBUG PURPOSES ONLY, lets us check which child class we are using
        if (currentState != null)
            currentStateCheck = currentState.StateName();

        // if the current state is done, load in the next plz

        if(currentState.shouldTick)
        {
            // A state's Tick is essentially it's update function
            currentState.Tick(); 
            tickCurrentState = true;
        }
        else
        {
            tickCurrentState = false;
        }

    }

    /// <summary>
    /// activate next state in queue
    /// </summary>
    public void SetState()
    {
        // get next state in queue
        if (nextStates.Count > 0 && currentState.GetIsFinished())
        {
            currentState = nextStates.Dequeue();
        }

        // activate next state
        if (currentState != null)
        {
            currentState.OnStateEnter();
        }
    }
    /// <summary>
    /// Adds next state to queue
    /// </summary>
    /// <param name="state"></param>
    public void AddNextState(StatesPossible state)
    {
        if (nextStates.Count > 0)
        {
            if (nextStates.Peek().StateName() != state)
            {
                nextStates.Enqueue(stateDict[state]);
            }
        }
        else
        {
            nextStates.Enqueue(stateDict[state]);
        }
    }
/// <summary>
/// WARNING: DOES NOT CHECK IF CURRENT STATE FINISHED
/// </summary>
    public void CallNextState()
    {
        // Implement a wait timer for when currentState = null
        if (nextStates.Count != 0)
        {
            currentState = nextStates.Dequeue();
            currentState.OnStateEnter();
        }

    }
}
