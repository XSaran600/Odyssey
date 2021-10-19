// Cristian Pop - https://boxophobic.com/

using UnityEngine;
using UnityEditor;
using Boxophobic.StyledGUI;
using Boxophobic.Utils;
using System.IO;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEditor.SceneManagement;
using System;

namespace TheVegetationEngine
{
    public class TVEHub : EditorWindow
    {
        string[] featureVegetationStudio = new string[]
        {
        "           //Vegetation Studio Support",
        "           #include \"XXX/Core/Library/VS_Indirect.cginc\"",
        "           #pragma instancing_options procedural:setup forwardadd",
        "           #pragma multi_compile GPU_FRUSTUM_ON __",
        };

        string[] featureVegetationStudioHD = new string[]
        {
        "           //Vegetation Studio Support",
        "           #include \"XXX/Core/Library/VS_IndirectHD.cginc\"",
        "           #pragma instancing_options procedural:setupVSPro forwardadd",
        "           #pragma multi_compile GPU_FRUSTUM_ON __",
        };

        string[] featureGPUInstancer = new string[]
        {
        "           //GPU Instancer Support",
        "           #include \"XXX\"",
        "           #pragma instancing_options procedural:setupGPUI",
        "           #pragma multi_compile_instancing",
        };

        string[] featureNatureRenderer = new string[]
        {
        "           //Nature Renderer Support",
        "           #include \"XXX\"",
        "           #pragma instancing_options procedural:SetupNatureRenderer",
        };

        readonly string[] compatibilityOptions =
        {
        "None",
        "GPU Instancer (Instanced Indirect)",
        "Vegetation Studio (Instanced Indirect)",
        "Nature Renderer (Procedural Instancing)",
        };

        //readonly string[] globalColorsOptions =
        //{
        //"Off",
        //"Use Global Colors",
        //};

        //readonly string[] globalOverlayOptions =
        //{
        //"Off",
        //"Use Global Overlay",
        //};

        //readonly string[] globalLeavesOptions =
        //{
        //"Off",
        //"Use Leaves Amount",
        //};

        //string boxophobicFolder = "Assets/BOXOPHOBIC";
        string folderAsset = "Assets/BOXOPHOBIC/The Vegetation Engine";
        string folderUser = "Assets/BOXOPHOBIC/User";

        string[] packagePaths;
        string[] packageOptions;
        string[] shaderPaths;
        string[] materialPaths;

        string aciveScene = "";
        string packagesPath;

        int packageIndex;

        int assetSettings = 0;
        int shaderCompatibility = 0;
        //int shaderGlobalColors = 1;
        //int shaderGlobalOverlay = 1;
        //int shaderGlobalLeaves = 1;

        int userVersion;
        int internalVersion;
        int unityMajorVersion;
        string assetPipeline = "";

        bool upgradeIsNeeded = false;

        GUIStyle stylePopup;

        Color bannerColor;
        string bannerText;
        string bannerVersion;
        string helpURL;
        static TVEHub window;
        Vector2 scrollPosition = Vector2.zero;

        [MenuItem("Window/BOXOPHOBIC/The Vegetation Engine/Hub")]
        public static void ShowWindow()
        {
            window = GetWindow<TVEHub>(false, "The Vegetation Engine Hub", true);
            window.minSize = new Vector2(389, 220);
        }

