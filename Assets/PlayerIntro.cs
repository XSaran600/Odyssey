using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Invector.vCamera;
using DG.Tweening;

public class PlayerIntro : MonoBehaviour
{
    public GameOver blackFader;
    public int playerIntroPhase;
    public float fadeInTime;
    public GameObject commandUI;
    public GameObject commandScript;
    public GameObject healthBar;
    public GameObject aimUI;
    public vThirdPersonCamera vCam;
    
    // Start is called before the first frame update
    void Start()
    {
        vCam.lockCamera = true;
        PlayerGlobals.playerAnim.Play("Standing Up", 7); // Frozen animation until player gets up
        Invoke("GetUp", 2.00f);
    }

    private void Awake()
    {
        //commandUI.SetActive(false);
        //commandScript.SetActive(false);
        for (int i = 0; i < 4; i++) // Each UI child
            commandUI.transform.GetChild(i).position = new Vector3 (commandUI.transform.GetChild(i).position.x + 500f, commandUI.transform.GetChild(i).position.y,  commandUI.transform.GetChild(i).position.z);
        
        healthBar.transform.position = new Vector3 (healthBar.transform.position.x - 500f, healthBar.transform.position.y, healthBar.transform.position.z);

        healthBar.SetActive(false);
        aimUI.SetActive(false);
        blackFader.FadeIn(fadeInTime);  // Fade in from black
    }

    private void GetUp()
    {
        playerIntroPhase++;
        PlayerGlobals.playerAnim.SetFloat("IntroStandingUpSpeed", 1.5f);
        Invoke("GetUpDone", 9.0f);
        //vCam.ChangeState("Intro", false); // POS Invector go back to school and lern 2 code
    
    }

    private void GetUpDone()
    {
        playerIntroPhase += 2;
        PlayerGlobals.invectorInput.SetLockBasicInput(false);
        PlayerGlobals.combatInput.attackingOrCasting = false;

        commandUI.SetActive(true);
        commandScript.SetActive(true);
        healthBar.SetActive(true);
        aimUI.SetActive(true);

        for (int i = 0; i < 4; i++) // Each UI child
            commandUI.transform.GetChild(i).transform.DOMove(new Vector3 (commandUI.transform.GetChild(i).position.x - 500f, commandUI.transform.GetChild(i).position.y,  commandUI.transform.GetChild(i).position.z), 2.0f).SetEase(Ease.OutExpo); //new Vector3 (commandUI.transform.GetChild(i).position.x - 500f, commandUI.transform.GetChild(i).position.y,  commandUI.transform.GetChild(i).position.z);
        
        healthBar.transform.DOMove(new Vector3 (healthBar.transform.position.x + 500f, healthBar.transform.position.y, healthBar.transform.position.z), 2.0f).SetEase(Ease.OutExpo);

        //vCam.ChangeState("Default", true);
        vCam.lockCamera = false;
    }

    // Update is called once per frame
    void Update()
    {
        // Disable player movement in phase 1
        if (playerIntroPhase == 1)
        {
            PlayerGlobals.invectorInput.SetLockBasicInput(true);
            PlayerGlobals.combatInput.attackingOrCasting = true;
        }
    }
}
