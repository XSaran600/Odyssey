using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Grass : MonoBehaviour
{
//    public Transform playerCam; 

    void Update()
    {
        //        transform.LookAt(playerCam, Vector3.up * Time.deltaTime);
        gameObject.GetComponent<MeshRenderer>().material.SetVector("_BaseForward", transform.forward);
    }

    //void OnCollisionEnter(Collision other)
    //{
    //    Debug.Log("Touch");
    //       transform.LookAt(playerCam, Vector3.up * Time.deltaTime);
    //}
    //void OnCollisionStay(Collision other)
    //{
    //    Debug.Log("Stay");
    //    transform.LookAt(playerCam, Vector3.up * Time.deltaTime);
    //}
}
