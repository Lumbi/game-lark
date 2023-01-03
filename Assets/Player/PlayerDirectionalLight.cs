using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerDirectionalLight : MonoBehaviour
{
    public float rotationSpeed = 1f;
    public PlayerInput input;
    private Vector2 direction = Vector2.right;
    private float targetAngle = 0f;
    private Quaternion targetRotation = Quaternion.identity;

    void LateUpdate()
    {
        if (input.MoveDirection() != Vector2.zero) {
            direction = input.MoveDirection();
        }

        // TODO: Fix me
        targetAngle = Mathf.Lerp(targetAngle, Vector2.SignedAngle(Vector2.right, direction), rotationSpeed * Time.deltaTime);
        targetRotation = Quaternion.AngleAxis(targetAngle, Vector3.forward);
        transform.rotation = targetRotation;
    }
}
