using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class AnimParameter : StateMachineBehaviour
{
    public string animName;
    public string modifierName;
    public int indexX;
    public int indexY;

    public AnimationCurve curveX = AnimationCurve.Linear(0, 0, 1, 0);
    public AnimationCurve curveY = AnimationCurve.Linear(0, 0, 1, 0);
    public AnimationCurve curveZ = AnimationCurve.Linear(0, 0, 1, 0);
}
// OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
//override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
//{
//    
//}

// OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
//override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
//{
//    
//}

// OnStateExit is called when a transition ends and the state machine finishes evaluating this state
//override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
//{
//    
//}

// OnStateMove is called right after Animator.OnAnimatorMove()
//override public void OnStateMove(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
//{
//    // Implement code that processes and affects root motion
//}

// OnStateIK is called right after Animator.OnAnimatorIK()
//override public void OnStateIK(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
//{
//    // Implement code that sets up animation IK (inverse kinematics)
//}