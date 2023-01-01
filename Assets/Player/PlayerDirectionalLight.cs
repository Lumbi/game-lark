using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerDirectionalLight : MonoBehaviour
{
    public float rotationSpeed = 100f;
    public Rigidbody2D body;
    private Vector2 direction = Vector2.right;
    private Quaternion targetRotation = Quaternion.identity;

    void LateUpdate()
    {
        direction = body.velocity;
        // targetRotation = Quaternion.LookRotation(direction, Vector3.forward);
        targetRotation = Quaternion.AngleAxis(Vector2.SignedAngle(Vector2.right, direction), Vector3.forward);
        transform.rotation = targetRotation;
    }
}
