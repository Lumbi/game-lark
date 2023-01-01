using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    public GameObject target;
    public float speed = 1.0f;
    public float targetPredictTime = 1.0f;

    void LateUpdate()
    {
        if (target != null) {
            float interpolation = speed * Time.deltaTime;
            Vector3 targetPosition = target.transform.position;
            Rigidbody2D targetBody = target.GetComponent<Rigidbody2D>();

            if (targetBody) {
                Vector3 delta = targetBody.velocity * targetPredictTime;
                targetPosition += delta;
            }

            var position = this.transform.position;
            position.y = Mathf.Lerp(this.transform.position.y, targetPosition.y, interpolation);
            position.x = Mathf.Lerp(this.transform.position.x, targetPosition.x, interpolation);

            position.z = -10;
            this.transform.position = position;
        }
    }

    public void FocusOn(GameObject target)
    {
        this.target = target;
        this.transform.position = target.transform.position;
    }
}
