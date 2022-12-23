using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using TMPro;

public class DepositOnCollision : MonoBehaviour
{
    public int requiredCount;

    public UnityEvent requiredCountReached = new UnityEvent();

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

        if (isFull) {
            requiredCountReached.Invoke();
        }
    }

    public void UpdateCounterText()
    {
        counterText.text = $"{count} / {requiredCount}";
    }
}
