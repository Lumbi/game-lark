using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Rendering.Universal;

public class LightSwitch : MonoBehaviour
{
    public float brightness = 0f;
    public float maxBrightness = 1f;
    public float fillSpeed = 0.2f;
    public float drainSpeed= 0.3f;

    public UnityEvent activated = new UnityEvent();
    public UnityEvent deactivated = new UnityEvent();

    private new Light2D light;
    private SpriteRenderer spriteRenderer;
    private bool isUnderPlayerLight = false;
    private bool isFull = false;
    private bool wasFull = false;
    private bool isEmpty = true;
    private bool wasEmpty = true;

    void Start()
    {
        light = GetComponent<Light2D>();
        spriteRenderer = GetComponent<SpriteRenderer>();
    }

    // void OnTriggerEnter2D(Collider2D collider)
    // {
    //     if (collider.gameObject.tag == "Player Light") {
    //         isUnderPlayerLight = true;
    //     }
    // }

    void OnTriggerStay2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player Light") {
            RaycastHit2D hit = Physics2D.Raycast(
                transform.position,
                (collider.gameObject.transform.position - transform.position).normalized,
                10f,
                LayerMask.GetMask("Player") | LayerMask.GetMask("Terrain")
            );
            var playerInLineOfSight = hit.collider != null && hit.collider.gameObject.tag == "Player";
            isUnderPlayerLight = playerInLineOfSight;
        }
    }

    void OnTriggerExit2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player Light") {
            isUnderPlayerLight = false;
        }
    }

    void Update()
    {
        // Update state
        isEmpty = brightness == 0f;
        isFull = brightness == maxBrightness;

        // Animate light
        if (isUnderPlayerLight && brightness < maxBrightness) {
            light.intensity = brightness + Mathf.Sin(Time.deltaTime);
        } else {
            light.intensity = brightness;
        }

        // Trigger deactivated / activated
        if (!wasEmpty && isEmpty) {
            deactivated.Invoke();
        } else if (!wasFull && isFull) {
            activated.Invoke();
        }

        // Update brightness value
        if (isUnderPlayerLight) {
            if (brightness < maxBrightness) {
                brightness += fillSpeed * Time.deltaTime;
            }
        } else {
            if (brightness > 0f) {
                brightness -= drainSpeed * Time.deltaTime;
            }
        }
        brightness = Mathf.Clamp(brightness, 0f, maxBrightness);

        wasEmpty = isEmpty;
        wasFull = isFull;
    }
}
