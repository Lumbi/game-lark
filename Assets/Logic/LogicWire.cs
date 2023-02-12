using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LogicWire : LogicConnector
{
    protected override bool Logic() {
        foreach (var inputPin in inputPins) {
            if (inputPin == null) { continue; }
            if (inputPin.state == true) { return true; }
        }
        return false;
    }
}
