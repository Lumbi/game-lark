using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Restart : MonoBehaviour
{
    public GameObject landerPrefab;

    public void Spawn()
    {
        var lander = Instantiate(landerPrefab, transform.position, Quaternion.identity);
        var cameraFollow = FindObjectOfType<CameraFollow>();
        cameraFollow.FocusOn(lander.transform);
    }

    void OnDrawGizmos()
    {
        Gizmos.color = Color.yellow;
        Gizmos.DrawSphere(transform.position, 1);
    }
}
