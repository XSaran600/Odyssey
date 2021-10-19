using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Odyssey.Combat;
using Invector.vCharacterController;

public class WeaponCollisionDamage : MonoBehaviour
{
    public CombatCore combat;
    private GameObject player;

    // Start is called before the first frame update
    void Start()
    {
        // Find Invector's Input
        if (player == null)
            player = GameObject.FindWithTag("Player");

        // Get necessary components
        //InvectorInput = player.GetComponent<vThirdPersonInput>();
        combat = player.GetComponent<CombatCore>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void OnTriggerEnter(Collider enemyCollider)
    {
        Enemy enemy = enemyCollider.gameObject.GetComponent<Enemy>();
        if (enemyCollider.gameObject.tag == "Enemy")
        {
            enemy.TakePhysicalDamage(1);
            Debug.Log("Took Damage");

        }    
    }

}
