using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class OneWaySwitch : MonoBehaviour
{
    public Sprite normalSprite;
    public Sprite activatedSprite;
    public UnityEvent activated = new UnityEvent();
    public UnityEvent deactivated = new UnityEvent();
    public bool isActivated = false;
    private bool wasActivated = false;

    private LogicConnector logicConnector;

    void Start()
    {
        logicConnector = GetComponent<LogicConnector>();
        UpdateSprite();
    }

    void OnTriggerEnter2D(Collider2D collider)
    {
        if (collider.gameObject.tag == "Player") {
            if (!isActivated) {
                Activate();
            }
        }
    }

    void Update()
    {
        if (logicConnector == null) {
            logicConnector = GetComponent<LogicConnector>();
        }

        if (isActivated != wasActivated) {
            if (isActivated) {
                Activate();
            } else {
                Reset();
            }
        }

        wasActivated = isActivated;
    }

    public void Activate()
    {
        isActivated = true;
        if (logicConnector) {
            logicConnector.state = true;
        }
        UpdateSprite();
        activated.Invoke();
    }

    public void Reset()
    {
        isActivated = false;
        if (logicConnector) {
            logicConnector.state = false;
        }
        UpdateSprite();
        deactivated.Invoke();
    }

    private void UpdateSprite() {
        if (isActivated) {
            GetComponent<SpriteRenderer>().sprite = activatedSprite;
        } else {
            GetComponent<SpriteRenderer>().sprite = normalSprite;
        }
    }
}
