using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInput : MonoBehaviour
{
    private Vector2 moveDirection = Vector2.zero;
    private bool dash = false;
    private bool dashBackBuffer = false; // Back buffer is needed to avoid relying on the component order
    private Vector2 dashDirection = Vector2.zero;
    private bool usingPointer = false;

    public bool UsingPointer() { return usingPointer; }

    public bool Move() { return ControllerAxisIsActive() || PointerIsDown(); }

    public Vector2 Movement() { return moveDirection; }

    public bool Dash() { return dash; }

    public Vector2 DashDirection() { return dashDirection; }

    void Update()
    {
        if (PointerIsDown()) {
            usingPointer = true;
        } else if (ControllerAxisIsActive()) {
            usingPointer = false;
        }

        if (usingPointer) {
            UpdatePointerInput();
        } else {
            UpdateControllerInput();
        }
    }

    void LateUpdate()
    {
        if (usingPointer) {
            LateUpdatePointerInput();
        }

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
        if (ControllerAxisIsActive()) {
            moveDirection.x = Input.GetAxis("Horizontal");
            moveDirection.y = Input.GetAxis("Vertical");
            moveDirection = Vector2.ClampMagnitude(moveDirection, 1f);

            dashDirection = moveDirection;
            if (Input.GetButtonDown("Dash")) {
                dashBackBuffer = true;
            }
        }
    }

    // Pointer-like Input

    private Vector2 pointerStartPosition = Vector2.zero;
    private Vector2 pointerLastPosition = Vector2.zero;
    private Vector2 pointerVelocity = Vector2.zero;
    private bool pointerWasDown = false;
    private float pointerDownDuration = 0f;
    private float pointerDownMaximumDistance = 200f; // found by experimentation, doesn't seem to match joystick size
    private float pointerDashGestureMaxDuration = 0.3f;
    private float pointerDashGestureMinDistance = 1f;
    private float pointerDashGestureMinSpeed = 1f;

    public bool PointerIsDown()
    {
        return Input.GetMouseButton(0) || Input.touchCount == 1;
    }

    public Vector2 PointerStartPosition()
    {
        return pointerStartPosition;
    }

    public Vector2 PointerPosition()
    {
        if (Input.GetMouseButton(0)) {
            return Input.mousePosition;
        } else if (Input.touchCount > 0) {
            return Input.GetTouch(0).position;
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
        if (PointerIsDown() && pointerWasDown) {
            moveDirection = PointerPosition() - pointerStartPosition;
            moveDirection = Vector2.ClampMagnitude(moveDirection, pointerDownMaximumDistance);
            moveDirection /= pointerDownMaximumDistance;
        }
    }

    private void UpdatePointerVelocity()
    {
        if (PointerIsDown() && pointerWasDown) {
            pointerVelocity = (PointerPosition() - pointerLastPosition) / Time.deltaTime;
        }
    }

    // TODO: Re-implement considering new joystick-like controls
    private void UpdateDetectPointerDashGesture()
    {
        if (PointerIsDown() && pointerWasDown) {
            if (pointerDownDuration < pointerDashGestureMaxDuration) {
                Vector2 pointerDownDistance = PointerPosition() - pointerStartPosition;
                // Trigger dash
                if (pointerDownDistance.magnitude > pointerDashGestureMinDistance && pointerVelocity.magnitude > pointerDashGestureMinSpeed) {
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
