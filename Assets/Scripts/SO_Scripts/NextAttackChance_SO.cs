using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*---------------------------------------------------------------------------------------------------
*---------------------------------------- Next Attack SO  -------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* Scriptable object with next attack a monster should make based on next state
* ----------
* How to Use: 
* Have the state that just finsihed as the current state
* Have a list of possible next states
* Have a list of same size as possibleStates giving weights for each state
*----------------------------------------------------------------------------------------------------*/

[System.Serializable]
[CreateAssetMenu(fileName = "Next_Atk_Chance ", menuName = "Attack Patterns")]

public class NextAttackChance_SO : ScriptableObject
{
    // Public Parameters
    [SerializeField]
    private StatesPossible _currentState;

    [SerializeField]
    private List<StatesPossible> _possibleStates;

    [SerializeField]
    private List<float> _chance;

    
}
