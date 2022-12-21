using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LanderControl : MonoBehaviour
{
    public float thrusterForce = 8.0f;
    private Vector2 leftThrusterDirection;
    private Vector2 rightThrusterDirection;

    // Start is called before the first frame update
    void Start()
    {
        leftThrusterDirection = (new Vector2(2.0f, 3.0f)).normalized;
        rightThrusterDirection = (new Vector2(-2.0f, 3.0f)).normalized;
    }

    // Update is called once per frame
    void Update()
    {
    }

    void FixedUpdate()
    {
        if (Input.GetAxis("Horizontal") == -1)
        {
            GetComponent<Rigidbody2D>().AddForce(thrusterForce * leftThrusterDirection);
        }

        if (Input.GetAxis("Horizontal") == 1)
        {
            GetComponent<Rigidbody2D>().AddForce(thrusterForce * rightThrusterDirection);
        }
    }
}
