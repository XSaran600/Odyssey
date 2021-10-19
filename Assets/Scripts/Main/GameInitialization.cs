using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*---------------------------------------------------------------------------------------------------
*-------------------------------------- Game Initialization -----------------------------------------
*----------------------------------------------------------------------------------------------------
* Purpose: 
* Initializes player globals and anything that requires initialization. 
* ----------
* How to Use: 
* Attach this script to the any game object.
* ----------
* Requires:
* [PlayerGlobals]
*----------------------------------------------------------------------------------------------------*/
public class GameInitialization : MonoBehaviour
{

    void Awake()
    {
        PlayerGlobals.Init();           // Init player global
        Invoke("LateInit", .5f);        // [SAFETY CATCH] Init again after .5 second in case of any non-runtime parameters 
    }

    void LateInit()
    {
        PlayerGlobals.LateInit();
    }

}
