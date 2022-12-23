using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DepotGate : MonoBehaviour
{
    public DepositOnCollision depot;

    void Start()
    {
        depot.requiredCountReached.AddListener(OnDepotRequiredCountReached);
    }

    void OnDepotRequiredCountReached()
    {
        Destroy(gameObject);
    }
}
