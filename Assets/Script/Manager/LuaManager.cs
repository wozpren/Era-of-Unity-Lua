using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LuaManager : MonoBehaviour
{
    private static LuaManager _instance;
    public static LuaManager Instance
    {
        get
        {
            return _instance;
        }
    }
    private LuaClient _luaClient;
    public LuaClient LuaClient
    {
        get
        {
            return _luaClient;
        }
    }
    void Awake()
    {
        _instance = this;
        //跨场景不销毁
        DontDestroyOnLoad(this.gameObject);
        _luaClient = this.gameObject.AddComponent<LuaClient>();
    }
}
