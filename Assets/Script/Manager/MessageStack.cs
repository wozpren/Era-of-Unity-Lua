using System.Collections;
using System.Collections.Generic;
using System.Text;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using System.Text.RegularExpressions;

namespace EraHF
{
    public class MessageStack : MonoBehaviour, IPointerDownHandler, IPointerEnterHandler,IPointerExitHandler
    {
        public StringBuilder text;//内容

        private TextMeshProUGUI tmp;
        private TextMeshProUGUI title;
        private Queue<string> messStack;
        private RawImage raw;

        private bool canPop;
        public bool CanPop
        {
            get => canPop;
            set => raw.raycastTarget = canPop = value;
        }

        public bool Wait;
        public bool Enter;

        private void Awake()
        {
            title = GameObject.Find("Canvas/Title").GetComponent<TextMeshProUGUI>();
            title.text = $"EraHumanFactory{Application.version}";
            tmp = transform.Find("Viewport/Content").GetComponent<TextMeshProUGUI>();
            raw = GetComponent<RawImage>();
            text = new StringBuilder();
            messStack = new Queue<string>();

            raw.raycastTarget = false;
        }
        /// <summary>
        /// 添加信息
        /// </summary>
        /// <param name="message"></param>
        public void AddMessage(string message)
        {
            messStack.Enqueue(message);
            if (text.Length >= 5000)
            {
                text.Remove(0, 1000);
            }
        }

        public void AddTopMessage(string message)
        {
            text.AppendLine(message);
            tmp.text = text.ToString();
            var rect = tmp.rectTransform.rect;
            tmp.rectTransform.anchoredPosition = new Vector2(0, rect.height);
        }

        public void TitleMessage(string mess)
        {
            title.text = mess;
        }

        public void ClearStack()
        {
            messStack.Clear();
        }
        /// <summary>
        /// 开始推送
        /// </summary>
        public void StartPop()
        {
            if (messStack.Count > 0 && !CanPop)
            {
                CanPop = true;
                TMPBase.Active = false;
                PushMessage();
            }
        }
        /// <summary>
        /// 向信息栏推送消息
        /// </summary>
        public void PushMessage()
        {
            if (CanPop)
            {
                if (messStack.Count > 0)
                {
                    var mess = messStack.Dequeue();
                    while (mess.StartsWith("command"))
                    {
                        string[] args = mess.Split(',');
                        LuaManager.Instance.LuaClient.luaState.Require(args[1]);
                        List<string> a = new List<string>(args);
                        a.RemoveRange(0, 3);
                        LuaManager.Instance.LuaClient.CallFunc(args[2], a.ToArray());
                        if (messStack.Count > 0)
                            mess = messStack.Dequeue();
                        else
                            goto nullmess;
                    }
                    if (mess.Contains("link="))
                        Wait = true;

                    text.AppendLine(mess);
                    tmp.text = text.ToString();
                    var rect = tmp.rectTransform.rect;
                    tmp.rectTransform.anchoredPosition = new Vector2(0, rect.height);
                }
            nullmess:;
                if (messStack.Count == 0 && !Wait)
                {
                    CanPop = false;
                    TMPBase.Active = true;
                    tmp.text = text.AppendLine("----------------------").ToString();
                    LuaManager.Instance.LuaClient.luaState.Require("Main");
                    LuaManager.Instance.LuaClient.CallFunc("EventInvoke", "Update");
                }
            }
        }

        public void PushAllMessage()
        {
            while (messStack.Count > 0 && !Wait)
            {
                PushMessage();
            }
        }

        public void Continue()
        {
            Wait = false;
        }


        public void OnPointerDown(PointerEventData eventData)
        {
            switch (eventData.button)
            {
                case PointerEventData.InputButton.Left:
                    PushMessage();
                    break;
                case PointerEventData.InputButton.Right:
                    PushAllMessage();
                    break;
            }

        }

        public void DelButton()
        {
            Regex regex = new Regex("<link=.*?><color=.*?>(.*?)</color></link>");
            string r = regex.Replace(text.ToString(), "$1");
            text.Clear();
            text.Append(r);
            tmp.text = text.ToString();
        }

        public void OnPointerEnter(PointerEventData eventData)
        {
            Enter = true;
        }

        public void OnPointerExit(PointerEventData eventData)
        {
            Enter = false;
        }
    }
}