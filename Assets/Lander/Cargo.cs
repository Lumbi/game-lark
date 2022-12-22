using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cargo : MonoBehaviour
{
    public HUD hud;
    public GameObject shardPrefab;

    private int count = 0;

    void Start()
    {
        hud = FindObjectOfType<HUD>();
    }

    public void PickUp(CollectOnCollision collectible)
    {
        count += 1;
        hud.UpdateCargoCount(count);
    }

    public bool UnloadOne()
    {
        if (count > 0)
        {
            count -= 1;
            hud.UpdateCargoCount(count);
            return true;
        } else {
            return false;
        }
    }

    public void DropCollectibles()
    {
        while (count > 0) {
            count -= 1;
            var droppedShard = Instantiate(shardPrefab, transform.position, Quaternion.identity);
            var randomDirection = Random.insideUnitCircle.normalized;
            droppedShard.GetComponent<Rigidbody2D>().AddForce(randomDirection, ForceMode2D.Impulse);
        }
    }
}
