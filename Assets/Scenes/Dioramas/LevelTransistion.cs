using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// The following script toggles on/off objects when the player collides with a World Collider (box collider).
/// Used for seemlessly transistioning between different environments found thorught the world.
/// </summary>
public class LevelTransistion : MonoBehaviour
{
    [Header("Gameobjects that are Toggled")]
    public GameObject[] ashAssets;  //Toggable assets in ash area
    public GameObject[] expAssets;  //Toggable assets in expanse area
    public GameObject[] ogAssets;   //Toggable assets in origin area
    public GameObject[] uwAssets;   //Toggable assets in underworld area

    [Header("Activate or Deactivate Objects")]
    //Using Unity inspector, toggle on or off assets with tags
    public bool activateAsh     = false;
    public bool activateExpanse = false;
    public bool activateOrigin  = false;
    public bool activateUnderworld = false;

    [Header("Transition Mode")]
    //Via player position on the map, determines what terrain, lighting and fog volumes are being enabled/disabled
    public bool ashExpanse    = false;    
    public bool expanseOrigin = false;

    public bool ashUnderworld = false;
    public bool underworldExpanse = false;

    void OnTriggerEnter(Collider other) //Depending what "Transition Mode is ticked, perform colling if statment"
    {
        if (ashExpanse)
        {
            Debug.Log("Mode: ashExpanse");

            //When "Collider Controller" under PLAYER in hierarchy hits a World Collider
            if (other.gameObject.tag == "WorldController") 
            {
                //Loop though array and disable 
                for (int i = 0; i < ashAssets.Length; i++)
                {
                    Debug.Log("Toggle ash"); 
                    ashAssets[i].SetActive(activateAsh); 
                }
                //Loop though array and enable 
                for (int i = 0; i < expAssets.Length; i++)
                {
                    Debug.Log("Toggle expanse");
                    expAssets[i].SetActive(activateExpanse);
                }
                //Loop though array and enable 
                for (int i = 0; i < uwAssets.Length; i++)
                {
                    Debug.Log("Toggle expanse");
                    uwAssets[i].SetActive(activateUnderworld);
                }
            }
        }

        if (ashUnderworld)
        {
            Debug.Log("Mode: ashToUnderworld");

            //When "Collider Controller" under PLAYER in hierarchy hits a World Collider
            if (other.gameObject.tag == "WorldController")
            {
                //Loop though array and disable 
                for (int i = 0; i < ashAssets.Length; i++)
                {
                    Debug.Log("Toggle ash");
                    ashAssets[i].SetActive(activateAsh);
                }
                //Loop though array and disable 
                for (int i = 0; i < uwAssets.Length; i++)
                {
                    Debug.Log("Toggle underworld");
                    uwAssets[i].SetActive(activateUnderworld);
                }
            }
        }

        if (expanseOrigin)
        {
            Debug.Log("Mode: expanseOrigin");

            //When "Collider Controller" under PLAYER in hierarchy hits a World Collider
            if (other.gameObject.tag == "WorldController")
            {
                //Loop though array and disable 
                for (int i = 0; i < expAssets.Length; i++)
                {
                    Debug.Log("Toggle expanse");
                    expAssets[i].SetActive(activateExpanse);    
                }
                //Loop though array and enable 
                for (int i = 0; i < ogAssets.Length; i++)
                {
                    Debug.Log("Toggle origin");
                    ogAssets[i].SetActive(activateOrigin);
                }
            }
        }
    
        if (underworldExpanse)
        {
            Debug.Log("Mode: underworldToExpanse");

            //When "Collider Controller" under PLAYER in hierarchy hits a World Collider
            if (other.gameObject.tag == "WorldController")
            {
                //Loop though array and disable 
                for (int i = 0; i < ashAssets.Length; i++)
                {
                    Debug.Log("Toggle Ash");
                    ashAssets[i].SetActive(activateAsh);
                }
                //Loop though array and enable 
                for (int i = 0; i < expAssets.Length; i++)
                {
                    Debug.Log("Toggle expanse");
                    expAssets[i].SetActive(activateExpanse);
                }
            }
        }
    
    }

    //void OnTriggerExit(Collider other)
    //{
    //    if (other.gameObject.tag == "WorldController")
    //    {
    //        Debug.Log("Player Touch");
    //
    //        for (int i = 0; i < ashAssets.Length; i++)
    //        {
    //            ashAssets[i].SetActive(true);
    //        }
    //    }
    //}
}