        void OnEnable()
        {
            //Safer search, there might be many user folders
            string[] searchFolders;

            searchFolders = AssetDatabase.FindAssets("The Vegetation Engine");

            for (int i = 0; i < searchFolders.Length; i++)
            {
                if (AssetDatabase.GUIDToAssetPath(searchFolders[i]).EndsWith("The Vegetation Engine.pdf"))
                {
                    folderAsset = AssetDatabase.GUIDToAssetPath(searchFolders[i]);
                    folderAsset = folderAsset.Replace("/The Vegetation Engine.pdf", "");
                }
            }

            //Debug.Log("[The Vegetation Engine] The Vegetation Engine detected at " + folderAsset);

            searchFolders = AssetDatabase.FindAssets("User");

            for (int i = 0; i < searchFolders.Length; i++)
            {
                if (AssetDatabase.GUIDToAssetPath(searchFolders[i]).EndsWith("User.pdf"))
                {
                    folderUser = AssetDatabase.GUIDToAssetPath(searchFolders[i]);
                    folderUser = folderUser.Replace("/User.pdf", "");
                }
            }

            //Debug.Log("[The Vegetation Engine] User Settings detected at " + folderUser);

            var cgincGPUI = "Assets/GPUInstancer/Shaders/Include/GPUInstancerInclude.cginc";

            searchFolders = AssetDatabase.FindAssets("GPUInstancerInclude");

            for (int i = 0; i < searchFolders.Length; i++)
            {
                if (AssetDatabase.GUIDToAssetPath(searchFolders[i]).EndsWith("GPUInstancerInclude.cginc"))
                {
                    cgincGPUI = AssetDatabase.GUIDToAssetPath(searchFolders[i]);
                }
            }

            var cgincNR = "Assets/Visual Design Cafe/Nature Shaders/Common/Nodes/Integrations/Nature Renderer.cginc";

            searchFolders = AssetDatabase.FindAssets("Nature Renderer");

            for (int i = 0; i < searchFolders.Length; i++)
            {
                if (AssetDatabase.GUIDToAssetPath(searchFolders[i]).EndsWith("Nature Renderer.cginc"))
                {
                    cgincNR = AssetDatabase.GUIDToAssetPath(searchFolders[i]);
                }
            }

            //Debug.Log("[The Vegetation Engine] NR detected at " + cgincNR);

            // Add corect paths for VSP and GPUI
            featureVegetationStudio[1] = featureVegetationStudio[1].Replace("XXX", folderAsset);
            featureVegetationStudioHD[1] = featureVegetationStudioHD[1].Replace("XXX", folderAsset);
            featureGPUInstancer[1] = featureGPUInstancer[1].Replace("XXX", cgincGPUI);
            featureNatureRenderer[1] = featureNatureRenderer[1].Replace("XXX", cgincNR);

            if (File.Exists(folderUser + "/The Vegetation Engine/Pipeline.asset"))
            {
                SettingsUtils.SaveSettingsData(folderUser + "/The Vegetation Engine/Asset Pipeline.asset", SettingsUtils.LoadSettingsData(folderUser + "/The Vegetation Engine/Pipeline.asset", 0));
                FileUtil.DeleteFileOrDirectory(folderUser + "/The Vegetation Engine/Pipeline.asset");
                AssetDatabase.SaveAssets();
                AssetDatabase.Refresh();
            }

            if (File.Exists(folderUser + "/The Vegetation Engine/Version.asset"))
            {
                SettingsUtils.SaveSettingsData(folderUser + "/The Vegetation Engine/Asset Version.asset", SettingsUtils.LoadSettingsData(folderUser + "/The Vegetation Engine/Version.asset", -99));
                FileUtil.DeleteFileOrDirectory(folderUser + "/The Vegetation Engine/Version.asset");
                AssetDatabase.SaveAssets();
                AssetDatabase.Refresh();
            }

            unityMajorVersion = int.Parse(Application.unityVersion.Substring(0, 4));
            //unityMinorVersion = Application.unityVersion.Substring(5, 1);
            internalVersion = SettingsUtils.LoadSettingsData(folderAsset + "/Core/Editor/TVEVersion.asset", -99);
            userVersion = SettingsUtils.LoadSettingsData(folderUser + "/The Vegetation Engine/Asset Version.asset", -99);

            bannerVersion = internalVersion.ToString();
            bannerVersion = bannerVersion.Insert(1, ".");
            bannerVersion = bannerVersion.Insert(3, ".");

            // Check for latest version
            //StartBackgroundTask(StartRequest("https://boxophobic.com/s/thevegetationengine", () =>
            //{
            //    int.TryParse(www.downloadHandler.text, out latestVersion);
            //    Debug.Log("hubhub" + latestVersion);
            //}));

            bannerColor = new Color(0.890f, 0.745f, 0.309f);
            bannerText = "The Vegetation Engine " + bannerVersion;
            helpURL = "https://docs.google.com/document/d/145JOVlJ1tE-WODW45YoJ6Ixg23mFc56EnB_8Tbwloz8/edit#heading=h.pr0qp2u684tr";

            packagesPath = folderAsset + "/Core/Packages";

            GetPackages();
            GetShaders();
            GetMaterials();
            LoadUserSettings();

            // Looks like new install, but User folder might be deleted
            if (userVersion == -99)
            {
                for (int i = 0; i < materialPaths.Length; i++)
                {
                    // Exclude TVE folder when checking
                    if (materialPaths[i].Contains("The Vegetation Engine") == false && materialPaths[i].Contains("TVE Material"))
                    {
                        upgradeIsNeeded = true;
                        break;
                    }
                }
            }

            // User Version exist and need upgrade
            if (userVersion != -99 && userVersion < internalVersion)
            {
                upgradeIsNeeded = true;
            }

            // Curent version was installed but deleted and reimported
            if (userVersion == internalVersion)
            {
                upgradeIsNeeded = false;
            }
        }

        void OnGUI()
        {
            SetGUIStyles();

            StyledGUI.DrawWindowBanner(bannerColor, bannerText, helpURL);

            GUILayout.BeginHorizontal();
            GUILayout.Space(15);

            GUILayout.BeginVertical();

            scrollPosition = GUILayout.BeginScrollView(scrollPosition, false, false, GUILayout.Width(this.position.width - 28), GUILayout.Height(this.position.height - 80));

            if (File.Exists(folderAsset + "/Core/Editor/TVEHubAutoRun.cs"))
            {
                if (upgradeIsNeeded)
                {
                    DrawUpgradeSetup();
                }
                else
                {
                    DrawInstallSetup();
                }
            }
            // TVE is installed
            else
            {
                if (assetSettings == 0)
                {
                    EditorGUILayout.HelpBox("The Vegetation Engine is currently installed for the Standard Render Pipeline with no shader compatibility! Follow the instructions below to change the pipeline or shader settings!", MessageType.Info, true);
                }

                EditorGUILayout.HelpBox("Click the Install Pipeline Support and then the Update Shaders buttons to use The Vegetation Engine with another render pipeline. The current scene will be saved before importing the new package! Click the Update Shaders button to update the shader features only. The selected features are shared across all TVE shaders.", MessageType.Info, true);

                if (shaderCompatibility > 0)
                {
                    EditorGUILayout.HelpBox("Please note that GPU Instancer, Vegetation Studio and Nature Renderer Instanced Indirect feature might not work with all render pipelines or all platforms! Check the product documentation for more details.", MessageType.Warning, true);
                }

                DrawPipelineOptions();
                DrawShaderOptions();

                DrawPipelineSetup();
                DrawShaderSetup();
            }

            GUILayout.EndScrollView();

            GUILayout.EndVertical();

            GUILayout.Space(13);
            GUILayout.EndHorizontal();
        }

        void SetGUIStyles()
        {
            stylePopup = new GUIStyle(EditorStyles.popup)
            {
                alignment = TextAnchor.MiddleCenter
            };
        }

