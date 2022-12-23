using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Restart : MonoBehaviour
{
    public GameObject landerPrefab;

    public void Spawn()
    {
        Debug.Log($"{GetType().Name} - {System.Reflection.MethodBase.GetCurrentMethod().Name}");
        var lander = Instantiate(landerPrefab, transform.position, Quaternion.identity);
        var cameraFollow = FindObjectOfType<CameraFollow>();
        cameraFollow.FocusOn(lander.transform);
    }

    public void SpawnLater(float delay) {
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
