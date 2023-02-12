using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways]
public class Gate : MonoBehaviour
{
    public bool isOpen = false;
    private bool wasOpen = false;

    public void Open()
    {
        Set(true);
    }

    public void Close()
    {
        Set(false);
    }

    void Update()
    {
        if (isOpen != wasOpen) {
            if (isOpen) {
                Open();
            } else {
                Close();
            }
        }

        wasOpen = isOpen;
    }

    private void Set(bool open)
    {
        isOpen = open;
        GetComponent<SpriteRenderer>().enabled = !open;
        GetComponent<Collider2D>().enabled = !open;
    }

    void OnDrawGizmos()
    {
        var spriteRenderer = GetComponent<SpriteRenderer>();
        Gizmos.color = spriteRenderer.color;
        Gizmos.DrawWireCube(transform.position, transform.localScale);
    }
}
