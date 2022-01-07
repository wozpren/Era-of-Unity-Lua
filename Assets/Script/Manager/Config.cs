using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace EraHF
{
    public class Config
    {
        public int RandomNameType;// 随机名称类型 001中文 010日文 100英文 
        public bool EasyShow;//简易显示
        public int width;//分辨率
        public int height;//分辨率
        public string mode;//全屏模式


        public Config()
        {
            height = 900;
            width = 1600;
            mode = "Windowed";

            RandomNameType = 0b111;
            ApplyWindows();
        }

        public void ApplyWindows()
        {
            Screen.SetResolution(width, height, (FullScreenMode)Enum.Parse(typeof(FullScreenMode),mode));
        }
    }
}