        void DrawPipelineOptions()
        {
            GUILayout.Space(20);

            GUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(new GUIContent("Render Pipeline", ""));
            packageIndex = EditorGUILayout.Popup(packageIndex, packageOptions, stylePopup);
            GUILayout.EndHorizontal();
        }

        void DrawShaderOptions()
        {
            //GUILayout.Space(10);

            GUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(new GUIContent("Shader Compatibility", ""));
            shaderCompatibility = EditorGUILayout.Popup(shaderCompatibility, compatibilityOptions, stylePopup);
            GUILayout.EndHorizontal();

            //GUILayout.BeginHorizontal();
            //EditorGUILayout.LabelField(new GUIContent("Shader Global Colors", ""));
            //shaderGlobalColors = EditorGUILayout.Popup(shaderGlobalColors, globalColorsOptions, stylePopup);
            //GUILayout.EndHorizontal();

            //GUILayout.BeginHorizontal();
            //EditorGUILayout.LabelField(new GUIContent("Shader Global Overlay", ""));
            //shaderGlobalOverlay = EditorGUILayout.Popup(shaderGlobalOverlay, globalOverlayOptions, stylePopup);
            //GUILayout.EndHorizontal();

            //GUILayout.BeginHorizontal();
            //EditorGUILayout.LabelField(new GUIContent("Shader Global Leaves", ""));
            //shaderGlobalLeaves = EditorGUILayout.Popup(shaderGlobalLeaves, globalLeavesOptions, stylePopup);
            //GUILayout.EndHorizontal();
        }

        void DrawInstallSetup()
        {
            EditorGUILayout.HelpBox("The Vegetation Engine needs to be installed for the current Unity version!", MessageType.Info, true);

            GUILayout.Space(20);

            if (GUILayout.Button("Install"))
            {
                UpdateShaders();

                SettingsUtils.SaveSettingsData(folderUser + "/The Vegetation Engine/Asset Settings.asset", 0);
                assetSettings = 0;

                SettingsUtils.SaveSettingsData(folderUser + "/The Vegetation Engine/Asset Version.asset", internalVersion);
                userVersion = internalVersion;

                FileUtil.DeleteFileOrDirectory(folderAsset + "/Core/Editor/TVEHubAutorun.cs");
                AssetDatabase.Refresh();

                SwitchDefineSymbols("Standard");

                Debug.Log("[The Vegetation Engine] " + "The Vegetation Engine " + bannerVersion + " is installed!");

                GUIUtility.ExitGUI();
            }
        }

        void DrawUpgradeSetup()
        {
            EditorGUILayout.HelpBox("Previous version detected! The Vegetation Engine needs to upgrade your assets! The action might take some time in some cases. Please do not close Unity during the upgrade!", MessageType.Warning, true);

            GUILayout.Space(20);

            GUI.enabled = false;

            if (userVersion < 100)
            {
                GUI.enabled = true;
            }

            EditorGUILayout.HelpBox("1.0.0 • Upgarde elements and vegetation materials.", MessageType.None, true);

            if (userVersion < 110)
            {
                GUI.enabled = true;
            }

            EditorGUILayout.HelpBox("1.1.0 • Upgarde internal detail, subsurface and occlusion shader properties.", MessageType.None, true);

            if (userVersion < 120)
            {
                GUI.enabled = true;
            }

            EditorGUILayout.HelpBox("1.2.0 • Deprecate Bark Advanced Lit. Switch all Bark Advanced Lit materials to Bark Standard Lit.", MessageType.None, true);

            if (userVersion < 130)
            {
                GUI.enabled = true;
            }

            EditorGUILayout.HelpBox("1.3.0 • Upgrade all materials internal naming conventions and subsurface settings. Some subsurface materials might need some adjustments!", MessageType.None, true);
            EditorGUILayout.HelpBox("1.3.0 • Upgrade all vegetation meshes for smaller size and better performance. The action might take some time depending on the number of the converted meshes! Due to a Unity bug, some meshes might not be upgraded and manual prefab reconversion is needed. The meshes will be listed in the console.", MessageType.None, true);

            if (userVersion < 140)
            {
                GUI.enabled = true;
            }

            EditorGUILayout.HelpBox("1.4.0 • Upgarde internal motion properties for all materials.", MessageType.None, true);

            GUI.enabled = true;

            EditorGUILayout.HelpBox(bannerVersion + " • Install The Vegetation Engine for the current Unity version.", MessageType.None, true);

            GUILayout.Space(20);

            if (GUILayout.Button("Upgrade"))
            {


                if (userVersion < 100)
                {
                    UpdateTo099();
                    UpdateTo100();
                }

                if (userVersion < 110)
                {
                    UpdateTo110();
                }

                if (userVersion < 120)
                {
                    UpdateTo120();
                }

                if (userVersion < 130)
                {
                    EditorUtility.DisplayProgressBar("The Vegetation Engine", "Upgrading ", 0f);
                    UpdateTo130();
                    EditorUtility.ClearProgressBar();
                }

                if (userVersion < 140)
                {
                    UpdateTo140();
                }

                UpdateShaders();
                SetMaterialsRenderSettings();

                SettingsUtils.SaveSettingsData(folderUser + "/The Vegetation Engine/Asset Settings.asset", 0);
                assetSettings = 0;

                SettingsUtils.SaveSettingsData(folderUser + "/The Vegetation Engine/Asset Version.asset", internalVersion);
                userVersion = internalVersion;

                FileUtil.DeleteFileOrDirectory(folderAsset + "/Core/Editor/TVEHubAutorun.cs");

                AssetDatabase.SaveAssets();
                AssetDatabase.Refresh();

                Debug.Log("[The Vegetation Engine] " + "The Vegetation Engine has been upgraded to version " + bannerVersion);
                GUIUtility.ExitGUI();
            }
        }

