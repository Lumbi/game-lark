using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FiniteStateMachine : MonoBehaviour
{
    public class State: MonoBehaviour {
        public virtual State Next() { return null; }
        public virtual void Enter() { enabled = true; }
        public virtual void Exit() { enabled = false; }
    }

    public State currentState;
    private State nextState;

    void Update()
    {
        nextState = currentState.Next();
        if (nextState) {
            currentState.Exit();
            nextState.Enter();
            currentState = nextState;
        }
    }
}