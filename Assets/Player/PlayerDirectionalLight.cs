using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerDirectionalLight : MonoBehaviour
{
    public PlayerInput input;
    public float alignSmoothTime = 0.09f;
    private Vector2 velocity = Vector2.zero;
    private Vector2 targetDirection = Vector2.zero;
    private Vector2 currentDirection = Vector2.right;

    void LateUpdate()
    {
        if (input.Movement() != Vector2.zero) {
            targetDirection = input.Movement();
            targetDirection.Normalize();
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
