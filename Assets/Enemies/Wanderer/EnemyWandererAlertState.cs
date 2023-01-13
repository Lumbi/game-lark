using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyWandererAlertState : FiniteStateMachine.State
{
    private DetectPlayer detectPlayer;
    private Rigidbody2D body;
    public float acceleration = 10f;
    public float maxSpeed = 3f;
    private Vector2 alignDirection;
    private Vector2 angularVelocity;
    private float alignSmoothTime = 0.09f;
    private float timeDetectingPlayer = 0f;
    public float delayBeforeChase = 1f;
    private float timeNotDetectingPlayer = 0f;
    public float delayBeforePatrol = 6f;
    private float timeLookingAtDirection = 0f;
    public float delayBeforeChangeDirection = 2f;
    private Vector2 randomLookingAtDirection = Vector2.zero;
    private Stack<Vector2> backtrackPositions = new Stack<Vector2>();

    void Start()
    {
        body = GetComponent<Rigidbody2D>();
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
            alignDirection = detectPlayer.DirectionToPlayer();
            randomLookingAtDirection = alignDirection;
        } else if (ShouldBacktrack()) {
            alignDirection = backtrackPositions.Peek() - body.position;
            alignDirection.Normalize();
            randomLookingAtDirection = alignDirection;
        } else if (randomLookingAtDirection != Vector2.zero) {
            alignDirection = randomLookingAtDirection;
        }
        transform.right = Vector2.SmoothDamp(transform.right, alignDirection, ref angularVelocity, alignSmoothTime);
        transform.right.Normalize();

        // Check sub-state transitions
        if (ShouldChase()) {
            GetComponent<FiniteStateMachine>().GoTo(GetComponent<EnemyWandererChaseState>());
        } else if (ShouldPatrol()) {
            GetComponent<FiniteStateMachine>().GoTo(GetComponent<EnemyWandererPatrolState>());
        } else if (ShouldBacktrack()) {
            // NOOP, handled in FixedUpdate
        } else if (ShouldChangeLookingDirection()) {
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

    void FixedUpdate()
    {
        if (ShouldBacktrack()) {
            if (Vector2.Distance(transform.position, backtrackPositions.Peek()) < 1f) {
                backtrackPositions.Pop();
            } else {
                if (body.velocity.magnitude < maxSpeed) {
                    body.AddForce(alignDirection * acceleration);
                }
            }
        }
    }

    private bool ShouldPatrol() { return timeNotDetectingPlayer > delayBeforePatrol && backtrackPositions.Count == 0; }
    private bool ShouldChase() { return timeDetectingPlayer > delayBeforeChase; }
    private bool ShouldBacktrack() { return timeNotDetectingPlayer > delayBeforePatrol && backtrackPositions.Count > 0; }
    private bool ShouldChangeLookingDirection() { return timeLookingAtDirection > delayBeforeChangeDirection; }

    public void PushBacktrackPosition(Vector2 position)
    {
        backtrackPositions.Push(position);
    }

    private void ResetTimers()
    {
        timeDetectingPlayer = 0f;
        timeNotDetectingPlayer = 0f;
        timeLookingAtDirection = 0f;
    }

    void OnDrawGizmos()
    {
        Gizmos.color = Color.blue;
        Vector2 posA = transform.position;
        foreach (var posB in backtrackPositions)
        {
            Gizmos.DrawLine(posA, posB);
            posA = posB;
        }
    }
}
