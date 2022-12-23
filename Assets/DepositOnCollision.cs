using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class DepositOnCollision : MonoBehaviour
{
    public int requiredCount;

    public TMP_Text counterText;

    private int count = 0;

    public bool isFull { get { return count >= requiredCount; } }

    void Start()
    {
        UpdateCounterText();
    }

    public void AcceptOne()
    {
        if (!isFull) {
            count += 1;
            UpdateCounterText();
        }
    }

    private void UpdateCounterText()
    {
        counterText.text = $"{count} / {requiredCount}";
    }
}
