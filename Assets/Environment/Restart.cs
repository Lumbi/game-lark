using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Restart : MonoBehaviour
{
    public GameObject landerPrefab;
    private GameObject lastCheckpoint;

    public UnityEvent onSpawn = new UnityEvent();

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

    private void Spawn()
    {
        if (GameObject.FindWithTag("Player") != null) { return; }

        Vector3 spawnPosition = lastCheckpoint != null ? lastCheckpoint.transform.position : transform.position;
        var lander = Instantiate(landerPrefab, spawnPosition, Quaternion.identity);
        var cameraFollow = FindObjectOfType<CameraFollow>();
        cameraFollow.FocusOn(lander);

        onSpawn.Invoke();
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
