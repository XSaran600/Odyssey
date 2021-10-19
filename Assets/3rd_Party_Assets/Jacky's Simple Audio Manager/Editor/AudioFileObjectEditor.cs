using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace JSAM
{
    [CustomEditor(typeof(AudioFileObject))]
    [CanEditMultipleObjects]
    public class AudioFileObjectEditor : Editor
    {
        Color buttonPressedColor = new Color(0.475f, 0.475f, 0.475f);

        static bool showFadeTool;

        static bool showHowTo;

        AudioClip playingClip;

        bool clipPlaying;
        bool playingRandom;

        Texture2D cachedTex;
        bool forceRepaint;
        AudioClip cachedClip;

        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            AudioFileObject myScript = (AudioFileObject)target;

            EditorGUILayout.LabelField("Audio File Object", EditorStyles.boldLabel);

            string theName = AudioManagerEditor.ConvertToAlphanumeric(myScript.name);
            EditorGUILayout.LabelField("Name: " + theName);

            EditorGUILayout.HelpBox(theName + " is the name that AudioManager will use to reference this object with.", MessageType.None);

            bool noFiles = myScript.GetFile() == null && myScript.IsLibraryEmpty();
            if (noFiles)
            {
                EditorGUILayout.HelpBox("Error! Add an audio file before running!", MessageType.Error);
            }
            if (myScript.name.Contains("NEW AUDIO FILE") || myScript.name.Equals("None") || myScript.name.Equals("GameObject"))
            {
                EditorGUILayout.HelpBox("Warning! Change the name of the gameObject to something different or things will break!", MessageType.Warning);
            }

            EditorGUILayout.Space();

            GUIContent blontent = new GUIContent("Use Library", "If true, the single AudioFile will be changed to a list of AudioFiles. AudioManager will choose a random AudioClip from this list when you play this sound");
            bool oldValue = myScript.useLibrary;
            bool newValue = EditorGUILayout.Toggle(blontent, oldValue);
            if (newValue != oldValue) // If you clicked the toggle
            {
                if (newValue)
                {
                    if (myScript.files.Count == 0)
                    {
                        if (myScript.file != null)
                        {
                            myScript.files.Add(myScript.file);
                        }
                    }
                    else if (myScript.files.Count == 1)
                    {
                        if (myScript.files[0] == null)
                        {
                            myScript.files[0] = myScript.file;
                        }
                    }
                }
                else
                {
                    if (myScript.files.Count > 0 && myScript.file == null)
                    {
                        myScript.file = myScript.files[0];
                    }
                }
                myScript.useLibrary = newValue;
            }

            List<string> excludedProperties = new List<string>() { "m_Script", "files" };

            if (myScript.UsingLibrary()) // Swap file with files
            {
                excludedProperties[1] = "file";
            }

            if (noFiles)
            {
                excludedProperties.AddRange(new List<string>() { "spatialize", "loopSound", "priority", "pitchShift", "delay", "ignoreTimeScale", "fadeMode" });
            }

            DrawPropertiesExcluding(serializedObject, excludedProperties.ToArray());

            Color colorbackup = GUI.backgroundColor;
            GUIStyle boldFoldout = new GUIStyle(EditorStyles.foldout);
            boldFoldout.fontStyle = FontStyle.Bold;
            using (new EditorGUI.DisabledScope(myScript.fadeMode == FadeMode.None))
            {
                if (!myScript.IsLibraryEmpty())
                {
                    showFadeTool = EditorGUILayout.Foldout(showFadeTool, new GUIContent("Fade Tool", "Show/Hide the Audio Fade previewer"), boldFoldout);
                    if (showFadeTool)
                    {
                        if (playingClip == null)
                        {
                            DesignateActiveAudioClip(myScript);
                        }
                        Rect progressRect = ProgressBar(helperSource.time / playingClip.length, GetInfoString());

                        GUIContent fContent = new GUIContent();
                        SerializedProperty fadeInDuration = serializedObject.FindProperty("fadeInDuration");
                        SerializedProperty fadeOutDuration = serializedObject.FindProperty("fadeOutDuration");
                        GUIStyle rightJustified = new GUIStyle(EditorStyles.label);
                        rightJustified.alignment = TextAnchor.UpperRight;
                        rightJustified.padding = new RectOffset(0, 15, 0, 0);
                        switch (myScript.fadeMode)
                        {
                            case FadeMode.FadeIn:
                                EditorGUILayout.BeginHorizontal();
                                EditorGUILayout.LabelField(new GUIContent("Fade In Time:    " + TimeToString(fadeInDuration.floatValue * playingClip.length), "Fade in time for this AudioClip in seconds"));
                                EditorGUILayout.LabelField(new GUIContent("Song Length: " + TimeToString(playingClip.length), "Length of the preview clip in seconds"), rightJustified);
                                EditorGUILayout.EndHorizontal();
                                EditorGUILayout.Slider(fadeInDuration, 0, 1);
                                break;
                            case FadeMode.FadeOut:
                                EditorGUILayout.BeginHorizontal();
                                EditorGUILayout.LabelField(new GUIContent("Fade Out Time: " + TimeToString(fadeOutDuration.floatValue * playingClip.length), "Fade out time for this AudioClip in seconds"));
                                EditorGUILayout.LabelField(new GUIContent("Song Length: " + TimeToString(playingClip.length), "Length of the preview clip in seconds"), rightJustified);
                                EditorGUILayout.EndHorizontal();
                                EditorGUILayout.Slider(fadeOutDuration, 0, 1);
                                break;
                            case FadeMode.FadeInAndOut:
                                EditorGUILayout.BeginHorizontal();
                                EditorGUILayout.LabelField(new GUIContent("Fade In Time:    " + TimeToString(fadeInDuration.floatValue * playingClip.length), "Fade in time for this AudioClip in seconds"));
                                EditorGUILayout.LabelField(new GUIContent("Song Length: " + TimeToString(playingClip.length), "Length of the preview clip in seconds"), rightJustified);
                                EditorGUILayout.EndHorizontal();
                                EditorGUILayout.LabelField(new GUIContent("Fade Out Time: " + TimeToString(fadeOutDuration.floatValue * playingClip.length), "Fade out time for this AudioClip in seconds"));
                                float fid = fadeInDuration.floatValue;
                                float fod = fadeOutDuration.floatValue;
                                fContent = new GUIContent("Fade In Percentage", "The percentage of time the sound takes to fade-in relative to it's total length.");
                                fid = Mathf.Clamp(EditorGUILayout.Slider(fContent, fid, 0, 1), 0, 1 - fod);
                                fContent = new GUIContent("Fade Out Percentage", "The percentage of time the sound takes to fade-out relative to it's total length.");
                                fod = Mathf.Clamp(EditorGUILayout.Slider(fContent, fod, 0, 1), 0, 1 - fid);
                                fadeInDuration.floatValue = fid;
                                fadeOutDuration.floatValue = fod;
                                EditorGUILayout.HelpBox("Note: The sum of your Fade-In and Fade-Out durations cannot exceed 1 (the length of the sound).", MessageType.None);
                                break;
                        }
                        EditorGUILayout.BeginHorizontal();
                        if (clipPlaying)
                        {
                            GUI.backgroundColor = buttonPressedColor;
                            fContent = new GUIContent("Stop", "Stop playback");
                        }
                        else
                        {
                            fContent = new GUIContent("Play", "Play a preview of the sound with it's current sound settings.");
                        }
                        if (GUILayout.Button(fContent))
                        {
                            helperSource.Stop();
                            if (playingClip != null && !clipPlaying)
                            {
                                StartFading(myScript);
                            }
                            else
                            {
                                clipPlaying = false;
                            }
                        }
                        GUI.backgroundColor = colorbackup;
                        using (new EditorGUI.DisabledScope(!myScript.useLibrary))
                        {
                            if (GUILayout.Button(new GUIContent("Play Random", "Preview settings with a random track from your library. Only usable if this Audio File has \"Use Library\" enabled.")))
                            {
                                DesignateRandomAudioClip(myScript);
                                helperSource.Stop();
                                StartFading(myScript);
                            }
                        }
                        GUILayout.FlexibleSpace();
                        EditorGUILayout.EndHorizontal();
                    }
                }
            }

            if (serializedObject.hasModifiedProperties)
            {
                forceRepaint = true;
                serializedObject.ApplyModifiedProperties();
            }

            EditorGUILayout.Space();

            #region Quick Reference Guide
            showHowTo = EditorGUILayout.Foldout(showHowTo, "Quick Reference Guide", boldFoldout);
            if (showHowTo)
            {
                EditorGUILayout.Space();

                EditorGUILayout.LabelField("Overview", EditorStyles.boldLabel);
                EditorGUILayout.HelpBox("Audio File Objects are containers that hold your sound files to be read by Audio Manager."
                    , MessageType.None);
                EditorGUILayout.HelpBox("No matter the filename or folder location, this Audio File will be referred to as it's name above"
                    , MessageType.None);

                EditorGUILayout.Space();

                EditorGUILayout.LabelField("Tips", EditorStyles.boldLabel);
                EditorGUILayout.HelpBox("If your one sound has many different variations available, try enabling the \"Use Library\" option " +
                    "just below the name field. This let's AudioManager play a random different sound whenever you choose to play from this audio file object."
                    , MessageType.None);
                EditorGUILayout.HelpBox("Relative volume only helps to reduce how loud a sound is. To increase how loud an individual sound is, you'll have to " +
                    "edit it using a sound editor."
                    , MessageType.None);
            }
            #endregion  

            //if (GUILayout.Button("Test"))
            //{
            //    myScript.GetFolderDepth("Assets/Jacky's Simple Audio Manager/Examples/First-Person 3D/Audio Files");
            //}
        }

        public void DesignateActiveAudioClip(AudioFileObject myScript)
        {
            AudioClip theClip = null;
            if (!myScript.IsLibraryEmpty())
            {
                theClip = myScript.GetFirstAvailableFile();
            }
            if (theClip != null)
            {
                playingClip = theClip;
            }
        }

        public void DesignateRandomAudioClip(AudioFileObject myScript)
        {
            AudioClip theClip = playingClip;
            if (!myScript.IsLibraryEmpty())
            {
                List<AudioClip> files = myScript.GetFiles();
                while (theClip == null || theClip == playingClip)
                {
                    theClip = files[Random.Range(0, files.Count)];
                }
            }
            playingClip = theClip;
            playingRandom = true;
        }

        void Update()
        {
            if (playingClip != null)
            {
                AudioFileObject myScript = (AudioFileObject)target;
                if (playingClip != cachedClip)
                {
                    forceRepaint = true;
                    cachedClip = myScript.GetFirstAvailableFile();
                }

                if (!clipPlaying && playingRandom)
                {
                    DesignateActiveAudioClip(myScript);
                }

                if (clipPlaying)
                {
                    Repaint();
                }
                HandleFading();
            }
            clipPlaying = (playingClip != null && helperSource.isPlaying);
        }

        void OnEnable()
        {
            EditorApplication.update += Update;
            Undo.undoRedoPerformed += OnUndoRedo;
            CreateAudioHelper();
        }

        void OnDisable()
        {
            EditorApplication.update -= Update;
            Undo.undoRedoPerformed -= OnUndoRedo;
            DestroyAudioHelper();
        }

        void OnUndoRedo()
        {
            forceRepaint = true;
        }

        FadeMode fadeMode;
        GameObject helperObject;
        float fadeInTime, fadeOutTime;
        AudioSource helperSource;

        void CreateAudioHelper()
        {
            if (helperObject == null)
            {
                helperObject = GameObject.Find("JSAM Audio Helper");
                if (helperObject == null)
                    helperObject = new GameObject("JSAM Audio Helper");
                helperSource = helperObject.AddComponent<AudioSource>();
                helperObject.hideFlags = HideFlags.HideAndDontSave;
            }
        }

        void DestroyAudioHelper()
        {
            helperSource.Stop();
            DestroyImmediate(helperObject);
        }

        void HandleFading()
        {
            if (helperSource.isPlaying)
            {
                EditorApplication.QueuePlayerLoopUpdate();
                switch (fadeMode)
                {
                    case FadeMode.FadeIn:
                        if (helperSource.time < fadeInTime)
                        {
                            if (fadeInTime == float.Epsilon)
                            {
                                helperSource.volume = 1;
                            }
                            else
                            {
                                helperSource.volume = Mathf.Clamp01(helperSource.time / fadeInTime);
                            }
                        }
                        break;
                    case FadeMode.FadeOut:
                        if (helperSource.time >= playingClip.length - fadeOutTime)
                        {
                            if (fadeOutTime == float.Epsilon)
                            {
                                helperSource.volume = 1;
                            }
                            else
                            {
                                helperSource.volume = Mathf.Clamp01((playingClip.length - helperSource.time) / fadeOutTime);
                            }
                        }
                        break;
                    case FadeMode.FadeInAndOut:
                        if (helperSource.time < playingClip.length - fadeOutTime)
                        {
                            if (fadeInTime == float.Epsilon)
                            {
                                helperSource.volume = 1;
                            }
                            else
                            {
                                helperSource.volume = Mathf.Clamp01(helperSource.time / fadeInTime);
                            }
                        }
                        else
                        {
                            if (fadeOutTime == float.Epsilon)
                            {
                                helperSource.volume = 1;
                            }
                            else
                            {
                                helperSource.volume = Mathf.Clamp01((playingClip.length - helperSource.time) / fadeOutTime);
                            }
                        }
                        break;
                }
            }
        }

        void StartFading(AudioFileObject myScript)
        {
            CreateAudioHelper();
            fadeMode = myScript.fadeMode;
            fadeInTime = myScript.fadeInDuration * playingClip.length;
            fadeOutTime = myScript.fadeOutDuration * playingClip.length;
            // To prevent divisions by 0
            if (fadeInTime == 0) fadeInTime = float.Epsilon;
            if (fadeOutTime == 0) fadeOutTime = float.Epsilon;
            helperSource.clip = playingClip;
            helperSource.volume = 1;
            helperSource.Play();
        }

        /// <summary>
        /// Conveniently draws a progress bar
        /// Referenced from the official Unity documentation
        /// https://docs.unity3d.com/ScriptReference/Editor.html
        /// </summary>
        /// <param name="value"></param>
        /// <param name="label"></param>
        /// <returns></returns>
        Rect ProgressBar(float value, string label)
        {
            EditorGUILayout.Space();

            // Get a rect for the progress bar using the same margins as a TextField:
            Rect rect = GUILayoutUtility.GetRect(64, 64, "TextField");

            AudioClip sound = playingClip;

            if (cachedTex == null || forceRepaint)
            {
                Texture2D waveformTexture = PaintWaveformSpectrum(sound, (int)rect.width, (int)rect.height, new Color(1, 0.5f, 0));
                cachedTex = waveformTexture;
                if (waveformTexture != null)
                    GUI.DrawTexture(rect, waveformTexture);
                forceRepaint = false;
            }
            else
            {
                GUI.DrawTexture(rect, cachedTex);
            }

            if (playingClip != null)
            {
                Rect progressRect = new Rect(rect);
                progressRect.width *= value;
                progressRect.xMin = progressRect.xMax - 1;
                GUI.Box(progressRect, "", "SelectionRect");
            }

            EditorGUILayout.Space();

            return rect;
        }

        /// <summary>
        /// Code from these gents
        /// https://answers.unity.com/questions/189886/displaying-an-audio-waveform-in-the-editor.html
        /// </summary>
        public Texture2D PaintWaveformSpectrum(AudioClip audio, int width, int height, Color col)
        {
            if (Event.current.type != EventType.Repaint) return null;

            Texture2D tex = new Texture2D(width, height, TextureFormat.RGBA32, false);
            float[] samples = new float[audio.samples];
            float[] waveform = new float[width];
            audio.GetData(samples, 0);

            int packSize = (audio.samples / width) + 1;
            int s = 0;
            for (int i = 0; i < audio.samples; i += packSize)
            {
                waveform[s] = Mathf.Abs(samples[i]);
                s++;
            }

            AudioFileObject myScript = (AudioFileObject)target;

            float fadeInDuration = myScript.fadeInDuration;
            float fadeOutDuration = myScript.fadeOutDuration;

            Color lightShade = new Color(0.3f, 0.3f, 0.3f);
            int halfHeight = (int)(height / 2);
            switch (myScript.fadeMode)
            {
                case FadeMode.FadeIn:
                    {
                        for (int x = 0; x < (int)(fadeInDuration * width); x++)
                        {
                            int amountToPaint = (int)Mathf.Lerp(0, halfHeight, ((float)x / (float)width) / fadeInDuration);
                            for (int y = halfHeight; y >= 0; y--)
                            {
                                switch (amountToPaint)
                                {
                                    case 0:
                                        tex.SetPixel(x, y, Color.black);
                                        break;
                                    default:
                                        tex.SetPixel(x, y, lightShade);
                                        break;
                                }
                                amountToPaint = Mathf.Clamp(amountToPaint - 1, 0, height);
                            }
                            for (int y = halfHeight; y < height; y++)
                            {
                                tex.SetPixel(x, halfHeight - y, tex.GetPixel(x, y - halfHeight));
                            }
                        }
                        for (int x = (int)(fadeInDuration * width); x < width; x++)
                        {
                            for (int y = 0; y < height; y++)
                            {
                                tex.SetPixel(x, y, lightShade);
                            }
                        }
                    }
                    break;
                case FadeMode.FadeOut:
                    for (int x = 0; x < width - (int)(fadeOutDuration * width); x++)
                    {
                        for (int y = 0; y < height; y++)
                        {
                            tex.SetPixel(x, y, lightShade);
                        }
                    }

                    for (int x = width - (int)(fadeOutDuration * width); x < width; x++)
                    {
                        int amountToPaint = (int)Mathf.Lerp(0, halfHeight, ((width - (float)x) / (float)width) / fadeOutDuration);
                        for (int y = halfHeight; y >= 0; y--)
                        {
                            switch (amountToPaint)
                            {
                                case 0:
                                    tex.SetPixel(x, y, Color.black);
                                    break;
                                default:
                                    tex.SetPixel(x, y, lightShade);
                                    break;
                            }
                            amountToPaint = Mathf.Clamp(amountToPaint - 1, 0, height);
                        }
                        for (int y = halfHeight; y < height; y++)
                        {
                            tex.SetPixel(x, halfHeight - y, tex.GetPixel(x, y - halfHeight));
                        }
                    }
                    break;
                case FadeMode.FadeInAndOut:
                    {
                        for (int x = 0; x < (int)(fadeInDuration * width); x++)
                        {
                            int amountToPaint = (int)Mathf.Lerp(0, halfHeight, ((float)x / (float)width) / fadeInDuration);
                            for (int y = halfHeight; y >= 0; y--)
                            {
                                switch (amountToPaint)
                                {
                                    case 0:
                                        tex.SetPixel(x, y, Color.black);
                                        break;
                                    default:
                                        tex.SetPixel(x, y, lightShade);
                                        break;
                                }
                                amountToPaint = Mathf.Clamp(amountToPaint - 1, 0, height);
                            }
                            for (int y = halfHeight; y < height; y++)
                            {
                                tex.SetPixel(x, halfHeight - y, tex.GetPixel(x, y - halfHeight));
                            }
                        }

                        for (int x = (int)(fadeInDuration * width); x < width - (int)(fadeOutDuration * width); x++)
                        {
                            for (int y = 0; y < height; y++)
                            {
                                tex.SetPixel(x, y, lightShade);
                            }
                        }

                        for (int x = width - (int)(fadeOutDuration * width); x < width; x++)
                        {
                            int amountToPaint = (int)Mathf.Lerp(0, halfHeight, ((width - (float)x) / (float)width) / fadeOutDuration);
                            for (int y = halfHeight; y >= 0; y--)
                            {
                                switch (amountToPaint)
                                {
                                    case 0:
                                        tex.SetPixel(x, y, Color.black);
                                        break;
                                    default:
                                        tex.SetPixel(x, y, lightShade);
                                        break;
                                }
                                amountToPaint = Mathf.Clamp(amountToPaint - 1, 0, height);
                            }
                            for (int y = halfHeight; y < height; y++)
                            {
                                tex.SetPixel(x, halfHeight - y, tex.GetPixel(x, y - halfHeight));
                            }
                        }
                    }
                    break;
            }
            
            for (int x = 0; x < waveform.Length; x++)
            {
                for (int y = 0; y <= waveform[x] * ((float)height * .75f); y++)
                {
                    Color currentPixelColour = tex.GetPixel(x, (height / 2) + y);
                    if (currentPixelColour == Color.black) continue;

                    tex.SetPixel(x, (height / 2) + y, currentPixelColour + col * 0.75f);

                    currentPixelColour = tex.GetPixel(x, (height / 2) - y);
                    tex.SetPixel(x, (height / 2) - y, currentPixelColour + col * 0.75f);
                }
            }
            tex.Apply();

            return tex;
        }

        public static string TimeToString(float time)
        {
            time *= 1000;
            int minutes = (int)time / 60000;
            int seconds = (int)time / 1000 - 60 * minutes;
            int milliseconds = (int)time - minutes * 60000 - 1000 * seconds;
            return string.Format("{0:00}:{1:00}:{2:000}", minutes, seconds, milliseconds);
        }
    }
}