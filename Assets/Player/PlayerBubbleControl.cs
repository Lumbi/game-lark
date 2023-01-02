using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerBubbleControl : MonoBehaviour
{
    public float pushingForce = 0.0f;
    public float maxSpeed = 7f;

    public bool increaseResponsiveness = true;

    private bool isPushing = false;
    private Vector2 pushingDirection;

    private Rigidbody2D body;
    private PlayerInput input;

    void Start()
    {
        body = GetComponent<Rigidbody2D>();
        input = GetComponent<PlayerInput>();
    }

    void Update()
    {
        if (input.Move())
        {
            pushingDirection = input.MoveDirection();
            isPushing = true;
        } else {
            isPushing = false;
        }
    }

    void FixedUpdate()
    {
        if (isPushing)
        {
            if (body.velocity.magnitude < maxSpeed)
            {
                body.AddForce(pushingForce * pushingDirection);
            }

            if (increaseResponsiveness)
            {
                // Add extra force when pushing against current velocity
                if ((body.velocity.normalized + pushingDirection).sqrMagnitude < 1.0f)
                {
                    body.AddForce(pushingForce * pushingDirection);
                }
            }
        }
    }
}
