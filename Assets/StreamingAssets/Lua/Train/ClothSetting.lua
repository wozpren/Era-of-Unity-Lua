﻿local text = SB.New()
text:Append(Female.Name.."的穿着".."\n")
text:Append("头"..Female : GetOutsideEquip(0).."\n")
text:Append("眼"..Female : GetOutsideEquip(1).."\n")
text:Append("嘴"..Female : GetOutsideEquip(2).."\n")
text:Append("脖子"..Female : GetOutsideEquip(3).."\n")
text:Append("手"..sFemale : GetOutsideEquip(4).."\n")
text:Append("身体"..Female : GetOutsideEquip(5).."\n")
text:Append("腿"..Female : GetOutsideEquip(6).."\n")
text:Append("脚"..Female : GetOutsideEquip(7).."\n")
Message : AddMessage(text:ToStr())