using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;


public class UIToolkitManager : MonoBehaviour
{
    public static UIToolkitManager Instance;
    public UIDocument Root;

    private void Awake()
    {
        Instance = this;
        Root = GetComponent<UIDocument>();
    }

    private void Start()
    {
        LoadUXML("/Lua/UI/UIToolkit/TestUI.uxml");
    }

    public void LoadUXML(string path)
    {
        using (StreamReader sr = new StreamReader(Application.streamingAssetsPath + path))
        {
            var ab = AssetBundle.LoadFromStream(sr.BaseStream);
            var sta = ab.LoadAsset<VisualTreeAsset>("Title");
            Root.visualTreeAsset = sta;
        }


    }

    private IEnumerator UXML(string path)
    {
        var handle = AssetBundle.LoadFromFileAsync(path);
        

        yield return handle;
        var sta = handle.assetBundle.LoadAsset<VisualTreeAsset>("Title");
        Root.visualTreeAsset = sta;
    }

}
