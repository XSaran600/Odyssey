using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Odyssey.Projectiles;
using MoreMountains.Tools;
using UnityEngine.EventSystems;
using Invector.vCharacterController;

namespace MoreMountains.InventoryEngine // For the luls
{
    public class Grimoire : MonoBehaviour
    {
        // VARIABLES
        // ------------------------------------------------------------------------
        [Header("MAP ALL SPELLS HERE TO THEIR ITEMID")]
        public SpellStats[] fullSpellList = new SpellStats[4];
        public SpellStats[] equippedSpells = new SpellStats[4];
        private static bool buffOnCooldown;

        [Header("MAP INVENTORIES")]
        public InventoryInputManager inventoryInputManager;
        public Inventory spellInventory;

        [HideInInspector]
        public int currentSpellCastIndex;

        [HideInInspector]
        public int currentInventoryOpenStatus;
        
        [HideInInspector]
        public int previousSpellIndex;          // Check for change in spell equipment
        
        [HideInInspector]
        public int previousInventoryOpenStatus; // Check for change in inventory toggling (to change player camera by toggling crouch)

        [HideInInspector]
        public AbilityManager playerAM;

        public GameObject[] grimoireUITexts;    // Update spell names in command UI
        public GameObject[] grimoireUIIcons;    // Update spell icons in command UI

        public AudioSource errorSoundSource;
        // ------------------------------------------------------------------------


        // INIT
        // ------------------------------------------------------------------------        
        public void Awake()
        {
            Invoke("Initt", 0.6f);
        }

        private void Initt()
        {
            if (PlayerGlobals.player.TryGetComponent(out AbilityManager atks))
                playerAM = atks;      
        }
        // ------------------------------------------------------------------------


        // LOOP
        // ------------------------------------------------------------------------ 
        void Update()
        {
            if (currentInventoryOpenStatus % 2 == 1)
            {
                // Disable player movement
                PlayerGlobals.combatInput.attackingOrCasting = true;
                PlayerGlobals.charController.isCrouching = true;
            }

            currentInventoryOpenStatus = inventoryInputManager.inventoryToggled;
            if (currentInventoryOpenStatus != previousInventoryOpenStatus)
            {
                if (currentInventoryOpenStatus % 2 == 0)
                {
                    // Enable player movement
                    PlayerGlobals.combatInput.attackingOrCasting = false;
                    PlayerGlobals.charController.isCrouching = false;
                }
                previousInventoryOpenStatus = currentInventoryOpenStatus;
            }

            currentSpellCastIndex = inventoryInputManager.equippedSpellCurrentIndex;
            if (currentSpellCastIndex != previousSpellIndex)
            {
                for (int i = 0; i < 4; i++)
                {
                    bool spellFound = false;
                    InventoryItem item = spellInventory.Content[i];
                    for (int j = 1; j < fullSpellList.Length; j++)
                    {
                        string s = string.Concat("spell_0", j); // Equippable Spell must have Item ID: spell_XX
                        string ss = string.Concat("spell_", j);
                        if (InventoryItem.GetItemID(item).Equals(s) || InventoryItem.GetItemID(item).Equals(ss))
                        {
                            equippedSpells[i] = fullSpellList[j-1];
                            spellFound = true;
                        }
                    }
                    if (!spellFound)
                        equippedSpells[i] = null;

                    if (grimoireUITexts[i] != null && equippedSpells[i] != null)
                        grimoireUITexts[i].GetComponent<Text>().text = equippedSpells[i].SpellName;
                    else if (currentInventoryOpenStatus > 0)
                        Debug.LogError("Player Grimoire UI Texts not mapped. Map 'Grimoire 1 Text', 'Grimoire 2 Text', 'Grimoire 3 Text'.");

                    if (grimoireUIIcons[i] != null && equippedSpells[i] != null)
                        grimoireUIIcons[i].GetComponent<Image>().sprite = equippedSpells[i].SpellIcon;
                    else if (currentInventoryOpenStatus > 0)
                        Debug.LogError("Player Grimoire Circle UI icons not mapped. Map 'Grimoire 1 Circle Spell Icon', 'Grimoire 2 Circle Spell Icon', 'Grimoire 3 Circle Spell Icon'.");
                }

                previousSpellIndex = currentSpellCastIndex;
            }
        }
        // ------------------------------------------------------------------------


