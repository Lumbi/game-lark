using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class DebugTool : MonoBehaviour
{
    public UnityEvent trigger1 = new UnityEvent();
    public GameObject prefab;

    void Update()
    {
        if (Input.GetKeyDown("1")) {
            trigger1.Invoke();
        }
    }

    public void InstantiatePrefab() {
        Instantiate(prefab, transform.position, Quaternion.identity);
    }
}
