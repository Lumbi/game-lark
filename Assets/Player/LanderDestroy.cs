using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LanderDestroy : MonoBehaviour
{
    public GameObject lightOnDestroy;
    public float respawnDelay = 2f;
    void OnCollisionEnter2D(Collision2D collision) {
        if (collision.gameObject.GetComponent<DamageOnCollision>()) {
            DestroyAndRespawn();
        }
    }

    public void DestroyAndRespawn()
    {
        FindObjectOfType<Restart>().SpawnLater(respawnDelay);
        GetComponent<Cargo>().DropCollectibles();
        Instantiate(lightOnDestroy, transform.position, Quaternion.identity);
        Destroy(gameObject);
    }
}
