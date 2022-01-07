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
        tmp.text = string.Format("Era of Unity{0}", Application.version);
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
