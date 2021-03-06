#Persistent
#SingleInstance,Force
#NoEnv
SendMode,Input
SetKeyDelay,-1
SetBatchLines,-1

applicationname=Accents
Gosub,INIREAD
Gosub,TRAYMENU
Loop,Parse,hotkeys,`,
  Hotkey,%A_LoopField%,ACCENT,On
Return


ACCENT:
hotkey:=A_ThisHotkey
Loop,Parse,hotkeys,`,
  Hotkey,%A_LoopField%,ACCENT,Off

StringRight,key,hotkey,1
StringLower,key,key

GetKeyState,caps,CapsLock,T

IfInString,hotkey,+
If caps=D
  caps=U
Else
  caps=D

string=
counter=1
Loop,
{
  ascii:=Asc(key)
  char:=%ascii%%counter%
  string=%string%%char%
  If %ascii%%A_Index%=
    Break
  counter+=1
}
counter=1

If caps=D
  StringUpper,string,string

Loop
{
  If A_Index=3
  {  
    counter=1
    char:=%ascii%%counter%
    If caps=D
      StringUpper,char,char
    Else
      StringLower,char,char
    Send,{BackSpace 2}%char%
  }
  Else
  If A_Index>3
  {
    char:=%ascii%%counter%
    If caps=D
      StringUpper,char,char
    Else
      StringLower,char,char
    Send,{BackSpace %length%}%char%
  }
  Else
  {
    If caps=D
      StringUpper,key,key
    Else
      StringLower,key,key
    Send,%key%
  }

  IfInString,hotkey,+
    Send,{Shift Down}
  Else
    Send,{Shift Up}

  Input,input,T1 L1,{BackSpace}{Left}{Right}{Up}{Down}{Shift},%char%
  If ErrorLevel=Timeout
  {
    ToolTip,
    Break
  }
  IfInString,ErrorLevel,EndKey:
  {
    StringTrimLeft,endkey,ErrorLevel,7
    endkey={%endkey%}
    Send,%endkey%
    ToolTip,
    Break
  }
    
  If (input<>key)
  {
;    If caps=D
;      StringUpper,input,input
;    Else
;      StringLower,input,input
    ToolTip,
    Send,%input%
    Break
  }

  StringLen,length,char

  StringLeft,char,string,% length
  StringTrimLeft,string,string,% length
  string=%string%%char%
  ToolTip,%string%,% A_CaretX,% A_CaretY-20 ;%counter%`n%key%`n%char%`n%caps%
  counter+=1
  If %ascii%%counter%= 
  {
    ; enable or disable character cycle with these lines vvv
    counter=1
    ; Tooltip,
    ; Send,%input%
  }
}
Loop,Parse,hotkeys,`,
  Hotkey,%A_LoopField%,ACCENT,On
Return


INIREAD:
IfNotExist,%applicationname%.ini
{
  ini=
(
[Settings]
delay=1

[1]
key=a
1=à
2=â
3=ä
4=æ
5=α
6=a

[2]
key=b
1=β
2=b

[3]
key=c
1=ç
2=c

[4]
key=d
1=δ
2=d

[5]
key=e
1=é
2=è
3=ê
4=ë
5=æ
6=ε
7=e

[6]
key=f
1=ƒ
2=f

[7]
key=g
1=γ
2=ȝ
3=g

[8]
key=h
1=η
2=h

[9]
key=i
1=î
2=ï
3=ι
4=i

[10]
key=k
1=κ
2=k

[11]
key=l
1=λ
2=l

[12]
key=m
1=μ
2=m

[13]
key=n
1=ñ
2=ν
3=n

[14]
key=o
1=ô
2=ö
3=œ
4=ο
5=ω
6=ø
7=o

[15]
key=p
1=π
2=p

[16]
key=r
1=ꝛ
2=ρ
3=r

[17]
key=s
1=ß
2=σ
3=ʃ
4=s

[18]
key=t
1=τ
2=θ
3=t

[19]
key=u
1=ù
2=û
3=ü
4=ᵫ
5=υ
6=u

[20]
key=v
1=ⱴ
2=ʌ
3=v

[21]
key=x
1=χ
2=ξ
3=x

[22]
key=y
1=ÿ
2=φ
3=ψ
4=y

[23]
key=z
1=ζ
2=z

[24]
key=*
1=×
2=*

[25]
key=/
1=÷
2=/

[26]
key=>
1=→
2=>

[27]
key=<
1=←
2=<

)
  FileAppend,%ini%,%applicationname%.ini
  ini=
}
hotkeys=
IniRead,delay,%applicationname%.ini,Settings,delay
Loop
{
  section:=A_Index
  IniRead,key,%applicationname%.ini,%section%,key
  If key=ERROR
    Break
  hotkeys=%hotkeys%%key%,+%key%,
  Loop
  {
    ascii:=Asc(key)
    IniRead,%ascii%%A_Index%,%applicationname%.ini,%section%,%A_Index%
    If %ascii%%A_Index%=ERROR
    {
      %ascii%%A_Index%=
      Break
    }
  }
}
StringTrimRight,hotkeys,hotkeys,1
Return


SETTINGS:
Run,%applicationname%.ini
Return


TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Add,%applicationname%,ABOUT
Menu,Tray,Add
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Tip,%applicationname%
Menu,Tray,Default,%applicationname%
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.1
Gui,99:Font
Gui,99:Add,Text,y+10,- Press a key three times or more to apply accents
Gui,99:Add,Text,y+10,- Change accents using Settings in the tray menu
Gui,99:Add,Text,y+10,- Doesn't work properly with CapsLock is on

Gui,99:Add,Picture,xm y+30 Icon6,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+5,Version 1.1 by Myro
Gui,99:Font
Gui,99:Add,Text,y+5,more accents, ux tweaks
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 GGITHUBMYRO,github.com/OMeyer973
Gui,99:Font

Gui,99:Add,Picture,xm y+20 Icon6,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+5,Version 1.0 by Skrommel
Gui,99:Font
Gui,99:Add,Text,y+5,1 Hour Software
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 G1HOURSOFTWARE,www.dcmembers.com/skrommel
Gui,99:Font

Gui,99:Add,Picture,xm y+20 Icon6,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,AutoHotkey
Gui,99:Font
Gui,99:Add,Text,y+5,This tool was made using the powerful
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 GAUTOHOTKEY,www.AutoHotkey.com
Gui,99:Font

Gui,99:Show,,%applicationname% About
hCurs:=DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt") ;IDC_HAND
OnMessage(0x200,"WM_MOUSEMOVE") 
Return

GITHUBMYRO:
  Run,https://github.com/OMeyer973,,UseErrorLevel
Return

	1HOURSOFTWARE:
  Run,https://www.dcmembers.com/skrommel/downloads/,UseErrorLevel
Return

AUTOHOTKEY:
  Run,http://www.autohotkey.com,,UseErrorLevel
Return

99GuiClose:
  Gui,99:Destroy
  OnMessage(0x200,"")
  DllCall("DestroyCursor","Uint",hCur)
Return

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static9,Static13,Static17
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return


EXIT:
ExitApp