        // ALL TYPES OF SPELL OUTCOME/ACTION HANDLING
        // ------------------------------------------------------------------------ 
        public void CastSpell(int index)
        {
            //Debug.Log("Fetching speed: " + equippedSpells[index].speed);

            // PROJECTILE

            if ( equippedSpells[index] != null && PlayerGlobals.player.GetComponent<Player>().stats.mp >= equippedSpells[index].manaCost)
            {
                
                if ( equippedSpells[index].isSpellProjectile )
                {
                    if ( PlayerGlobals.combat.targetObject != null )
                    {
                        // Mana cost
                        PlayerGlobals.player.GetComponent<Player>().stats.mp -= equippedSpells[index].manaCost;

                        // Rotate player to target
                        var rotationAngle = Quaternion.LookRotation ( PlayerGlobals.combat.targetObject.transform.position - PlayerGlobals.player.transform.position);    // We get the angle has to be rotated
                        rotationAngle.x = 0; // Fix rotation angle
                        rotationAngle.z = 0; // Fix rotation angle
                        PlayerGlobals.player.transform.rotation = rotationAngle;

                        // LOCK PLAYER INPUT WHILE CASTING
                        PlayerGlobals.combatInput.SpellLockInputs(index); 

                        // CREATE PROJECTILE
                        if (equippedSpells[index].multipleProjectiles == false && equippedSpells[index].projSpawnDelay == 0)
                        {
                            // No spawn delay, no extra rotation, no projectile offset
                            if ((equippedSpells[index].projectileRotation.x == 0 && equippedSpells[index].projectileRotation.y == 0 && equippedSpells[index].projectileRotation.z == 0) && (equippedSpells[index].projectileOffset.x == 0 && equippedSpells[index].projectileOffset.y == 0 && equippedSpells[index].projectileOffset.z == 0))
                                ProjectileCore.CreateNonHomingProjectilePlayerToTarget(equippedSpells[index].speed, equippedSpells[index].projectileModel, equippedSpells[index].projectileImpact);
                            // No spawn delay, No extra rotation, yes projectile offset
                            else if ((equippedSpells[index].projectileRotation.x == 0 && equippedSpells[index].projectileRotation.y == 0 && equippedSpells[index].projectileRotation.z == 0) && (equippedSpells[index].projectileOffset.x != 0 || equippedSpells[index].projectileOffset.y != 0 || equippedSpells[index].projectileOffset.z != 0))
                                ProjectileCore.CreateNonHomingProjectilePlayerToTargetOffset(equippedSpells[index].speed, equippedSpells[index].projectileModel, equippedSpells[index].projectileImpact, equippedSpells[index].projectileOffset);
                            // No spawn delay, Yes extra rotation, yes projectile offset
                            else if ((equippedSpells[index].projectileRotation.x != 0 || equippedSpells[index].projectileRotation.y != 0 || equippedSpells[index].projectileRotation.z != 0) && (equippedSpells[index].projectileOffset.x != 0 || equippedSpells[index].projectileOffset.y != 0 || equippedSpells[index].projectileOffset.z != 0))
                                ProjectileCore.CreateNonHomingProjectilePlayerToTargetOffset(equippedSpells[index].speed, equippedSpells[index].projectileModel, equippedSpells[index].projectileImpact, equippedSpells[index].projectileRotation, equippedSpells[index].projectileOffset);
                            // No spawn delay, Yes extra rotation, no projectile offset
                            else 
                                ProjectileCore.CreateNonHomingProjectilePlayerToTarget(equippedSpells[index].speed, equippedSpells[index].projectileModel, equippedSpells[index].projectileImpact, equippedSpells[index].projectileRotation);
                        } else if (equippedSpells[index].multipleProjectiles == false) // Spawn with delay
                        {
                            // Yes extra spawn delay, no extra rotation, no projectile offset
                            if ((equippedSpells[index].projectileRotation.x == 0 && equippedSpells[index].projectileRotation.y == 0 && equippedSpells[index].projectileRotation.z == 0) && (equippedSpells[index].projectileOffset.x == 0 && equippedSpells[index].projectileOffset.y == 0 && equippedSpells[index].projectileOffset.z == 0))
                                StartCoroutine(DelayedProjectileSpawn(equippedSpells[index].speed, equippedSpells[index].projectileModel, equippedSpells[index].projectileImpact, equippedSpells[index].projSpawnDelay));
                            // Yes extra spawn delay, yes extra rotation, no projectile offset
                            else if ((equippedSpells[index].projectileRotation.x != 0 || equippedSpells[index].projectileRotation.y != 0 || equippedSpells[index].projectileRotation.z != 0) && (equippedSpells[index].projectileOffset.x == 0 && equippedSpells[index].projectileOffset.y == 0 && equippedSpells[index].projectileOffset.z == 0))
                                StartCoroutine(DelayedProjectileSpawn(equippedSpells[index].speed, equippedSpells[index].projectileModel, equippedSpells[index].projectileImpact, equippedSpells[index].projectileRotation, equippedSpells[index].projSpawnDelay));
                            // Yes extra spawn delay, no extra rotation, yes projectile offset
                            else if ((equippedSpells[index].projectileRotation.x != 0 || equippedSpells[index].projectileRotation.y != 0 || equippedSpells[index].projectileRotation.z != 0) && (equippedSpells[index].projectileOffset.x == 0 && equippedSpells[index].projectileOffset.y == 0 && equippedSpells[index].projectileOffset.z == 0))
                                StartCoroutine(DelayedProjectileSpawnOffset(equippedSpells[index].speed, equippedSpells[index].projectileModel, equippedSpells[index].projectileImpact, equippedSpells[index].projectileOffset, equippedSpells[index].projSpawnDelay));
                            // Yes extra spawn delay, yes extra rotation, yes projectile offset
                            else 
                                StartCoroutine(DelayedProjectileSpawnOffset(equippedSpells[index].speed, equippedSpells[index].projectileModel, equippedSpells[index].projectileImpact, equippedSpells[index].projectileRotation, equippedSpells[index].projectileOffset, equippedSpells[index].projSpawnDelay));
                        }

                        // CREATE MUTIPLE PROJECTILES
                        if (equippedSpells[index].multipleProjectiles)
                        {
                            StartCoroutine(DelayedProjectileSpawnMultiple(equippedSpells[index].speed, equippedSpells[index].projectileModel, equippedSpells[index].projectileImpact, equippedSpells[index].projectileRotation, equippedSpells[index].projectileOffset, equippedSpells[index].projSpawnDelay, equippedSpells[index].projectileCount, equippedSpells[index].projectileInterval, equippedSpells[index].projectileArc));
                        }

                        // PLACE ON COOLDOWN
                        PlayerGlobals.combatInput.Invoke("CastCooldown", equippedSpells[index].castTime);
                    
                        // ANIMATION ON PLAYER
                        if ( equippedSpells[index].extraVisual && equippedSpells[index].playerAnimationStringName != null )
                        {
                            PlayerGlobals.playerAnim.SetFloat(equippedSpells[index].playerAnimationSpeedMultiplierParameterStringName, equippedSpells[index].playerAnimationSpeedMultiplier);
                            PlayerGlobals.playerAnim.Play(equippedSpells[index].playerAnimationStringName, 7);
                        }

                        // EXTRA VISUAL ON PLAYER
                        if ( equippedSpells[index].extraVisual && equippedSpells[index].sfxOnPlayer != null )
                        {
                            Quaternion qRot = Quaternion.Euler(equippedSpells[index].sfxRotation);
                            GameObject xtraFX;

                            if (qRot.x != 0 || qRot.y != 0 || qRot.z != 0)
                                xtraFX = Instantiate(equippedSpells[index].sfxOnPlayer, PlayerGlobals.player.transform.position + new Vector3(0f,0.05f,0f), qRot);
                            else
                                xtraFX = Instantiate(equippedSpells[index].sfxOnPlayer, PlayerGlobals.player.transform.transform);

                            Destroy(xtraFX, equippedSpells[index].sfxDuration);
                        }
                    }

                // AOE
                } else if ( equippedSpells[index].extraVisual && equippedSpells[index].isSpellInstantAOE ) {

                    // Mana cost
                    PlayerGlobals.player.GetComponent<Player>().stats.mp -= equippedSpells[index].manaCost;

                    // Rotate player to target
                    var rotationAngle = Quaternion.LookRotation ( PlayerGlobals.combat.targetObject.transform.position - PlayerGlobals.player.transform.position);    // We get the angle has to be rotated
                    rotationAngle.x = 0; // Fix rotation angle
                    rotationAngle.z = 0; // Fix rotation angle
                    PlayerGlobals.player.transform.rotation = rotationAngle;

                    // LOCK PLAYER INPUT WHILE CASTING
                    PlayerGlobals.combatInput.SpellLockInputs(index); 

                    PlayerGlobals.combatInput.Invoke("CastCooldown", equippedSpells[index].castTime);
                
                    // ANIMATION ON PLAYER
                    if ( equippedSpells[index].playerAnimationStringName != null )
                    {
                        PlayerGlobals.playerAnim.SetFloat(equippedSpells[index].playerAnimationSpeedMultiplierParameterStringName, equippedSpells[index].playerAnimationSpeedMultiplier);
                        PlayerGlobals.playerAnim.Play(equippedSpells[index].playerAnimationStringName, 7);
                    }
                    
                    // EXTRA VISUAL ON PLAYER
                    if ( equippedSpells[index].extraVisual && equippedSpells[index].sfxOnPlayer != null )
                    {
                        Quaternion qRot = Quaternion.Euler(equippedSpells[index].sfxRotation);
                        GameObject xtraFX;

                        if (qRot.x != 0 || qRot.y != 0 || qRot.z != 0)
                            xtraFX = Instantiate(equippedSpells[index].sfxOnPlayer, PlayerGlobals.player.transform.position + new Vector3(0f,0.05f,0f), qRot);
                        else
                            xtraFX = Instantiate(equippedSpells[index].sfxOnPlayer, PlayerGlobals.player.transform.transform);

                        Destroy(xtraFX, equippedSpells[index].sfxDuration);
                    }

                        if ( equippedSpells[index].originIsPlayer )
                            PlayerGlobals.combat.ApplyAOEAttack(PlayerGlobals.player.transform, equippedSpells[index].radius, equippedSpells[index].power, equippedSpells[index].knockbackForce, equippedSpells[index].sfxAoEImpact, 1.5f);
                        else if ( equippedSpells[index].originIsEnemy )
                            PlayerGlobals.combat.ApplyAOEAttack(PlayerGlobals.combat.targetObject.transform, equippedSpells[index].radius, equippedSpells[index].power, equippedSpells[index].knockbackForce, equippedSpells[index].sfxAoEImpact, 1.5f);

                // ATK SPD BUFF
                } else if ( equippedSpells[index].isBuff  && !equippedSpells[index].healSingle) {

                    if ( !buffOnCooldown )
                    {
                        // Mana cost
                        PlayerGlobals.player.GetComponent<Player>().stats.mp -= equippedSpells[index].manaCost;

                        // LOCK PLAYER INPUT WHILE CASTING
                        PlayerGlobals.combatInput.SpellLockInputs(index); 

                        buffOnCooldown = true;

                        // PLACE ON COOLDOWN
                        PlayerGlobals.combatInput.Invoke("CastCooldown", equippedSpells[index].castTime);
                        
                        // ATK SPD BUFF ( DO FOR ALL WEAPONS IN FUTURE )
                        if ( equippedSpells[index].atkSpeedBuff)
                        {
                            for (int i = 0; i < playerAM.playerCombo.Count; i++)
                            {
                                playerAM.playerCombo[i].animationSpeedMultiplier = playerAM.playerCombo[i].defaultAttackSpeedMultiplier;
                                playerAM.playerCombo[i].animationSpeedMultiplier *= equippedSpells[index].atkSpeedModifier;
                            }

                        // EXTRA VISUAL ON PLAYER
                        if ( equippedSpells[index].extraVisual && equippedSpells[index].sfxOnPlayer != null )
                        {
                            Quaternion qRot = Quaternion.Euler(equippedSpells[index].sfxRotation);
                            GameObject xtraFX;

                            if (qRot.x != 0 || qRot.y != 0 || qRot.z != 0)
                                xtraFX = Instantiate(equippedSpells[index].sfxOnPlayer, PlayerGlobals.player.transform.position + new Vector3(0f,0.05f,0f), qRot);
                            else
                                xtraFX = Instantiate(equippedSpells[index].sfxOnPlayer, PlayerGlobals.player.transform.transform);

                            Destroy(xtraFX, equippedSpells[index].sfxDuration);
                        }

                        // ANIMATION ON PLAYER
                        if ( equippedSpells[index].playerAnimationStringName != null )
                        {
                            PlayerGlobals.playerAnim.SetFloat(equippedSpells[index].playerAnimationSpeedMultiplierParameterStringName, equippedSpells[index].playerAnimationSpeedMultiplier);
                            PlayerGlobals.playerAnim.Play(equippedSpells[index].playerAnimationStringName, 7);
                        }
                            
                            GameObject visualFXAttachment = Instantiate(equippedSpells[index].buffFX);
                            visualFXAttachment.transform.SetParent(PlayerGlobals.player.transform, false);
                            Destroy(visualFXAttachment, equippedSpells[index].buffDuration);

                            StartCoroutine(ResetAtkSpdBuff(equippedSpells[index].buffDuration, index));
                        }                        
                    }
                // SINGLE HEAL
                } else if ( equippedSpells[index].isBuff  && equippedSpells[index].healSingle) 
                {
                    // Mana cost
                    PlayerGlobals.player.GetComponent<Player>().stats.mp -= equippedSpells[index].manaCost;

                    // LOCK PLAYER INPUT WHILE CASTING
                    PlayerGlobals.combatInput.SpellLockInputs(index); 

                    // PLACE ON COOLDOWN
                    PlayerGlobals.combatInput.Invoke("CastCooldown", equippedSpells[index].castTime);

                    // ANIMATION ON PLAYER
                    if ( equippedSpells[index].extraVisual && equippedSpells[index].playerAnimationStringName != null )
                    {
                        PlayerGlobals.playerAnim.SetFloat(equippedSpells[index].playerAnimationSpeedMultiplierParameterStringName, equippedSpells[index].playerAnimationSpeedMultiplier);
                        PlayerGlobals.playerAnim.Play(equippedSpells[index].playerAnimationStringName, 7);
                    }

                    // EXTRA VISUAL ON PLAYER
                    if ( equippedSpells[index].extraVisual && equippedSpells[index].sfxOnPlayer != null )
                    {
                        Quaternion qRot = Quaternion.Euler(equippedSpells[index].sfxRotation);
                        GameObject xtraFX;

                        if (qRot.x != 0 || qRot.y != 0 || qRot.z != 0)
                            xtraFX = Instantiate(equippedSpells[index].sfxOnPlayer, PlayerGlobals.player.transform.position + new Vector3(0f,0.05f,0f), qRot);
                        else
                            xtraFX = Instantiate(equippedSpells[index].sfxOnPlayer, PlayerGlobals.player.transform.transform);

                        Destroy(xtraFX, equippedSpells[index].sfxDuration);
                    }

                    // HEAL
                    PlayerGlobals.player.GetComponent<Player>().stats.hp += equippedSpells[index].healSingleAmount;
                }
                
                // SLOW MOTION
                if ( equippedSpells[index].extraVisual && equippedSpells[index].slowMotionEffect == true )
                    TimeManager.SlowMotion(0.04f, 0.5f, 0.04f); // [TEST] Slow motion test!
            } else // Play error audio (not enough mana or spell not equipped)
            {
                errorSoundSource.Play();
            }
        }
        // ------------------------------------------------------------------------


