using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerDashControl : MonoBehaviour
{
    public float dashForce = 4f;
    public float minDistance = 1f;
    public float minInputSpeed = 1f;
    public float maxInputDuration = 0.3f;
    private float inputDuration = 0f;
    private Vector2 dashDirection = Vector2.zero;
    private Rigidbody2D body;
    private PlayerInput input;

    private bool applyForce = false;

    void Start()
    {
        body = GetComponent<Rigidbody2D>();
        input = GetComponent<PlayerInput>();
    }

    void Update()
    {
        if (input.IsDown() && !applyForce) {
            if (inputDuration < maxInputDuration) {
                Debug.Log(input.Velocity().magnitude);
                if (input.Distance().magnitude > minDistance && input.Velocity().magnitude > minInputSpeed) {
                    Debug.Log("PUSH!");
                    applyForce = true;
                    dashDirection = input.Velocity().normalized;
                }
                inputDuration += Time.deltaTime;
            }
        } else {
            inputDuration = 0f;
        }
    }

    void FixedUpdate()
    {
        if (applyForce) {
            applyForce = false;
            body.AddForce(dashForce * dashDirection, ForceMode2D.Impulse);
        }
    }
}
