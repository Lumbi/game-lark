using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways]
public class DebugDepot : MonoBehaviour
{
    void Update()
    {
        GetComponent<DepositOnCollision>().UpdateCounterText();
    }
}
