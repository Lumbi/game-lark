using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInputTouchJoystickUI : MonoBehaviour
{
    public PlayerInput input;
    public GameObject graphics;
    private bool enableAtNextFrame = false;

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

        if (input.PointerIsDown() && input.MoveDirection() != Vector2.zero) {
            transform.position = input.PointerStartPosition();
            transform.right = input.MoveDirection();
            enableAtNextFrame = true;
        } else {
            if (graphics.activeSelf) { graphics.SetActive(false); }
        }
    }
}
