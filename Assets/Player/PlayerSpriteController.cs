using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerSpriteController : MonoBehaviour
{
    private SpriteRenderer sprite;
    private PlayerInput input;
    private float facingDirection = 0f;
    private float newFacingDirection = 0f;

    void Start()
    {
        sprite = GetComponent<SpriteRenderer>();
        input = GetComponent<PlayerInput>();
    }

    void Update()
    {
        newFacingDirection = Mathf.Sign(input.MoveDirection().x);
        if (input.Move() && newFacingDirection != facingDirection) {
            facingDirection = newFacingDirection;
            sprite.flipX = facingDirection < 0f;
        }
    }
}
