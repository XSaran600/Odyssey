using System;
using System.Collections.Generic;
using UnityEngine;

namespace JSAM
{
    [CreateAssetMenu(fileName = "New Audio File", menuName = "AudioManager/New Audio File Object", order = 1)]
    public class AudioFileObject : ScriptableObject, IComparer<AudioFileObject>
    {
        [Header("Attach audio file here to use")]
        [SerializeField]
        public AudioClip file;

        [Header("Attach audio files here to use")]
        [SerializeField]
        public List<AudioClip> files = new List<AudioClip>();

        [HideInInspector]
        public bool useLibrary;

        [SerializeField]
        [Range(0, 1)]
        [Tooltip("The volume of this Audio File relative to the volume levels defined in the main AudioManager. Leave at 1 to keep unchanged. The lower the value, the quieter it will be during playback.")]
        public float relativeVolume = 1;

        [SerializeField]
        [Tooltip("If true, playback will be affected based on distance and direction from listener")]
        public bool spatialize;

        [Tooltip("If there are several sounds playing at once, sounds with higher priority will be culled by Unity's sound system later than sounds with lower priority.")]
        [SerializeField]
        public Priority priority = Priority.Default;

        [Tooltip("How much random variance to the sound's frequency will be applied when this sound is played. Keep at Very Low for best results.")]
        [SerializeField]
        public Pitch pitchShift = Pitch.VeryLow;

        [Tooltip("Adds a delay in seconds before this sound is played. If the sound loops, delay is only added to when the sound is first played before the first loop.")]
        [SerializeField]
        public float delay = 0;

        [Tooltip("If true, will ignore the \"Time Scaled Sounds\" parameter in AudioManager and will keep playing the sound even when the Time Scale is set to 0")]
        [SerializeField]
        public bool ignoreTimeScale = false;

        [Tooltip("Add fade to your sound. Set the details of this fade using the FadeMode tools")]
        [SerializeField]
        public FadeMode fadeMode;
        [HideInInspector]
        [Tooltip("The percentage of time the sound takes to fade-in relative to it's total length.")]
        [SerializeField]
        public float fadeInDuration;

        [HideInInspector]
        [SerializeField]
        [Tooltip("The percentage of time the sound takes to fade-out relative to it's total length.")]
        public float fadeOutDuration;

        /// <summary>
        /// Don't touch this unless you're modifying AudioManager functionality
        /// </summary>
        [HideInInspector]
        public string safeName = "";
        string folderName = "";
        int folderDepth = -1;

        public AudioClip GetFile()
        {
            return file;
        }

        public List<AudioClip> GetFiles()
        {
            return files;
        }

        public AudioClip GetFirstAvailableFile()
        {
            if (useLibrary)
            {
                foreach (AudioClip f in files)
                {
                    if (f != null) return f;
                }
            }
            else
            {
                return file;
            }
            return null;
        }

        public bool IsLibraryEmpty()
        {
            if (!useLibrary)
            {
                return file == null;
            }
            else
            {
                foreach (AudioClip a in files)
                {
                    if (a != null)
                    {
                        return false;
                    }
                }
            }
            return true;
        }

        public bool HasAudioClip(AudioClip a)
        {
            return file == a || files.Contains(a);
        }

        public bool UsingLibrary()
        {
            return useLibrary;
        }

#if UNITY_EDITOR

        public string GetFolderName(string filePath)
        {
            if (folderName == "")
            {
                string folder = UnityEditor.AssetDatabase.GUIDToAssetPath(UnityEditor.AssetDatabase.FindAssets(name, new[] { filePath })[0]);

            }
            return folderName;
        }

        public int GetFolderDepth(string filePath)
        {
            Debug.Log("HI");
            if (folderDepth == -1 || folderName == "")
            {
                string folder = UnityEditor.AssetDatabase.GUIDToAssetPath(UnityEditor.AssetDatabase.FindAssets(name, new[] { filePath })[0]);
                Debug.Log(folder.Remove(0, filePath.Length + 1));
            }
            return folderDepth;
        }

        public int Compare(AudioFileObject x, AudioFileObject y)
        {
            if (x == null || y == null)
            {
                return 0;
            }

            return x.safeName.CompareTo(y.safeName);
        }
    }
#endif
}