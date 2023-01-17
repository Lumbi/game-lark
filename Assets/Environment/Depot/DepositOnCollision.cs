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
    private int transientCount = 0;

    public bool isFull { get { return count >= requiredCount; } }

    void Start()
    {
        UpdateCounterText();
    }

    public bool CanAcceptOne()
    {
        return (count + transientCount) < requiredCount;
    }

    public void BeginAcceptOne()
    {
        if (CanAcceptOne()) {
            transientCount += 1;
        }
    }

    public void CommitAcceptOne()
    {
        if (!isFull) {
            count += 1;
            if (transientCount > 0) {
                transientCount -= 1;
            }
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
