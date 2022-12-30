using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerDashControl : MonoBehaviour
{
    public float dashForce = 4f;
    public float minDistance = 1f;
    public float minInputSpeed = 1f;
    public float maxInputDuration = 0.3f;
    public float cooldownDuration = 1f;
    public Behaviour controls; // Normal player controls to be disabled while dashing

    private float inputDuration = 0f;
    private bool inCooldown = false;
    private float cooldownTimer = 0f;

    private bool triggerDash = false;
    private Vector2 dashDirection = Vector2.zero;
    private bool isDashing = false;
    private float dashDuration = 0.3f;
    private float dashTimer = 0f;

    private Rigidbody2D body;
    private PlayerInput input;

    void Start()
    {
        body = GetComponent<Rigidbody2D>();
        input = GetComponent<PlayerInput>();
    }

    void Update()
    {
        // Accumulate cooldown time
        if (inCooldown) {
            if (cooldownTimer >= cooldownDuration) {
                inCooldown = false;
            } else {
                cooldownTimer += Time.deltaTime;
            }
        } else {
            cooldownTimer = 0f;
        }

        // Detect dash input
        if (input.IsDown() && !inCooldown) {
            if (inputDuration < maxInputDuration) {
                // Trigger dash
                if (input.Distance().magnitude > minDistance && input.Velocity().magnitude > minInputSpeed) {
                    dashDirection = input.Velocity().normalized;
                    triggerDash = true;
                    GetComponent<AnimateWobble>().Play();
                } else {
                    inputDuration += Time.deltaTime;
                }
            }
        } else {
            inputDuration = 0f;
        }

        // Accumulate dash state frames
        if (isDashing) {
            controls.enabled = false;
            if (dashTimer >= dashDuration) {
                isDashing = false;
            } else {
                dashTimer += Time.deltaTime;
            }
        } else {
            dashTimer = 0f;
            controls.enabled = true;
        }
    }

    void FixedUpdate()
    {
        if (triggerDash && !inCooldown) {
            ApplyForce();
        }
    }

    public bool IsDashing() { return isDashing; }

    private void ApplyForce()
    {
        triggerDash = false;
        inCooldown = true;
        cooldownTimer = 0f;
        body.AddForce(dashForce * dashDirection, ForceMode2D.Impulse);
    }
}
