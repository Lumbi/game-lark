using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyWandererAlertState : FiniteStateMachine.State
{
    private DetectPlayer detectPlayer;
    private Vector2 angularVelocity;
    private float alignSmoothTime = 0.09f;
    private float timeDetectingPlayer = 0f;
    public float delayBeforeChase = 1f;
    private float timeNotDetectingPlayer = 0f;
    public float delayBeforePatrol = 6f;
    private float timeLookingAtDirection = 0f;
    public float delayBeforeChangeDirection = 2f;
    private Vector2 randomLookingAtDirection = Vector2.zero;

    void Start()
    {
        detectPlayer = GetComponent<DetectPlayer>();
    }

    public override void OnEnter() {
        ResetTimers();
        randomLookingAtDirection = Vector2.zero;
    }

    public override void OnExit()
    {
        ResetTimers();
    }

    void LateUpdate()
    {
        // Align to player if visible or random direction otherwise
        if (detectPlayer.IsPlayerVisible()) {
            transform.right = Vector2.SmoothDamp(transform.right, detectPlayer.DirectionToPlayer(), ref angularVelocity, alignSmoothTime);
            randomLookingAtDirection = detectPlayer.DirectionToPlayer();
        } else if (randomLookingAtDirection != Vector2.zero) {
            transform.right = Vector2.SmoothDamp(transform.right, randomLookingAtDirection, ref angularVelocity, alignSmoothTime);
        }
        transform.right.Normalize();

        // Check timers
        if (timeDetectingPlayer > delayBeforeChase) {
            GetComponent<FiniteStateMachine>().GoTo(GetComponent<EnemyWandererChaseState>());
        } else if (timeNotDetectingPlayer > delayBeforePatrol) {
            GetComponent<FiniteStateMachine>().GoTo(GetComponent<EnemyWandererPatrolState>());
        } else if (timeLookingAtDirection > delayBeforeChangeDirection) {
            randomLookingAtDirection = Random.insideUnitCircle; // TODO: Random +/- near the direction instead of completely random
            randomLookingAtDirection.Normalize();
            timeLookingAtDirection = 0f;
        }

        // Accumulate timers
        if (detectPlayer.IsPlayerVisible()) {
            timeDetectingPlayer += Time.deltaTime;
            timeNotDetectingPlayer = 0f;
            timeLookingAtDirection = 0f;
        } else {
            timeDetectingPlayer = 0f;
            timeNotDetectingPlayer += Time.deltaTime;
            timeLookingAtDirection += Time.deltaTime;
        }
    }

    private void ResetTimers() {
        timeDetectingPlayer = 0f;
        timeNotDetectingPlayer = 0f;
        timeLookingAtDirection = 0f;
    }
}
