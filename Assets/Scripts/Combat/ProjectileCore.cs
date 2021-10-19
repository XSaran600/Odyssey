using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

/*---------------------------------------------------------------------------------------------------
*---------------------------------------- Projectile Core -------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* Creates projectiles, does object pooling. (TO-DO: Object pooling, note Object Pool script already exists)
* ----------
* How to Use: 
* Call ProjectileCore.CreateProjectile(parameters...) from anywhere.
* ----------
* Requires:
* [DG.Tweening]
*----------------------------------------------------------------------------------------------------*/
namespace Odyssey.Projectiles
{
    public class ProjectileCore : MonoBehaviour
    {
        private static Vector3 offsetY = new Vector3(0f,0.75f,0f);
        private static int projCount = 0;

        public static void CreateProjectile(Vector3 origin, Vector3 target, float speed, GameObject fxProjPrefab, GameObject fxImpactPrefab)
        {
            GameObject proj;
            proj = Instantiate(fxProjPrefab, origin + offsetY, new Quaternion(90, 0, 0, 90));
            proj.transform.DOMove(target + offsetY, Vector3.Distance(target, origin)/speed).SetEase(Ease.Linear).OnComplete(() => OnDestination(proj, fxImpactPrefab));
        }

        // Override optional owner parameter
        public static void CreateProjectile(Vector3 origin, Vector3 target, float speed, GameObject fxProjPrefab, GameObject fxImpactPrefab, bool ownerIsEnemy)
        {
            GameObject proj;
            proj = Instantiate(fxProjPrefab, origin + offsetY, new Quaternion(90, 0, 0, 90));
            proj.transform.DOMove(target, 0.8f).OnComplete(() => OnDestination(proj, fxImpactPrefab));
            //proj.transform.DOMove(target + offsetY, Vector3.Distance(target, origin)/speed).SetEase(Ease.Linear).OnComplete(() => OnDestination(proj, fxImpactPrefab));
            if (ownerIsEnemy) // Set owner
                proj.GetComponent<Projectile>().enemyProjectile = true;
        }

        public static void CreateProjectile(Vector3 origin, Vector3 target, Quaternion n, float speed, GameObject fxProjPrefab, GameObject fxImpactPrefab, bool ownerIsEnemy)
        {
            GameObject proj;
            proj = Instantiate(fxProjPrefab, origin + offsetY, n);
            proj.transform.DOMove(target, 0.8f).OnComplete(() => OnDestination(proj, fxImpactPrefab));
            //proj.transform.DOMove(target + offsetY, Vector3.Distance(target, origin)/speed).SetEase(Ease.Linear).OnComplete(() => OnDestination(proj, fxImpactPrefab));
            if (ownerIsEnemy) // Set owner
                proj.GetComponent<Projectile>().enemyProjectile = true;
        }

        public static void CreateNonHomingProjectilePlayerToTarget(float speed, GameObject fxProjPrefab, GameObject fxImpactPrefab)
        {
            Vector3 playerObj = PlayerGlobals.player.gameObject.transform.position;
            Vector3 targetObj = PlayerGlobals.combat.targetObject.transform.parent.gameObject.transform.position;
            GameObject proj;
            proj = Instantiate(fxProjPrefab, playerObj + offsetY, new Quaternion(90, 0, 0, 90));
            proj.transform.DOMove(targetObj + offsetY, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.Linear).OnComplete(() => OnDestination(proj, fxImpactPrefab));
        }

        // Rotation
        public static void CreateNonHomingProjectilePlayerToTarget(float speed, GameObject fxProjPrefab, GameObject fxImpactPrefab, Vector3 rotationOffset)
        {
            Vector3 playerObj = PlayerGlobals.player.gameObject.transform.position;
            Vector3 targetObj = PlayerGlobals.combat.targetObject.transform.parent.gameObject.transform.position;
            GameObject proj;
            proj = Instantiate(fxProjPrefab, playerObj + offsetY, new Quaternion(90, 0, 0, 90));
            if (PlayerGlobals.combat.targetObject != null)
            {
                proj.transform.LookAt(PlayerGlobals.combat.targetObject.transform);
                proj.transform.Rotate(rotationOffset);
            }
            proj.transform.DOMove(targetObj + offsetY, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.Linear).OnComplete(() => OnDestination(proj, fxImpactPrefab));
        }