        // DELAYED SPELL ACTIONS
        // ------------------------------------------------------------------------
        IEnumerator ResetAtkSpdBuff(float delayTime, int index)
        {
            yield return new WaitForSeconds(delayTime);
            for (int i = 0; i < playerAM.playerCombo.Count; i++)
            {
                playerAM.playerCombo[i].animationSpeedMultiplier = playerAM.playerCombo[i].defaultAttackSpeedMultiplier;
            }
            
        }

        // Delayed projectile activation
        IEnumerator DelayedProjectileSpawn(float speed, GameObject fxProjPrefab, GameObject fxImpactPrefab, float delayTime)
        {
            yield return new WaitForSeconds(delayTime);
            ProjectileCore.CreateNonHomingProjectilePlayerToTarget(speed, fxProjPrefab, fxImpactPrefab);
        }

        // Overload rotation
        IEnumerator DelayedProjectileSpawn(float speed, GameObject fxProjPrefab, GameObject fxImpactPrefab, Vector3 rotationOffset, float delayTime)
        {
            yield return new WaitForSeconds(delayTime);
            ProjectileCore.CreateNonHomingProjectilePlayerToTarget(speed, fxProjPrefab, fxImpactPrefab, rotationOffset);
        }

        // Overload rotation & offset
        IEnumerator DelayedProjectileSpawnOffset(float speed, GameObject fxProjPrefab, GameObject fxImpactPrefab, Vector3 projectileOffset, float delayTime)
        {
            yield return new WaitForSeconds(delayTime);
            ProjectileCore.CreateNonHomingProjectilePlayerToTargetOffset(speed, fxProjPrefab, fxImpactPrefab, projectileOffset);
        }

