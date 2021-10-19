using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PauseMenuDisplayPlayerStats : MonoBehaviour
{
    public Text lvl;
    public Text nextLvl;
    public Text hp;
    public Text mp;
    public Text str;
    public Text mag;
    public Text def;

    private void Update() 
    {
        if (Input.GetKeyDown(KeyCode.I) || Input.GetKeyDown(KeyCode.Joystick1Button6))
            UpdatePlayerStats();
    }

    public void UpdatePlayerStats() 
    {
        lvl.text    = PlayerGlobals.player.GetComponent<Player>().stats.level.ToString();
        hp.text     = PlayerGlobals.player.GetComponent<Player>().stats.hp.ToString() + "/" + PlayerGlobals.player.GetComponent<Player>().stats.maxHP.ToString();
        mp.text     = PlayerGlobals.player.GetComponent<Player>().stats.mp.ToString() + "/" + PlayerGlobals.player.GetComponent<Player>().stats.maxMP.ToString();
    }
}
