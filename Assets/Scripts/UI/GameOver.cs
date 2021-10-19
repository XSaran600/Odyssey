using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class GameOver : MonoBehaviour
{
    public Image blackImgToFade;
    public Image gameOverBackgroundToFade;
    public Text gameOverTextToFade;
    
    public void FadeBlack(float duration)
    {
        blackImgToFade.gameObject.SetActive(true);
        blackImgToFade.DOFade(1.0f, duration);
    }

    public void FadeIn(float duration)
    {
        blackImgToFade.gameObject.SetActive(true);
        blackImgToFade.color = new Color(0,0,0,1);
        blackImgToFade.DOFade(0.0f, duration).SetEase(Ease.InExpo);
        Invoke("DisableBlackImage", duration + 0.02f);
    }

    public void FadeInGameOver(float duration)
    {
        gameOverBackgroundToFade.gameObject.SetActive(true);
        gameOverTextToFade.gameObject.SetActive(true);
        gameOverBackgroundToFade.DOFade(1.0f, duration);
        gameOverTextToFade.DOFade(1.0f, duration);
    }

    private void DisableBlackImage()
    {
        blackImgToFade.gameObject.SetActive(false);
    }
    
}
