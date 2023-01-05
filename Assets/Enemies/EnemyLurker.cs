using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyLurker : MonoBehaviour
{
    public enum State { Idle, WaitingToChase, Chasing }

    public State state;
    public float speed = 1f;
    private Rigidbody2D body;
    private Vector3 moveDirection = Vector2.zero;
    private GameObject player;
    public bool isPlayerInRange = false;
    public bool isUnderPlayerLight = false;
    public GameObject effectKillPlayer;
    private float waitingToChaseTime = 0f;
    public float waitingToChaseDuration = 1f;

    void Start()
    {
        state = State.Idle;
        body = GetComponent<Rigidbody2D>();
    }

    // Events

    void OnTriggerEnter2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player") {
            HandlePlayerRangeTrigger(true);
        } else if (collider.gameObject.tag == "Player Light") {
            HandlePlayerLightTrigger(true);
        }
    }

    void OnTriggerExit2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player") {
            HandlePlayerRangeTrigger(false);
        } else if (collider.gameObject.tag == "Player Light") {
            HandlePlayerLightTrigger(false);
        }
    }

    void OnCollisionEnter2D(Collision2D collision) {
        if (collision.gameObject.tag == "Player") {
            HandlePlayerCollision(collision);
        }
    }

    // Collisions

    private void HandlePlayerRangeTrigger(bool inRange)
    {
        isPlayerInRange = inRange;
    }

    private void HandlePlayerLightTrigger(bool underLight)
    {
        isUnderPlayerLight = underLight;
    }

    private void HandlePlayerCollision(Collision2D collision)
    {
        if (!isUnderPlayerLight && state == State.Chasing) {
            KillPlayer(collision.gameObject);
        }
    }

    // Actions

    private void KillPlayer(GameObject player)
    {
        player.GetComponent<LanderDestroy>().DestroyAndRespawn();
        Instantiate(effectKillPlayer, transform.position, Quaternion.identity);
    }

    // Updates

    void Update()
    {
        if (player == null) {
            player = GameObject.FindWithTag("Player");
        }

        switch (state) {
            case State.Idle: {
                if (isPlayerInRange && !isUnderPlayerLight) {
                    state = State.WaitingToChase;
                }
                break;
            }

            case State.WaitingToChase: {
                if (waitingToChaseTime < waitingToChaseDuration) {
                    waitingToChaseTime += Time.deltaTime;
                } else {
                    waitingToChaseTime = 0f;
                    state = State.Chasing;
                }
                break;
            }

            case State.Chasing: {
                if (!isPlayerInRange || isUnderPlayerLight) {
                    state = State.Idle;
                }
                break;
            }
        }
    }

    void FixedUpdate()
    {
        switch (state) {
            case State.Idle: { break; }

            case State.WaitingToChase: { break; }

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
