using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LanderDestroy : MonoBehaviour
{
    public GameObject lightOnDestroy;
    void OnCollisionEnter2D(Collision2D collision) {
        if (collision.gameObject.GetComponent<DamageOnCollision>()) {
            DestroyAndRespawn();
        }
    }

    public void DestroyAndRespawn()
    {
        FindObjectOfType<Restart>().SpawnLater(1.3f);
        GetComponent<Cargo>().DropCollectibles();
        Instantiate(lightOnDestroy, transform.position, Quaternion.identity);
        Destroy(gameObject);
    }
}
