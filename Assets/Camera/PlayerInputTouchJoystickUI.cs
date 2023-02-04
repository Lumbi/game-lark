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
            enableAtNextFrame = false;
        }

        Vector2 vector = Vector2.zero;
        bool isTouching = false;
        switch (control) {
            case Control.move:
                isTouching = input.Move();
                vector = input.Movement();
                break;
            case Control.look:
                isTouching = input.Look();
                vector = input.LookDirection();
                break;
        }

        if (input.UsingTouch() && isTouching && vector != Vector2.zero) {
            transform.right = vector;
            transform.right.Normalize();
            enableAtNextFrame = true;
        } else {
            if (graphics.activeSelf) { graphics.SetActive(false); }
        }
    }
}
