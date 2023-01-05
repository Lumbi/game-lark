using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyLurker : MonoBehaviour
{
    public enum State { Idle, Chasing }

    public State state;
    public float speed = 1f;
    private Rigidbody2D body;
    private Vector3 moveDirection = Vector2.zero;
    private GameObject player;
    public bool isPlayerInRange = false;
    public bool isUnderPlayerLight = false;

    void Start()
    {
        state = State.Idle;
        body = GetComponent<Rigidbody2D>();
    }

    void OnTriggerEnter2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player Light") {
            isUnderPlayerLight = true;
        }
    }

    void OnTriggerExit2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player Light") {
            isUnderPlayerLight = false;
        }
    }

    public void OnPlayerInRange()
    {
        isPlayerInRange = true;
    }

    public void OnPlayerOutRange()
    {
        isPlayerInRange = false;
    }

    void Update()
    {
        if (player == null) {
            player = GameObject.FindWithTag("Player");
        }

        if (isPlayerInRange && !isUnderPlayerLight) {
            state = State.Chasing;
        } else {
            state = State.Idle;
        }
    }

    void FixedUpdate()
    {
        switch (state) {
            case State.Idle: {
                break;
            }
            case State.Chasing: {
                FixedUpdateChasing();
                break;
            }
        }
    }

    private void FixedUpdateChasing()
    {
        if (player != null) {
            moveDirection = player.transform.position - transform.position;
            moveDirection.z = 0;
            moveDirection.Normalize();
            body.MovePosition(transform.position + (moveDirection * speed * Time.fixedDeltaTime));
        }
    }
}
