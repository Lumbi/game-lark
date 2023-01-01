using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimateWobble : MonoBehaviour
{
    public float duration;
    public float speed;

    private float time;
    private Vector3 initialScale;
    private Vector3 targetScale = Vector3.zero;
    private bool isPlaying = false;

    private float wobbleTime = 0;

    void Start()
    {
        initialScale = transform.localScale;
    }

    public void Play()
    {
        Reset();
        isPlaying = true;
    }

    private void Reset()
    {
        StopAllCoroutines();
        transform.localScale = initialScale;
        time = 0;
    }

    void Update()
    {
        if (isPlaying)
        {
            if (time < duration)
            {
                if (targetScale == Vector3.zero)
                {
                    targetScale = (0.3f * Random.insideUnitCircle + Vector2.up + Vector2.right) * initialScale;
                }

                float interpolation = speed * Time.deltaTime;
                Vector3 scale = transform.localScale;
                scale.x = Interpolate(transform.localScale.x, targetScale.x, interpolation, 0.2f, 0.2f);
                scale.y = Interpolate(transform.localScale.y, targetScale.y, interpolation, 0.2f, 0.2f);
                transform.localScale = scale;

                if (wobbleTime > 0.1f)
                {
                    wobbleTime = 0;
                    targetScale = Vector3.zero;
                }

                time += Time.deltaTime;
                wobbleTime += Time.deltaTime;
            } else {
                isPlaying = false;
                transform.localScale = initialScale;
            }
        }
    }

    float Interpolate(float startValue, float endValue, float t, float overshoot, float anticipation)
    {
        float interpolatedValue;
        if (t < anticipation)
        {
            // Perform anticipation
            interpolatedValue = startValue + (endValue - startValue) * (t / anticipation);
        }
        else if (t > 1 - overshoot)
        {
            // Perform overshoot
            interpolatedValue = endValue + (endValue - startValue) * ((t - (1 - overshoot)) / overshoot);
        }
        else
        {
            // Perform normal interpolation
            interpolatedValue = startValue + (endValue - startValue) * ((t - anticipation) / (1 - anticipation - overshoot));
        }
        return interpolatedValue;
    }
}
