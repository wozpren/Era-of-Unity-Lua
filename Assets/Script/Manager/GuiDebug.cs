using UnityEngine;
using System.Collections;


public class GuiDebug : MonoBehaviour
{


    private bool bShow = true;
    public Rect windowRect0 = new Rect(80, 100, 420, 366);


    public string mSzLog = "";


    void Awake()
    {
        Application.logMessageReceived += HandleLog;
    }
    void OnDisable()
    {
        Application.logMessageReceived -= HandleLog;
    }


    void HandleLog(string logString, string stackTrace, LogType type)
    {
        //output = logString;  
        //stack = stackTrace;  
        mSzLog += logString + "\n" + stackTrace + "\n";
    }


    void DoMyWindow(int windowID)
    {
        if (GUI.Button(new Rect(20, 20, 80, 20), "Add"))
        {
            mSzLog += "Hello!!\n";
        }
        if (GUI.Button(new Rect(120, 20, 80, 20), "Clear"))
        {
            mSzLog = "";
        }
        GUI.TextArea(new Rect(20, 50, 600, 380), mSzLog);
        //GUI.DragWindow（）;//
        GUI.DragWindow(new Rect(0, 0, 600, 400));



        //  
    }




    void OnGUI()
    {
        if (bShow)
        {
            windowRect0 = GUI.Window(0, windowRect0, DoMyWindow, "Draggable Window");
        }
    }
}
