using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyLurkerSpriteController : MonoBehaviour
{
    public Sprite spriteIdle;
    public Sprite spriteChasing;
    private SpriteRenderer spriteRenderer;
    private EnemyLurker lurker;
    private EnemyLurker.State lastState;

    void Start()
    {
        lurker = GetComponent<EnemyLurker>();
        spriteRenderer = GetComponent<SpriteRenderer>();
        lastState = lurker.CurrentState();
    }

    void Update()
    {

    }

    void LateUpdate()
    {
        if (lurker.CurrentState() != lastState) {
            UpdateSprite();
            lastState = lurker.CurrentState();
        }
    }

    private void UpdateSprite()
    {
        switch (lurker.CurrentState()) {
            case EnemyLurker.State.Idle: case EnemyLurker.State.WaitingToChase: {
                spriteRenderer.sprite = spriteIdle;
                break;
            }

            case EnemyLurker.State.Chasing: {
                spriteRenderer.sprite = spriteChasing;
                break;
            }
        }
    }
}
