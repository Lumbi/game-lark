using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class DetectPlayer : MonoBehaviour
{
    public UnityEvent playerInRange = new UnityEvent();
    public UnityEvent playerOutRange = new UnityEvent();

    void OnTriggerEnter2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player") {
            playerInRange.Invoke();
        }
    }

    void OnTriggerExit2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player") {
            playerOutRange.Invoke();
        }
    }
}
