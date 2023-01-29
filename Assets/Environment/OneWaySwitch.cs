using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[ExecuteAlways]
public class OneWaySwitch : MonoBehaviour
{
    public Sprite normalSprite;
    public Sprite activatedSprite;
    public UnityEvent activated = new UnityEvent();
    public bool isActivated = false;

    void Start()
    {
        UpdateSprite();
    }

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
        UpdateSprite();
        activated.Invoke();
    }

    public void Reset()
    {
        isActivated = false;
        UpdateSprite();
    }

    private void UpdateSprite() {
        if (isActivated) {
            GetComponent<SpriteRenderer>().sprite = activatedSprite;
        } else {
            GetComponent<SpriteRenderer>().sprite = normalSprite;
        }
    }

    void Update() {
        if (!Application.IsPlaying(gameObject)) {
            UpdateSprite();
        }
    }
}
