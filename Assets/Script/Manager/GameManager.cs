using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.SceneManagement;
using Newtonsoft.Json;
using System.Text;
using System.Linq;
using System;
using JetBrains.Annotations;
using LuaInterface;
using System.Text.RegularExpressions;
using TMPro;

namespace EraHF
{
    public class GameManager : MonoBehaviour
    {
        public static GameManager Instance;
        public static string luaDir;

        public Title Title;
        public TrainPage TrainPage;
        public GeneralPage GeneralPage;
        public MessageStack MessageStack;
        public InputView Input;
        public GameObject DebugTool;


        private void Awake()
        {
            Instance = this;
            TMPBase.canvas = GameObject.Find("Canvas").GetComponent<Canvas>();
            TMPBase.camera = TMPBase.canvas.worldCamera;

            luaDir = Application.platform == RuntimePlatform.Android ? Application.persistentDataPath + "/Lua" : Application.streamingAssetsPath + "/Lua";


            MessageStack = GameObject.Find("Canvas/MessageStack").GetComponent<MessageStack>();
            Input = GameObject.Find("Canvas/Input").GetComponent<InputView>();
            TrainPage = GameObject.Find("Canvas/TrainPage").GetComponent<TrainPage>();
            GeneralPage = GameObject.Find("Canvas/GeneralPage").GetComponent<GeneralPage>();
            DebugTool = GameObject.Find("Canvas/DebugTool");
        }

        private void Start()
        {
            Input.gameObject.SetActive(false);
            DebugTool.SetActive(false);
            TrainPage.gameObject.SetActive(false);
            GeneralPage.gameObject.SetActive(false);
            LuaManager.Instance.LuaClient.CallFunc("Init");
        }


        public void ClickHandle(string file, string command)
        {
            string[] args = command.Split(',');
            if (args.Length == 2)
            {
                LuaManager.Instance.LuaClient.CallFunc(args[0], args[1]);
            }
            else if (args.Length == 3)
            {
                LuaManager.Instance.LuaClient.CallFunc(args[0], args[1], args[2]);
            }
            else
            {
                LuaManager.Instance.LuaClient.CallFunc(command);
            }

        }

        public void ClickHandle(string command)
        {
            string[] args = command.Split(',');
            if (args[0] == "Train")
            {
                LuaManager.Instance.LuaClient.CallFunc("Train.StartTrain", args[1], args[2]);
            }
            else if (args[0] == "Event")
            {
                if (args.Length == 2)
                    LuaManager.Instance.LuaClient.CallFunc("EventInvoke", args[1]);
                else if (args.Length == 3)
                    LuaManager.Instance.LuaClient.CallFunc("EventInvoke", args[1], args[2]);
                else if (args.Length == 4)
                    LuaManager.Instance.LuaClient.CallFunc("EventInvoke", args[1], args[2], args[3]);
            }
            else if (args.Length == 2)
            {
                LuaManager.Instance.LuaClient.CallFunc(args[0], args[1]);
            }
            else if (args.Length == 3)
            {
                LuaManager.Instance.LuaClient.CallFunc(args[0], args[1], args[2]);
            }
            else
            {
                LuaManager.Instance.LuaClient.CallFunc(command);
            }
        }

        public bool IsMatch(string str, string pattern)
        {
            return Regex.IsMatch(str, pattern);
        }
        public void StartInput()
        {
            Input.gameObject.SetActive(true);
        }
        public void StopInput()
        {
            Input.gameObject.SetActive(false);
        }
    }
}