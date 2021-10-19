using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using Odyssey.Combat;

// This is stuck on the Enemy Weapon.
public class EnemyAttackListener : MonoBehaviour
{
    public EnemyInput enemyInput;

    //public UnityEvent enemyHitPlayerWithWeaponEvent;

    // Start is called before the first frame update
    void Start()
    {
        enemyInput = transform.root.GetComponent<EnemyInput>();
    }

    private void OnEnable()
    {
        //enemyHitPlayerWithWeaponEvent.AddListener(EnemyHitPlayerWithWeaponAction);
        //enemyHitPlayerWithWeaponEvent.AddListener(enemyInput.EnemyAttackedPlayerWithWeapon);
    }

    private void OnDisable()
    {
        //enemyHitPlayerWithWeaponEvent.RemoveListener(enemyInput.EnemyAttackedPlayerWithWeapon);
    }

    // This is invoked when enemy hit player based on listener
    //private void EnemyHitPlayerWithWeaponAction()
    //{
    //    Debug.Log("enemy hit player");
    //}

    /// <summary>
    /// Detects when Enemy Weapon comes into collision with enemy. TO-DO: change IsPhysicalDamageable to enable collider player attacks, disable after damage.
    /// </summary>
    void OnTriggerStay(Collider playerCollider)
    {
        if (!enemyInput.canHit) return;

        IsCombatable hittable = playerCollider.GetComponent<IsCombatable>();

        if (hittable != null)
        {
            if (enemyInput.attackingDelayed)
            {
                enemyInput.EnemyAttackedPlayerWithWeapon(hittable);
            }

        }
    }
    //------------------------------------------------------------------
}
