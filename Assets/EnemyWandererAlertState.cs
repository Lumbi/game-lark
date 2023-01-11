using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyWandererAlertState : FiniteStateMachine.State
{
    private GameObject player;
    private bool seesPlayer = false;
    private Vector2 direction;
    private Vector2 angularVelocity;
    private float alignSmoothTime = 0.09f;
    private float timeDetectingPlayer = 0f;
    public float delayBeforeChase = 1f;
    private float timeNotDetectingPlayer = 0f;
    public float delayBeforePatrol = 6f;
    private float timeLookingAtDirection = 0f;
    public float delayBeforeChangeDirection = 2f;
    private Vector2 randomLookingAtDirection = Vector2.zero;

    public override void OnEnter() {
        ResetTimers();
        randomLookingAtDirection = Vector2.zero;
    }

    void LateUpdate()
    {
        // Get direction to player
        if (player != null) {
            direction = player.transform.position - transform.position;
            direction.Normalize();
        }

        // Test visibility to player
        RaycastHit2D hit = Physics2D.Raycast(transform.position, direction, 100f, LayerMask.GetMask("Player") | LayerMask.GetMask("Terrain"));
        seesPlayer = player != null && hit.collider != null && hit.collider.gameObject == player;
        if (seesPlayer) {
            transform.right = Vector2.SmoothDamp(transform.right, direction, ref angularVelocity, alignSmoothTime);
        } else if (randomLookingAtDirection != Vector2.zero) {
            transform.right = Vector2.SmoothDamp(transform.right, randomLookingAtDirection, ref angularVelocity, alignSmoothTime);
        }
        transform.right.Normalize();

        // Check timers
        if (timeDetectingPlayer > delayBeforeChase) {
            // GetComponent<FiniteStateMachine>().GoTo(GetComponent<EnemyWandererChaseState>());
        } else if (timeNotDetectingPlayer > delayBeforePatrol) {
            GetComponent<FiniteStateMachine>().GoTo(GetComponent<EnemyWandererPatrolState>());
        } else if (timeLookingAtDirection > delayBeforeChangeDirection) {
            randomLookingAtDirection = Random.insideUnitCircle; // TODO: Random +/- near the direction instead of completely random
            randomLookingAtDirection.Normalize();
            timeLookingAtDirection = 0f;
        }

        // Accumulate timers
        if (seesPlayer) {
            timeDetectingPlayer += Time.deltaTime;
            timeNotDetectingPlayer = 0f;
            timeLookingAtDirection = 0f;
        } else {
            timeDetectingPlayer = 0f;
            timeNotDetectingPlayer += Time.deltaTime;
            timeLookingAtDirection += Time.deltaTime;
        }
    }

    // Collisions

    void OnTriggerEnter2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player") {
            player = collider.gameObject;
            ResetTimers();
        }
    }

    void OnTriggerExit2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player") {
            player = null;
            ResetTimers();
        }
    }

    private void ResetTimers() {
        timeDetectingPlayer = 0f;
        timeNotDetectingPlayer = 0f;
        timeLookingAtDirection = 0f;
    }
}
