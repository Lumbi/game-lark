using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SlidingWall : MonoBehaviour
{
    private Vector2 originPosition;
    public Vector2 deltaPosition;
    public float slideDuration = 1f;

    void Start()
    {
        originPosition = transform.position;
    }

    public void Slide()
    {
        StopAllCoroutines();
        StartCoroutine(_Translate(originPosition + deltaPosition));
    }

    public void Return()
    {
        StopAllCoroutines();
        StartCoroutine(_Translate(originPosition));
    }

    private IEnumerator _Translate(Vector2 endPosition)
    {
        float time = 0f;
        float interpolation = 0f;
        Vector2 startPosition = transform.position;

        while (time < slideDuration) {
            interpolation = time / slideDuration;
            transform.position = new Vector2(
                Mathf.SmoothStep(startPosition.x, endPosition.x, interpolation),
                Mathf.SmoothStep(startPosition.y, endPosition.y, interpolation)
            );
            time += Time.deltaTime;
            yield return null;
        }
        transform.position = endPosition;
    }

    void OnDrawGizmos()
    {
        if (deltaPosition != null) {
            Gizmos.color = Color.blue;
            Vector2 originPosition = transform.position;
            Vector2 targetPosition = originPosition + deltaPosition;
            Gizmos.DrawLine(originPosition, targetPosition);

            var sprite = GetComponentInChildren<SpriteRenderer>();
            if (sprite != null) {
                Gizmos.color = Color.cyan;
                Gizmos.DrawWireCube(targetPosition, sprite.transform.localScale);
            }
        }
    }
}