        void DrawPipelineSetup()
        {
            GUILayout.Space(10);

            if (GUILayout.Button("Install " + packageOptions[packageIndex] + " Support"/*, GUILayout.Width(160)*/))
            {
                SettingsUtils.SaveSettingsData(folderUser + "/The Vegetation Engine/Asset Pipeline.asset", packageOptions[packageIndex]);

                SwitchDefineSymbols(packageOptions[packageIndex]);

                ImportPackage();

                GUIUtility.ExitGUI();
            }
        }

        void DrawShaderSetup()
        {
            //GUILayout.Space(10);

            if (GUILayout.Button("Update Shaders and Materials"/*, GUILayout.Width(160)*/))
            {
                SaveScene();
                ReopenScene();

                assetSettings = 1;

                SaveUserSettings();

                UpdateShaders();
                SetMaterialsRenderSettings();

                GUIUtility.ExitGUI();
            }
        }

        int StyledBool(string name, int value)
        {
            bool boolValue = false;

            if (value == 1)
            {
                boolValue = true;
            }

            GUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(new GUIContent(name, ""));
            boolValue = EditorGUILayout.Toggle(boolValue, GUILayout.Width(14));
            GUILayout.EndHorizontal();

            if (boolValue == false)
            {
                return 0;
            }
            else
            {
                return 1;
            }
        }

        void GetPackages()
        {
            packagePaths = Directory.GetFiles(packagesPath, "*.unitypackage", SearchOption.TopDirectoryOnly);

            packageOptions = new string[packagePaths.Length];

            for (int i = 0; i < packageOptions.Length; i++)
            {
                packageOptions[i] = Path.GetFileNameWithoutExtension(packagePaths[i].Replace("Built-in Pipeline", "Standard"));
            }
        }

        void GetShaders()
        {
            shaderPaths = Directory.GetFiles("Assets/", "*.shader", SearchOption.AllDirectories);
        }

        void GetMaterials()
        {
            materialPaths = Directory.GetFiles("Assets/", "*.mat", SearchOption.AllDirectories);
        }

        void SaveUserSettings()
        {
            SettingsUtils.SaveSettingsData(folderUser + "/The Vegetation Engine/Asset Settings.asset", assetSettings);
            SettingsUtils.SaveSettingsData(folderUser + "/The Vegetation Engine/Shader Compatibility.asset", shaderCompatibility);
            //SettingsUtils.SaveSettingsData(boxophobicFolder + "/User/The Vegetation Engine/Shader Global Colors.asset", shaderGlobalColors);
            //SettingsUtils.SaveSettingsData(boxophobicFolder + "/User/The Vegetation Engine/Shader Global Overlay.asset", shaderGlobalOverlay);
            //SettingsUtils.SaveSettingsData(boxophobicFolder + "/User/The Vegetation Engine/Shader Global Leaves.asset", shaderGlobalLeaves);
        }

        void LoadUserSettings()
        {
            assetSettings = SettingsUtils.LoadSettingsData(folderUser + "/The Vegetation Engine/Asset Settings.asset", 0);
            shaderCompatibility = SettingsUtils.LoadSettingsData(folderUser + "/The Vegetation Engine/Shader Compatibility.asset", 0);
            //shaderGlobalColors = SettingsUtils.LoadSettingsData(boxophobicFolder + "/User/The Vegetation Engine/Shader Global Colors.asset", 1);
            //shaderGlobalOverlay = SettingsUtils.LoadSettingsData(boxophobicFolder + "/User/The Vegetation Engine/Shader Global Overlay.asset", 1);
            //shaderGlobalLeaves = SettingsUtils.LoadSettingsData(boxophobicFolder + "/User/The Vegetation Engine/Shader Global Leaves.asset", 1);

            assetPipeline = SettingsUtils.LoadSettingsData(folderUser + "/The Vegetation Engine/Asset Pipeline.asset", "");

            for (int i = 0; i < packageOptions.Length; i++)
            {
                if (packageOptions[i] == assetPipeline)
                {
                    packageIndex = i;
                }
            }
        }

        void SaveScene()
        {
            if (/*SceneManager.GetActiveScene() != null ||*/ SceneManager.GetActiveScene().name != "")
            {
                if (SceneManager.GetActiveScene().isDirty)
                {
                    EditorSceneManager.SaveScene(SceneManager.GetActiveScene());
                    AssetDatabase.SaveAssets();
                    AssetDatabase.Refresh();
                }

                aciveScene = SceneManager.GetActiveScene().path;
                EditorSceneManager.NewScene(NewSceneSetup.EmptyScene);
            }
        }

        void ReopenScene()
        {
            if (aciveScene != "")
            {
                EditorSceneManager.OpenScene(aciveScene);
            }
        }

        void ImportPackage()
        {
            AssetDatabase.ImportPackage(packagePaths[packageIndex], false);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();

            Debug.Log("[The Vegetation Engine] " + packageOptions[packageIndex] + " package imported!");
        }

        void UpdateShaders()
        {
            for (int i = 0; i < shaderPaths.Length; i++)
            {
                if (shaderPaths[i].Contains("The Vegetation Engine") || shaderPaths[i].Contains("TVE"))
                {
                    if (shaderPaths[i].Contains("Elements") == false && shaderPaths[i].Contains("Helpers") == false && shaderPaths[i].Contains("Legacy") == false && shaderPaths[i].Contains("Tools") == false)
                    {
                        // Auto generated GPUI Shaders need to be removed to avoid issues
                        if (shaderPaths[i].Contains("GPUI"))
                        {
                            FileUtil.DeleteFileOrDirectory(shaderPaths[i]);
                            AssetDatabase.Refresh();
                        }
                        else
                        {
                            InjectShaderFeature(shaderPaths[i]);
                        }
                    }
                }
            }

            Debug.Log("[The Vegetation Engine] " + "Shaders and Materials updated!");

            //AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
        }

