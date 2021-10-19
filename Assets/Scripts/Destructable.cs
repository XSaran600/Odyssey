using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class Destructable : MonoBehaviour
{
    public GameObject destroyedVer;
    public float powerMin, powerMax, radius, upForce;
    public bool touchColumnAnyColliderDestroy;
    private Rigidbody[] allChildRigidBodies;

    // Update is called once per frame
    void Update()
    {

    }

    public void SwapToDestroy()
    {
        gameObject.GetComponent<Collider>().enabled = false;
        GameObject objectToSwap;
        Debug.Log("x: " + transform.rotation.x);
        if (touchColumnAnyColliderDestroy)
            objectToSwap = Instantiate(destroyedVer, transform.position, transform.rotation * Quaternion.Euler(90, 0, 0));
        else
            objectToSwap = Instantiate(destroyedVer, transform.position, transform.rotation);

        allChildRigidBodies = objectToSwap.GetComponentsInChildren<Rigidbody>();

        foreach (var body in allChildRigidBodies)
        {
            //Debug.Log(body.name);
            body.AddExplosionForce(Random.Range(powerMin, powerMax), transform.position, radius, 1);
            body.transform.position =  new Vector3( body.transform.position.x, Mathf.Max(transform.position.y, body.transform.position.y), body.transform.position.z);
        }
        gameObject.SetActive(false);

        //SinkingObjects();
        Invoke("SinkingObjects", 5.5f);
        Destroy(gameObject, 5.51f);
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.GetComponent<Odyssey.Combat.CombatInput>() != null)
            SwapToDestroy();
        if (touchColumnAnyColliderDestroy)
            SwapToDestroy();
    }

    public void SinkingObjects()
    {
        Debug.Log("Sinking objects");
        foreach (var body in allChildRigidBodies)
        {
            body.gameObject.transform.DOMove(body.transform.position + new Vector3(0f,-5.0f,0f), 3.0f);
            Destroy(body.gameObject, 3.01f);
        }
    }


}
