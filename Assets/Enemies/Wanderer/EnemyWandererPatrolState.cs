using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyWandererPatrolState : FiniteStateMachine.State
{
    public Waypoint nextWaypoint;
    public float nearWaypointThreshold = 1f;
    public float acceleration = 10f;
    public float maxSpeed = 3f;
    private Rigidbody2D body;
    private Vector2 direction;
    private Vector2 angularVelocity;
    public float alignSmoothTime = 0.09f;
    private DetectPlayer detectPlayer;

    void Start()
    {
        body = GetComponent<Rigidbody2D>();
        detectPlayer = GetComponent<DetectPlayer>();
    }

    void Update()
    {
        if (Vector2.Distance(transform.position, nextWaypoint.transform.position) <= nearWaypointThreshold) {
            nextWaypoint = nextWaypoint.GetSuccessor();
        }

        direction = nextWaypoint.transform.position - transform.position;
        direction.Normalize();

        if (detectPlayer.IsPlayerVisible()) {
            GetComponent<FiniteStateMachine>().GoTo(GetComponent<EnemyWandererAlertState>());
        }
    }

    void LateUpdate()
    {
        transform.right = Vector2.SmoothDamp(transform.right, direction, ref angularVelocity, alignSmoothTime);
        transform.right.Normalize();
    }

    void FixedUpdate()
    {
        if (nextWaypoint != null) {
            if (body.velocity.magnitude < maxSpeed) {
                body.AddForce(direction * acceleration);
            }
        }
    }
}
