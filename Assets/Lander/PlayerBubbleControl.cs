using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerBubbleControl : MonoBehaviour
{
    public float pushingForce = 0.0f;

    private bool isPushing = false;
    private Vector3 pushingDirection;

    void Update()
    {
        if (IsInputActive())
        {
            Vector3 inputPosition = GetInputPosition();
            pushingDirection = (transform.position - inputPosition).normalized;
            if (!isPushing) {
                FindObjectOfType<HUD>().HideControlsHint();
            }
            isPushing = true;
        } else {
            isPushing = false;
        }
    }

    private bool IsInputActive()
    {
        return Input.GetMouseButton(0) || Input.touchCount > 0;
    }

    private Vector3 GetInputPosition()
    {
        if (Input.GetMouseButton(0)) {
            Vector3 clickPosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            clickPosition.z = transform.position.z;
            return clickPosition;
        } else if (Input.touchCount > 0) {
            Vector3 tapPosition = Camera.main.ScreenToWorldPoint(Input.GetTouch(0).position);
            for (int i = 1; i < Input.touchCount; i++) {
                tapPosition += Camera.main.ScreenToWorldPoint(Input.GetTouch(i).position);
            }
            tapPosition /= Input.touchCount;
            tapPosition.z = transform.position.z;
            return tapPosition;
        } else {
            return Vector3.zero;
        }
    }

    void FixedUpdate()
    {
        if (isPushing)
        {
            GetComponent<Rigidbody2D>().AddForce(pushingForce * pushingDirection);
        }
    }
}
