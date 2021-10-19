// Author: Saran Krishnaraja

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Odyssey.Combat;

public class CommandMenu : MonoBehaviour
{
    enum Selected
    {
        attack,
        grimoire,
        items
    };

    enum GrimSelected
    {
        grim1,
        grim2,
        grim3,
        grim4
    };
    enum ItemSelected
    {
        health,
        mana
    };

    Selected currentlySelected;
    GrimSelected grimSelected;
    ItemSelected itemSelected;

    [SerializeField] public Image attackImage;
    [SerializeField] public Image grimoreImage;
    [SerializeField] public Image inventoryImage;

    public List<Image> menu;
    public List<Image> grimoire;
    public List<Image> items;


    public GameObject grimoireSelected;
    public GameObject itemsSelected;


    bool selected = false;

    // Start is called before the first frame update
    void Start()
    {
        menu[0].color = Color.red;
        menu[1].color = Color.white;
        menu[2].color = Color.white;

        attackImage.enabled = true;
        grimoreImage.enabled = false;
        inventoryImage.enabled = false;

        grimoireSelected.SetActive(false);
        itemsSelected.SetActive(false);

        currentlySelected = Selected.attack;
    }

    // Update is called once per frame
    void Update()
    {
        if (!selected)
        {
            MenuInputs();
        }

        if (selected)
        {
            if (currentlySelected == Selected.grimoire)
            {
                GrimInputs();
            }
            if (currentlySelected == Selected.items)
            {
                ItemInputs();
            }

        }
    }

    void MenuInputs()
    {
        // Input
        if (Input.GetAxis("Mouse ScrollWheel") < 0 || Input.GetAxis("D-Pad Vertical") < -0.1f)    // Down
        {
            if (currentlySelected == Selected.items)    // Menu loops around
            {
                currentlySelected = Selected.attack;
            }
            else
            {
                currentlySelected++;
            }
            // Selected Colors
            if (currentlySelected == Selected.attack)
            {
                menu[0].color = Color.red;
                menu[1].color = Color.white;
                menu[2].color = Color.white;
                attackImage.enabled = true;
                grimoreImage.enabled = false;
                inventoryImage.enabled = false;
                grimoireSelected.SetActive(false);
                itemsSelected.SetActive(false);
            }
            if (currentlySelected == Selected.grimoire)
            {
                menu[0].color = Color.white;
                menu[1].color = Color.red;
                menu[2].color = Color.white;
                attackImage.enabled = false;
                grimoreImage.enabled = true;
                inventoryImage.enabled = false;
            }
            if (currentlySelected == Selected.items)
            {
                menu[0].color = Color.white;
                menu[1].color = Color.white;
                menu[2].color = Color.red;
                attackImage.enabled = false;
                grimoreImage.enabled = false;
                inventoryImage.enabled = true;
            }
        }
        if (Input.GetAxis("Mouse ScrollWheel") > 0 || Input.GetAxis("D-Pad Vertical") > 0.1f)    // Up
        {
            if (currentlySelected == Selected.attack)   // Menu loops around
            {
                currentlySelected = Selected.items;
            }
            else
            {
                currentlySelected--;
            }
            // Selected Colors
            if (currentlySelected == Selected.attack)
            {
                menu[0].color = Color.red;
                menu[1].color = Color.white;
                menu[2].color = Color.white;
                attackImage.enabled = true;
                grimoreImage.enabled = false;
                inventoryImage.enabled = false;
                grimoireSelected.SetActive(false);
                itemsSelected.SetActive(false);
            }
            if (currentlySelected == Selected.grimoire)
            {
                menu[0].color = Color.white;
                menu[1].color = Color.red;
                menu[2].color = Color.white;
                attackImage.enabled = false;
                grimoreImage.enabled = true;
                inventoryImage.enabled = false;
            }
            if (currentlySelected == Selected.items)
            {
                menu[0].color = Color.white;
                menu[1].color = Color.white;
                menu[2].color = Color.red;
                attackImage.enabled = false;
                grimoreImage.enabled = false;
                inventoryImage.enabled = true;
            }
        }
        if (Input.GetMouseButtonDown(0) || Input.GetButtonDown("X"))    // Select
        {
            if (currentlySelected == Selected.attack)
            {
                AttackSelected();   // Attack
            }
            if (currentlySelected == Selected.grimoire)
            {
                Invoke("SelectGrimoire", 0.01f); // Add a delay to fix grimoire instantly casting spells the next time player navigates in
            }
            if (currentlySelected == Selected.items)
            {
                grimoireSelected.SetActive(false);
                itemsSelected.SetActive(true);
                foreach (Image m in menu)
                {
                    m.color = Color.white;
                }
                items[0].color = Color.red;
                items[1].color = Color.white;
                selected = true;
            }
        }

    }

