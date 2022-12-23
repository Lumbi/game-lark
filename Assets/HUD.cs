using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class HUD : MonoBehaviour
{
    public TMP_Text cargoAmountText;
    public GameObject controlsHint;
    private bool hidingControlHints = false;

    void Start()
    {
        UpdateCargoCount(0);
    }

    public void UpdateCargoCount(int count)
    {
        cargoAmountText.text = $"IN CARGO: {count}";
    }

    public void HideControlsHint()
    {
        if (controlsHint.activeSelf && !hidingControlHints) {
            StartCoroutine(_HideControlsHint());
        }
    }

    private IEnumerator _HideControlsHint()
    {
        hidingControlHints = true;
        yield return new WaitForSeconds(3f);
        controlsHint.SetActive(false);
    }
}
