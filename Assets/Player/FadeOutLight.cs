using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.Universal;

public class FadeOutLight : MonoBehaviour
{
    public float fadeDuration = 1f;
    private float time = 0f;
    private new Light2D light;
    private float startIntensity = 1f;

    void Start()
    {
        light = GetComponent<Light2D>();
        startIntensity = light.intensity;
    }

    void Update()
    {
        if (time < fadeDuration) {
            light.intensity = Mathf.Lerp(startIntensity, 0f, time / fadeDuration);
            time += Time.deltaTime;
        } else {
            Destroy(gameObject);
        }
    }
}
