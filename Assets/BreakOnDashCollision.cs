using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BreakOnDashCollision : MonoBehaviour
{
    void OnCollisionEnter2D(Collision2D collision) {
        PlayerDashControl dashControl = collision.gameObject.GetComponent<PlayerDashControl>();
        if (dashControl && dashControl.IsDashing()) {
            LetPassthrough(collision);
            Break();
        }
    }

    private void LetPassthrough(Collision2D collision)
    {
        Physics2D.IgnoreCollision(collision.collider, collision.otherCollider);
        // Restore the player velocity
        collision.collider.attachedRigidbody.velocity = collision.relativeVelocity;
    }

    private void Break()
    {
        Destroy(gameObject);
    }
}
