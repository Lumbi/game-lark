using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerBubbleControl : MonoBehaviour
{
    public float pushingForce = 0.0f;

    private bool isPushing = false;
    private Vector3 pushingDirection;

    void Update()
    {
        if (Input.GetMouseButton(0)) // TODO: Refactor inputs
        {
            Vector3 clickPosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            clickPosition.z = transform.position.z;
            pushingDirection = (transform.position - clickPosition).normalized;
            if (!isPushing) {
                FindObjectOfType<HUD>().HideControlsHint();
            }
            isPushing = true;
        } else {
            isPushing = false;
        }
    }

    void FixedUpdate()
    {
        if (isPushing)
        {
            GetComponent<Rigidbody2D>().AddForce(pushingForce * pushingDirection);
        }
    }
}
