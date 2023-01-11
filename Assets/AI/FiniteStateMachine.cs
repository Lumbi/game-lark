using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FiniteStateMachine : MonoBehaviour
{
    public class State: MonoBehaviour {
        public virtual void Enter() { enabled = true; OnEnter(); }
        public virtual void OnEnter() { }
        public virtual void Exit() { OnExit(); enabled = false; }
        public virtual void OnExit() { }
    }

    public State currentState;

    public void GoTo(State nextState)
    {
        if (nextState != null) {
            currentState.Exit();
            nextState.Enter();
            currentState = nextState;
        }
    }
}