    void GrimInputs()
    {
        // Input
        if (Input.GetAxis("Mouse ScrollWheel") < 0 || Input.GetAxis("D-Pad Vertical") < -0.1f)    // Down
        {
            if (grimSelected == GrimSelected.grim4)    // Menu loops around
            {
                grimSelected = GrimSelected.grim1;
            }
            else
            {
                grimSelected++;
            }
            // Selected Colors
            if (grimSelected == GrimSelected.grim1)
            {
                grimoire[0].color = Color.red;
                grimoire[1].color = Color.white;
                grimoire[2].color = Color.white;
                grimoire[3].color = Color.white;
            }
            if (grimSelected == GrimSelected.grim2)
            {
                grimoire[0].color = Color.white;
                grimoire[1].color = Color.red;
                grimoire[2].color = Color.white;
                grimoire[3].color = Color.white;
            }
            if (grimSelected == GrimSelected.grim3)
            {
                grimoire[0].color = Color.white;
                grimoire[1].color = Color.white;
                grimoire[2].color = Color.red;
                grimoire[3].color = Color.white;
            }
            if (grimSelected == GrimSelected.grim4)
            {
                grimoire[0].color = Color.white;
                grimoire[1].color = Color.white;
                grimoire[2].color = Color.white;
                grimoire[3].color = Color.red;
            }
        }
        if (Input.GetAxis("Mouse ScrollWheel") > 0 || Input.GetAxis("D-Pad Vertical") > 0.1f)    // Up
        {
            if (grimSelected == GrimSelected.grim1)   // Menu loops around
            {
                grimSelected = GrimSelected.grim4;
            }
            else
            {
                grimSelected--;
            }
            // Selected Colors
            if (grimSelected == GrimSelected.grim1)
            {
                grimoire[0].color = Color.red;
                grimoire[1].color = Color.white;
                grimoire[2].color = Color.white;
                grimoire[3].color = Color.white;
            }
            if (grimSelected == GrimSelected.grim2)
            {
                grimoire[0].color = Color.white;
                grimoire[1].color = Color.red;
                grimoire[2].color = Color.white;
                grimoire[3].color = Color.white;
            }
            if (grimSelected == GrimSelected.grim3)
            {
                grimoire[0].color = Color.white;
                grimoire[1].color = Color.white;
                grimoire[2].color = Color.red;
                grimoire[3].color = Color.white;
            }
            if (grimSelected == GrimSelected.grim4)
            {
                grimoire[0].color = Color.white;
                grimoire[1].color = Color.white;
                grimoire[2].color = Color.white;
                grimoire[3].color = Color.red;
            }
        }
        if (Input.GetMouseButtonDown(0) || Input.GetButtonDown("X"))    // Select
        {
            if (grimSelected == GrimSelected.grim1)
            {
                GrimoireSelected(1);
            }
            if (grimSelected == GrimSelected.grim2)
            {
                GrimoireSelected(2);
            }
            if (grimSelected == GrimSelected.grim3)
            {
                GrimoireSelected(3);
            }
            if (grimSelected == GrimSelected.grim4)
            {
                GrimoireSelected(4);
            }
        }
        if (Input.GetKeyDown(KeyCode.Q) || Input.GetMouseButtonDown(1) || Mathf.Abs(Input.GetAxis("D-Pad Horizontal")) > 0.1f)    // Back
        {
            grimoireSelected.SetActive(false);
            itemsSelected.SetActive(false);
            if (currentlySelected == Selected.attack)
            {
                menu[0].color = Color.red;
                menu[1].color = Color.white;
                menu[2].color = Color.white;
            }
            if (currentlySelected == Selected.grimoire)
            {
                menu[0].color = Color.white;
                menu[1].color = Color.red;
                menu[2].color = Color.white;
            }
            if (currentlySelected == Selected.items)
            {
                menu[0].color = Color.white;
                menu[1].color = Color.white;
                menu[2].color = Color.red;
            }
            foreach (Image m in grimoire)
            {
                m.color = Color.white;
            }
            selected = false;
        }
    }

