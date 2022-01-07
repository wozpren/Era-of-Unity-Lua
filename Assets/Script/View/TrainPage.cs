using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class TrainPage : MonoBehaviour
{
    public TextMeshProUGUI Property;
    public TextMeshProUGUI Koujiu;
    public TextMeshProUGUI Options;

    public void Awake()
    {
        Property = transform.Find("Property").GetComponent<TextMeshProUGUI>();
        Property = transform.Find("Koujiu/Viewport/Content").GetComponent<TextMeshProUGUI>();
        Options = transform.Find("Options/Viewport/Content").GetComponent<TextMeshProUGUI>();
    }
}
