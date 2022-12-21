using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class HUD : MonoBehaviour
{
    public TMP_Text cargoAmountText;

    void Start()
    {
        UpdateCargoCount(0);
    }

    public void UpdateCargoCount(int count)
    {
        cargoAmountText.text = $"IN CARGO: {count}";
    }
}
