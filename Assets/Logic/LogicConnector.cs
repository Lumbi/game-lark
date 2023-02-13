using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Rendering.Universal;

[ExecuteAlways]
public class LogicConnector : MonoBehaviour
{
    public bool state;

    public List<LogicConnector> inputPins = new List<LogicConnector>();

    public UnityEvent onTurnOn = new UnityEvent();
    public UnityEvent onTurnOff = new UnityEvent();

    // Visual stuff, would be nice to move to separate component

    private Light2D mainLight;

    // ----

    void Start()
    {
        mainLight = GetComponent<Light2D>();

        if (state) {
            TurnOn();
        } else {
            TurnOff();
        }
    }

    void Update()
    {
        var newState = Logic();
        if (newState != state) {
            state = newState;
            if (state) {
                TurnOn();
            } else {
                TurnOff();
            }
        }
    }

    protected virtual bool Logic() {
        return state;
    }

    private void TurnOn()
    {
        onTurnOn.Invoke();
        if (mainLight) {
            mainLight.intensity = 2f;
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
}