    void ItemInputs()
    {
        // Input
        if (Input.GetAxis("Mouse ScrollWheel") < 0 || Input.GetAxis("D-Pad Vertical") < -0.1f)    // Down
        {
            if (itemSelected == ItemSelected.mana)    // Menu loops around
            {
                itemSelected = ItemSelected.health;
            }
            else
            {
                itemSelected++;
            }
            // Selected Colors
            if (itemSelected == ItemSelected.health)
            {
                items[0].color = Color.red;
                items[1].color = Color.white;
            }
            if (itemSelected == ItemSelected.mana)
            {
                items[0].color = Color.white;
                items[1].color = Color.red;
            }
        }
        if (Input.GetAxis("Mouse ScrollWheel") > 0 || Input.GetAxis("D-Pad Vertical") > 0.1f)    // Up
        {
            if (itemSelected == ItemSelected.health)   // Menu loops around
            {
                itemSelected = ItemSelected.mana;
            }
            else
            {
                itemSelected--;
            }
            // Selected Colors
            if (itemSelected == ItemSelected.health)
            {
                items[0].color = Color.red;
                items[1].color = Color.white;
            }
            if (itemSelected == ItemSelected.mana)
            {
                items[0].color = Color.white;
                items[1].color = Color.red;
            }
        }
        if (Input.GetMouseButtonDown(0) || Input.GetButtonDown("X"))    // Select
        {
            if (itemSelected == ItemSelected.health)
            {
                ItemsSelected(1);
            }
            if (itemSelected == ItemSelected.mana)
            {
                ItemsSelected(2);
            }

        }
        if (Input.GetKeyDown(KeyCode.Q) || Input.GetMouseButtonDown(1) || Mathf.Abs(Input.GetAxis("D-Pad Horizontal")) > 0.1f)    // Back
        {
            grimoireSelected.SetActive(false);
            itemsSelected.SetActive(false);
            if (currentlySelected == Selected.attack)
            {
                menu[0].color = Color.red;
                menu[1].color = Color.white;
                menu[2].color = Color.white;
            }
            if (currentlySelected == Selected.grimoire)
            {
                menu[0].color = Color.white;
                menu[1].color = Color.red;
                menu[2].color = Color.white;
            }
            if (currentlySelected == Selected.items)
            {
                menu[0].color = Color.white;
                menu[1].color = Color.white;
                menu[2].color = Color.red;
            }
            foreach (Image m in grimoire)
            {
                m.color = Color.white;
            }
            selected = false;
        }
    }

    void AttackSelected()
    {

        //Debug.Log("Attack Selected");
        PlayerGlobals.combatInput.QueueNextCommand(CombatInput.CommandTypes.attack);
    }

    void GrimoireSelected(int g)
    {
        if (g == 1)
        {
            PlayerGlobals.combatInput.QueueNextCommand(CombatInput.CommandTypes.spell1);
            //Debug.Log("Grimoire Attack 1");
        }
        if (g == 2)
        {
            PlayerGlobals.combatInput.QueueNextCommand(CombatInput.CommandTypes.spell2);
            //Debug.Log("Grimoire Attack 2");
        }
        if (g == 3)
        {
            PlayerGlobals.combatInput.QueueNextCommand(CombatInput.CommandTypes.spell3);
            //Debug.Log("Grimoire Attack 3");
        }
        if (g == 4)
        {
            PlayerGlobals.combatInput.QueueNextCommand(CombatInput.CommandTypes.spell4);
            //Debug.Log("Grimoire Attack 3");
        }
    }

    void ItemsSelected(int i)
    {
        if (i == 1)
        {
            Debug.Log("Health");
        }
        if (i == 2)
        {
            Debug.Log("Mana");
        }
    }

    void SelectGrimoire()
    {
        grimSelected = GrimSelected.grim1; // fixes grimoire memorizing previous spell
        grimoireSelected.SetActive(true);
        itemsSelected.SetActive(false);
        foreach (Image m in menu)
        {
            m.color = Color.white;
        }
        grimoire[0].color = Color.red;
        grimoire[1].color = Color.white;
        grimoire[2].color = Color.white;
        grimoire[3].color = Color.white;
        selected = true;
    }
}
