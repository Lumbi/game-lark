using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Restart : MonoBehaviour
{
    public GameObject landerPrefab;
    private GameObject lastCheckpoint;

    void Start()
    {
        if (GameObject.FindWithTag("Player") == null) {
            Spawn();
        }
    }

    public void SaveCheckpointAt(GameObject checkpoint)
    {
        lastCheckpoint = checkpoint;
    }

    public void Spawn()
    {
        Vector3 spawnPosition = lastCheckpoint != null ? lastCheckpoint.transform.position : transform.position;
        var lander = Instantiate(landerPrefab, spawnPosition, Quaternion.identity);
        var cameraFollow = FindObjectOfType<CameraFollow>();
        cameraFollow.FocusOn(lander);
    }

    public void SpawnLater(float delay)
    {
        StartCoroutine(_SpawnLater(delay));
    }

    private IEnumerator _SpawnLater(float delay)
    {
        yield return new WaitForSeconds(delay);
        Spawn();
    }

    void OnDrawGizmos()
    {
        Gizmos.color = Color.yellow;
        Gizmos.DrawSphere(transform.position, 1);
    }
}
