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

    void Start()
    {
        body = GetComponent<Rigidbody2D>();
    }

    void Update()
    {
        if (Vector2.Distance(transform.position, nextWaypoint.transform.position) <= nearWaypointThreshold) {
            nextWaypoint = nextWaypoint.GetSuccessor();
        }

        direction = nextWaypoint.transform.position - transform.position;
        direction.Normalize();
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

    // Collisions

    void OnTriggerEnter2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player") {
            Vector2 direction = collider.gameObject.transform.position - transform.position;
            RaycastHit2D hit = Physics2D.Raycast(transform.position, direction, 100f, LayerMask.GetMask("Player") | LayerMask.GetMask("Terrain"));
            bool seesPlayer = hit.collider != null && hit.collider.gameObject == collider.gameObject;
            if (seesPlayer) {
                GetComponent<FiniteStateMachine>().GoTo(GetComponent<EnemyWandererAlertState>());
            }
        }
    }
}
