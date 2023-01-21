using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotatingWall : MonoBehaviour
{
    public float rotateBy = 180f;
    public float rotateDuration = 1f;

    private bool isRotating = false;
    private Vector2 angularVelocity = Vector2.zero;

    public void Rotate() {
        if (!isRotating) {
            StartCoroutine(_Rotate());
        }
    }

    private IEnumerator _Rotate()
    {
        isRotating = true;
        float time = 0f;
        float startAngle = transform.localEulerAngles.z;
        float endAngle = startAngle + rotateBy;
        float currentAngle = startAngle;
        Vector2 endDirection = Quaternion.Euler(0, 0, endAngle) * Vector2.right;
        while (time < rotateDuration) {
            currentAngle = Mathf.SmoothStep(startAngle, endAngle, time / rotateDuration);
            transform.right = Quaternion.Euler(0, 0, currentAngle) * Vector2.right;
            time += Time.deltaTime;
            yield return null;
        }
        transform.right = Quaternion.Euler(0, 0, endAngle) * Vector2.right;

        angularVelocity = Vector2.zero;
        isRotating = false;
    }
}
