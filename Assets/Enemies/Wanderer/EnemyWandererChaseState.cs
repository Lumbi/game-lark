using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyWandererChaseState : FiniteStateMachine.State
{
    private GameObject player;
    private Rigidbody2D body;
    private Vector2 direction;
    public float acceleration = 12f;
    public float maxSpeed = 8f;
    private Vector2 angularVelocity;
    private float alignSmoothTime = 0.09f;
    private float timeNotDetectingPlayer = 0f;
    public float delayBeforeAlert = 1f;

    private bool DetectingPlayer()
    {
        // TODO: Handle line of sight to player with raycast
        return player != null;
    }

    void Start()
    {
        body = GetComponent<Rigidbody2D>();
    }

    void Update()
    {
        if (DetectingPlayer()) {
            direction = player.transform.position - transform.position;
            direction.Normalize();
        }

        if (direction != Vector2.zero) {
            transform.right = Vector2.SmoothDamp(transform.right, direction, ref angularVelocity, alignSmoothTime);
            transform.right.Normalize();
        }

        if (timeNotDetectingPlayer > delayBeforeAlert) {
            GetComponent<FiniteStateMachine>().GoTo(GetComponent<EnemyWandererAlertState>());
            timeNotDetectingPlayer = 0f;
        }

        if (DetectingPlayer()) {
            timeNotDetectingPlayer = 0f;
        } else {
            timeNotDetectingPlayer += Time.deltaTime;
        }
    }

    void FixedUpdate()
    {
        if (DetectingPlayer()) {
            if (body.velocity.magnitude < maxSpeed) {
                body.AddForce(direction * acceleration);
            }
        }
    }

    void OnTriggerEnter2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player") {
            player = collider.gameObject;
        }
    }

    void OnTriggerExit2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player") {
            player = null;
        }
    }
}
