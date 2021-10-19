using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MoreMountains.InventoryEngine;
using DG.Tweening;
using UnityEngine.UI;

public class WorldItemInteraction : MonoBehaviour
{
    public GameObject[] items;
    public float distanceUntilUIShows = 5.0f;
    public float uiFadeInAndOutTime = 0.5f;
    [Range(0, 1)] public float uiShowAngleTolerance = 0.5f;
    [Range(0, 3)] [Tooltip("Distance that guarantees UI to show regardless of facing angle (ie. standing almost on top of item)")] public float meleeDistance = 1.3f;

    public AudioSource pickupSound;
    public GameObject itemPickupTextUI;

    [Range(0, 5)] public float uiShowObtainedItemTime = 2.0f;

    private GameObject[] itemUIs = new GameObject[50];
    private bool[] once = new bool[50];

    private int Xbox_One_Controller = 0;
    private int PS4_Controller = 0;
    private int controllerInt;

    // Start is called before the first frame update
    void Start()
    {
        items = GameObject.FindGameObjectsWithTag("InteractableItem");

        for (int i = 0; i < items.Length; i++)
        {
            itemUIs[i] = items[i].transform.GetChild(0).gameObject;
            itemUIs[i].SetActive(false);
        }

    }

    // Update is called once per frame
    void Update()
    {

        string[] names = Input.GetJoystickNames();
        for (int x = 0; x < names.Length; x++)
        {
            print(names[x].Length);
            if (names[x].Length == 19)
            {
                print("PS4 CONTROLLER IS CONNECTED");
                PS4_Controller = 1;
                Xbox_One_Controller = 0;
            }
            if (names[x].Length == 33)
            {
                print("XBOX ONE CONTROLLER IS CONNECTED");
                //set a controller bool to true
                PS4_Controller = 0;
                Xbox_One_Controller = 1;
            }
        }
        if (Xbox_One_Controller == 1)
        {
            controllerInt = 1;

        }
        else if (PS4_Controller == 1)
        {
            // do something
        }
        else
        {
            // there is no controllers
            controllerInt = 0;
            // print("NO CONTROLLER IS CONNECTED");
        }

        if (Input.anyKeyDown)
            controllerInt = 0;


        for (int i = 0; i < items.Length; i++)
        {
            if (items[i] != null)
            {
                if (once[i] == false)
                {
                    // Within distance and player facing item OR standing on top of item
                    if ((Vector3.Distance(transform.position, items[i].transform.position) < distanceUntilUIShows && Vector3.Dot(transform.forward, (items[i].transform.position - transform.position).normalized) > (1 - uiShowAngleTolerance*2f)) || Vector3.Distance(transform.position, items[i].transform.position) < meleeDistance) 
                    {
                        itemUIs[i].SetActive(true);
                        itemUIs[i].transform.GetChild(controllerInt).GetComponent<Image>().DOFade(1.0f, uiFadeInAndOutTime);
                        once[i] = true;
                    } 
                }
                
                if (once[i])
                {
                    // Out of range or not facing
                    if ((Vector3.Distance(transform.position, items[i].transform.position) >= distanceUntilUIShows || Vector3.Dot(transform.forward, (items[i].transform.position - transform.position).normalized) <= (1 - uiShowAngleTolerance*2f)) && Vector3.Distance(transform.position, items[i].transform.position) >= meleeDistance)
                    {
                        StartCoroutine(DelayedDisable(itemUIs[i], i, uiFadeInAndOutTime));
                        itemUIs[i].transform.GetChild(controllerInt).GetComponent<Image>().DOFade(0f, uiFadeInAndOutTime);
                        once[i] = false;
                    }
                }
            }
        }

        if (Input.GetKeyDown(KeyCode.E) || Input.GetButtonDown("Triangle"))
        {
            for (int i = 0; i < items.Length; i++)
            {
                if (items[i] != null)
                {
                    if (once[i])
                    {
                        items[i].GetComponent<ItemPickerInteractable>().Pick();
                        pickupSound.Play();

                        itemPickupTextUI.SetActive(true);
                        itemPickupTextUI.GetComponent<Image>().DOFade(1.0f, uiFadeInAndOutTime);
                        itemPickupTextUI.transform.GetChild(0).GetComponent<Text>().DOFade(1.0f, uiFadeInAndOutTime);
                        itemPickupTextUI.transform.GetChild(1).GetComponent<Image>().DOFade(1.0f, uiFadeInAndOutTime);
                        itemPickupTextUI.transform.GetChild(0).GetComponent<Text>().text = (items[i].GetComponent<ItemPickerInteractable>().GetQuantity()) + "x " + items[i].GetComponent<ItemPickerInteractable>().GetName();
                        itemPickupTextUI.transform.GetChild(1).GetComponent<Image>().sprite = items[i].GetComponent<ItemPickerInteractable>().GetIcon();
                        Invoke("FadeOut", uiShowObtainedItemTime);
                        Destroy(items[i]);
                        break;
                    }
                }
            }
        }
    }

    private void FadeOut()
    {
        itemPickupTextUI.GetComponent<Image>().DOFade(0.0f, uiFadeInAndOutTime);
        itemPickupTextUI.transform.GetChild(0).GetComponent<Text>().DOFade(0.0f, uiFadeInAndOutTime);
        itemPickupTextUI.transform.GetChild(1).GetComponent<Image>().DOFade(0.0f, uiFadeInAndOutTime);
    }

    IEnumerator DelayedDisable(GameObject obj, int index, float delayTime)
    {
        Debug.Log("RunningItemDisable");
        yield return new WaitForSeconds(delayTime);
        if (once[index] == false) // If player quickly looks away then looks back within the delay time, don't deactivate object
            obj.SetActive(false);
    }
    

    
}
