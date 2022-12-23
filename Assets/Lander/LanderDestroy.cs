using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LanderDestroy : MonoBehaviour
{
    void OnCollisionEnter2D(Collision2D collision) {
        if (collision.gameObject.GetComponent<DamageOnCollision>()) {
            DestroyAndRespawn();
        }
    }

    private void DestroyAndRespawn()
    {
        FindObjectOfType<Restart>().SpawnLater(1.3f);
        GetComponent<Cargo>().DropCollectibles();
        Destroy(gameObject);
    }
}
