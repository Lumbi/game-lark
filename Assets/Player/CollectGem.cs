using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollectGem : MonoBehaviour
{
    public void Collect(CollectOnCollision collectible)
    {
        GetComponent<Cargo>().PickUp(collectible);
        Destroy(collectible.gameObject);
    }
}
