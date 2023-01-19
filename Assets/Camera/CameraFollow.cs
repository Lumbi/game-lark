using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    public GameObject target;
    private PlayerDirectionalLight playerDirectionalLight;
    public float targetPredictDistance = 3.0f;
    public float followSmoothTime = 0.5f;
    private Vector2 velocity = Vector2.zero;
    private Vector3 nextPosition = Vector3.zero;

    void LateUpdate()
    {
        if (target != null) {
            Vector2 currentPosition = this.transform.position;
            Vector2 targetPosition = target.transform.position;

            if (playerDirectionalLight != null) {
                targetPosition += (playerDirectionalLight.TargetDirection() * targetPredictDistance);
            }

            nextPosition = Vector2.SmoothDamp(currentPosition, targetPosition, ref velocity, followSmoothTime);
            nextPosition.z = -10;
            this.transform.position = nextPosition;
        }
    }

    public void FocusOn(GameObject target)
    {
        this.target = target;
        this.playerDirectionalLight = target.GetComponentInChildren<PlayerDirectionalLight>();
        this.transform.position = target.transform.position;
    }
}
