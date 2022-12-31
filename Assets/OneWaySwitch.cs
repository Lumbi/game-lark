using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class OneWaySwitch : MonoBehaviour
{
    public Sprite activatedSprite;
    public UnityEvent activated = new UnityEvent();
    private bool isActivated = false;

    void OnTriggerEnter2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player") {
            if (!isActivated) {
                Activate();
            }
        }
    }

    private void Activate()
    {
        isActivated = true;
        GetComponent<SpriteRenderer>().sprite = activatedSprite;
        activated.Invoke();
    }
}
