using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PrototypeReturnToWorldSelect : MonoBehaviour
{
    private Camera targetCamera;
    private bool transition = false;
    private Matrix4x4 originalProjection;

    void Start()
    {
        targetCamera = Camera.main;
        originalProjection = targetCamera.projectionMatrix;
    }

    void OnTriggerEnter2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player" && !transition) {
            transition = true;
            StartCoroutine(AnimateTransition());
        }
    }

    private IEnumerator AnimateTransition()
    {
        float time = 0f;
        float duration = 3f;
        while (time < duration) {
            Matrix4x4 p = originalProjection;
            p.m01 += Mathf.Sin(time * 1.2f) * 0.1f;
            p.m10 += Mathf.Sin(time * 1.5f) * 0.1f;
            targetCamera.projectionMatrix = p;
            time += Time.deltaTime;
            yield return null;
        }
        SceneManager.LoadScene("Prototype_WorldSelect", LoadSceneMode.Single);
        Destroy(this);
    }
}