        void InjectShaderFeature(string shaderAssetPath)
        {
            StreamReader reader = new StreamReader(shaderAssetPath);

            List<string> lines = new List<string>();

            while (!reader.EndOfStream)
            {
                lines.Add(reader.ReadLine());
            }

            reader.Close();

            // Delete Features before adding new ones
            int count = lines.Count;

            for (int i = 0; i < count; i++)
            {
                if (lines[i].Contains("SHADER INJECTION POINT BEGIN"))
                {
                    int c = 0;
                    int j = i + 1;

                    while (lines[j].Contains("SHADER INJECTION POINT END") == false)
                    {
                        j++;
                        c++;
                    }

                    lines.RemoveRange(i + 1, c);
                    count = count - c;
                }
            }


            var pipeline = SettingsUtils.LoadSettingsData(folderUser + "/The Vegetation Engine/Asset Pipeline.asset", "Standard");

            // Delete GPUI added lines    
            count = lines.Count;

            if (pipeline.Contains("Standard"))
            {
                for (int i = 0; i < count; i++)
                {
                    if (lines[i].StartsWith("#"))
                    {
                        lines.RemoveRange(i + 1, 4);
                        count = count - 4;

                        i--;
                    }

                    if (lines[i].Contains("#pragma target 3.0"))
                    {
                        if (lines[i + 1].Contains("multi_compile_instancing") == false)
                        {
                            lines.Insert(i + 1, "		#pragma multi_compile_instancing");
                        }
                    }
                }
            }
            else if (pipeline.Contains("Universal"))
            {
                for (int i = 0; i < count; i++)
                {
                    if (lines[i].StartsWith("#"))
                    {
                        lines.RemoveRange(i, 3);
                        count = count - 3;

                        i--;
                    }

                    if (lines[i].Contains("HLSLPROGRAM"))
                    {
                        if (lines[i + 1].Contains("multi_compile_instancing") == false)
                        {
                            lines.Insert(i + 1, "		    #pragma multi_compile_instancing");
                        }
                    }
                }
            }
            else if (pipeline.Contains("High"))
            {
                for (int i = 0; i < count; i++)
                {
                    if (lines[i].StartsWith("#"))
                    {
                        lines.RemoveRange(i, 3);
                        count = count - 3;

                        i--;
                    }

                    if (lines[i].Contains("HLSLINCLUDE"))
                    {
                        if (lines[i + 3].Contains("multi_compile_instancing") == false)
                        {
                            lines.Insert(i + 3, "		    #pragma multi_compile_instancing");
                        }
                    }
                }
            }

            for (int i = 0; i < count; i++)
            {
                if (lines[i].Contains("GPUInstancerInclude.cginc"))
                {
                    if (pipeline.Contains("Standard"))
                    {
                        lines.RemoveAt(i - 1);
                        lines.RemoveAt(i);
                        lines.RemoveAt(i + 1);
                    }

                    count = count - 3;
                }
            }

            //Inject 3rd Party Support
            if (shaderCompatibility == 1)
            {
                for (int i = 0; i < lines.Count; i++)
                {
                    if (lines[i].Contains("SHADER INJECTION POINT BEGIN"))
                    {
                        lines.InsertRange(i + 1, featureGPUInstancer);
                    }
                }
            }

            else if (shaderCompatibility == 2)
            {
                for (int i = 0; i < lines.Count; i++)
                {
                    if (lines[i].Contains("SHADER INJECTION POINT BEGIN"))
                    {
                        if (pipeline.Contains("High"))
                        {
                            lines.InsertRange(i + 1, featureVegetationStudioHD);
                        }
                        else
                        {
                            lines.InsertRange(i + 1, featureVegetationStudio);
                        }
                    }
                }
            }

            else if (shaderCompatibility == 3)
            {
                for (int i = 0; i < lines.Count; i++)
                {
                    if (lines[i].Contains("SHADER INJECTION POINT BEGIN"))
                    {
                        lines.InsertRange(i + 1, featureNatureRenderer);
                    }
                }
            }

            // Set Keywords to local
            if (unityMajorVersion >= 2019)
            {
                for (int i = 0; i < lines.Count; i++)
                {
                    // Disable Universal define set by ASE
                    if (lines[i].Contains("_ALPHATEST_ON 1"))
                    {
                        lines[i] = lines[i].Replace("_ALPHATEST_ON 1", "TVE_DISABLE_ALPHATEST_ON 1");
                    }

                    // Set keyword to local
                    if (lines[i].Contains("shader_feature _ALPHATEST_ON"))
                    {
                        lines[i] = lines[i].Replace("shader_feature _ALPHATEST_ON", "shader_feature_local _ALPHATEST_ON");
                    }

                    // Set keyword to local
                    if (lines[i].Contains("shader_feature MATERIAL_USE_DETAIL_OFF"))
                    {
                        lines[i] = lines[i].Replace("shader_feature MATERIAL_USE_DETAIL_OFF", "shader_feature_local MATERIAL_USE_DETAIL_OFF");
                    }

                    if (lines[i].Contains("shader_feature MATERIAL_USE_OBJECT_DATA"))
                    {
                        lines[i] = lines[i].Replace("shader_feature MATERIAL_USE_OBJECT_DATA", "shader_feature_local MATERIAL_USE_OBJECT_DATA");
                    }
                }
            }

#if AMPLIFY_SHADER_EDITOR

            // Add diffusion profile support
            if (pipeline.Contains("High"))
            {
                if (shaderAssetPath.Contains("Subsurface Lit"))
                {
                    for (int i = 0; i < lines.Count; i++)
                    {
                        if (lines[i].Contains("ASEDiffusionProfile"))
                        {
                            lines[i] = lines[i].Replace("[HideInInspector][ASEDiffusionProfile(_SubsurfaceDiffusion)]", "[ASEDiffusionProfile(_SubsurfaceDiffusion)]");
                        }

                        if (lines[i].Contains("StyledDiffusionMaterial"))
                        {
                            lines[i] = lines[i].Replace("[StyledDiffusionMaterial(_SubsurfaceDiffusion)]", "[HideInInspector][StyledDiffusionMaterial(_SubsurfaceDiffusion)]");
                        }
                    }
                }
            }
#endif
            // Check if the Hub should enable/disable shader features
            //bool useHubOverrides = false;

            //for (int i = 0; i < lines.Count; i++)
            //{
            //    if (lines[i].Contains("SHADER_USE_GLOBAL_OVERRIDES"))
            //    {
            //        useHubOverrides = true;
            //        break;
            //    }
            //}

            //if (useHubOverrides)
            //{
            //    for (int i = 0; i < lines.Count; i++)
            //    {
            //        if (lines[i].Contains("#define SHADER_USE_GLOBAL_COLORS"))
            //        {
            //            if (shaderGlobalColors == 1)
            //            {
            //                lines[i] = lines[i].Replace("0", "1");
            //            }
            //            else
            //            {
            //                lines[i] = lines[i].Replace("1", "0");
            //            }
            //        }

            //        if (lines[i].Contains("#define SHADER_USE_GLOBAL_OVERLAY"))
            //        {
            //            if (shaderGlobalOverlay == 1)
            //            {
            //                lines[i] = lines[i].Replace("0", "1");
            //            }
            //            else
            //            {
            //                lines[i] = lines[i].Replace("1", "0");
            //            }
            //        }

            //        if (lines[i].Contains("#define SHADER_USE_GLOBAL_LEAVES"))
            //        {
            //            if (shaderGlobalLeaves == 1)
            //            {
            //                lines[i] = lines[i].Replace("0", "1");
            //            }
            //            else
            //            {
            //                lines[i] = lines[i].Replace("1", "0");
            //            }
            //        }
            //    }
            //}

            StreamWriter writer = new StreamWriter(shaderAssetPath);

            for (int i = 0; i < lines.Count; i++)
            {
                writer.WriteLine(lines[i]);
            }

            writer.Close();

            lines = new List<string>();

            AssetDatabase.ImportAsset(shaderAssetPath);
        }

