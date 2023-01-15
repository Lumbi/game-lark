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
}
