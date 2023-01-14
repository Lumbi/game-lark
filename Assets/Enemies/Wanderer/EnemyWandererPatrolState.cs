using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyWandererPatrolState : FiniteStateMachine.State
{
    public EnemyWanderer wanderer;
    public Waypoint nextWaypoint;
    public float nearWaypointThreshold = 1f;
    public float acceleration = 10f;
    public float maxSpeed = 3f;
    private Vector2 direction;
    private Vector2 angularVelocity;
    public float alignSmoothTime = 0.09f;
    public Sprite sprite;
    public Color color;

    public override void OnEnter()
    {
        wanderer.spriteRenderer.sprite = sprite;
        wanderer.spriteRenderer.color = color;
        wanderer.leftEyeLight.color = color;
        wanderer.rightEyeLight.color = color;
    }

    void Update()
    {
        if (Vector2.Distance(transform.position, nextWaypoint.transform.position) <= nearWaypointThreshold) {
            nextWaypoint = nextWaypoint.GetSuccessor();
        }

        direction = nextWaypoint.transform.position - transform.position;
        direction.Normalize();

        if (wanderer.detectPlayer.IsPlayerVisible()) {
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
            if (wanderer.body.velocity.magnitude < maxSpeed) {
                wanderer.body.AddForce(direction * acceleration);
            }
        }
    }
}
