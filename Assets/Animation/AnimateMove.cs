using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimateMove : MonoBehaviour
{
    public Transform target;
    public float duration = 1.0f;
    public float speed = 1.0f;

    private float time = 0f;

    void Start()
    {
        time = 0f;
    }

    void Update()
    {
        if (time < duration)
        {
            float interpolation = speed * Time.deltaTime;
            var position = Vector3.Lerp(this.transform.position, target.position, interpolation);
            this.transform.position = position;
        }
        time += Time.deltaTime;
    }
}
