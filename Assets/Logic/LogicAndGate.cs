using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LogicAndGate : LogicConnector
{
    protected override bool Logic() {
        foreach (var inputPin in inputPins) {
            if (inputPin == null) { continue; }
            if (inputPin.state == false) { return false; }
        }
        return true;
    }
}
