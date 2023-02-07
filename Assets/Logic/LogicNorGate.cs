using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LogicNorGate : LogicConnector
{
    protected override bool Logic() {
        var result = false;
        foreach (var inputPin in inputPins) {
            if (inputPin == null) { continue; }
            result = result || inputPin.state;
            if (result) { break; }
        }
        return !result;
    }
}
