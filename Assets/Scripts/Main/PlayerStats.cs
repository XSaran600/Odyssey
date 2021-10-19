using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*---------------------------------------------------------------------------------------------------
*----------------------------------------- Player Stats ---------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* Stores player stats on the player.
* ----------
* How to Use: 
* Attach script to player object.
*----------------------------------------------------------------------------------------------------*/
[System.Serializable]
public class PlayerStats {

    public string   playerName;
    public float    hp;
    public float    mp;
    public float    maxHP;
    public float    maxMP;
    public int      power;
    public int      level;
    public float    exp;
    public Vector3  position;
    public int      hpPotCount;
    public int      mpPotCount;
    public bool     isPhysicalDamageable;

    public PlayerStats(string playerName, float hp, float mp, float maxHP, float maxMP, int power, int level, float exp, Vector3 position, int hpPotCount, int mpPotCount) {
        this.playerName = playerName;
        this.hp         = hp;
        this.mp         = mp;
        this.maxHP      = maxHP;
        this.maxMP      = maxMP;
        this.power      = power;
        this.level      = level;
        this.exp        = exp;
        this.position   = position;
        this.hpPotCount = hpPotCount;
        this.mpPotCount = mpPotCount;
    }

    public PlayerStats(SaveLoad source) {
        this.playerName = source.playerName;
        this.hp         = source.hp;
        this.mp         = source.mp;
        this.maxHP      = source.maxHP;
        this.maxMP      = source.maxMP;
        this.power      = source.power;
        this.level      = source.level;
        this.exp        = source.exp;
        this.position   = source.position;
        this.hpPotCount = source.hpPotCount;
        this.mpPotCount = source.mpPotCount;
    }
}