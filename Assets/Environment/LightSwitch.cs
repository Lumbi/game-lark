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
    public float drainSpeed = 0.3f;
    public bool stayOn = false;

    public UnityEvent activated = new UnityEvent();
    public UnityEvent deactivated = new UnityEvent();

    private new Light2D light;
    private SpriteRenderer spriteRenderer;
    private bool isUnderPlayerLight = false;
    private bool isFull = false;
    private bool wasFull = false;
    private bool isEmpty = true;
    private bool wasEmpty = true;
    private bool inDelayAfterSwitchingOff = false;
    private float delayAfterSwitchingOff = 1f;
    private float timeAfterSwitchingOff = 0f;

    void Start()
    {
        light = GetComponent<Light2D>();
        spriteRenderer = GetComponent<SpriteRenderer>();
    }

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

        // Update light
        light.intensity = brightness;

        UpdateFullPresentation();

        // Trigger deactivated / activated
        if (!wasEmpty && isEmpty) {
            deactivated.Invoke();
        } else if (!wasFull && isFull) {
            activated.Invoke();
        }

        // Update brightness value
        if (inDelayAfterSwitchingOff) {
            timeAfterSwitchingOff += Time.deltaTime;
            if (timeAfterSwitchingOff > delayAfterSwitchingOff) {
                inDelayAfterSwitchingOff = false;
                timeAfterSwitchingOff = 0f;
            }
        } else if (isUnderPlayerLight) { // Increase brightness
            if (brightness < maxBrightness) {
                brightness += fillSpeed * Time.deltaTime;
            }
        } else { // Decrease brightness
            if (isFull && stayOn) {
                // Do nothing
            } else if (brightness > 0f) {
                brightness -= drainSpeed * Time.deltaTime;
            }
        }
        brightness = Mathf.Clamp(brightness, 0f, maxBrightness);

        wasEmpty = isEmpty;
        wasFull = isFull;
    }

    private void UpdateFullPresentation()
    {
        if (!wasFull && isFull) {
            var updatedRotation = transform.localEulerAngles;
            updatedRotation.z = 90f;
            transform.localEulerAngles = updatedRotation;
        } else if (wasFull && !isFull) {
            var updatedRotation = transform.localEulerAngles;
            updatedRotation.z = 0f;
            transform.localEulerAngles = updatedRotation;
        }
    }

    public void TurnOff()
    {
        brightness = 0f;
        inDelayAfterSwitchingOff = true;
        timeAfterSwitchingOff = 0f;
        deactivated.Invoke();
    }

    void OnDrawGizmos()
    {
        if (activated.GetPersistentEventCount() > 0) {
            var activatedTarget = activated.GetPersistentTarget(0) as Component;
            if (activatedTarget != null) {
                Gizmos.color = Color.green;
                Gizmos.DrawLine(transform.position, activatedTarget.transform.position);
            }
        }
    }
}
