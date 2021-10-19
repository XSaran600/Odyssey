using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EmitterPause : MonoBehaviour
{
    // Update is called once per frame    
    public bool emmiterMode = true;

    void Update()
    {
        if (emmiterMode)
        {
            if (PlayerGlobals.GetStepTrigger() && PlayerGlobals.IsPlayerGrounded())
            {
                GetComponent<ParticleSystem>().enableEmission = true;
            }
            else
            {
                GetComponent<ParticleSystem>().enableEmission = false;
            }

        }
        else
        {
            if (PlayerGlobals.IsPlayerGrounded())
            {
                GetComponent<ParticleSystem>().enableEmission = true;
            }
            else
            {
                GetComponent<ParticleSystem>().enableEmission = false;
            }
        }
    }
}
