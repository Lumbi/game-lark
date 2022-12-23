using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    public Transform target;
    public float speed = 2.0f;

    void LateUpdate()
    {
        if (target != null) {
            float interpolation = speed * Time.deltaTime;
            var position = this.transform.position;
            position.y = Mathf.Lerp(this.transform.position.y, target.transform.position.y, interpolation);
            position.x = Mathf.Lerp(this.transform.position.x, target.transform.position.x, interpolation);

            position.z = -10;
            this.transform.position = position;
        }
    }

    public void FocusOn(Transform target)
    {
        this.target = target;
        this.transform.position = target.position;
    }
}
