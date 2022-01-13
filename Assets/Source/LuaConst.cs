using UnityEngine;

public static class LuaConst
{
#if UNITY_ANDROID
    public static string luaDir = Application.persistentDataPath + "/Lua";                  //lua逻辑代码目录
#else
    public static string luaDir = Application.streamingAssetsPath + "/Lua";
#endif
    public static string toluaDir = Application.streamingAssetsPath + "/ToLua";        //tolua lua文件目录

#if UNITY_STANDALONE
    public static string osDir = "Win";
#elif UNITY_ANDROID
    public static string osDir = "Android";            
#elif UNITY_IPHONE
    public static string osDir = "iOS";        
#else
    public static string osDir = "";        
#endif
#if UNITY_ANDROID
    public static string luaResDir = string.Format("{0}/{1}/Lua", Application.persistentDataPath, osDir);      //手机运行时lua文件下载目录    
#else
    public static string luaResDir = string.Format("{0}/Lua", Application.streamingAssetsPath);
#endif
#if UNITY_EDITOR_WIN || UNITY_STANDALONE_WIN
    public static string zbsDir = "D:/ZeroBraneStudio/lualibs/mobdebug";        //ZeroBraneStudio目录       
#elif UNITY_EDITOR_OSX || UNITY_STANDALONE_OSX
	public static string zbsDir = "/Applications/ZeroBraneStudio.app/Contents/ZeroBraneStudio/lualibs/mobdebug";
#else
    public static string zbsDir = luaResDir + "/mobdebug/";
#endif

    public static bool openLuaSocket = false;            //是否打开Lua Socket库
    public static bool openLuaDebugger = false;         //是否连接lua调试器
}