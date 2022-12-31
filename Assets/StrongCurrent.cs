using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StrongCurrent : MonoBehaviour
{
    public float force = 10f;
    private List<Collider2D> collidersInCurrent = new List<Collider2D>();

    void OnTriggerEnter2D(Collider2D collider)
    {
        if (!collidersInCurrent.Contains(collider)) {
            collidersInCurrent.Add(collider);
        }
    }

    void OnTriggerExit2D(Collider2D collider)
    {
        if (collidersInCurrent.Contains(collider)) {
            collidersInCurrent.Remove(collider);

            // Slow down the object when leaving the strong current to avoid conserving a very high momentum
            if (collider.attachedRigidbody)
            {
                collider.attachedRigidbody.velocity /= 2f;
            }
        }
    }

    void FixedUpdate()
    {
        foreach (Collider2D collider in collidersInCurrent)
        {
            // TODO: Add proper check with the velocity projected onto the local right direction unit vector
            if (collider.attachedRigidbody)
            {
                collider.attachedRigidbody.AddForce(force * transform.right);
            }
        }
    }
}
