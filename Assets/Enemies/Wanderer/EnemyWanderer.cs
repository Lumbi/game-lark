using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.Universal;

public class EnemyWanderer : MonoBehaviour
{
    public Rigidbody2D body;
    public DetectPlayer detectPlayer;
    public Light2D leftEyeLight;
    public Light2D rightEyeLight;
    public SpriteRenderer spriteRenderer;
}