        // OFFSET
        public static void CreateNonHomingProjectilePlayerToTargetOffset(float speed, GameObject fxProjPrefab, GameObject fxImpactPrefab, Vector3 spawnOffset)
        {
            Vector3 playerObj = PlayerGlobals.player.gameObject.transform.position;
            Vector3 targetObj = PlayerGlobals.combat.targetObject.transform.parent.gameObject.transform.position;
            GameObject proj;
            proj = Instantiate(fxProjPrefab, playerObj + offsetY, new Quaternion(90, 0, 0, 90));
            
            // Offset from facing
            proj.transform.localPosition += proj.transform.forward * spawnOffset.x;
            proj.transform.localPosition += proj.transform.right * spawnOffset.z;
            proj.transform.localPosition += proj.transform.up * spawnOffset.y;

            proj.transform.DOMove(targetObj + offsetY, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.Linear).OnComplete(() => OnDestination(proj, fxImpactPrefab));
        }

        // Rotation & Offset
        public static void CreateNonHomingProjectilePlayerToTargetOffset(float speed, GameObject fxProjPrefab, GameObject fxImpactPrefab, Vector3 rotationOffset, Vector3 spawnOffset)
        {
            Vector3 playerObj = PlayerGlobals.player.gameObject.transform.position;
            Vector3 targetObj = PlayerGlobals.combat.targetObject.transform.parent.gameObject.transform.position;
            GameObject proj;
            proj = Instantiate(fxProjPrefab, playerObj + offsetY, new Quaternion(90, 0, 0, 90));

            // Offset from facing
            proj.transform.localPosition += proj.transform.forward * spawnOffset.x;
            proj.transform.localPosition += proj.transform.right * spawnOffset.z;
            proj.transform.localPosition += proj.transform.up * spawnOffset.y;

            if (PlayerGlobals.combat.targetObject != null)
            {
                proj.transform.LookAt(PlayerGlobals.combat.targetObject.transform);
                proj.transform.Rotate(rotationOffset);
            }
            proj.transform.DOMove(targetObj + offsetY, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.Linear).OnComplete(() => OnDestination(proj, fxImpactPrefab));
            
            //proj.transform.DOMoveX(targetObj.x + offsetY.x, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.OutQuad);
            //proj.transform.DOMoveZ(targetObj.z + offsetY.z, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.InQuad).OnComplete(() => OnDestination(proj, fxImpactPrefab));
        }

        public static void CreateNonHomingProjectilePlayerToTargetMultiple(float speed, GameObject fxProjPrefab, GameObject fxImpactPrefab, Vector3 rotationOffset, Vector3 spawnOffset)
        {
            Vector3 playerObj = PlayerGlobals.player.gameObject.transform.position;
            Vector3 targetObj = PlayerGlobals.combat.targetObject.transform.parent.gameObject.transform.position;
            GameObject proj;
            Vector3 randOffset = new Vector3(Random.Range(-1,1), Random.Range(-1,1), Random.Range(-1,1));
            proj = Instantiate(fxProjPrefab, playerObj + randOffset + offsetY, new Quaternion(90, 0, 0, 90));

            // Offset from facing
            proj.transform.localPosition += proj.transform.forward * spawnOffset.x;
            proj.transform.localPosition += proj.transform.right * spawnOffset.z;
            proj.transform.localPosition += proj.transform.up * spawnOffset.y;

            if (PlayerGlobals.combat.targetObject != null)
            {
                proj.transform.LookAt(PlayerGlobals.combat.targetObject.transform);
                proj.transform.Rotate(rotationOffset);
            }
            proj.transform.DOMove(targetObj + offsetY, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.Linear).OnComplete(() => OnDestination(proj, fxImpactPrefab));
            
            //proj.transform.DOMoveX(targetObj.x + offsetY.x, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.OutQuad);
            //proj.transform.DOMoveZ(targetObj.z + offsetY.z, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.InQuad).OnComplete(() => OnDestination(proj, fxImpactPrefab));
        }

