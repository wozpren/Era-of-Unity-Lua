using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class GeneralPage : MonoBehaviour
{
    public TextMeshProUGUI Page;
    public TextMeshProUGUI Menu;

    private void Awake()
    {
        Page = transform.Find("ScrollPage/Viewport/Content").GetComponent<TextMeshProUGUI>();
        Menu = transform.Find("Menu").GetComponent<TextMeshProUGUI>();
    }
}
