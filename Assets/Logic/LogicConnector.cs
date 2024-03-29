using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Rendering.Universal;

public class LogicConnector : MonoBehaviour
{
    public bool state;
    private bool previousState;

    public List<LogicConnector> inputPins = new List<LogicConnector>();

    public UnityEvent onTurnOn = new UnityEvent();
    public UnityEvent onTurnOff = new UnityEvent();

    // Visual stuff, would be nice to move to separate component

    private Light2D mainLight;

    // ----

    void Start()
    {
        mainLight = GetComponent<Light2D>();
        previousState = state;

        if (state) {
            TurnOn();
        } else {
            TurnOff();
        }
    }

    void Update()
    {
        var newState = Logic();
        if (newState != previousState) {
            state = newState;
            if (state) {
                TurnOn();
            } else {
                TurnOff();
            }
        }
        previousState = state;
    }

    protected virtual bool Logic() {
        return state;
    }

    private void TurnOn()
    {
        onTurnOn.Invoke();
        if (mainLight) {
            mainLight.intensity = 3f;
        }
        OnTurnOn();
    }

    protected virtual void OnTurnOn() {}

    private void TurnOff()
    {
        onTurnOff.Invoke();
        if (mainLight) {
            mainLight.intensity = 0.2f;
        }
        OnTurnOff();
    }

    protected virtual void OnTurnOff() {}


    void OnDrawGizmos()
    {
        Gizmos.color = Color.green;
        foreach (var inputPin in inputPins) {
            if (inputPin == null) { continue; }
            Gizmos.DrawLine(inputPin.transform.position, transform.position);
        }
    }
}
