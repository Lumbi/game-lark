using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LanderDestroy : MonoBehaviour
{
    public void Trigger() {
        Destroy(gameObject);
        GetComponent<Cargo>().DropCollectibles();
        FindObjectOfType<Restart>().Spawn();
    }
}
