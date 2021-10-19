// Author: Saran Krishnaraja
// Reference: https://youtu.be/0VGosgaoTsw

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//using Beautifyy.Universall;
using BeautifyHDRP;
using UnityEngine.Rendering;

/*---------------------------------------------------------------------------------------------------
*------------------------------------------ Time Manager --------------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* Slows time temporarily for dramatic effect or gameplay mechanic.
* ----------
* How to Use: 
* call TimeManager.SlowMotion(timeFactor, duration);
*----------------------------------------------------------------------------------------------------*/
public class TimeManager : MonoBehaviour
{
    private static bool reverting;
    private static float remainingTime;
    private static float factor;
    private static float dur;
    private static float delay;
    //private static BeautifySettings _beautifySettings;
    private static Volume _beautifyVolume;
    private static Beautify _beautify;

    private void Update()
    {
        if (delay >= 0)
            delay -= Time.unscaledDeltaTime;
        
        if (delay < 0 && delay > -1) {
            SlowMotion(factor, dur);
            delay = -1;
        }

        if (remainingTime >= 0)
            remainingTime -= Time.unscaledDeltaTime;
        
        if (remainingTime < 0 && remainingTime > -1) {
            reverting = true;
            remainingTime = -1;
        }

        if (reverting) {
            ResetBeautifyPostProcess();
            Time.timeScale += 2f * Time.unscaledDeltaTime;
            Time.timeScale = Mathf.Clamp(Time.timeScale, 0f, 1f);
            if (Time.timeScale >= 1f) {
                reverting = false;
            }
        }
    }

    // For physics updates
    private void FixedUpdate()
    {
        if (reverting) {
            Time.fixedDeltaTime += 0.04f * Time.unscaledDeltaTime;
            Time.fixedDeltaTime = Mathf.Clamp(Time.fixedDeltaTime, 0f, 0.02f);
            if (Time.timeScale >= 1f) {
                Time.fixedDeltaTime = 0.02f;
            }
        }
    }

    /// <summary>
    /// Static slow motion that can be called anywhere. Time factor of 0.1f for example is 10% speed.
    /// </summary>
    public static void SlowMotion(float timeFactor, float duration)
    {
        Time.timeScale = timeFactor;
        Time.fixedDeltaTime = timeFactor * 0.02f;
        remainingTime = duration;

        //_beautifySettings = PlayerGlobals.postProcessing.GetComponent<Beautify>();
        _beautifyVolume = FindBeautifyVolume();
        _beautifyVolume.profile.TryGet(out _beautify);

        //_beautify.bloomIntensity.value = 1.6f;
        //_beautify.anamorphicFlaresIntensity.value = 1.6f;
        _beautify.saturate.value = -1.9f;
        _beautify.brightness.value = 1.5f;
        //_beautify.depthOfFieldDistance.value = 1.0f;

    }

    /// <summary>
    /// Overload optional parameter, delay is time before slow begins.
    /// </summary>
    public static void SlowMotion(float timeFactor, float duration, float delayTime)
    {
        factor = timeFactor;
        dur = duration;
        delay = delayTime;
    }

    /// <summary>
    /// Fetch post processing stack
    /// </summary>
    private static Volume FindBeautifyVolume()
    {
        Volume[] vols = FindObjectsOfType<Volume>();
        foreach (Volume volume in vols)
        {
           if (volume.sharedProfile != null && volume.sharedProfile.Has<Beautify>())
           {
               _beautifyVolume = volume;
               return volume;
           }
        }
        return null;
    }

    /// <summary>
    /// Reset post processing effects to default values
    /// </summary>
    private static void ResetBeautifyPostProcess()
    {
        //_beautify.bloomIntensity.value = 0.2f;
        //_beautify.anamorphicFlaresIntensity.value = 0f;
        _beautify.saturate.value = 0.75f;
        _beautify.brightness.value = 1.025f;
        //_beautify.depthOfFieldDistance.value = 2.5f;
    }

}