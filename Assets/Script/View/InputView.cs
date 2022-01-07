using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.UI;

namespace EraHF
{
    public class InputView : MonoBehaviour
    {
        public string input;
        public Button Button;

        private void Awake()
        {
            Button = GetComponentInChildren<Button>();
        }

        public void OnChange(string input)
        {
            this.input = input;
        }

        public void Invoke()
        {
            LuaManager.Instance.LuaClient.luaState.Require("Main");
            LuaManager.Instance.LuaClient.CallFunc("EventInvoke", "Input", input);
        }
    }
}