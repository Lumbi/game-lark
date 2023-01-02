using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerDashControl : MonoBehaviour
{
    public float dashForce = 8f;
    public float cooldownDuration = 1f;
    public Behaviour controls; // Normal player controls to be disabled while dashing

    private bool inCooldown = false;
    private float cooldownTimer = 0f;

    private bool triggerDash = false;
    private bool isDashing = false;
    public float dashDuration = 0.5f;
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
        if (input.Dash() && !inCooldown) {
            triggerDash = true;
            GetComponent<AnimateWobble>().Play();
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
            Dash();
        }
    }

    public bool IsDashing() { return isDashing; }

    private void Dash()
    {
        triggerDash = false;
        isDashing = true;
        inCooldown = true;
        cooldownTimer = 0f;
        body.AddForce(dashForce * input.DashDirection(), ForceMode2D.Impulse);
    }
}