        void SetMaterialsRenderSettings()
        {
            for (int i = 0; i < materialPaths.Length; i++)
            {
                var material = AssetDatabase.LoadAssetAtPath<Material>(materialPaths[i]);
                var shaderName = material.shader.name;

                if (shaderName.Contains("The Vegetation Engine"))
                {
                    TVEShaderUtils.SetRenderSettings(material);
                }
            }

            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
        }

        void SwitchDefineSymbols(string pipeline)
        {
            var defineSymbols = PlayerSettings.GetScriptingDefineSymbolsForGroup(EditorUserBuildSettings.selectedBuildTargetGroup);

            // Cleanup
            defineSymbols = defineSymbols.Replace("THE_VEGETATION_ENGINE", "");
            defineSymbols = defineSymbols.Replace("THE_VEGETATION_ENGINE_STANDARD", "");
            defineSymbols = defineSymbols.Replace("THE_VEGETATION_ENGINE_UNIVERSAL", "");
            defineSymbols = defineSymbols.Replace("THE_VEGETATION_ENGINE_HD", "");

            defineSymbols = defineSymbols + ";THE_VEGETATION_ENGINE;";

            var define = "";

            if (pipeline.Contains("Standard"))
            {
                define = "THE_VEGETATION_ENGINE_STANDARD";
            }
            else if (pipeline.Contains("Universal"))
            {
                define = "THE_VEGETATION_ENGINE_UNIVERSAL";
            }

            else if (pipeline.Contains("High"))
            {
                define = "THE_VEGETATION_ENGINE_HD";
            }
            else if (pipeline == "")
            {
                define = "THE_VEGETATION_ENGINE_STANDARD";
            }

            defineSymbols = defineSymbols + ";" + define + ";";

            PlayerSettings.SetScriptingDefineSymbolsForGroup(EditorUserBuildSettings.selectedBuildTargetGroup, defineSymbols);
        }

