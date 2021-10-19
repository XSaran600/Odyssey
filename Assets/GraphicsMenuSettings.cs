using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GraphicsMenuSettings : MonoBehaviour
{
    public Dropdown m_Dropdown;
    public Text m_Text;
    public string[] namez;

    void Start()
    {
        //Add listener for when the value of the Dropdown changes, to take action
        m_Dropdown.onValueChanged.AddListener(delegate {
            DropdownValueChanged(m_Dropdown);
        });

        //Initialise the Text to say the first value of the Dropdown
        Debug.Log("First Value : " + m_Dropdown.value);
    }

    //Ouput the new value of the Dropdown into Text
    void DropdownValueChanged(Dropdown change)
    {
        Debug.Log("Change Value : " + change.value);
        QualitySettings.SetQualityLevel(change.value, true);
        namez = QualitySettings.names;
    }
}
