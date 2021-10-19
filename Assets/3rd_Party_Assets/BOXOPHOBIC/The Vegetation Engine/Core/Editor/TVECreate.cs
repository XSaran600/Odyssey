// Cristian Pop - https://boxophobic.com/

using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

namespace TheVegetationEngine
{
    public class TVECreate
    {
        [MenuItem("GameObject/BOXOPHOBIC/The Vegetation Engine/Setup", false, 9)]
        static void SetupInScene()
        {
            if (GameObject.Find("The Vegetation Engine") != null)
            {
                Debug.Log("[Warning][The Vegetation Engine] " + "The Vegetation Engine is already set in your scene!");
                return;
            }

            GameObject manager = new GameObject();
            manager.AddComponent<TVEManager>();
            manager.name = "The Vegetation Engine";

            EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());
        }

        [MenuItem("GameObject/BOXOPHOBIC/The Vegetation Engine/Element", false, 9)]
        static void CreateElement()
        {
            if (GameObject.Find("The Vegetation Engine") == null)
            {
                Debug.Log("[Warning][The Vegetation Engine] " + "The Vegetation Engine manager is missing from your scene. Make sure setup it up first!");
                return;
            }

            GameObject element = MonoBehaviour.Instantiate(Resources.Load<GameObject>("Internal Element"));

            var sceneCamera = SceneView.lastActiveSceneView.camera;

            if (sceneCamera != null)
            {
                element.transform.position = sceneCamera.ViewportToWorldPoint(new Vector3(0.5f, 0.5f, 10f));
            }
            else
            {
                element.transform.localPosition = Vector3.zero;
                element.transform.localEulerAngles = Vector3.zero;
                element.transform.localScale = Vector3.one;
            }

            if (Selection.activeGameObject != null)
            {
                element.transform.parent = Selection.activeGameObject.transform;
            }

            if (EditorSceneManager.IsPreviewSceneObject(element))
            {
                element.name = "Element (Shared)";
                element.GetComponent<TVEElement>().elementMode = ElementMode.Shared;
                Debug.Log("[Warning][The Vegetation Engine] " + "Only Shared Elements can be created inside prefabs! The Element Material and Gameobject Layer need to be set manually!");
            }
            else
            {
                element.name = "Element (Colors)";
                element.GetComponent<TVEElement>().elementMode = ElementMode.Colors;
                element.GetComponent<MeshRenderer>().sharedMaterial = Resources.Load<Material>("Internal Colors");
            }

            Selection.activeGameObject = element;

            EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());
        }

        [MenuItem("GameObject/BOXOPHOBIC/The Vegetation Engine/Link", false, 9)]
        static void CreateLink()
        {
            GameObject link = new GameObject();
            link.AddComponent<TVELink>();

            if (Selection.activeGameObject != null)
            {
                link.transform.parent = Selection.activeGameObject.transform;
                link.transform.localPosition = Vector3.zero;
                link.transform.localEulerAngles = Vector3.zero;
                link.transform.localScale = Vector3.one;
            }

            Selection.activeGameObject = link;

            EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());
        }
    }
}
