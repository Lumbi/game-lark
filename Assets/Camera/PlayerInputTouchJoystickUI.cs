using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInputTouchJoystickUI : MonoBehaviour
{
    public PlayerInput input;
    public GameObject graphics;
    private bool enableAtNextFrame = false;

    public enum Control { move, look }

    public Control control;

    void Start()
    {
        graphics.SetActive(false);
    }

    void LateUpdate()
    {
        if (enableAtNextFrame && !graphics.activeSelf) {
            graphics.SetActive(true);
        }

        Vector2 vector = Vector2.zero;
        bool isTouching = false;
        Vector2 position = Vector2.zero;
        switch (control) {
            case Control.move:
                isTouching = input.Move();
                vector = input.Movement();
                position = input.LeftTouchPosition();
                break;
            case Control.look:
                isTouching = input.Look();
                vector = input.LookDirection();
                position = input.RightTouchPosition();
                break;
        }

        if (input.UsingTouch() && isTouching && vector != Vector2.zero) {
            transform.right = vector;
            transform.right.Normalize();
            if (enableAtNextFrame == false) {
                transform.position = position;
                enableAtNextFrame = true;
            }
        } else {
            if (graphics.activeSelf) {
                graphics.SetActive(false);
                enableAtNextFrame = false;
            }
        }
    }
}
