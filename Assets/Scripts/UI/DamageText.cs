using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class DamageText : MonoBehaviour
{
    public Text damageText;
    private static DamageText _instance;
    public static DamageText Instance { get { return _instance; } }
    private Vector3 defaultPos;

    void Awake()
    {
        damageText = GameObject.FindWithTag("PlayerDMGText").GetComponent<Text>();

            if (_instance != null) {
                DestroyImmediate(gameObject);
                return;
            }
            _instance = this;
            DontDestroyOnLoad(gameObject);

        defaultPos = damageText.gameObject.transform.localPosition;
    }

    public void CreateFloatingDMGText(string text, float duration)
    {
        damageText.gameObject.transform.DOLocalMove(damageText.gameObject.transform.localPosition + new Vector3(0f, 50.0f, 0f), 1.0f).SetEase(Ease.Linear);
        damageText.gameObject.transform.DOPunchScale(new Vector3(0.75f,1f,0.75f), 0.75f, 1, 0.25f);
        damageText.text = text;
        Invoke("DestroyFloatingDMGText", duration);
    }

    void DestroyFloatingDMGText()
    {
        damageText.text = "";
        damageText.gameObject.transform.localPosition = defaultPos;
    }


}
