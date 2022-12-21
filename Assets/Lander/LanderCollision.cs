using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LanderCollision : MonoBehaviour
{
    void OnCollisionEnter2D(Collision2D collision) {
        if (collision.gameObject.GetComponent<DamageOnCollision>()) {
            GetComponent<LanderDestroy>().Trigger();
        }

        GetComponent<AnimateWobble>().Play();
    }

    void OnTriggerEnter2D(Collider2D collider)
    {
        if (collider.gameObject.GetComponent<CollectOnCollision>()) {
            var toCollect = collider.gameObject.GetComponent<CollectOnCollision>();
            GetComponent<CollectGem>().Collect(toCollect);
        }
    }
}
