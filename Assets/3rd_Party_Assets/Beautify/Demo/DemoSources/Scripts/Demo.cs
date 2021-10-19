using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Rendering;
using BeautifyHDRP;

namespace BeautifyHDRP_Demo {
    public class Demo : MonoBehaviour {

        public VolumeProfile profile;
        Beautify settings;

        private void Start() {
            profile.TryGet(out settings);
            UpdateText();
        }

        void Update() {
            if (Input.GetKeyDown(KeyCode.T) || Input.GetMouseButtonDown(0)) {
                settings.active = !settings.active;
                UpdateText();
            }
        }

        void UpdateText() {
            if (settings.active) {
                GameObject.Find("Beautify").GetComponent<Text>().text = "Beautify ON";
            } else {
                GameObject.Find("Beautify").GetComponent<Text>().text = "Beautify OFF";
            }
        }

    }
}
