using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class DetectPlayer : MonoBehaviour
{
    private GameObject player;
    private bool playerDetected = false;
    private bool playerInLineOfSight = false;
    private Vector2 direction;

    public GameObject Player() { return player; }

    public bool IsPlayerVisible() { return playerDetected && playerInLineOfSight; }

    public Vector2 DirectionToPlayer() { return direction; }

    void OnTriggerEnter2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player") {
            player = collider.gameObject;
            playerDetected = true;
        }
    }

    void OnTriggerExit2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player") {
            player = null;
            playerDetected = false;
        }
    }

    void Update()
    {
        if (player != null) {
            direction = player.transform.position - transform.position;
            direction.Normalize();
            RaycastHit2D hit = Physics2D.Raycast(
                transform.position,
                direction, 100f,
                LayerMask.GetMask("Player") | LayerMask.GetMask("Terrain") | LayerMask.GetMask("EnemyTrigger") // Wont work
            );
            playerDetected = true;
            playerInLineOfSight = hit.collider != null && hit.collider.gameObject == player;
        } else {
            playerDetected = false;
            playerInLineOfSight = false;
        }
    }
}
