using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DepositGem : MonoBehaviour
{
    public float delay = 1f;

    private bool collidingWithDepot = false;
    private GameObject depot = null;

    private float time = 0f;

    void OnTriggerEnter2D(Collider2D collider)
    {
        if (collider.gameObject.GetComponent<DepositOnCollision>())
        {
            collidingWithDepot = true;
            depot = collider.gameObject;
            time = 0f;
        }
    }

    void OnTriggerExit2D(Collider2D collider)
    {
        if (collider.gameObject.GetComponent<DepositOnCollision>())
        {
            collidingWithDepot = false;
            depot = null;
        }
    }

    void Update()
    {
        if (collidingWithDepot && depot != null)
        {
            if (time > delay)
            {
                var player = gameObject;
                depot.GetComponent<DepositOnCollision>().DepositOne(gameObject);
                time = 0f;
            }
            time += Time.deltaTime;
        }
    }
}
