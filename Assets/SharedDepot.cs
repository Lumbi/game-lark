using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SharedDepot : MonoBehaviour
{
    private HUD hud;
    private int count = 0;

    void Start()
    {
        hud = FindObjectOfType<HUD>();
    }

    public void Accept()
    {
        count += 1;
        hud.UpdateDepotCount(count);
    }
}
