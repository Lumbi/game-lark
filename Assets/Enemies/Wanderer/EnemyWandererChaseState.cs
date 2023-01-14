using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyWandererChaseState : FiniteStateMachine.State
{
    public EnemyWanderer wanderer;
    public float acceleration = 12f;
    public float maxSpeed = 8f;
    private Vector2 angularVelocity;
    private float alignSmoothTime = 0.09f;
    private float timeNotDetectingPlayer = 0f;
    public float delayBeforeAlert = 1f;
    private float timeAddingBacktrack = 1f;
    private float delayBeforeAddToBacktrack = 1f;
    public Sprite sprite;
    public Color color;

    public override void OnEnter()
    {
        timeNotDetectingPlayer = 0f;
        timeAddingBacktrack = delayBeforeAddToBacktrack;
        wanderer.spriteRenderer.sprite = sprite;
        wanderer.spriteRenderer.color = color;
        wanderer.leftEyeLight.color = color;
        wanderer.rightEyeLight.color = color;
    }

    void Update()
    {
        if (wanderer.detectPlayer.IsPlayerVisible()) {
            transform.right = Vector2.SmoothDamp(transform.right, wanderer.detectPlayer.DirectionToPlayer(), ref angularVelocity, alignSmoothTime);
            transform.right.Normalize();
        }

        if (timeNotDetectingPlayer > delayBeforeAlert) {
            GetComponent<FiniteStateMachine>().GoTo(GetComponent<EnemyWandererAlertState>());
            return;
        }

        if (timeAddingBacktrack > delayBeforeAddToBacktrack) {
            timeAddingBacktrack = 0f;
            GetComponent<EnemyWandererAlertState>().PushBacktrackPosition(transform.position);
        }

        if (wanderer.detectPlayer.IsPlayerVisible()) {
            timeNotDetectingPlayer = 0f;
            timeAddingBacktrack += Time.deltaTime;
        } else {
            timeNotDetectingPlayer += Time.deltaTime;
        }
    }

    void FixedUpdate()
    {
        if (wanderer.detectPlayer.IsPlayerVisible()) {
            if (wanderer.body.velocity.magnitude < maxSpeed) {
                wanderer.body.AddForce(wanderer.detectPlayer.DirectionToPlayer() * acceleration);
            }
        }
    }
}
