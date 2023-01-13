using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyWandererChaseState : FiniteStateMachine.State
{
    private DetectPlayer detectPlayer;
    private Rigidbody2D body;
    public float acceleration = 12f;
    public float maxSpeed = 8f;
    private Vector2 angularVelocity;
    private float alignSmoothTime = 0.09f;
    private float timeNotDetectingPlayer = 0f;
    public float delayBeforeAlert = 1f;
    private float timeAddingBacktrack = 1f;
    private float delayBeforeAddToBacktrack = 1f;

    void Start()
    {
        body = GetComponent<Rigidbody2D>();
        detectPlayer = GetComponent<DetectPlayer>();
    }

    public override void OnEnter()
    {
        timeNotDetectingPlayer = 0f;
        timeAddingBacktrack = delayBeforeAddToBacktrack;
    }

    void Update()
    {
        if (detectPlayer.IsPlayerVisible()) {
            transform.right = Vector2.SmoothDamp(transform.right, detectPlayer.DirectionToPlayer(), ref angularVelocity, alignSmoothTime);
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

        if (detectPlayer.IsPlayerVisible()) {
            timeNotDetectingPlayer = 0f;
            timeAddingBacktrack += Time.deltaTime;
        } else {
            timeNotDetectingPlayer += Time.deltaTime;
        }
    }

    void FixedUpdate()
    {
        if (detectPlayer.IsPlayerVisible()) {
            if (body.velocity.magnitude < maxSpeed) {
                body.AddForce(detectPlayer.DirectionToPlayer() * acceleration);
            }
        }
    }
}