        void UpdateTo099()
        {
            var count = 0;

            for (int i = 0; i < materialPaths.Length; i++)
            {
                if (materialPaths[i].Contains("Element - "))
                {
                    var material = AssetDatabase.LoadAssetAtPath<Material>(materialPaths[i]);
                    var shaderName = material.shader.name;

                    if (material.GetFloat("_Intensity") >= 0)
                    {
                        if (shaderName.Contains("Color"))
                        {
                            material.SetColor("_MainColor", material.GetColor("_Simple"));
                            material.SetColor("_WinterColor", material.GetColor("_Winter"));
                            material.SetColor("_SpringColor", material.GetColor("_Spring"));
                            material.SetColor("_SummerColor", material.GetColor("_Summer"));
                            material.SetColor("_AutumnColor", material.GetColor("_Autumn"));
                        }
                        else if (shaderName.Contains("Color HDR"))
                        {
                            material.SetColor("_MainColorHDR", material.GetColor("_Simple"));
                        }
                        else if (shaderName.Contains("Leaves") || shaderName.Contains("Overlay") || shaderName.Contains("Size"))
                        {
                            material.SetFloat("_MainValue", material.GetFloat("_Simple"));
                            material.SetFloat("_WinterValue", material.GetFloat("_Winter"));
                            material.SetFloat("_SpringValue", material.GetFloat("_Spring"));
                            material.SetFloat("_SummerValue", material.GetFloat("_Summer"));
                            material.SetFloat("_AutumnValue", material.GetFloat("_Autumn"));
                        }
                        else if (shaderName.Contains("Wetness"))
                        {
                            material.SetFloat("_MainValue", material.GetFloat("_Simple"));
                        }

                        if (material.HasProperty("_SeasonMode"))
                        {
                            material.SetInt("_ElementMode", material.GetInt("_SeasonMode"));
                        }

                        material.SetFloat("_ElementIntensity", material.GetFloat("_Intensity"));

                        // Set Old _Intensity to -1 to avoid updating multiple times
                        material.SetFloat("_Intensity", -1);

                        count++;
                    }
                }
            }

            if (count > 0)
            {
                AssetDatabase.SaveAssets();
                AssetDatabase.Refresh();
            }
        }

        void UpdateTo100()
        {
            for (int i = 0; i < materialPaths.Length; i++)
            {
                var material = AssetDatabase.LoadAssetAtPath<Material>(materialPaths[i]);

                if (materialPaths[i].Contains("TVE Material") && material.HasProperty("_IsVersion"))
                {
                    if (material.GetInt("_IsVersion") < 100)
                    {
                        material.SetInt("_IsTVEShader", 1);
                        material.SetInt("_IsTVEElement", 1);

                        material.SetInt("_IsStandardPipeline", 1);
                        material.SetInt("_IsUniversalPipeline", 1);
                        material.SetInt("_IsHDPipeline", 1);

                        material.SetInt("_IsLitShader", 1);

                        material.SetInt("_IsStandardShader", 1);
                        material.SetInt("_IsSubsurfaceShader", 1);
                        material.SetInt("_IsDisplacementShader", 1);
                        material.SetInt("_IsTessellationShader", 1);

                        material.SetInt("_IsBillboardShader", 1);
                        material.SetInt("_IsVegetationShader", 1);

                        material.SetInt("_IsVersion", 100);
                    }
                }
            }
        }

        void UpdateTo110()
        {
            for (int i = 0; i < materialPaths.Length; i++)
            {
                var material = AssetDatabase.LoadAssetAtPath<Material>(materialPaths[i]);

                if (materialPaths[i].Contains("TVE Material"))
                {
                    if (material.GetInt("_IsVersion") < 110)
                    {
                        if (material.HasProperty("_DetailMaskValue"))
                        {
                            material.SetFloat("_DetailMeshValue", material.GetFloat("_DetailMaskValue"));
                            material.SetFloat("_DetailMaskValue", material.GetFloat("_MainMaskValue"));
                        }

                        if (material.HasProperty("_VertexOcclusion"))
                        {
                            material.SetFloat("_ObjectOcclusionValue", material.GetFloat("_VertexOcclusion"));
                        }

                        if (material.HasProperty("_SubsurfaceMode"))
                        {
                            if (material.GetInt("_SubsurfaceMode") == 0)
                            {
                                material.SetFloat("_SubsurfaceMinValue", 0);
                                material.SetFloat("_SubsurfaceMaxValue", 1);
                            }
                            else
                            {
                                material.SetFloat("_SubsurfaceMinValue", 1);
                                material.SetFloat("_SubsurfaceMaxValue", 0);
                            }
                        }

                        if (material.HasProperty("_ObjectThicknessValue"))
                        {
                            material.SetFloat("_SubsurfaceValue", 1 - material.GetFloat("_ObjectThicknessValue"));
                        }

                        material.SetInt("_IsVersion", 110);
                    }
                }

            }
        }

        void UpdateTo120()
        {
            for (int i = 0; i < materialPaths.Length; i++)
            {
                var material = AssetDatabase.LoadAssetAtPath<Material>(materialPaths[i]);

                if (material.shader.name.Contains("Bark Advanced Lit"))
                {
                    material.shader = Shader.Find("BOXOPHOBIC/The Vegetation Engine/Vegetation/Bark Standard Lit");
                }
            }
        }

