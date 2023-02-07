using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LogicXorGate : LogicConnector
{
    protected override bool Logic()
    {
        bool result = false;
        foreach (var inputPin in inputPins) {
            if (inputPin == null) { continue; }
            if (result && inputPin.state) { return false; }
            result = inputPin.state ^ result;
        }
        return result;
    }
}
