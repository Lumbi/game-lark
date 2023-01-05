using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LanderCollision : MonoBehaviour
{
    void OnCollisionEnter2D(Collision2D collision) {
    }

    void OnTriggerEnter2D(Collider2D collider)
    {
        if (collider.gameObject.GetComponent<CollectOnCollision>() != null) {
            CollectOnCollision toCollect = collider.gameObject.GetComponent<CollectOnCollision>();
            if (toCollect != null) {
                GetComponent<CollectGem>().Collect(toCollect);
            }
        }
    }
}
