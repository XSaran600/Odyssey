// Author: Saran Krishnaraja
// Reference: https://forum.unity.com/threads/anyone-have-an-example-of-a-charged-shot-type-of.47333/

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChargeAttack : MonoBehaviour
{
    float fireRate = 0.5f;

    float nextFire = 0f;

    [SerializeField]
    float chargeCounter = 0f;

    private void Update()
    {
        if(Input.GetKey(KeyCode.T))
        {
            chargeCounter++;

            if(chargeCounter >= 100)
            {
                Debug.Log("Charging weapon");
            }
        }
        if(Input.GetKeyUp(KeyCode.T))
        {

            if (chargeCounter >= 100)
            {
                Debug.Log("This was a charged attack");
            }
            else if(Time.time > nextFire)
            {
                nextFire = Time.time + fireRate;
            }

            chargeCounter = 0;
        }
    }
}