        public static void CreateNonHomingProjectilePlayerToTargetMultipleArc(float speed, GameObject fxProjPrefab, GameObject fxImpactPrefab, Vector3 rotationOffset, Vector3 spawnOffset)
        {
            Vector3 playerObj = PlayerGlobals.player.gameObject.transform.position;
            Vector3 targetObj = PlayerGlobals.combat.targetObject.transform.parent.gameObject.transform.position;
            GameObject proj;
            Vector3 randOffset = new Vector3(Random.Range(-2,2), Random.Range(-2,2), Random.Range(-2,2));
            proj = Instantiate(fxProjPrefab, playerObj + randOffset + offsetY, new Quaternion(90, 0, 0, 90));

            // Offset from facing
            proj.transform.localPosition += proj.transform.forward * spawnOffset.x;
            proj.transform.localPosition += proj.transform.right * spawnOffset.z;
            proj.transform.localPosition += proj.transform.up * spawnOffset.y;

            if (PlayerGlobals.combat.targetObject != null)
            {
                proj.transform.LookAt(PlayerGlobals.combat.targetObject.transform);
                proj.transform.Rotate(rotationOffset);
            }
            //proj.transform.DOMove(targetObj + offsetY, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.Linear).OnComplete(() => OnDestination(proj, fxImpactPrefab));
            
            projCount++;

            if (projCount % 5 == 0)
            {
                proj.transform.DOMoveX(targetObj.x + offsetY.x, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.OutQuad);
                proj.transform.DOMoveY(targetObj.y + offsetY.y, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.Linear);
                proj.transform.DOMoveZ(targetObj.z + offsetY.z, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.InQuad).OnComplete(() => OnDestination(proj, fxImpactPrefab));
            } else if (projCount % 5 == 1)
            {
                proj.transform.DOMoveX(targetObj.x + offsetY.x, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.InQuad);
                proj.transform.DOMoveY(targetObj.y + offsetY.y, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.Linear);
                proj.transform.DOMoveZ(targetObj.z - offsetY.z, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.OutQuad).OnComplete(() => OnDestination(proj, fxImpactPrefab));                
            } else if (projCount % 5 == 2)
            {
                proj.transform.DOMoveX(targetObj.x - offsetY.x, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.OutQuad);
                proj.transform.DOMoveY(targetObj.y + offsetY.y, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.Linear);
                proj.transform.DOMoveZ(targetObj.z - offsetY.z, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.InQuad).OnComplete(() => OnDestination(proj, fxImpactPrefab));                
            } else if (projCount % 5 == 3)
            {
                proj.transform.DOMoveX(targetObj.x - offsetY.x, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.InQuad);
                proj.transform.DOMoveY(targetObj.y + offsetY.y, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.Linear);
                proj.transform.DOMoveZ(targetObj.z + offsetY.z, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.OutQuad).OnComplete(() => OnDestination(proj, fxImpactPrefab));                
            } else if (projCount % 5 == 4)
            {
                proj.transform.DOMoveX(targetObj.x - offsetY.x, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.OutQuad);
                proj.transform.DOMoveY(targetObj.y - offsetY.y, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.Linear);
                proj.transform.DOMoveZ(targetObj.z - offsetY.z, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.InQuad).OnComplete(() => OnDestination(proj, fxImpactPrefab));                
            } else 
            {
                proj.transform.DOMove(targetObj + offsetY, Vector3.Distance(targetObj, playerObj)/speed).SetEase(Ease.Linear).OnComplete(() => OnDestination(proj, fxImpactPrefab));            
            }
        }



        // ENEMY!!
        // Enemy
                public static void CreateNonHomingProjectileToTarget(Vector3 origin, Vector3 target, float speed, GameObject fxProjPrefab, GameObject fxImpactPrefab, bool ownerIsEnemy)
        {
            GameObject proj;
            proj = Instantiate(fxProjPrefab, origin + offsetY, new Quaternion(90, 0, 0, 90));

            proj.transform.DOMove(target + offsetY, Vector3.Distance(target, origin) / speed).SetEase(Ease.Linear).OnComplete(() => OnDestination(proj, fxImpactPrefab));
            if (ownerIsEnemy) // Set owner
                proj.GetComponent<Projectile>().enemyProjectile = true;
        }

        // Enemy Proj with offset
        public static void CreateNonHomingProjectilePlayerToTargetOffset(Vector3 origin, Vector3 target, float speed, GameObject fxProjPrefab, GameObject fxImpactPrefab, bool ownerIsEnemy, Vector3 spawnOffset)
        {
            GameObject proj;
            proj = Instantiate(fxProjPrefab, origin + offsetY, new Quaternion(90, 0, 0, 90));

            // Offset from facing
            proj.transform.localPosition += proj.transform.forward * spawnOffset.x;
            proj.transform.localPosition += proj.transform.right * spawnOffset.z;
            proj.transform.localPosition += proj.transform.up * spawnOffset.y;

            proj.transform.DOMove(target + offsetY, Vector3.Distance(target, origin) / speed).SetEase(Ease.Linear).OnComplete(() => OnDestination(proj, fxImpactPrefab));
            if (ownerIsEnemy) // Set owner
                proj.GetComponent<Projectile>().enemyProjectile = true;
        }




        private static void OnDestination(GameObject proj, GameObject fxImpactPrefab)
        {
            // Add FX effect
            Destroy((Instantiate(fxImpactPrefab, proj.transform.position, proj.transform.rotation)), 3);
            Destroy(proj);
        }


    }
}
