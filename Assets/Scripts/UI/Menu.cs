using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Menu : MonoBehaviour
{
    public float timeScalePaused = 0.0f;
    public float timeDecrementSteps = 0.05f;
    public bool shouldDisable = false;

    public Vector3 camConstraintPos;

    public Invector.vCamera.vThirdPersonCamera inst;


    public float xSensitiv;
    public float ySensitiv;

    public Vector2 xMinMaxLimit;
    public Vector2 yMinMaxLimit;


    private float xSensitivInit;
    private float ySensitivInit;
    private Vector2 xMinMaxLimitInit;
    private Vector2 yMinMaxLimitInit;

    private void OnEnable()
    {
        Cursor.lockState = CursorLockMode.None;
        camConstraintPos = Camera.main.transform.position;

        inst = GetComponent<Invector.vCamera.vThirdPersonCamera>();

        xSensitivInit = inst.CameraStateList.tpCameraStates[0].xMouseSensitivity;
        ySensitivInit = inst.CameraStateList.tpCameraStates[0].yMouseSensitivity;
        xMinMaxLimitInit = new Vector2(inst.CameraStateList.tpCameraStates[0].xMinLimit, inst.CameraStateList.tpCameraStates[0].xMaxLimit);
        yMinMaxLimitInit = new Vector2(inst.CameraStateList.tpCameraStates[0].yMinLimit, inst.CameraStateList.tpCameraStates[0].yMaxLimit);

        inst.CameraStateList.tpCameraStates[0].xMouseSensitivity = xSensitiv;
        inst.CameraStateList.tpCameraStates[0].yMouseSensitivity = ySensitiv;
        inst.CameraStateList.tpCameraStates[0].xMinLimit = xMinMaxLimit.x;
        inst.CameraStateList.tpCameraStates[0].xMaxLimit = xMinMaxLimit.y;
        inst.CameraStateList.tpCameraStates[0].yMinLimit = yMinMaxLimit.x;
        inst.CameraStateList.tpCameraStates[0].yMaxLimit = yMinMaxLimit.y;

//        Time.timeScale = timeScalePaused;
    }


    private void Update()
    {
        if (Time.timeScale > timeScalePaused && !shouldDisable)
        {
            Time.timeScale = Mathf.Max(Time.timeScale - timeDecrementSteps, 0);
            if (Time.timeScale < 0)
                Time.timeScale = 0.0f;
        }
        else if (shouldDisable)
        {
            Time.timeScale += timeDecrementSteps;
            if (Time.timeScale > 1)
                 GetComponent<Menu>().enabled = false;
        }
        else
        {
            Camera.main.transform.position = camConstraintPos;
        }

    }
    private void OnDisable()
    {
        Time.timeScale = 1.0f;
        Cursor.lockState = CursorLockMode.Locked;
        inst.CameraStateList.tpCameraStates[0].xMouseSensitivity = xSensitivInit;
        inst.CameraStateList.tpCameraStates[0].yMouseSensitivity = ySensitivInit;
        inst.CameraStateList.tpCameraStates[0].xMinLimit = xMinMaxLimitInit.x;
        inst.CameraStateList.tpCameraStates[0].xMaxLimit = xMinMaxLimitInit.y;
        inst.CameraStateList.tpCameraStates[0].yMinLimit = yMinMaxLimitInit.x;
        inst.CameraStateList.tpCameraStates[0].yMaxLimit = yMinMaxLimitInit.y;

    }

}
