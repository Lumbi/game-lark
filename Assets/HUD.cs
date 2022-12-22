using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class HUD : MonoBehaviour
{
    public TMP_Text cargoAmountText;
    public TMP_Text depotAmountText;

    void Start()
    {
        UpdateCargoCount(0);
        UpdateDepotCount(0);
    }

    public void UpdateCargoCount(int count)
    {
        cargoAmountText.text = $"IN CARGO: {count}";
    }

    public void UpdateDepotCount(int count)
    {
        depotAmountText.text = $"IN DEPOT: {count}";
    }
}
