using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerSafeArea : MonoBehaviour
{
    private bool isInSafeArea = false;

    public bool IsInSafeArea() { return isInSafeArea; }

    void OnTriggerEnter2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player Safe Area") {
            isInSafeArea = true;
        }
    }

    void OnTriggerExit2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player Safe Area") {
            isInSafeArea = false;
        }
    }
}
