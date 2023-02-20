using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInput : MonoBehaviour
{
    private Vector2 moveDirection = Vector2.zero;
    private Vector2 lookDirection = Vector2.zero;
    private bool usingTouch = false;

    public bool UsingTouch() { return usingTouch; }

    public bool Move() { return ControllerAxisIsActive() || LeftTouchIsActive(); }

    public Vector2 Movement() { return moveDirection; }

    public bool Look() { return ControllerAxisIsActive() || RightTouchIsActive(); }

    public Vector2 LookDirection() { return lookDirection; }

    void Update()
    {
        if (Input.touchCount > 0) {
            usingTouch = true;
        } else if (ControllerAxisIsActive()) {
            usingTouch = false;
        }

        if (usingTouch) {
            UpdateTouchInput();
        } else {
            UpdateControllerInput();
        }
    }

    void LateUpdate()
    {
        if (usingTouch) {
            LateUpdateTouchInput();
        }
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
            lookDirection = moveDirection;
        }
    }

    // Touch input

    struct TouchState {
        public bool isDown { get; set; }
        public bool wasDown { get; set; }
        public Vector2 startPosition { get; set; }
        public Vector2 lastPosition { get; set; }
        public Vector2 position { get; set; }
    }

    private TouchState leftTouch = new TouchState();
    private TouchState rightTouch = new TouchState();
    private float touchMoveMinimumDistance = 50f; // Deadzone
    private float touchMoveMaximumDistance = 300f; // found by experimentation, doesn't seem to match joystick size

    private bool LeftTouchIsActive() { return leftTouch.isDown && leftTouch.wasDown; }

    public Vector2 LeftTouchPosition() { return leftTouch.position; }

    private bool RightTouchIsActive() { return rightTouch.isDown && rightTouch.wasDown; }

    public Vector2 RightTouchPosition() { return rightTouch.position; }

    private void UpdateTouchInput()
    {
        UpdateTouchStates();
        UpdateTouchMoveDirection();
        UpdateTouchLookDirection();
    }

    private void UpdateTouchStates()
    {
        UpdateTouchState(ref leftTouch);
        UpdateTouchState(ref rightTouch);

        for (int i = 0; i < 2; i++) {
            if (i < Input.touchCount) {
                Touch touch = Input.GetTouch(0);
                if (touch.position.x < Screen.width / 2f) {
                    UpdateTouchState(touch, ref leftTouch);
                } else {
                    UpdateTouchState(touch, ref rightTouch);
                }
            }
        }
    }

    private void UpdateTouchState(ref TouchState state)
    {
        state.isDown = false;
    }

    private void UpdateTouchState(Touch touch, ref TouchState state)
    {
        state.isDown = true;
        if (!state.wasDown) {
            state.startPosition = touch.position;
        }
        state.position = touch.position;
    }

    private void UpdateTouchMoveDirection()
    {
        if (leftTouch.isDown && leftTouch.wasDown) {
            Vector2 touchDelta = leftTouch.position - leftTouch.startPosition;
            if (touchDelta.magnitude < touchMoveMinimumDistance) {
                // Deadzone
                moveDirection = Vector2.zero;
            } else {
                moveDirection = touchDelta;
                moveDirection = Vector2.ClampMagnitude(moveDirection, touchMoveMaximumDistance);
                moveDirection /= touchMoveMaximumDistance;
            }
        }
    }

    private void UpdateTouchLookDirection()
    {
        if (rightTouch.isDown && rightTouch.wasDown) {
            Vector2 touchDelta = rightTouch.position - rightTouch.startPosition;
            if (touchDelta.magnitude < touchMoveMinimumDistance) {
                // Deadzone
                lookDirection = Vector2.zero;
            } else {
                lookDirection = touchDelta;
                lookDirection = Vector2.ClampMagnitude(lookDirection, touchMoveMaximumDistance);
                lookDirection /= touchMoveMaximumDistance;
            }
        }
    }

    private void LateUpdateTouchInput()
    {
        leftTouch.wasDown = leftTouch.isDown;
        leftTouch.lastPosition = leftTouch.position;
        rightTouch.wasDown = rightTouch.isDown;
        rightTouch.lastPosition = rightTouch.position;
    }
}
