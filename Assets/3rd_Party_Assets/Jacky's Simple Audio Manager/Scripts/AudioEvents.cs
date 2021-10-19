using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace JSAM
{
    public class AudioEvents : MonoBehaviour
    {
        public void PlayAudioPlayer(AudioPlayer player)
        {
            player.Play();
        }

        /// <summary>
        /// Takes the name of the Audio enum sound to be played as a string and plays it without spatializing.
        /// </summary>
        /// <param name="enumName">Either specify the name by it's Audio File name or use the entire enum</param>
        public void PlaySoundByEnum(string enumName)
        {
            string name = enumName;
            if (enumName.Contains("."))
            {
                name = enumName.Remove(0, enumName.LastIndexOf('.') + 1);
            }
            string[] enums = System.Enum.GetNames(AudioManager.instance.GetSceneSoundEnum());

            AudioFileObject file;

            for (int i = 0; i < enums.Length; i++)
            {
                if (name.Equals(enums[i]))
                {
                    file = AudioManager.instance.GetSoundLibrary()[i];
                    AudioManager.instance.PlaySoundSpecialInternal(i, null, file.priority, file.pitchShift, file.delay, file.ignoreTimeScale);
                }
            }
        }

        public void PlaySpatializedSoundByEnum(string enumName)
        {
            string name = enumName;
            if (enumName.Contains("."))
            {
                name = enumName.Remove(0, enumName.LastIndexOf('.'));
            }
            string[] enums = System.Enum.GetNames(AudioManager.instance.GetSceneSoundEnum());

            AudioFileObject file;

            for (int i = 0; i < enums.Length; i++)
            {
                if (name.Equals(enums[i]))
                {
                    file = AudioManager.instance.GetSoundLibrary()[i];
                    AudioManager.instance.PlaySoundSpecialInternal(i, transform, file.priority, file.pitchShift, file.delay, file.ignoreTimeScale);
                }
            }
        }
    }
}