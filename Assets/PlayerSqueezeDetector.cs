using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerSqueezeDetector : MonoBehaviour
{
    public LanderDestroy playerDestroy;

    void OnTriggerEnter2D() {
        playerDestroy.DestroyAndRespawn();
    }
}
