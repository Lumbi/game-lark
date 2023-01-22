using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SlidingWall : MonoBehaviour
{
    private Vector2 originPosition;
    public Vector2 deltaPosition;
    private bool isSliding = false;
    public float slideDuration = 1f;

    void Start()
    {
        originPosition = transform.position;
    }

    public void Slide()
    {
        if (!isSliding) {
            StartCoroutine(_Translate(originPosition + deltaPosition));
        }
    }

    public void Return()
    {
        if (!isSliding) {
            StartCoroutine(_Translate(originPosition));
        }
    }

    private IEnumerator _Translate(Vector2 endPosition)
    {
        isSliding = true;
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

        isSliding = false;
    }

    void OnDrawGizmos()
    {
        if (deltaPosition != null) {
            Gizmos.color = Color.blue;
            Vector3 targetPosition = deltaPosition;
            targetPosition += transform.position;
            Gizmos.DrawLine(transform.position, targetPosition);

            var sprite = GetComponentInChildren<SpriteRenderer>();
            if (sprite != null) {
                Gizmos.color = Color.cyan;
                Gizmos.DrawWireCube(targetPosition, sprite.transform.localScale);
            }
        }
    }
}