        void UpdateTo130()
        {
            for (int i = 0; i < materialPaths.Length; i++)
            {
                var material = AssetDatabase.LoadAssetAtPath<Material>(materialPaths[i]);

                if (materialPaths[i].Contains("TVE Material"))
                {
                    if (material.GetInt("_IsVersion") < 130)
                    {
                        if (material.HasProperty("__surface"))
                        {
                            material.SetFloat("_render_mode", material.GetFloat("__surface"));
                        }

                        if (material.HasProperty("__cull"))
                        {
                            material.SetFloat("_render_cull", material.GetFloat("__cull"));
                        }

                        if (material.HasProperty("__normals"))
                        {
                            material.SetFloat("_render_normals", material.GetFloat("__normals"));
                        }

                        if (material.HasProperty("__normalsoptions"))
                        {
                            material.SetFloat("_render_normals_options", material.GetFloat("__normalsoptions"));
                        }

                        if (material.HasProperty("__blend"))
                        {
                            material.SetFloat("_render_blend", material.GetFloat("__blend"));
                        }

                        if (material.HasProperty("__clip"))
                        {
                            material.SetFloat("_render_clip", material.GetFloat("__clip"));
                        }

                        if (material.HasProperty("__priority"))
                        {
                            material.SetFloat("_render_priority", material.GetFloat("__priority"));
                        }

                        if (material.HasProperty("__premul"))
                        {
                            material.SetFloat("_render_premul", material.GetFloat("__premul"));
                        }

                        if (material.HasProperty("__src"))
                        {
                            material.SetFloat("_render_src", material.GetFloat("__src"));
                        }

                        if (material.HasProperty("__dst"))
                        {
                            material.SetFloat("_render_dst", material.GetFloat("__dst"));
                        }

                        if (material.HasProperty("__zw"))
                        {
                            material.SetFloat("_render_zw", material.GetFloat("__zw"));
                        }

                        material.SetInt("_IsVersion", 130);
                    }
                }
            }

            // Get all TVE Meshes
            var allMeshesPaths = Directory.GetFiles("Assets/", "*.asset", SearchOption.AllDirectories);
            allMeshesPaths = Array.FindAll(allMeshesPaths, (s) => { return s.Contains("TVE Mesh") && s.EndsWith(".asset"); });

            for (int i = 0; i < allMeshesPaths.Length; i++)
            {
                EditorUtility.DisplayProgressBar("The Vegetation Engine", "Converting " + Path.GetFileName(allMeshesPaths[i]), i * 1f / allMeshesPaths.Length);

                var oldMesh = AssetDatabase.LoadAssetAtPath<Mesh>(allMeshesPaths[i]);

                // Enable IsReadable manually in text mode
                string filePath = Path.Combine(Directory.GetCurrentDirectory(), allMeshesPaths[i]);
#if UNITY_EDITOR_WIN
                filePath = filePath.Replace("/", "\\");
#endif
                string fileText = File.ReadAllText(filePath);
                fileText = fileText.Replace("m_IsReadable: 0", "m_IsReadable: 1");
                File.WriteAllText(filePath, fileText);
                AssetDatabase.Refresh();

                var newMesh = Instantiate(oldMesh);
                var newPath = allMeshesPaths[i].Replace(".asset", ".mesh");

                if (newMesh.isReadable)
                {
                    var UV4 = new List<Vector4>();
                    oldMesh.GetUVs(3, UV4);

                    // Create new Data
                    var newColors = new List<Color>(oldMesh.vertexCount);
                    var newUV4 = new List<Vector4>(oldMesh.vertexCount);

                    //Calculate new Data
                    for (int j = 0; j < oldMesh.vertexCount; j++)
                    {
                        float x = ((Mathf.RoundToInt(UV4[j].x) >> 0) & 0xFF) / 255.0f;
                        float y = ((Mathf.RoundToInt(UV4[j].x) >> 8) & 0xFF) / 255.0f;
                        float z = ((Mathf.RoundToInt(UV4[j].x) >> 16) & 0xFF) / 255.0f;

                        newColors.Add(new Color(oldMesh.colors[j].a, oldMesh.colors[j].g, oldMesh.colors[j].r, x));
                        newUV4.Add(new Vector4(x, y, z, 0));
                    }

                    // Assign new Data
                    newMesh.SetColors(newColors);
                    newMesh.SetUVs(3, newUV4);

                    AssetDatabase.MoveAsset(allMeshesPaths[i], newPath);
                    oldMesh.Clear();
                    EditorUtility.CopySerialized(newMesh, oldMesh);
                }
                else
                {
                    Debug.Log("The following mesh cannot be converted " + Path.GetFileName(allMeshesPaths[i]) + ". Manual prefab rencoversion is needed!");
                }
            }
        }

        void UpdateTo140()
        {
            for (int i = 0; i < materialPaths.Length; i++)
            {
                var material = AssetDatabase.LoadAssetAtPath<Material>(materialPaths[i]);

                if (materialPaths[i].Contains("TVE Material"))
                {
                    if (material.GetInt("_IsVersion") < 140)
                    {
                        if (material.HasProperty("_UseMotion_Main"))
                        {
                            material.SetFloat("_Motion_10", material.GetFloat("_UseMotion_Main"));
                        }

                        if (material.HasProperty("_Motion_Main"))
                        {
                            material.SetFloat("_Motion_20", material.GetFloat("_UseMotion_Main"));
                        }

                        if (material.HasProperty("_UseMotion_Leaves"))
                        {
                            material.SetFloat("_Motion_30", material.GetFloat("_UseMotion_Leaves"));
                        }

                        if (material.HasProperty("_UseMotion_Leaves"))
                        {
                            material.SetFloat("_Motion_32", material.GetFloat("_UseMotion_Leaves"));
                        }

                        material.SetInt("_IsVersion", 140);
                    }
                }
            }
        }

        // Check for latest version
        //UnityWebRequest www;

        //IEnumerator StartRequest(string url, Action success = null)
        //{
        //    using (www = UnityWebRequest.Get(url))
        //    {
        //        yield return www.Send();

        //        while (www.isDone == false)
        //            yield return null;

        //        if (success != null)
        //            success();
        //    }
        //}

        //public static void StartBackgroundTask(IEnumerator update, Action end = null)
        //{
        //    EditorApplication.CallbackFunction closureCallback = null;

        //    closureCallback = () =>
        //    {
        //        try
        //        {
        //            if (update.MoveNext() == false)
        //            {
        //                if (end != null)
        //                    end();
        //                EditorApplication.update -= closureCallback;
        //            }
        //        }
        //        catch (Exception ex)
        //        {
        //            if (end != null)
        //                end();
        //            Debug.LogException(ex);
        //            EditorApplication.update -= closureCallback;
        //        }
        //    };

        //    EditorApplication.update += closureCallback;
        //}
    }
}
