using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using TMPro;

public class DepositOnCollision : MonoBehaviour
{
    public int requiredCount;
    public GameObject depositShardPrefab;

    public UnityEvent requiredCountReached = new UnityEvent();

    public TMP_Text counterText;

    private int count = 0;
    private int transientCount = 0;

    public bool isFull { get { return count >= requiredCount; } }

    void Start()
    {
        UpdateCounterText();
    }

    public void DepositOne(GameObject player)
    {
        StartCoroutine(_DepositOne(player));
    }

    private IEnumerator _DepositOne(GameObject player)
    {
        var cargo = player.GetComponent<Cargo>();

        if (cargo == null) { yield break; }
        if (cargo.isEmpty) { yield break; }
        if (CanAcceptOne() == false) { yield break; }

        // Decrement the cargo
        cargo.UnloadOne();

        // Begin deposit
        BeginAcceptOne();

        // Create a transient shard to animate
        var depositedShard = Instantiate(depositShardPrefab, transform.position, Quaternion.identity);

        // Animate-move toward depot
        var animateMove = depositedShard.AddComponent<AnimateMove>();
        animateMove.target = transform;

        // Destroy after animation finishes
        yield return new WaitForSeconds(animateMove.duration);
        Destroy(depositedShard);

        // Transfer the count to the depot
        CommitAcceptOne();
    }

    private bool CanAcceptOne()
    {
        return (count + transientCount) < requiredCount;
    }

    private void BeginAcceptOne()
    {
        if (CanAcceptOne()) {
            transientCount += 1;
        }
    }

    private void CommitAcceptOne()
    {
        if (!isFull) {
            count += 1;
            if (transientCount > 0) {
                transientCount -= 1;
            }
            UpdateCounterText();
        }

        if (isFull) {
            // Save checkpoint
            FindObjectOfType<Restart>().SaveCheckpointAt(gameObject);
            // Invoke event
            requiredCountReached.Invoke();
        }
    }

    public void UpdateCounterText()
    {
        counterText.text = $"{count} / {requiredCount}";
    }
}
