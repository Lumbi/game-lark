using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInput : MonoBehaviour
{

    private Vector2 startPosition = Vector2.zero;
    private Vector2 lastPosition = Vector2.zero;
    private Vector2 velocity = Vector2.zero;
    private bool wasDown = false;

    public bool IsDown()
    {
        return Input.GetMouseButton(0) || Input.touchCount > 0;
    }

    public Vector2 Position()
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

    public Vector2 StartPosition()
    {
        return startPosition;
    }

    public Vector2 Velocity()
    {
        return velocity;
    }

    public Vector2 Distance()
    {
        if (wasDown) {
            return Position() - lastPosition;
        } else {
            return Vector2.zero;
        }
    }

    void Update()
    {
        if (IsDown()) {
            if (wasDown) {
                velocity = (Position() - lastPosition) / Time.deltaTime;
            }
        } else {
            velocity = Vector2.zero;
        }
    }

    void LateUpdate()
    {
        if (IsDown()) {
            lastPosition = Position();
            wasDown = true;
        } else {
            wasDown = false;
        }
    }
}
