using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[System.Serializable]
public class StringUnityEvent : UnityEvent<string> {}

public class Lock : MonoBehaviour
{
    public List<string> answer = new List<string>();
    private List<string> input = new List<string>();
    private bool isSolved = false;

    public StringUnityEvent entered = new StringUnityEvent();
    public UnityEvent correct = new UnityEvent();
    public UnityEvent incorrect = new UnityEvent();

    public void Enter(string word)
    {
        if (isSolved) { return; }

        input.Add(word);
        entered.Invoke(word);

        if (input.Count == answer.Count) {
            bool isCorrect = true;
            for (int i = 0; i < input.Count; i++) {
                if (input[i] != answer[i]) {
                    isCorrect = false;
                    break;
                }
            }
            if (isCorrect) {
                isSolved = true;
                correct.Invoke();
            } else {
                incorrect.Invoke();
                Reset();
            }
        } else if (input.Count > answer.Count) {
            incorrect.Invoke();
            Reset();
        }
    }

    private void Reset()
    {
        input.Clear();
    }

    void OnDrawGizmos()
    {
        Gizmos.color = Color.white;
        Gizmos.DrawWireSphere(transform.position, 1f);

        if (correct.GetPersistentEventCount() > 0) {
            var correctTarget = correct.GetPersistentTarget(0) as Component;
            if (correctTarget != null) {
                Gizmos.color = Color.green;
                Gizmos.DrawLine(transform.position, correctTarget.transform.position);
            }
        }
    }
}
