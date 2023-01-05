using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerDirectionalLight : MonoBehaviour
{
    public PlayerInput input;
    public Rigidbody2D body;
    public float alignSmoothTime = 0.09f;
    private Coroutine rotateAlignToCoroutine;
    private Vector2 velocity = Vector2.zero;
    private Vector2 targetDirection = Vector2.zero;
    private Vector2 currentDirection = Vector2.right;

    void LateUpdate()
    {
        if (input.MoveDirection() != Vector2.zero) {
            targetDirection = input.MoveDirection();
        }

        currentDirection = transform.right;

        if (targetDirection != Vector2.zero) {
            if (currentDirection + targetDirection == Vector2.zero) { // if exactly at opposite
               // slightly shift to allow the smooth damp to work with normalized vectors
                currentDirection.x += 0.1f;
                currentDirection.y += 0.1f;
            }
            transform.right = Vector2.SmoothDamp(currentDirection, targetDirection, ref velocity, alignSmoothTime);
            transform.right.Normalize();
        }
    }
}
