using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;

public class CameraSequence : MonoBehaviour
{
    public bool beenPlayed;
    private void Awake()
    {
        beenPlayed = false;
    }
    public Animation timeLine;
    private void OnTriggerEnter(Collider other)
    {
        if (!beenPlayed)
            if (other.tag == "Cutscene")
            {
                timeLine.Play();
                beenPlayed = true;
            }
    }

}
