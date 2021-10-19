using UnityEngine;
using UnityEngine.AI;

public class FollowPlayer : MonoBehaviour
{

    public Transform follow;
    NavMeshAgent agent;
    private Animator animator = null;

    private void Awake() {
        animator = GetComponent<Animator>();
        if (follow == null)
            follow = GameObject.FindWithTag("Player").GetComponent<Transform>();
    }

    void Start()
    {
        agent = GetComponent<NavMeshAgent>();
    }

    // Follow player
    void Update()
    {
        agent.destination = follow.position;

        // if (animator.GetBool("Dead") == false) {
        //    agent.destination = follow.position; 
        // } else {
        //     agent.isStopped = true;
        // }
    }
}