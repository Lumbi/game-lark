using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PrototypeWorldSelect : MonoBehaviour
{
    public void LoadWorld1() {
        SceneManager.LoadScene("Prototype_World1", LoadSceneMode.Single);
        Destroy(this);
    }

    public void LoadWorld2() {
        SceneManager.LoadScene("Prototype_World2", LoadSceneMode.Single);
        Destroy(this);
    }
}
