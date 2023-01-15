using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyWandererAlertState : FiniteStateMachine.State
{
    public EnemyWanderer wanderer;
    public float acceleration = 10f;
    public float maxSpeed = 3f;
    private Vector2 alignDirection;
    private float timeDetectingPlayer = 0f;
    public float delayBeforeChase = 1f;
    private float timeNotDetectingPlayer = 0f;
    public float delayBeforePatrol = 6f;
    private float timeLookingAtDirection = 0f;
    public float delayBeforeChangeDirection = 2f;
    private Vector2 randomLookingAtDirection = Vector2.zero;
    private Stack<Vector2> backtrackPositions = new Stack<Vector2>();
    public Sprite sprite;
    public Color color;

    public override void OnEnter() {
        ResetTimers();
        randomLookingAtDirection = Vector2.zero;
        wanderer.spriteRenderer.sprite = sprite;
        wanderer.spriteRenderer.color = color;
        wanderer.leftEyeLight.color = color;
        wanderer.rightEyeLight.color = color;
    }

    public override void OnExit()
    {
        ResetTimers();
    }

    void LateUpdate()
    {
        // Align to player if visible or random direction otherwise
        if (wanderer.detectPlayer.IsPlayerVisible()) {
            alignDirection = wanderer.detectPlayer.DirectionToPlayer();
            randomLookingAtDirection = alignDirection;
        } else if (ShouldBacktrack()) {
            alignDirection = backtrackPositions.Peek() - wanderer.body.position;
            alignDirection.Normalize();
            randomLookingAtDirection = alignDirection;
        } else if (randomLookingAtDirection != Vector2.zero) {
            alignDirection = randomLookingAtDirection;
        }
        wanderer.SmoothAlign(alignDirection);

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
        if (wanderer.detectPlayer.IsPlayerVisible()) {
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
                if (wanderer.body.velocity.magnitude < maxSpeed) {
                    wanderer.body.AddForce(alignDirection * acceleration);
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