        // Overload  offset
        IEnumerator DelayedProjectileSpawnOffset(float speed, GameObject fxProjPrefab, GameObject fxImpactPrefab, Vector3 rotationOffset, Vector3 projectileOffset, float delayTime)
        {
            yield return new WaitForSeconds(delayTime);
            ProjectileCore.CreateNonHomingProjectilePlayerToTargetOffset(speed, fxProjPrefab, fxImpactPrefab, rotationOffset, projectileOffset);
        }

        // Multiple Projectiles
        IEnumerator DelayedProjectileSpawnMultiple(float speed, GameObject fxProjPrefab, GameObject fxImpactPrefab, Vector3 rotationOffset, Vector3 projectileOffset, float delayTime, int projCount, float projInterval, bool arc)
        {
            for (int i = 0; i < projCount; i++)
            {
                yield return new WaitForSeconds(projInterval);
                if (arc)
                    ProjectileCore.CreateNonHomingProjectilePlayerToTargetMultipleArc(speed, fxProjPrefab, fxImpactPrefab, rotationOffset, projectileOffset);
                else
                    ProjectileCore.CreateNonHomingProjectilePlayerToTargetMultiple(speed, fxProjPrefab, fxImpactPrefab, rotationOffset, projectileOffset);
            }
        }
        // ------------------------------------------------------------------------


        // ADDITIONAL SPELL HELPERS
        // ------------------------------------------------------------------------
        private void DisablePlayerMovement()
        {
            // Disable player movement
            PlayerGlobals.invectorInput.SetLockBasicInput(true);
        }

        private void EnablePlayerMovement()
        {
            // Disable player movement
            PlayerGlobals.invectorInput.SetLockBasicInput(false);
        }
        // ------------------------------------------------------------------------

    }
}