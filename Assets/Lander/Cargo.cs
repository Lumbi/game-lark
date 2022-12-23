using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cargo : MonoBehaviour
{
    public GameObject shardPrefab;
    private HUD hud;
    private int count = 0;

    public bool isEmpty { get { return count == 0; } }

    void Start()
    {
        hud = FindObjectOfType<HUD>();
    }

    public void PickUp(CollectOnCollision collectible)
    {
        count += 1;
        hud.UpdateCargoCount(count);
    }

    public void UnloadOne()
    {
        if (isEmpty) { return; }

        count -= 1;
        hud.UpdateCargoCount(count);
    }

    public void DropCollectibles()
    {
        while (count > 0) {
            count -= 1;
            var droppedShard = Instantiate(shardPrefab, transform.position, Quaternion.identity);
            var randomDirection = Random.insideUnitCircle.normalized;
            droppedShard.GetComponent<Rigidbody2D>().AddForce(randomDirection, ForceMode2D.Impulse);
        }
        hud.UpdateCargoCount(count);
    }
}
