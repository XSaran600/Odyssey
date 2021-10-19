using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Odyssey.Combat;

/*---------------------------------------------------------------------------------------------------
*----------------------------------------- Health Bar ---------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* Enemy Health bar
* ----------
* How to Use: 
* Attach to health bar
*----------------------------------------------------------------------------------------------------*/
public class HealthBar : MonoBehaviour
{
	public enum Owner { _enemy, _player };
	public Owner owner;
	public Slider slider;
	public Gradient gradient;
	public Image fill;
	public float maxHealth = 100.0f;
	public float health = 100.0f;
    public bool isDead = false;
	[Tooltip("Set to true to treat as mana bar instead.")] public bool manaBar;

    private Animator animator = null;
	[SerializeField]
	private CombatCore combat;
	[SerializeField]
	private GameObject player;

	public GameObject lockedOnEnemy;

    private void Awake() {
        animator = transform.GetComponent<Animator>();
		slider.maxValue = maxHealth;
		player = GameObject.FindGameObjectWithTag("Player");
		combat = player.GetComponent<CombatCore>();
	}

	private void Update()
	{
		if (owner == Owner._enemy)
		{
			// Set HP and Max HP to locked on target
			if (combat.screenTargets.Count > 0)
			{
				transform.GetChild(0).gameObject.SetActive(true); // Show HP Bar
				transform.GetChild(1).gameObject.SetActive(true); // Show HP Bar
				IsCombatable hittable = combat.screenTargets[combat.targetIndex()].transform.root.gameObject.GetComponent<IsCombatable>();
				lockedOnEnemy = combat.screenTargets[combat.targetIndex()].transform.root.gameObject;
				if (hittable.GetHealth() > 0)
					slider.value = hittable.GetHealth();
				else
					slider.value = 0f;
				slider.maxValue = hittable.GetMaxHP();
				//fill.color = gradient.Evaluate(1f); // If max health changing
				fill.color = gradient.Evaluate(slider.normalizedValue);
				health = slider.value;
			}
			else
			{
				transform.GetChild(0).gameObject.SetActive(false); // Hide HP Bar
				transform.GetChild(1).gameObject.SetActive(false); // Hide HP Bar
			}
		} 
		else
		{
			if (manaBar)
			{ // MANA BAR
				if (player.GetComponent<Player>().stats.mp > 0)
					slider.value = player.GetComponent<Player>().stats.mp;
				else
					slider.value = 0f;
				slider.maxValue = player.GetComponent<Player>().stats.maxMP;
				fill.color = gradient.Evaluate(slider.normalizedValue);
				health = slider.value;
			} else { // HP BAR
				IsCombatable hittable = player.GetComponent<IsCombatable>();
				if (hittable.GetHealth() > 0)
					slider.value = hittable.GetHealth();
				else
					slider.value = 0f;
				slider.maxValue = hittable.GetMaxHP();
				fill.color = gradient.Evaluate(slider.normalizedValue);
				health = slider.value;
			}
		}
	}

	public void SetMaxHealth(float health)
	{
		slider.maxValue = health;
		slider.value = health;

		fill.color = gradient.Evaluate(1f);
	}

    public void SetHealth(float health)
	{
		slider.value = health;
		fill.color = gradient.Evaluate(slider.normalizedValue);
	}

}