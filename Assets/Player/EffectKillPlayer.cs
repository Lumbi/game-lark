using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EffectKillPlayer : MonoBehaviour
{
    public float duration = 1f;
    private float time = 0f;

    private float startScale;
    private float startAlpha;
    public float targetScale = 2f;
    public float targetAlpha = 0f;

    private SpriteRenderer sprite;

    void Start()
    {
        sprite = GetComponent<SpriteRenderer>();
        time = 0f;
        startScale = transform.localScale.x;
        startAlpha = sprite.color.a;
    }

    void Update()
    {
        if (time < duration) {
            float interpolation = time / duration;
            float scale = Mathf.SmoothStep(startScale, targetScale, interpolation);
            transform.localScale = new Vector3(scale, scale, 0f);

            float alpha = Mathf.SmoothStep(startAlpha, targetAlpha, interpolation);
            Color color = sprite.color;
            color.a = alpha;
            sprite.color = color;

            time += Time.deltaTime;
        } else {
            End();
        }
    }

    private void End()
    {
        Destroy(gameObject);
    }
}
