using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyLurker : MonoBehaviour
{
    public enum State { Idle, WaitingToChase, Chasing }

    public State state;
    public float speed = 10f;
    public float maxSpeed = 5f;
    private Rigidbody2D body;
    private Vector2 moveDirection = Vector2.zero;
    private GameObject player;
    public bool isPlayerInRange = false;
    public bool isUnderPlayerLight = false;
    public GameObject effectKillPlayer;
    private float waitingToChaseTime = 0f;
    public float waitingToChaseDuration = 1f;
    private Vector3 startPosition;
    private float forceKillTime = 0f;
    private float forceKillDelay = 3f;

    void Start()
    {
        state = State.Idle;
        body = GetComponent<Rigidbody2D>();
        startPosition = transform.position;
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

    void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.tag == "Player") {
            HandlePlayerCollisionEnter(collision.gameObject);
        }
    }

    void OnCollisionStay2D(Collision2D collision)
    {
        if (collision.gameObject.tag == "Player") {
            HandlePlayerCollisionStay(collision.gameObject);
        }
    }

    void OnCollisionExit2D(Collision2D collision)
    {
        if (collision.gameObject.tag == "Player") {
            HandlePlayerCollisionExit(collision.gameObject);
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

    private void HandlePlayerCollisionEnter(GameObject player)
    {
        if (!isUnderPlayerLight && state == State.Chasing) {
            KillPlayer(player);
        }
    }

    private void HandlePlayerCollisionStay(GameObject player)
    {
        // Force kill player after a certain duration to avoid dead locks
        if (forceKillTime < forceKillDelay) {
            forceKillTime += Time.deltaTime;
        } else {
            KillPlayer(player);
            forceKillTime = 0f;
        }
    }

    private void HandlePlayerCollisionExit(GameObject player)
    {
        forceKillTime = 0f;
    }

    // Actions

    private void KillPlayer(GameObject player)
    {
        player.GetComponent<LanderDestroy>().DestroyAndRespawn();
        Instantiate(effectKillPlayer, transform.position, Quaternion.identity);
        StartCoroutine(MoveToStartPosition());
    }

    private IEnumerator MoveToStartPosition()
    {
        float delay = 2f;
        float time = 0f;
        while (time < delay) {
            time += Time.deltaTime;
            yield return null;
        }
        transform.position = startPosition;
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
            case State.Idle: {
                FixedUpdateIdle();
                break;
            }

            case State.WaitingToChase: {
                FixedUpdateWaitingToChase();
                break;
            }

            case State.Chasing: {
                FixedUpdateChasing();
                break;
            }
        }
    }

    private void FixedUpdateIdle()
    {
        body.velocity = Vector2.zero;
    }

    private void FixedUpdateWaitingToChase()
    {
        body.velocity = Vector2.zero;
    }

    Vector2 adjustedDirection = Vector2.zero;

    private void FixedUpdateChasing()
    {
        if (player != null) {
            moveDirection = player.transform.position - transform.position;
            moveDirection.Normalize();

            Vector2 counterVelocity = -1 * (body.velocity - (Vector2.Dot(body.velocity, moveDirection) * moveDirection));
            adjustedDirection = moveDirection + counterVelocity;
            adjustedDirection.Normalize();

            body.AddForce(adjustedDirection * speed);
            body.velocity = Vector2.ClampMagnitude(body.velocity, maxSpeed);
        } else {
            body.velocity = Vector2.zero;
        }
    }
}
