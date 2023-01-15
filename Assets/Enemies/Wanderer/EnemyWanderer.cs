using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.Universal;

public class EnemyWanderer : MonoBehaviour
{
    public Rigidbody2D body;
    public DetectPlayer detectPlayer;
    public Light2D leftEyeLight;
    public Light2D rightEyeLight;
    public SpriteRenderer spriteRenderer;
    private Vector2 angularVelocity; // Used to smooth align
    private float alignSmoothTime = 0.09f;

    void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.tag == "Player") {
            KillPlayer(collision.gameObject);
        }
    }

    private void KillPlayer(GameObject player)
    {
        Physics2D.IgnoreCollision(GetComponent<Collider2D>(), player.GetComponent<Collider2D>());
        player.GetComponent<LanderDestroy>().DestroyAndRespawn();
    }

    void FixedUpdate()
    {
        body.angularVelocity = 0f; // Cancel physics angular velocity (fully control by SmoothAlign)
    }

    public void SmoothAlign(Vector2 direction)
    {
        if (Vector3.Angle(transform.right, direction) > 1f)
        {
            transform.right = Vector2.SmoothDamp(transform.right, direction, ref angularVelocity, alignSmoothTime);
        } else {
            angularVelocity = Vector2.zero;
            transform.right = direction;
        }
        transform.right.Normalize();
    }

    public void StopAlign()
    {
        angularVelocity = Vector2.zero;
    }
}
