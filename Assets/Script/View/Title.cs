using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class Title : MonoBehaviour
{
    private TextMeshProUGUI tmp;
    // Start is called before the first frame update
    void Start()
    {
        tmp = GetComponent<TextMeshProUGUI>();
    }

    public string GetTitle()
    {
        return tmp.text;
    }

    public void SetTitle(string text)
    {
        tmp.text = text;
    }
}
