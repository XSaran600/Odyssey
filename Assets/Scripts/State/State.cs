using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

/* Touched by: Nathan
 * 
 * Use: create new states with required functions to make handling new states easier
 * Needs: Must call an onstateEnter,Exit, and MUST call finished.Invoke on onstateExit
 * 
 * Problems: Am unsure how to call finished.invoke without having the child classes deal with it
 */

// Base state class
public abstract class State : MonoBehaviour
{
    protected StateHandler user;
    public bool shouldTick;
    protected bool isFinished;
    [HideInInspector]
    public UnityEvent finished;

    // Has no def, needs to be created every class
    public abstract void Tick();
    public abstract void OnStateEnter();
    public abstract void OnStateExit();
    /// <summary>
    /// the purpose of this class is to know which child class the state class is holding
    /// </summary>
    /// <returns></returns>
    public abstract StatesPossible StateName();
    /// <summary>
    /// Set a target, and do nothing if none
    /// </summary>
    public virtual void SetTarget(GameObject target) { }

    protected virtual void Awake()
    {
        if (user == null)
            user = GetComponent<StateHandler>();
        shouldTick = true;
    }

    public State(StateHandler user)
    {
        this.user = user;
    }

    public bool GetIsFinished()
    {
        return isFinished;
    }

}
