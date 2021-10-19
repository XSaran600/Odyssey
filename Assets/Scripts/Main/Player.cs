using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*---------------------------------------------------------------------------------------------------
*-------------------------------------------- Player ------------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* Takes stats from PlayerStats.
* ----------
* How to Use: 
* Attach this script to the player.
* ----------
* Requires:
* [IsCombatable]
*----------------------------------------------------------------------------------------------------*/
public class Player : MonoBehaviour , IsCombatable
{
    public PlayerStats stats;

    // lets add some stats
    //public string playerName;
    //public float hp;
    //public float mp;
    //public float maxHP;
    //public float maxMP;
    //public int power;
    //public int level;
    //public float exp;
    //public Vector3 position;
    //public int hpPotCount;
    //public int mpPotCount;

    // is he dead?
    public bool isAlive;
    public Rigidbody weaponHitbox;

    /// Get health
    float IsCombatable.GetHealth()
    {
        return stats.hp;
    }

    float IsCombatable.GetMaxHP()
    {
        return stats.maxHP;
    }

    // Is physically damageable (once per hit)
    public bool IsPhysicalDamageable()
    {
        return stats.isPhysicalDamageable;
    }

    public void SetPhysicalDamageable(bool isDamageable)
    {
        stats.isPhysicalDamageable = isDamageable;
    }

    /// combat functions
    public void TakePhysicalDamage(float damage)
    {
        //Debug.Log("Attacked");
        stats.hp -= damage;
        
        if (stats.hp < 0.405f)
        {
            stats.hp = 0;
            isAlive = false;

            TimeManager.SlowMotion(0.33f, 6.0f, 0.2f); // Slow to 1/3 speed

            PlayerGlobals.player.GetComponent<Animator>().SetBool("Dead", true);    // Play dead animation
            PlayerGlobals.invectorInput.SetLockBasicInput(true);                    // Lock motion

            PlayerGlobals.playerExplodeFX.SetActive(true);  // Play black explosion
            PlayerGlobals.playerExplodeFX.transform.SetParent(null, true); // Un-parent
            Destroy(PlayerGlobals.playerExplodeFX, 2.0f);  // Destroy black explosion

            Invoke("RemovePlayerMesh", 0.5f);   // Remove player mesh and weapon childed to armature
            Invoke("FadeBlack", 0.75f);
            Invoke("EndGameMenu", 2.25f);
        }
    }

    // Remove player mesh and armature (weapon)
    private void RemovePlayerMesh()
    {
        PlayerGlobals.playerMesh.SetActive(false);
        PlayerGlobals.playerArmature.SetActive(false);

        PlayerGlobals.explodeSmokePrefab.SetActive(true);  // Play red smoke explosion
        PlayerGlobals.explodeSmokePrefab.transform.SetParent(null, true); // Un-parent
        Destroy(PlayerGlobals.explodeSmokePrefab, 1.00f);  // Destroy
    }

    private void FadeBlack()
    {
        PlayerGlobals.gameInitObject.GetComponent<GameOver>().FadeBlack(1.25f);
    }

    private void EndGameMenu()
    {
        PlayerGlobals.gameInitObject.GetComponent<GameOver>().FadeInGameOver(4.0f);
    }

    public void TakeMagicDamage(float damage, int type = 0)
    {
        stats.hp -= damage;

        if (stats.hp < 1)
        {
            stats.hp = 0;
            isAlive = false;
        }
    }

    // Reset state
    public void ResetStats()
    {
        stats.hp = stats.maxHP;
        stats.mp = stats.maxMP;
        isAlive = true;
    }



    // Update is called once per frame
    void Update()
    {
    }




}
