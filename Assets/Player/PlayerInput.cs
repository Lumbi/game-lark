using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInput : MonoBehaviour
{
    private Vector2 moveDirection = Vector2.zero;
    private bool dash = false;
    private bool dashBackBuffer = false; // Back buffer is needed to avoid relying on the component order
    private Vector2 dashDirection = Vector2.zero;

    public bool Move() { return ControllerAxisIsActive() || PointerIsDown(); }

    public Vector2 MoveDirection() { return moveDirection; }

    public bool Dash() { return dash; }

    public Vector2 DashDirection() { return dashDirection; }

    void Update()
    {
        UpdateControllerInput();
        UpdatePointerInput();
    }

    void LateUpdate()
    {
        LateUpdatePointerInput();

        // Swap dash flag back buffer
        dash = dashBackBuffer;
        dashBackBuffer = false;
    }

    // Controller-like input

    private bool ControllerAxisIsActive()
    {
        return Input.GetAxis("Horizontal") != 0 || Input.GetAxis("Vertical") != 0;
    }

    private void UpdateControllerInput()
    {
        moveDirection.x = Input.GetAxis("Horizontal");
        moveDirection.y = Input.GetAxis("Vertical");
        moveDirection.Normalize();

        dashDirection = moveDirection;

        if (ControllerAxisIsActive() && Input.GetButtonDown("Dash")) {
            dashBackBuffer = true;
        }
    }

    // Pointer-like Input

    private Vector2 pointerStartPosition = Vector2.zero;
    private Vector2 pointerLastPosition = Vector2.zero;
    private Vector2 pointerVelocity = Vector2.zero;
    private bool pointerWasDown = false;
    private float pointerDownDuration = 0f;
    private float pointerDashGestureMaxDuration = 0.3f;
    private float pointerDashGestureMinDistance = 1f;
    private float pointerDashGestureMinSpeed = 1f;

    private bool PointerIsDown()
    {
        return Input.GetMouseButton(0) || Input.touchCount > 0;
    }

    private Vector2 PointerPosition()
    {
        if (Input.GetMouseButton(0)) {
            Vector3 clickPosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            return clickPosition;
        } else if (Input.touchCount > 0) {
            Vector3 tapPosition = Camera.main.ScreenToWorldPoint(Input.GetTouch(0).position);
            for (int i = 1; i < Input.touchCount; i++) {
                tapPosition += Camera.main.ScreenToWorldPoint(Input.GetTouch(i).position);
            }
            tapPosition /= Input.touchCount;
            return tapPosition;
        } else {
            return Vector2.zero;
        }
    }

    private void UpdatePointerInput()
    {
        UpdatePointerMoveDirection();
        UpdatePointerVelocity();
        UpdateDetectPointerDashGesture();
    }

    private void UpdatePointerMoveDirection()
    {
        if (PointerIsDown()) {
            Vector3 pointerPosition = PointerPosition();
            moveDirection = (transform.position - pointerPosition).normalized;
        }
    }

    private void UpdatePointerVelocity()
    {
        if (PointerIsDown()) {
            if (pointerWasDown) {
                pointerVelocity = (PointerPosition() - pointerLastPosition) / Time.deltaTime;
            }
        }
    }

    private void UpdateDetectPointerDashGesture()
    {
        if (PointerIsDown() && pointerWasDown) {
            if (pointerDownDuration < pointerDashGestureMaxDuration) {
                Vector2 pointeDownDistance = PointerPosition() - pointerStartPosition;
                // Trigger dash
                if (pointeDownDistance.magnitude > pointerDashGestureMinDistance && pointerVelocity.magnitude > pointerDashGestureMinSpeed) {
                    dashDirection = pointerVelocity.normalized;
                    dashBackBuffer = true;
                } else {
                    pointerDownDuration += Time.deltaTime;
                }
            }
        } else {
            pointerDownDuration = 0f;
        }
    }

    private void LateUpdatePointerInput()
    {
        if (PointerIsDown()) {
            if (!pointerWasDown) {
                pointerStartPosition = PointerPosition();
            }
            pointerLastPosition = PointerPosition();
            pointerWasDown = true;
        } else {
            pointerWasDown = false;
        }
    }
}
