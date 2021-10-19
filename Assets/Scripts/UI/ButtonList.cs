using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ButtonList : MonoBehaviour
{
    public Button abilWeaponHeader;
    public Button abilMobilHeader;

    public List<Button> abilityWeapon;
    public List<Button> abilityMobility;

    public bool weaponAbilActive;
    public bool mobilAbilActive;

    public float lerpSpeed;
    public Vector3 buttonSpacing;
    private float lerpStep;

    private float timePassed;
    private bool moveButtons;

    private int playerWepAbilCount;
    private int playerMobilAbilCount;


    public bool disableMouse;
    [Header("normal = available, Selected = inUse, Disabled = notAvailable")]
    public ColorBlock activeColors;

    public Text abilPoints;

    public void ResetWeapArrayPos()
    {
        for (int i = 0; i < abilityWeapon.Count; i++)
            abilityWeapon[i].transform.position = abilWeaponHeader.transform.position;
    }
    public void ResetMobilArrayPos()
    {
        for (int i = 0; i < abilityMobility.Count; i++)
            abilityMobility[i].transform.position = abilMobilHeader.transform.position;
    }
    public void MoveWeapAbilList()
    {
        for (int i = 0; i < abilityWeapon.Count; i++)
            abilityWeapon[i].transform.position = new Vector3(Mathf.Lerp(abilWeaponHeader.transform.position.x, abilWeaponHeader.transform.position.x + buttonSpacing.x * (i + 1), lerpStep),
                Mathf.Lerp(abilWeaponHeader.transform.position.y, abilWeaponHeader.transform.position.y + buttonSpacing.y * (i + 1), lerpStep),
                0);
    }
    public void MoveMobilAbilList()
    {
        for (int i = 0; i < abilityMobility.Count; i++)
            abilityMobility[i].transform.position = new Vector3( Mathf.Lerp(abilMobilHeader.transform.position.x, abilMobilHeader.transform.position.x + buttonSpacing.x * (i + 1), lerpStep),
                Mathf.Lerp(abilMobilHeader.transform.position.y, abilMobilHeader.transform.position.y + buttonSpacing.y * (i + 1), lerpStep),
                0);
    }
    public void MoveButtons()
    {
        moveButtons = true;
    }
    public void EnableAttackHeader()
    {
        weaponAbilActive = true;
        mobilAbilActive = false;
        moveButtons = true;
        lerpStep = 0;
        timePassed = 0;
        ResetWeapArrayPos();
        ResetMobilArrayPos();
        foreach (Transform child in abilWeaponHeader.transform)
        {
            if (child != abilWeaponHeader.transform.GetChild(0))
                child.gameObject.SetActive(true);
        }
        foreach (Transform child in abilMobilHeader.transform)
        {
            if (child != abilMobilHeader.transform.GetChild(0))
                child.gameObject.SetActive(false);
        }
        CheckWepButtonsAvailable();
    }
    public void EnableMobilityHeader()
    {
        weaponAbilActive = false;
        mobilAbilActive = true;
        moveButtons = true;
        lerpStep = 0;
        timePassed = 0;
        ResetWeapArrayPos();
        ResetMobilArrayPos();
        foreach (Transform child in abilWeaponHeader.transform)
        {
            if (child != abilWeaponHeader.transform.GetChild(0))
                child.gameObject.SetActive(false);
        }
        foreach (Transform child in abilMobilHeader.transform)
        {
            if (child != abilMobilHeader.transform.GetChild(0))
                child.gameObject.SetActive(true);
        }
        CheckMobButtonsAvailable();
    }
    public void ToggleMouseLock()
    {
        if (Cursor.lockState != CursorLockMode.None)
        {
            Cursor.lockState = CursorLockMode.None;
            Cursor.visible = true;
        }
        else
        {
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
        }
    }

    public void GetAbilityNames()
    {
        for (int i = 0; i < playerWepAbilCount; i++)
        {
            abilityWeapon[i].GetComponentInChildren<Text>().text = PlayerGlobals.player.GetComponent<AbilityManager>().weaponAbility[i].attackInfo.attackAnimationName;
        }

        for (int i = 0; i < playerMobilAbilCount; i++)
        {
            abilityMobility[i].GetComponentInChildren<Text>().text = PlayerGlobals.player.GetComponent<AbilityManager>().mobilityAbility[i].attackInfo.attackAnimationName;
        }
    }

    private void Start()
    {
        playerWepAbilCount = PlayerGlobals.player.GetComponent<AbilityManager>().weaponAbility.Count;
        playerMobilAbilCount = PlayerGlobals.player.GetComponent<AbilityManager>().mobilityAbility.Count;

        if (playerWepAbilCount != abilityWeapon.Count)
        {
            Debug.LogError(playerWepAbilCount + " player wep abil != " + abilityWeapon.Count + " Errors may occur, Says Nathan");
        }
        else if (playerMobilAbilCount != abilityMobility.Count)
        {
            Debug.LogError(playerMobilAbilCount + " player mobil abil != " + abilityMobility.Count + " Errors may occur, Says Nathan");
        }
        else
        {
            GetAbilityNames();
        }

    }

    public void CheckWepButtonsAvailable()
    {
        bool[] wepAbilAvail = PlayerGlobals.player.GetComponent<AbilityManager>().GetWeaponAbilitiesAvailable();
        for(int i = 0; i < wepAbilAvail.Length; i++)
        {
            ColorBlock cb = abilityWeapon[i].colors;
            if (wepAbilAvail[i])
            {
                cb.normalColor = new Color(activeColors.normalColor.r, activeColors.normalColor.g, activeColors.normalColor.b, activeColors.normalColor.a);
                abilityWeapon[i].colors = cb;
            }
            else if (PlayerGlobals.player.GetComponent<AbilityManager>().weaponAbility[i].inUse)
            {
                cb.normalColor = new Color(activeColors.selectedColor.r, activeColors.selectedColor.g, activeColors.selectedColor.b, activeColors.selectedColor.a);
                abilityWeapon[i].colors = cb;
            }
            else
            {
                cb.normalColor = new Color(activeColors.disabledColor.r, activeColors.disabledColor.g, activeColors.disabledColor.b, activeColors.disabledColor.a);
                abilityWeapon[i].colors = cb;
            }
        }
    }
    public void CheckMobButtonsAvailable()
    {
        bool[] mobAbilAvail = PlayerGlobals.player.GetComponent<AbilityManager>().GetMobilityAbilitiesAvailable();
        for (int i = 0; i < mobAbilAvail.Length; i++)
        {
            ColorBlock cb = abilityWeapon[i].colors;
            if (mobAbilAvail[i])
            {
                cb.normalColor = new Color(activeColors.normalColor.r, activeColors.normalColor.g, activeColors.normalColor.b, activeColors.normalColor.a);
                abilityWeapon[i].colors = cb;
            }
            else if (PlayerGlobals.player.GetComponent<AbilityManager>().mobilityAbility[i].inUse)
            {
                cb.normalColor = new Color(activeColors.selectedColor.r, activeColors.selectedColor.g, activeColors.selectedColor.b, activeColors.selectedColor.a);
                abilityWeapon[i].colors = cb;
            }
            else
            {
                cb.normalColor = new Color(activeColors.disabledColor.r, activeColors.disabledColor.g, activeColors.disabledColor.b, activeColors.disabledColor.a);
                abilityWeapon[i].colors = cb;
            }
        }
    }

    public void ToggleAbilityWep(int i = 0)
    {
        PlayerGlobals.player.GetComponent<AbilityManager>().ToggleWeaponAbility(i);
        CheckWepButtonsAvailable();
        CheckMobButtonsAvailable();
        UpdatePointsText();
    }
    public void ToggleAbilityMob(int i = 0)
    {
        PlayerGlobals.player.GetComponent<AbilityManager>().ToggleMobilityAbility(i);
        CheckWepButtonsAvailable();
        CheckMobButtonsAvailable();
        UpdatePointsText();
    }

    public void UpdatePointsText()
    {
       abilPoints.text = "Ability Points " + PlayerGlobals.player.GetComponent<AbilityManager>().pointsAvailable.ToString();
    }

    private void Update()
    {
        if (moveButtons && lerpStep <= 1)
        {
            timePassed = timePassed + Time.deltaTime;
            lerpStep = Mathf.Min(1, lerpStep + lerpSpeed * timePassed);
        }

        if (weaponAbilActive && lerpStep <= 1)
        {
            MoveWeapAbilList();
        }
        else if (mobilAbilActive && lerpStep <= 1)
        {
            MoveMobilAbilList();
        }
        if (lerpStep >= 1)
        {
            moveButtons = false;
        }

        if (Input.GetKeyDown(KeyCode.O))
            ToggleMouseLock();
    }
}
