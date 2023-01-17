using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DepositGem : MonoBehaviour
{
    public GameObject depositShardPrefab;

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
                StartCoroutine(DepositInto(depot));
                time = 0f;
            }
            time += Time.deltaTime;
        }
    }

    IEnumerator DepositInto(GameObject depot)
    {
        var cargo = GetComponent<Cargo>();
        var deposit = depot.GetComponent<DepositOnCollision>();

        if (cargo.isEmpty) { yield break; }
        if (deposit.CanAcceptOne() == false) { yield break; }

        // Save checkpoint
        FindObjectOfType<Restart>().SaveCheckpointAt(depot);

        // Decrement the cargo
        cargo.UnloadOne();

        // Begin deposit
        deposit.BeginAcceptOne();

        // Create a transient shard to animate
        var depositedShard = Instantiate(depositShardPrefab, transform.position, Quaternion.identity);

        // Animate-move toward depot
        var animateMove = depositedShard.AddComponent<AnimateMove>();
        animateMove.target = depot.transform;

        // Destroy after animation finishes
        yield return new WaitForSeconds(animateMove.duration);
        Destroy(depositedShard);

        // Transfer the count to the depot
        deposit.CommitAcceptOne();
    }
}
