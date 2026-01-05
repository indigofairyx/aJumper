

global ImportantEncodingMSG := "! IMPORTANT! THIS FILE MUST BE ENCODED WITH UTF8+BOM !"
#Warn All, Off
#Warn UseEnv, Off
Menu, tray, UseErrorLevel, On

#Requires Autohotkey v1.1.+
Envget, atemp, atemp
Envget, ahk, ahk
Envget, xinc, xinc

envget, userprofile, userprofile
EnvGet, LocalAppData, LocalAppData
envget, appdata, appdata
envget, xscript, XScript
global ahk, xinc, atemp, userprofile, LocalAppData, appdata, path, XScript

SetWorkingDir,%A_ScriptDir%
splitpath, A_ScriptFullPath, , , A_ScriptEXT, A_ScriptStem
global SourceScript := A_ScriptDir "\" A_ScriptStem ".ahk"
global CompiledScript := A_ScriptDir "\" A_ScriptStem ".exe"

If (A_AhkPath ~= "i)AutoHotkeyU.*_UIA\.exe$")
    Global A_IsUIA := 1


global A_Enter := "`r`n"
global A_Return := "`r`n"
global A_R := "`r`n"
global A_NewLine := "`n"
global A_NL := "`n"
global A_Quote := """"
global A_Q := """"


global atemp := A_ScriptDir "\aTemp"
If !FileExist(atemp)
    FileCreateDir, %atemp%
global icons := A_ScriptDir "\Icons"
global msglog := A_ScriptDir "\aTemp\msg_debug.log"
global inifile := A_ScriptDir "\" A_ScriptStem ".ini"
If !FileExist(inifile)
{
    Tip("INI File not found!`nMaking a new one...", 3000)
    sleep 1000
    gosub makeini
}


global AHKFilePath := ""
global xtime := ""
xtime()
{
    FormatTime, XTime, %date%, yyyy/MM/dd HH:mm tt
}
ExpandVars(str) {
    Transform, result, Deref, %str%
    return result
}


GetFullPath(path) {
    VarSetCapacity(buf, 260 * 2)
    DllCall("GetFullPathName", "str", path, "uint", 260, "str", buf, "ptr", 0)
    return buf
}


tip(msg, rtt := "")
{
    global AutoClearTooltips, ClearToolTipTimer
    if (AutoClearTooltips)
        rtt := ClearToolTipTimer
    
    if (rtt > 0)
    {
        Tooltip, %msg%
        SetTimer, RemoveTooltip, %rtt%
    }
    else
        Tooltip, %msg%
}
RemoveToolTip()
{
    ToolTip
}
global to
box(msg, to := 0) {
    SetTimer, AutoMsgBoxButtons_Func, -50
    if (to > 0)
        MsgBox, 262404, - xMsg - %A_ScriptName%, %msg%, %to%
    else
        MsgBox, 262404, - xMsg - %A_ScriptName%, %msg%
    
    IfMsgBox Yes
    {
        clipboard =
        sleep 30
        clipboard := msg
        ClipWait,0.5
        if Clipboard !=
        {
            tooltip, Copied...`n %msg%
            SetTimer, RemoveToolTip, -2500
        }
    }
    IfMsgBox No
    {
        
    }
    IfMsgBox Cancel
    {
        
    }
    IfMsgBox Timeout
    {
        
    }
    Return
}

AutoMsgBoxButtons_Func() {
    IfWinNotExist, - xMsg - %A_ScriptName%
        return
    
    SetTimer, AutoMsgBoxButtons_Func, Off
    WinActivate
    ControlSetText, Button1, &Copy
    ControlSetText, Button2, &OK
    return
}


INIReadSection_OG_(sectionName)
{
    global
    IniRead, SectionContent, %inifile%, %sectionName%
    if (SectionContent = "ERROR")
    {
        tooltip ERR! reading [%sectionName%]
        return
    }
    Loop, Parse, SectionContent, `n, `r
    {
        if (A_LoopField = "")
            continue
        KeyParts := StrSplit(A_LoopField, "=")
        if (KeyParts.Length() < 2)
            continue
        VarName := Trim(KeyParts[1])
        VarValue := Trim(KeyParts[2])
        if (VarValue = "" || VarValue = "ERROR")
            VarValue := (sectionName = "Settings") ? 0 : ""
        VarName := RegExReplace(VarName, "[^A-Za-z0-9_]", "_")
        VarName := RegExReplace(VarName, "^[0-9]+", "")
        VarName := RegExReplace(VarName, "_+", "_")
        VarName := Trim(VarName, "_")
        if (VarName = "")
            VarName := "var_" A_TickCount
        %VarName% := VarValue
    }
    if fileExist(texteditor)
    {
        splitpath, texteditor, TE_Name, TE_Dir, , TE_Stem, TE_Drive
        TE := texteditor
    }
}
INIReadSection(sectionName)
{
    global
    IniRead, SectionContent, %inifile%, %sectionName%
    if (SectionContent = "ERROR")
    {
        tooltip ERR! reading [%sectionName%] `n %A_LineFile% Line#: %A_LineNumber%
        return
    }
    
    Loop, Parse, SectionContent, `n, `r
    {
        if (A_LoopField = "")
            continue
        
        KeyParts := StrSplit(A_LoopField, "=")
        if (KeyParts.Length() < 2)
            continue
        
        VarName := Trim(KeyParts[1])
        VarValue := Trim(KeyParts[2])
        
        if (VarValue = "" || VarValue = "ERROR")
            VarValue := (sectionName = "Settings") ? 0 : ""
        
        VarName := RegExReplace(VarName, "[^A-Za-z0-9_]", "_")
        VarName := RegExReplace(VarName, "_+", "_")
        VarName := Trim(VarName, "_")
        
        if (VarName = "")
            VarName := "var_" A_TickCount
        
        
        
        %VarName% := VarValue
        if fileExist(texteditor)
        {
            splitpath, texteditor, TE_Name, TE_Dir, , TE_Stem, TE_Drive
            TE := texteditor
        }
        If FileExist(iniTextEditor)
        {
            splitpath, iniTextEditor, iniTE_Name, iniTE_Dir, , iniTE_Stem, iniTE_Drive
            
            iniTE := iniTextEditor
            splitpath, iniTE, iniefilename
            
        }
    }
}

global iniefilename
global TE := texteditor


INIGroupAdd(groupName, iniSection := "aJump_Config") {
    global IniFile
    IniRead, exeList, %IniFile%, %iniSection%, GroupAdd_%groupName%_exe, %A_Space%
    Loop, Parse, exeList, |
    {
        exe := Trim(A_LoopField)
        if (exe != "")
            GroupAdd, %groupName%, ahk_exe %exe%
    }
    IniRead, classList, %IniFile%, %iniSection%, GroupAdd_%groupName%_class, %A_Space%
    Loop, Parse, classList, |
    {
        class := Trim(A_LoopField)
        if (class != "")
            GroupAdd, %groupName%, ahk_class %class%
    }
}


dummy()
{
    return
}





OpenTEToLine(file, line) {
    global TE_Name, SciTE, vscode, notepadpp, ahkstudio, notepad4, sublimetext, texteditor, iniTextEditor, geany
    splitpath, texteditor, TE_Name
    splitpath, iniTextEditor, iniTE_Name, iniTE_Dir, , iniTE_Stem, iniTE_Drive
    splitpath, file, ,,ext
    if (ext = "ini")
    {
        if (iniTE_name = "Notepad4.exe")
            run, %iniTextEditor% /g %Line% "%File%"
        else
            try run, %iniTextEditor% "%File%"
        catch
            try run "%File%"
        return
    }
    root := A_ScriptDir
    if (TE_Name = "SciTE.exe")
        Run, "%SciTE%" -goto:%line% "%file%"
    else if (TE_Name = "VSCodium.exe") || (TE_Name = "code.exe")
    {
        if (InStr(file, root) = 1)
            Run, "%vscode%" --reuse-window -g "%file%:%line%"
        else
            Run, "%vscode%" -g "%file%:%line%"
    }
    else if (TE_Name = "Notepad++.exe")
        Run, "%notepadpp%" "%file%" -n%line%
    else if (TE_Name = "AHK-Studio.exe")
    {
        Run, "%ahkstudio%" "%file%"
        WinWaitActive, AHK Studio - ahk_exe AHK-Studio.exe
        send, ^g
        sleep 200
        send, %line%
        send, {enter}
        
    }
    else if (TE_Name = "notepad4.exe")
        Run, "%notepad4%" /g %line% "%file%"
    else if (TE_Name = "geany.exe")
        Run, "%geany%" -l %line% "%file%"
    else if (TE_Name = "sublime_text.exe")
        Run, "%sublimetext%" "%file%:%line%"
    else if (TE_Name = "Adventure.exe")
        Run, "%texteditor%" "%file%"
    else
        Try Run, "%texteditor%" "%file%"
    catch
        Run, notepad.exe "%file%"
    
}
OpenFileToFoundText(file,text:="")
{
    global texteditor, notepad4, TE_name, vscode, sublimetext, targetfile, currentfile, te, iniTextEditor, gotosearch, geany
    searchText := text
    targetFile := file
    foundLine := 0
    splitpath, targetfile, ,,ext
    splitpath, texteditor,TE_Name
    splitpath, iniTextEditor, iniTE_name
    FileRead, fileContents, %targetFile%
    Loop, Parse, fileContents, `n, `r
    {
        if InStr(A_LoopField, searchText) {
            foundLine := A_Index
            break
        }
    }
    if !(searchText)
    {
        run, %texteditor% "%targetFile%"
        return
    }
    if !(foundline)
    {
        run, %texteditor% "%targetFile%"
        return
    }
    if (foundLine > 0)
    {
        if (ext = "ini")
        {
            if (iniTE_name = "Notepad4.exe")
                run, %iniTextEditor% /g %foundLine% "%targetFile%"
            else
                try run, %te% "%targetFile%"
            catch
                try run "%targetFile%"
            return
        }
        else
        {
            if (TE_Name = "notepad++.exe")
                Run, notepad++.exe "%targetFile%" -n%foundLine%
            else if (TE_Name = "VSCodium.exe")
                Run, %vscode% -g "%targetFile%:%foundLine%"
            else if (TE_Name = "sublime_text.exe")
                Run, %sublimetext% "%targetFile%:%foundLine%"
            else if (TE_Name = "geany.exe")
                Run, "%geany%" -l %foundLine% "%targetFile%"
            else if (TE_Name = "notepad4.exe")
                run, %notepad4% /g %foundLine% "%targetFile%"
        }
    }
    return
}



ProcessExist(exeName)
{
    Process, Exist, %exeName%
    return ErrorLevel
}



FindAllInNpp(filepath,text)
{
    global find, this, tip, notepadpp
    SplitPath, filepath, name, dir, ext, stem
    SetTitleMatchMode, 2
    
    Run, %notepadpp% "%filepath%"
    WinWaitActive, %name% - Notepad++ ahk_class Notepad++ ahk_exe notepad++.exe,,7
    if ErrorLevel
    {
        tip("what the fuck ahk!`nWaiting for " name " - Notepad++`nHas Errored Out! Check your spelling in the filepath being sent, ITs CaseSensitive!", 7000)
        return
    }
    sleep 300
    send, ^f
    WinWaitActive, Find ahk_class #32770 ahk_exe notepad++.exe,,3
    if ErrorLevel
    {
        tip("what the fuck ahk!`nWaiting for Find ahk_class #32770 ahk_exe notepad++.exe", 7000)
        return
    }
    sleep 200
    ControlSetText, Edit1, %text%, A
    ControlClick, Find All in Current &Document, A,,left,1,na
    sleep 100
    WinActivate, Find ahk_class #32770 ahk_exe notepad++.exe
    sleep 100
    ControlClick, ? Find Next, A,,left,1,na
    WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
    return
}

ToggleScript(filepath)
{
    DetectHiddenWindows, On
    global ahk, xinc, atemp
    splitpath, filepath, name,,ext
    If !FileExist(filepath)
    {
        tip("The provided filepath cannont be found.`n" filepath, 3500)
        return
    }
    if (ext = "exe")
    {
        if ProcessExist(name)
            Run, taskkill /f /im %name%,, Hide
        else
            run, %filepath%
    }
    else if (ext = "ahk")
    {
        if (WinExist(filepath " ahk_class AutoHotkey"))
        {
            WinClose, %filepath% ahk_class AutoHotkey
        }
        else
        {
            Run %filepath%
        }
    }
    Else
    {
        tip("This Function only works with .exes or .ahks`nOR`nFilepath was not found`n" filepath, 5000)
    }
    
    DetectHiddenWindows, Off
    return
}






;; x[SendToMain].ahk
global labelname := ""
global stringtosend := ""
global StringReceived := ""
global CopyOfData := ""
global LabelCMD := atemp "\LabelCMD.txt"
global FuncCMD := atemp "\FuncCMD.txt"
DetectHiddenWindows, On
OnMessage(0x4A, "ReceiveMessage") ;; this is in autoexe ;; this need to be inside of DetectHiddenWindows says gpt:ai:
; global MainScriptTitle := "xxx.ahk ahk_class AutoHotkey" ; X:\AHK\x.ahk ; X:\AHK\x.ini
; global MainScript := "xxx.ahk ahk_class AutoHotkey"
global MainScriptTitle := "xxx.ahk - AutoHotkey v1." ; X:\AHK\x.ahk ; X:\AHK\x.ini
global MainScript := "xxx.ahk - AutoHotkey v1."
Global Main := "xxx.ahk - AutoHotkey v1."
; Global MainScriptEXE :=
; If FileExist(ahk "\xxx.exe")
; {
    ; global MainScriptTitle := "xxx.exe" ; X:\AHK\x.ahk ; X:\AHK\x.ini
    ; global MainScript := "xxx.exe"
; }

; If ProcessExist("xxx.exe")
; {
    ; global MainScriptTitle := "xxx.exe" ; X:\AHK\x.ahk ; X:\AHK\x.ini
    ; global MainScript := "xxx.exe"
; }

DetectHiddenWindows, off
; X:\AHK\xxx.ahk - AutoHotkey v1.1.37.02 ahk_class AutoHotkey ahk_exe AutoHotkeyU64_UIA.exe
; SendLabelToMain(labelName) {
    ; FileAppend, %A_Now% - Sent Message via %A_thisfunc%(%labelName%`, %mainscripttitle%) from = %A_scriptname%`n, %msglog%
    ; global MainScriptTitle
    ; return SendToScript(labelName, MainScriptTitle)
; }
SendLabelToMain(text) {
; global LabelCMD := A_scriptdir "\..\LabelCMD.txt" ;; in autoexe
    FileDelete, %LabelCMD%
    FileAppend, %text%, %LabelCMD%
    ; run, %labelcmd%
    ; run, %LabelCMD%
}

SendFuncToMain(text) {
; global FuncCMD := A_ScriptDir "\..\FuncCMD.txt" ;; in autoexe
    FileDelete, %FuncCMD%
    FileAppend, %text%, %FuncCMD%
}

; ========================================
; FINAL VERSION: Use This Single Function
; ========================================
; usage = sendtoscript("GotoGuiContextMenu", "GoTo.ahk") ; !the script name is CaseSensitive!, sends label
SendToScript(ByRef StringToSend, ByRef TargetScript) {
    ; This function sends the specified string to the specified window and returns the reply.
    ; The reply is 1 if the target window processed the message, or 0 if it ignored it.

    if !InStr(TargetScript, "ahk_class")    ; Auto-append ahk_class if not present
        TargetScript .= " ahk_class AutoHotkey"
    
    ; Check if target window exists first
    Prev_DetectHiddenWindows := A_DetectHiddenWindows
    Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows, On
    SetTitleMatchMode, 2
    
    ; Check if window exists
    if !WinExist(TargetScript) {
        tip("The TargetScript = " TargetScript "`nIs Not Running\Not Found`nThe TargetScript Title is Case Sensitive! so Check your tyPos?", 5000)
        DetectHiddenWindows, %Prev_DetectHiddenWindows%
        SetTitleMatchMode, %Prev_TitleMatchMode%
        return 0
    }
    
    ; Set up the structure's memory area
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)
    
    ; First set the structure's cbData member to the size of the string, including its zero terminator
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  ; OS requires that this be done
    NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)  ; Set lpData to point to the string itself
    
    TimeOutTime := 4000  ; Milliseconds to wait for response from receiver. Default is 5000
    
    ; Must use SendMessage not PostMessage
    SendMessage, 0x4A, 0, &CopyDataStruct,, %TargetScript%,,,, %TimeOutTime%  ; 0x4A is WM_COPYDATA
    
    ; Restore original settings for the caller
    DetectHiddenWindows, %Prev_DetectHiddenWindows%
    SetTitleMatchMode, %Prev_TitleMatchMode%
    FileAppend, `n%A_Now% - Sent Message via %A_thisfunc%(%StringToSend%`, %TargetScript%) FROM= %A_scriptname%`, TO= %TargetScript% `n`t¦ Run`, Notepad++.exe -n%A_linenumber% "%A_linefile%"`n, %msglog%
    ; Return SendMessage's reply back to our caller
    return ErrorLevel
}

SendToMain(ByRef StringToSend) {
    ; This function sends the specified string to the specified window and returns the reply.
    ; The reply is 1 if the target window processed the message, or 0 if it ignored it.

global Main
    ; if !InStr(TargetScript, "ahk_class")    ; Auto-append ahk_class if not present
        ; TargetScript .= " ahk_class AutoHotkey"
    
    ; Check if target window exists first
    Prev_DetectHiddenWindows := A_DetectHiddenWindows
    Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows, On
    SetTitleMatchMode, 2
    
    ; Check if window exists
    if !WinExist(Main) {
        tip("The TargetScript = " Main "`nIs Not Running\Not Found`nThe TargetScript Title is Case Sensitive! so Check your tyPos?", 5000)
        DetectHiddenWindows, %Prev_DetectHiddenWindows%
        SetTitleMatchMode, %Prev_TitleMatchMode%
        return 0
    }
    
    ; Set up the structure's memory area
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)
    
    ; First set the structure's cbData member to the size of the string, including its zero terminator
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  ; OS requires that this be done
    NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)  ; Set lpData to point to the string itself
    
    TimeOutTime := 4000  ; Milliseconds to wait for response from receiver. Default is 5000
    
    ; Must use SendMessage not PostMessage
    SendMessage, 0x4A, 0, &CopyDataStruct,, %Main%,,,, %TimeOutTime%  ; 0x4A is WM_COPYDATA
    
    ; Restore original settings for the caller
    DetectHiddenWindows, %Prev_DetectHiddenWindows%
    SetTitleMatchMode, %Prev_TitleMatchMode%
    ; FileAppend, %A_Now% - Sent Message via %A_thisfunc%(%StringToSend%) FROM= %A_scriptname%`, TO= %Main% ¦ Run`, Notepad++.exe -n%A_linenumber% "%A_linefile%"`n, %msglog%
    FileAppend, `n%A_Now% - Sent Message via %A_thisfunc%(%StringToSend%) ¦FROM= %A_scriptname%¦TO= %Main%¦`n, %msglog%
    ; Return SendMessage's reply back to our caller
    return ErrorLevel
}


;; x[ReceiveMessage].ahk
ReceiveMessage(wParam, lParam) {  ;; ReceiveMessage()
    global ahk
    ; CRITICAL: Set thread to interrupt-safe
    Critical, On
    
    ; Debug log (comment out after testing)
   
    StringAddress := NumGet(lParam + 2*A_PtrSize)
    StringReceived := StrGet(StringAddress)
    
    parts := StrSplit(StringReceived, "|")
    
    FileAppend, `n%A_Now% - Message received in %A_scriptname% ¦ StringReceived=%StringReceived% via %A_ThisFunc%()`n`tRun`, Notepad++.exe -n%A_linenumber% "%A_linefile%" <-#!R`n, %msglog%
    ; FileAppend, %A_Now% - Content= %StringReceived%`n,   %msglog%

    if (parts.Length() = 1)    ; --- PRIORITY HANDLER ---
    {
        if IsLabel(StringReceived)
        {
            FileAppend, `n%A_Now% - Executing label= %StringReceived%`n,  %msglog%
            gosub %StringReceived%
            return true
        }
        else
        {

            return false            ;; Unknown single param – safely ignore
        }
    }

    cmd := parts[1]

    if (cmd = "msg")
        MsgBox, % parts[2]
    else if (cmd = "set")
        parts[2] := parts[3]
    else if (cmd = "toggle")
        parts[2] := !parts[2]
    else if (cmd = "run")
        Run, % parts[2]
    else if (cmd = "label" && IsLabel(parts[2]))
        Gosub % parts[2]

    else if (cmd = "func") ;; gpt add 12-22-2025, can now take more params, suposiedly untested
    {
        fn := parts[2]

        ; Build params array
        params := []
        for i, val in parts
            if (i > 2)
                params.Push(val)

        try
        {
            Func(fn).Call(params*)
        }
        catch e
        {
            ToolTip, Failed to call function:`n%fn% ;`n% e.Message
            SetTimer, RemoveToolTip, -3000
        }
    }
    else
        MsgBox, 16, Unknown Command, Unknown command:`n%StringReceived%

    return true
} 



;; ==================================================
;; Moved from = %A_scriptdir%\xINC\SideLoads\aJump\aJump.ahk = 12/27/2025 @ 21:46 PM =
;; ==================================================
; usage LoadASDSection("aJump_Config")
LoadASDSection(section)
{
    global inifile, iie
    if WinExist(" - iniEditor ahk_class AutoHotkeyGUI ahk_exe iniEditor.exe")
    {
        Winactivate
        iniwrite, %section%, %inifile%, iiEConfig, ASDToLoad         ; sleep 200
        SendToScript("SideLoadASDSection", "iniEditor.exe")
    }
    else
        run, %iie% /s "%section%" "%inifile%"
}
;; ==================================================








contextcolor() ;0=Default ;1=AllowDark ;2=ForceDark ;3=ForceLight ;4=Max
contextcolor(color:=2)
	{
        static uxtheme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
        static SetPreferredAppMode := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 135, "ptr")
        static FlushMenuThemes := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 136, "ptr")
        DllCall(SetPreferredAppMode, "int", color)
        DllCall(FlushMenuThemes)
	}

OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1. 

WM_LBUTTONDOWNdrag() {  ;;∙======∙Gui Drag Pt 2
; Get the control class under mouse
    MouseGetPos,,, Win, Control
    
    ; Don't drag if clicking in an Edit control
    ; if InStr(Control, "Edit")
        ; return
    
    ; Don't drag if clicking in a ListView
    if InStr(Control, "SysListView")
        return
    
    ; Don't drag if clicking a Button
    if InStr(Control, "Button")
        return
    
    ; Only drag from the GUI background or specific safe areas
    PostMessage, 0x00A1, 2, 0
}



OnMessage(0x0232, "WM_EXITSIZEMOVE")  
SetWindowIcon(hGui, IconPath)
{
    hIcon := DllCall("LoadImage", "Ptr", 0, "Str", IconPath, "UInt", 1, "Int", 0, "Int", 0, "UInt", 0x10)
    SendMessage, 0x80, 1, hIcon,, ahk_id %hGui% ; WM_SETICON (1 = ICON_BIG)
    SendMessage, 0x80, 0, hIcon,, ahk_id %hGui% ; WM_SETICON (0 = ICON_SMALL)
}
;; ==================================================


#SingleInstance, Force
#Persistent
SendLevel, 1
#InstallKeybdHook
#InstallMouseHook
#MaxThreads 255
SetBatchLines, -1
SetTitleMatchMode,2
CoordMode, mouse, window





INIGroupAdd("editors")


If FileExist(CompiledScript)
{
}
OnMessage(0x0232, "WM_EXITSIZEMOVE")
WM_EXITSIZEMOVE() {
    SaveGotoPos()
}

SaveGotoPos()
{
    global inifile, ggX, ggY
    WinGet, state, MinMax, > A_Jumper > ahk_class AutoHotkeyGUI
    if (state = 0)
    {
        WinGetPos, ggX, ggY,,, > A_Jumper > ahk_class AutoHotkeyGUI
        IniWrite, %ggX%, %inifile%, aJump_Config, ggX
        IniWrite, %ggY%, %inifile%, aJump_Config, ggY
    }
}

OnExit("ExitaJump")
ExitaJump()
{
    Menu, tray, noicon
    global inifile
    SaveGotoPos()
}

Global it := ""
Global Line := ""
Global Row := ""
global filename := ""
global dir := ""
global CurrentFile := ""
global A_file := ""
global A_FileClicked := ""
global fullpath := ""
global ReIndex := 0
global FontSize_LV := 12
global texteditor
global GOTOS := {}
GOTOS.filelist := {}
goto_cache := {}
global scriptlistcount := 0
global SearchTerm := ""
Global hastext := ""
global mainlist, ggggg, slvbut, rel, ed, ex, fname, adir, alse
global autoLoadFileIN := 1
global FileIN := ""
global ViewMode := "A_single"
global ActiveFileIndex := 0
global fname := ""
global name := ""
global isStartup := 1
Global ShowMoreBelow := 0
Global ShowInlineComments := 1
global InlineComment := ""
Global FullListViewBuilt := 0
global NppFile := ""
global A_nppfile := "Void"
global UseFuzzy := 0
global pin := 1
Global listviewrows := 13
global DefaultGUIWidth := 675
global HideTooltips := 0
global FontSize_SB
global Font_LV
global FontSize_LV






global aJumpTempSave := atemp "\aJump_ListviewTemp.txt"
global trayicon := icons "\ajump.ico"

if (A_TickCount < 60000)
{
    Global A_IsBooting := 1
}





global aJumpList := A_ScriptDir "\aJumpScriptList.txt"
global InFileList := ""


INIReadSection("aJump_Config")
INIReadSection("MenuOptions")
INIReadSection("Programs")

if (HideTooltips)
    AddTooltip("Deactivate")
else
    AddTooltip("Activate")
global IS := Menu_IconSize
global TE := TextEditor

if (scriptlist != "")
{
    If FileExist(scriptlist)
        ajumplist := Scriptlist
}
if FileExist(aJumpList)
    LoadScriptListMap()


LoadScriptListMap()
{
    global InFileList, aJumpList
    InFileList := ""
    if FileExist(aJumpList)
    {
        FileRead, txt, %aJumpList%
        InFileList := "`n" . txt . "`n"
    }
}




If FileExist(trayicon)
    Menu, tray, icon, %trayicon%

menu, tray, add, Show Gui, BuildGUI
menu, tray, Icon, Show Gui, %trayicon%,,%is%
Menu, tray, click, 1

menu, tray, default, show gui
Menu, tray, add,

Menu, tray, add, Edit [aJump_Config] Settings, EditaJumpSettings
If FileExist(iie)
    Menu, tray, Icon, Edit [aJump_Config] Settings, %iie%,,%is%
else
    Menu, tray, Icon, Edit [aJump_Config] Settings, %icons%\iniicon.ico,,%is%


if FileExist(XScript)
{
    if !(A_IsCompiled)
    {
        Menu, tray, add, Compile,CompileGTF
        Menu, tray, Icon, Compile, %A_AHKPath%,,%is%
    }
    else
    {
        Menu, tray, add, Re-Compile && Run, CompileGTF
        Menu, tray, Icon, Re-Compile && Run, %Icons%\compile4.ico,,%is%
    }
    
}
If FileExist(SourceScript) && (DevMode)
{
    if (A_iscompiled)
    {
        Menu, tray, add, Edit Source Script, EditaJump
        Menu, tray, Icon, Edit Source Script, %texteditor%,,%is%
    }
    else
    {
        Menu, tray, add, Edit Script, EditaJump
        Menu, tray, Icon, Edit Script, %texteditor%,,%is%
    }
}
Menu, tray, add,
Menu, tray, add, Reload, reload
Menu, tray, Icon, Reload, %icons%\reload.ico,,%is%
Menu, Tray, add, Quit\Exit, Exit
Menu, Tray, Icon, Quit\Exit, %Icons%\closer warning error imageres_98_256x256.ico,,%is%


if (DevMode)
{
    menu, tray, add,
    Menu, Tray, add, Listlines`t[env], Listlines
    Menu, Tray, Icon, Listlines`t[env], %icons%\bug.ico,,16
    Menu, Tray, add, KeyHistory`t[env], KeyHistory
    Menu, Tray, Icon, KeyHistory`t[env], %icons%\bug.ico,,16
    Menu, Tray, add, ListHotkeys`t[env], ListHotkeys
    Menu, Tray, Icon, ListHotkeys`t[env], %icons%\bug.ico,,16
    Menu, Tray, add, ListVars`t[env], ListVars
    Menu, Tray, Icon, ListVars`t[env], %icons%\bug.ico,,16
}
ListVars() {
    ListVars
}

ListHotkeys() {
    ListHotkeys
}

KeyHistory() {
    KeyHistory
}

Listlines() {
    Listlines
}

menu, tray, NoStandard



if (%0% > 0)
{
    Loop %0%
    {
        FileIN := %A_Index%
        autoLoadfileIN := 1
    }
}

if FileExist(FileIN) {
    global CurrentFile := FileIN
    GoTo_Readfile(FileIN)
    ActiveFileIndex := FileIsCached(FileIN)
    iniwrite, %CurrentFile%, %inifile%, aJump_Config, A_FileIN
    iniwrite, %CurrentFile%, %inifile%, aJump_Config, A_File
    
    goto BuildGUI
}




IniRead, ViewMode, %inifile%, aJump_Config, ActiveViewMode, A_single
if (viewMode = "A_full")
{
    gosub BuildFullListView
    gosub BuildGUI
}
else
{
    
    if WinExist("ahk_class Notepad++")
    {
        WinGetTitle, Title, - Notepad++ ahk_class Notepad++
        if RegExMatch(Title, "([A-Z]:\\[^*]+\.ahk)", foundPath)
            if FileExist(foundPath) {
                Global CurrentFile := foundPath
                GoTo_Readfile(foundPath)
                ActiveFileIndex := FileIsCached(foundPath)
                
                goto BuildGUI
            }
        
    }
    else
    {
        iniread, a_file, %inifile%, aJump_Config, A_file
        If FileExist(A_file)
            CurrentFile := A_file
        else
            CurrentFile := SourceSource
        
        GoTo_Readfile(CurrentFile)
        ActiveFileIndex := FileIsCached(CurrentFile)
        goto BuildGUI
    }
    
}


return

rebuildGUI:
BuildaJumpGUI:

BuildGUI:
    Gui, g: New
    Gui, Default
    Gui, +HwndhGGG
    Gui, +LastFound +resize -MaximizeBox
    Gui, color, 131313,242424
    Gui, Margin, 5, 5
    
    if (HideTooltips)
        AddTooltip("Deactivate")
    else
        AddTooltip("Activate")
    
    filename := ""
    dir := ""
    ActiveEditor := ""
    WinGet, ActiveEditor, ProcessName, A
    
    
    GuiControl,, Mainlist, |
    GuiControl,, SearchTerm
    
    if (A_username = "CLOUDEN")
        Gui, font, s11, checkbook
    else
        Gui, font, s11, Consolas
    
    FontSize_SB := FontSize_LV + 1
    Gui, Font, s%FontSize_SB% c%fontcolor_LV% q6, %Font_LV%
    Gui, Add, Edit, vSearchTerm gSearchListview w675
    
    Gui, Font, s%FontSize_LV%, %Font_LV%
    
    
    if (ShowGridLines)
        Gui, Add, ListView, xm r%listviewrows% hwndmlv vMainList gLV_Handler w675 Grid AltSubmit, Item|Line|FilePath
    else
        Gui, Add, ListView, xm r%listviewrows% hwndmlv vMainList gLV_Handler w675 AltSubmit, Item|Line|FilePath
    
    DllCall("uxtheme\SetWindowTheme", "ptr", mlv, "str", "DarkMode_Explorer", "ptr", 0)
    
    
    Gui, font, s9
    
    
    
    Gui, Add, Checkbox, xm vUseFuzzy gToggleFuzzy Checked%UseFuzzy%, Fu&zzy
    Gui, add, checkbox, x+m vViewComments gToggleViewComments Checked%ShowInlineComments%, `;`; Show Comments ¦
    Gui, Add, Radio, x+m vRadioSingle gToggleModeSingle Checked, A_Single {F7}
    
    Gui, Add, Radio, x+m vRadioFull gToggleModeFull, A_Full {F10}
    
    Gui, Add, Picture, x+m w20 h20 vBusy gDummy hidden, %icons%\loading.ani
    
    Gui, add, text, x+m cgray hwndfff8 gtogglemode, {F8}%A_Space%
    addtooltip(fff8, "Toggle ViewMove A_Single <¦> A_Full")
    
    
    Gui, add, checkbox, x+m vPin gPinUnpin Checked%pin%, &Pin
    Gui, add, checkbox, x+m vGridBox gToggleShowGridLines checked%ShowGridLines%, Grid
    Gui, add, text, x+m, %A_space%
    
    if (DevMode)
    {
        Gui, add, checkbox, x+m vShowDebug gToggleDebugOnGuI Checked%DebugOnGuI%, Debug
        
        If FileExist(XScript)
            Gui, add, text, x+m cTeal gSendToMainShowAEMenu, ¦ {F9}
        
    }
    
    
    
    
    Gui, Add, Text, xm vtl1 w675 h2 0x7
    Gui, Add, Button, xm Hwndggggg vggggg gGOOO default, % " Gooo ?? "
    GuiControlGet, Hwndggggg, Hwnd, ggggg
    DllCall("uxtheme\SetWindowTheme", "ptr", ggggg, "str", "DarkMode_Explorer", "ptr", 0)
    GuiButtonIcon(ggggg, Icons "\doceditlinejump.ico", 1, "s24 A0 L2")
    addtooltip(ggggg, "Open to Line of selected listview item.`n* {Enter} & Double-Click Deafault *")
    
    
    Gui, Add, Button, x+m Hwndalse valse gopenCurrentFileToFoundText , % " Alt-&Find* "
    GuiControlGet, Hwndalse, Hwnd, alse
    DllCall("uxtheme\SetWindowTheme", "ptr", alse, "str", "DarkMode_Explorer", "ptr", 0)
    GuiButtonIcon(alse, Icons "\findloop.ico", 1, "s24 A0 L2")
    addtooltip(alse, "Alt-Search opens to the, top-most found, searched text in the selected listview file.`nIf un-found, it just opens the file in your text editor.`n** Typing an optional pipe, "" | "", into the search box to stops filtering the listview.`nCausing the text after the | to be searched.")
    
    Gui, Add, Button, hwndrel vrel gReload X+M, % " &Reload "
    GuiControlGet, hwndrel, Hwnd, rel
    DllCall("uxtheme\SetWindowTheme", "ptr", hwndrel, "str", "DarkMode_Explorer", "ptr", 0)
    GuiButtonIcon(rel, Icons "\reload.ico", 1, "A0 L2")
    
    Gui, Add, Button, hwndex vex gExit X+M, % " &Quit "
    GuiControlGet, hwndex, Hwnd, ex
    DllCall("uxtheme\SetWindowTheme", "ptr", hwndex, "str", "DarkMode_Explorer", "ptr", 0)
    GuiButtonIcon(ex, Icons "\closer warning error imageres_98_256x256.ico", 1, "A0 L2")
    
    
    Gui, add, text, x+m, %A_space%
    If FileExist(sourcescript) && (DevMode)
    {
        
        Gui, Add, Button, hwnded ved gEditaJump X+M, % " Edit !&E "
        GuiControlGet, hwnded, Hwnd, ed
        DllCall("uxtheme\SetWindowTheme", "ptr", hwnded, "str", "DarkMode_Explorer", "ptr", 0)
        GuiButtonIcon(ed, texteditor, 1, "a0 L2")
        
        If FileExist(SourceScript)
            Gui, add, picture, x+m w24 h24 gHksInGoto, %Icons%\HotKeys auto List_101 xfav_32x32.ico
        
        If FileExist(xinc)
            Gui, add, picture, x+m w24 h24 gShowASDMenuViaGoto, %Icons%\xINC.ico
    }
    
    Gui, add, text, x+m, %A_space%
    
    If FileExist(ajumplist)
    {
        Gui, Add, Picture, x+m w24 h24 hwndajslb gLoadFromFileList, %Icons%\bullet list Resources_147_24x24.ico
        addtooltip(ajslb, "Load a File from your script list into Single File ViewMode`n*A ? icon means the file cannot be found.")
    }
    else
    {
        Gui, Add, Picture, x+m w20 h20 hwndmisajl gEditaJumpScriptList, %icons%\attention.ico
        addtooltip(misajl, "The Script List File for Full View Mode is Missing!`nClick here to create & edit.`nAdd 1 .ahk file per-line to search them when Full View Mode.")
    }
    
    
    Gui, add, text, x+m, %A_space%
    if (TE_name = "Notepad++.exe")
        Gui, add, picture, x+m w24 h24 hwndhnpphov vnppbut gLoadNppfile, %texteditor%
    
    addtooltip(hnpphov, "Click to load that active ahk file from NP++ into Single ViewMode.`n* At the moment this only works if your text editor is set to NP++.`nMore Editors Coming soon...")
    Gui, add, picture, x+m w24 h24 hwndtmb gshowtraymenu, %Icons%\xfce4-systray_64x64.ico
    addtooltip(tmb, "Show the Tray Menu on the GUI.")
    
    
    
    if (A_IsCompiled)
    {
        Gui, add, text, x+m, %A_space%
        Gui, add, picture, x+m w24 h24 hwndtarg gdummy, %icons%\target.ico
        addtooltip(targ, "Drag n Drop .ahk file onto the GUI`n to load them in Single View Mode.")
    }
    
    if (A_Username = "CLOUDEN") && InStr(A_ScriptDir, "\AHK Share\")
        Gui, Add, Picture, x+m w24 h24 gDummy, X:\AHK\Icons\share.ico
    Gui, Add, Text, xm vtl2 w675 h2 0x7
    Gui, font, cFAB500
    Gui, font, s9 q6, %Font_Footer%
    Gui, add, edit, xm w675 vclickedline gdummy, -ln[%line%]¦%InlineComment%¦
    
    Gui, font, s8 c%FontColor_Footer% q6, %Font_Footer%
    Gui, add, text, xm w675 vquery gdummy, %SearchTerm% ?=> LV_Rows_#[%lv_count%]
    
    Gui, font, s8 q6, %Font_Footer%
    
    
    
    
    
    If FileExist(CurrentFile)
        SplitPath, CurrentFile, filename, dir, ext, stem
    if (DebugOnGuI)
    {
        Gui, add, text, xm w650 vtmf gdummy, CurrentFile=%CurrentFile%
        Gui, add, text, xm w650 vtmp gdummy, Fullpath=%fullpath%
        Gui, add, text, xm w650 vfname gdummy, A_File: %filename%
        Gui, add, text, xm w650 vadir gdummy, A_Dir: %dir%
        
        Gui, add, text, xm w75 vSLCount gdummy, SL_#[%ScriptListCount%]
        Gui, add, text, x+m w75 vVMode, VM=%viewmode%
        Gui, add, text, x+m w250, A_App= %ActiveEditor% %A_space%%A_space%%A_space%
    }
    
    
    If FileExist(CurrentFile)
    {
        SplitPath, CurrentFile, filename, dir
        
        GuiControl,, adir, A_Dir: %dir%
        GuiControl,, fname, A_File: %filename%
        GuiControl,, tmf, CurrentFile=%CurrentFile%
        GuiControl,, A_file, %CurrentFile%
    }
    
    if (ShowQueryResultsOnStatsBar)
    {
        Gui, font, s8 q6, consolas
        if (UseThemedStatusBar)
            Gui, add, statusbar, -Theme Background818181,
        else
            Gui, add, statusbar, ,
        SB_SetText(SearchTerm " ?=> LV_Rows_#[" LV_Count "]")
    }
    
    if (ggX < -10000 or ggX > A_ScreenWidth or ggY < -10000 or ggY > A_ScreenHeight)
    {
        ggX := 3287
        ggY := 1300
    }
    
    if (pin)
        Gui, +AlwaysOnTop
    
    if (ViewMode = "A_full") {
        Gui, Show, x%ggX% y%ggY% w%DefaultGUIWidth%, >_ \List\..\ > A_Jumper >
        GuiControl, , RadioFull, 1
        GuiControl, , RadioSingle, 0
    }
    else {
        Gui, Show, x%ggX% y%ggY% w%DefaultGUIWidth% , ..\..\%filename% > A_Jumper >
        GuiControl, , RadioFull, 0
        GuiControl, , RadioSingle, 1
        iniwrite, %currentfile%, %inifile%, aJump_Config, A_file
        SetWindowIcon(hggg, Icons "\script_go__32x32.ico")
    }
    
    
    Update_GUI("")
    if (isStartup) && (StartMinimized)
        WinMinimize, > A_Jumper > ahk_class AutoHotkeyGUI
    
    isStartup := 0
    A_IsBooting := 0
    
    
    
    
    
    
    GuiControl,Focus,SearchTerm
    
    if (PreloadFullFileList)
        if !(FullListViewBuilt)
            gosub BuildFullListView

FirstReturn:
Return
gGuiDropFiles:
    Loop, Parse, A_GuiEvent, `n
    {
        FirstFile := A_LoopField
        break
    }
    
    if FileExist(FirstFile) {
        global CurrentFile := FirstFile
        splitpath, CurrentFile, filename, dir, ext, stem
        GoTo_Readfile(CurrentFile)
        ActiveFileIndex := FileIsCached(CurrentFile)
        
        SetMode("A_single")
    }
return







PinUnpin:
unpin:
    gui, submit, nohide
    if (pin)
    {
        iniwrite, 1, %inifile%, aJump_Config, Pin
        Gui, +alwaysontop
    }
    else
    {
        iniwrite, 0, %inifile%, aJump_Config, Pin
        Gui, -alwaysontop
    }
return
ToggleShowGridLines:
    Gui,submit,nohide
    ShowGridLines := ! ShowGridLines
    if ShowGridLines
        iniwrite, 1, %inifile%, aJump_Config, ShowGridLines
    else
        iniwrite, 0, %inifile%, aJump_Config, ShowGridLines
    Gui, g: destroy
    gosub BuildGUI
return

ToggleDebugOnGuI:
    Gui,submit,nohide
    DebugOnGuI := !DebugOnGuI
    if (DebugOnGuI)
    {
        iniwrite, 1, %inifile%, aJump_Config, DebugOnGuI
    }
    else
    {
        iniwrite, 0, %inifile%, aJump_Config, DebugOnGuI
    }
    Gui,g:destroy
    gosub BuildGUI
return

FocusEdit()
{
    global hggg
    hastext := ""
    Gui, %hggg%:Default
    ControlGetText, hastext , edit1, > A_Jumper > ahk_class AutoHotkeyGUI
    guicontrol,focus,edit1
    guicontrol,focus,SearchTerm
    ControlFocus, Edit1, > A_Jumper > ahk_class AutoHotkeyGUI
    if (Hastext != "")
    {
        sleep 30
        sendinput, ^a
    }
}
ClearEdit()
{
    Send, ^a
    sleep 10
    send, {BS}
}



return



GoTo_Readfile(File) {
    Critical, On
    guicontrol,show,busy
    static filecount, commentneedle := A_space ";|" A_tab ";"
    global ShowInlineComments
    
    SplitPath, File, filenameOnly
    
    if (filecount_N := FileIsCached(File))
        Filename := filecount_N
    else {
        Filename := filecount := filecount ? filecount+1 : 1
        GOTOS.filelist.Insert(file)
    }
    GOTOS[Filename] := {}
    if (ShowInlineComments)
    {
        loop, read, %file%
        {
            originalLine := Trim(A_LoopReadLine)
            readline := Trim(A_LoopReadLine)
            
            if block_comments
                if Instr(readline, "*/") = 1 {
                    block_comments := 0
                    continue
                } else continue
                    
                    if Instr(readline, ";") = 1
                        continue
            
            if Instr(readline, "/*") = 1 {
                block_comments := 1
                continue
            }
            
            
            readline := Trim(Substr(readline, 1, SuperInstr(readline, commentneedle, 1) ? SuperInstr(readline, commentneedle, 1)-1 : Strlen(readline)))
            
            
            if (include_path := Check4Include(readline))
                CreateCache(Filename, "include", originalLine, A_index, File)
            else if (readline_temp := Check4Hotkey(readline))
                CreateCache(Filename, "hotkey", originalLine, A_Index, File)
            else if (Instr(readline, ":") = 1) and (Instr(readline, "::", 0, 0) > 1)
                CreateCache(filename, "hotstr", originalLine, A_Index, File)
            else if !SuperInstr(readline, "``|`t| |,", 0) and Substr(readline,0) == ":"
                CreateCache(filename, "label", originalLine, A_Index, File)
            else if Check4func(readline, A_index, file)
                CreateCache(filename, "func", originalLine, A_Index, File)
        }
        
        
        
    }
    else
    {
        loop, read, %file%
        {
            readline := Trim(A_LoopReadLine)
            if block_comments
                if Instr(readline, "*/") = 1
                {
                    block_comments := 0
                    continue
                }
                else
                    continue
            
            if Instr(readline, ";") = 1
                continue
            
            if Instr(readline, "/*") = 1
            {
                block_comments := 1
                continue
            }
            
            readline := Trim(Substr(readline, 1, SuperInstr(readline, commentneedle, 1) ? SuperInstr(readline, commentneedle, 1)-1 : Strlen(readline)))
            
            if (include_path := Check4Include(readline))
                CreateCache(Filename, "include", include_path, A_index, File)
            else if (readline_temp := Check4Hotkey(readline))
                CreateCache(Filename, "hotkey", readline_temp, A_Index, File)
            else if ( readline_temp := Check4Hotkey(readline) )
                CreateCache(filename, "hotkey", readline_temp, A_Index, File)
            else if ( Instr(readline, ":") = 1 ) and ( Instr(readline, "::", 0, 0) > 1 )
                CreateCache(filename, "hotstr", Substr(readline, 1, Instr(readline, "::", 0, 0)-1), A_Index, File )
            else if !SuperInstr(readline, "``|`t| |,", 0) and Substr(readline,0) == ":"
                CreateCache(filename, "label", readline, A_Index, File)
            else if Check4func(readline, A_index, file)
                CreateCache(filename, "func", Substr(readline, 1, Instr(readline, "(")) ")", A_Index, File)
        }
    }
    
    guicontrol,hide,busy
}


Check4Comment(line) {
    if RegExMatch(line, "\s*;+\s*(.+)$", match)
        return Trim(match1)
    return ""
}

SuperInstr(Hay, Needles, return_min=true, Case=false, Startpoint=1, Occurrence=1)
{
    
    pos := return_min*Strlen(Hay)
    if return_min
    {
        loop, parse, Needles,|
            if ( pos > (var := Instr(Hay, A_LoopField, Case, startpoint, Occurrence)) )
                pos := var ? var : pos
        if ( pos == Strlen(Hay) )
            return 0
    }
    else
    {
        loop, parse, Needles,|
            if ( (var := Instr(Hay, A_LoopField, Case, startpoint, Occurrence)) > pos )
                pos := var
    }
    return pos
}

Check4Include(line) {
    
    if !RegExMatch(line, "i)^\s*#include(again)?\s+(.+)$", match)
        return ""
    
    includePath := Trim(match2)
    
    includePath := RegExReplace(includePath, "i)^\*i\s+", "")
    
    includePath := RegExReplace(includePath, "^<(.+)>$", "$1")
    
    return "#Include " includePath
}



Check4Hotkey(line) {
    
    if ( Instr(line, "::") = 1 ) and ( Instr(line, ":", false, 0) = 3 )
        return ""
    hK := Substr( line, 1, ( Instr(line, ":::") ? Instr(line, ":::")+2 : ( Instr(line, "::") ? Instr(line, "::")+1 : Strlen(line)+2 ) ) - Strlen(line) - 2)
    if hK =
        return
    
    if !SuperInstr(hK, " |	", 0)
        if !SuperInstr(hK, "^|!|+|#", 0) And RegExMatch(hK, "[a-z]+[,(]")
            return
        else
            return hK "::"
    else
        if Instr(hK, " & ") or ( Substr(hK, -1) == "UP" )
            return hK "::"
}
Check4func(readline, linenum, file){
    if RegExmatch(readline, "i)[A-Z0-9#_@\$\?\[\]]+\(.*\)") != 1
        return
    if ( Substr(readline, 0) == "{" )
        return 1
    
    loop,
    {
        FileReadLine, cl, %file%,% linenum+A_index
        if Errorlevel = 1
            return
        cl := Trim( Substr(cl, 1, Instr(cl, ";") ? Instr(cl, ";")-1 : Strlen(cl)) )
        if cl =
            continue
        
        if block_comments
        {
            if Instr(cl, "*/") = 1
            {
                block_comments := 0
                continue
            }
            else
                continue
        }
        
        if Instr(cl, "/*") = 1
        {
            block_comments := 1
            continue
        }
        
        return Instr(cl, "{") = 1 ? 1 : 0
    }
}


FileIsCached(file){
    for k,v in GOTOS.filelist
        if ( file == v )
            return k
}

TypefromTab(TabCount){
    if Tabcount = 1
        return ""
    else if Tabcount = 2
        return "label"
    else if Tabcount = 3
        return "func"
    else if Tabcount = 4
        return "hotkey"
    else if Tabcount = 5
        return "hotstr"
    else if TabCount = 6
        return "include"
}




SearchBox:
    SetTimer, DoSearch, -300
return
DoSearch:
    Gui, g:Submit, NoHide
    
    Gui, g:Default
    Gui, g:ListView, MainList
    LV_Delete()
    
    FilterTerm := Trim(SearchTerm)
    
    if (FilterTerm = "" || FilterTerm = "Search...") {
        for index, item in OriginalKeyValues
            LV_Add("", item.key, item.value)
        LV_ModifyCol(1, 350)
        LV_ModifyCol(2, 60)
        LV_ModifyCol(3, "AutoHdr")
        LV_ModifyCol(4, "AutoHdr")
        return
    }
    
    matchCount := 0
    for index, item in OriginalKeyValues
    {
        if (InStr(item.key, FilterTerm) || InStr(item.value, FilterTerm)) {
            LV_Add("", item.key, item.value)
            matchCount++
        }
    }
    
    LV_ModifyCol(1, 300)
    LV_ModifyCol(2, "AutoHdr")
return



ShowCommandPalette()
{
    LV_Delete()
    LV_Add("", "/refresh", "Rebuild aJumpScriptList")
    LV_Add("", "/exit", "Exit app")
    LV_Add("", "/quit", "Exit app")
    LV_Add("", "/menu", "Show Context Menu")
    LV_Add("", "/compile", "Re-Compile SourceSript")
    
    LV_ModifyCol(1, 100)
    LV_ModifyCol(2, "AutoHdr")
}

GOOO:
    Gui, g:default
    Gui, %hggg%:default
    Gui, submit, nohide
    
    if (searchterm = "codestrings")
    {
        LoadFile("X:\AHK\xINC\HS\CodeStrings.ahk")
        return
    }
    if (searchterm = "autoabc")
    {
        LoadFile("X:\AHK\xINC\HS\autocorrect.ahk")
        return
    }
    if (searchterm == "/compile")
        goto CompileGTF
    
    if (searchterm == "/menu")
    {
        ClearEdit()
        tooltip
        goto gGuiContextMenu
    }
    if (SearchTerm == "/full") {
        clearedit()
        tooltip
        SetMode("A_full")
        Return
    }
    if (SearchTerm == "/hide") {
        clearedit()
        tooltip
        Gui, hide
        Return
    }
    if (SearchTerm == "/single") {
        clearedit()
        tooltip
        SetMode("A_single")
        Return
    }
    if (SearchTerm == "/reload") {
        reload
        Return
    }
    if (SearchTerm == "/edit") {
        clearedit()
        goto EditaJump
    }
    if (SearchTerm == "/tip") {
        Clearedit()
        gosub ShowSlashTooltip
        update_gui("")
    }
    if (SearchTerm == "/editlist") {
        clearedit()
        tooltip
        goto EditaJumpList
    }
    if (SearchTerm == "/settings") {
        clearedit()
        tooltip
        goto EditaJumpSettings
    }
    if regexmatch(SearchTerm, "^/load\s") {
        
        file := Trim(RegexReplace(searchterm, "i)^/load\s"))
        If FileExist(file)
        {
            clearedit()
            tooltip
            loadfile(file)
        }
        else
            Tip("ERR! -> " file "`nwas not found.")
        focusedit()
        Return
    }
    if (searchterm == "/refresh")
    {
        ClearEdit()
        tooltip
        goto ReFreshFileView
    }
    if (searchterm == "/exit" || searchterm == "/quit")
        exitapp
    
    
    If FileExist(SearchTerm) {
        tip("Loading ...`n" SearchTerm, 1500)
        clearedit()
        LoadFile(searchterm)
        return
    }
    if (GetKeyState("Control", "P"))
        ThenHide := 1
    Row := LV_GetNext(0)
    if !Row
        return
    
    LV_GetText(it, Row, 1)
    LV_GetText(line, Row, 2)
    LV_GetText(fullPath, row, 3)
    
    if !FileExist(fullPath) {
        ToolTip, File not found: %fullPath%
        SetTimer, RemoveToolTip, -2000
        return
    }
    If FileExist(texteditor)
    {
        OpenTEtoLine(fullpath, line)
        return
    }
    if (A_ThisMenuItem = "Open To Line in NP++") {
        Run, notepad++.exe -n%line% "%fullPath%"
        return
    }
    if (A_ThisMenuItem = "Open To Line in NP4") {
        run, %notepad4% /g %Line% "%fullPath%"
        return
    }
    if (A_ThisMenuItem = "Open To Line in VSCode") {
        Run, "%vscode%" --reuse-window -g "%fullPath%:%line%"
        return
    }
    
    if (A_ThisMenuItem = "")
        OpenTEtoLine(fullpath, line)
    
    if (ThenHide) {
        gui, hide
        thenhide := 0
    }
return

SearchListview:
    Gui, Submit, NoHide
    Gui, %Hggg%:default
    
    
    
    
    
    
    if instr(searchterm, "|")
    {
        return
    }
    
    Update_GUI(Trim(SearchTerm))
return

ShowSlashTip:
ShowSlashTooltip:
    
    ToolTipText := "
    (LTrim
        /edit     " A_tab A_tab " Edit Source Script
        /editlist     " A_tab " Edit Script List
        /exit     " A_tab A_tab " Exit app
        /full     " A_tab A_tab " Set ViewMode to Full List.
        /hide     " A_tab A_tab " Hide GUI
        /load     " A_tab A_tab " {Space} C:\Paste\a\FilePath.ahk
        /menu     " A_tab A_tab " Show Context Menu
        /quit     " A_tab A_tab " Exit app
        /refresh  " A_tab A_tab " Rebuild list
        /reload   " A_tab A_tab " Reload App
        /settings " A_tab A_tab " Edit INI Options
        /single   " A_tab A_tab " Set View Mode to Single File
        /tip      " A_tab A_tab " Show This Tip Again
        /compile " A_tab " Re-Compile Source Script
    
    )"
    
    tooltip, %tooltiptext%, 32, 90
    SetTimer, RemoveToolTip, -5555
Return

ToggleFuzzy:
    UseFuzzy := !UseFuzzy
    if (UseFuzzy)
        iniwrite, 1, %inifile%, aJump_Config, UseFuzzy
    else
        iniwrite, 0, %inifile%, aJump_Config, UseFuzzy
    FocusEdit()
    sendinput, {End}
    sleep 30
    sendinput, {space}
    sendinput, {Backspace}
return
matchText(haystack, needle) {
    global UseFuzzy
    
    if (needle = "")
        return true
    
    if (UseFuzzy)
        return fuzzyMatch(haystack, needle)
    
    return InStr(haystack, needle, false)
}
fuzzyMatch(haystack, needle) {
    if (needle = "")
        return true
    
    hay := haystack
    ned := needle
    StringReplace, ned, ned, %A_Space%, , All
    pos := 1
    Loop, Parse, ned
    {
        c := A_LoopField
        pos := InStr(hay, c, false, pos)
        if (!pos)
            return false
        pos++
    }
    return true
}
ToggleViewComments:
    ShowInlineComments := !ShowInlineComments
    if (ShowInlineComments)
        IniWrite, 1, %IniFile%, aJump_Config, ShowInlineComments
    else
        IniWrite, 0, %IniFile%, aJump_Config, ShowInlineComments
    if (viewmode = "A_single")
    {
        GoTo_Readfile(CurrentFile)
        ActiveFileIndex := FileIsCached(CurrentFile)
    }
    else
    {
        BuildFullListView(1)
    }
    Update_GUI("")
return
SetModeFull:
    SetMode("A_full")
return
SetModeSingle:
    SetMode("A_single")
return


LoadFile(FilePath)
{
    global CurrentFile, inifile, ActiveFileIndex, viewmode, fname, HGGG
    splitpath, filepath,,,ext
    if !(ext = "ahk")
    {
        tip("This is not an .ahk file!`nAborted.", 2500)
        return
    }
    iniwrite, %FilePath%, %inifile%, aJump_Config, A_File
    iniwrite, %FilePath%, %inifile%, aJump_Config, A_FileClicked
    CurrentFile := FilePath
    if !FileIsCached(CurrentFile)
        GoTo_Readfile(CurrentFile)
    ActiveFileIndex := FileIsCached(CurrentFile)
    SetMode("A_single")
}
SetMode(mode)
{
    global ViewMode, inifile, HGGG, fname, CurrentFile
    Gui, %hggg%:Default
    ViewMode := mode
    iniWrite, %mode%, %inifile%, aJump_Config, ActiveViewMode
    if (ViewMode = "A_full") {
        GuiControl, , RadioFull, 1
        GuiControl, , RadioSingle, 0
        SetWindowIcon(hGGG, trayicon)
        WinSetTitle, ahk_id %HGGG%,, >_ ..\List\..\ > A_Jumper >
        if !(FullListViewBuilt)
            gosub BuildFullListView
    }
    else {
        GuiControl, , RadioFull, 0
        GuiControl, , RadioSingle, 1
        SetWindowIcon(hggg, Icons "\script_go__32x32.ico")
        SplitPath, CurrentFile, fname
        WinSetTitle, ahk_id %HGGG%,, >_ ..\..\%fname% > A_Jumper >
    }
    GuiControl, ,VMode, VM=%viewmode%
    Update_GUI("")
}
Update_GUI(find="") {
    global ViewMode, ActiveFileIndex, GOTOS, HGGG, fullpath, InFileList, query, qlayout, searchterm
    guicontrol, show ,busy
    Gui, %hggg%:Default
    LV_Delete()
    
    if (ViewMode = "A_full") {
        for fileIdx in GOTOS.filelist
        {
            Loop, 5
            {
                if (!GOTOS[fileIdx].HasKey(Typefromtab(A_Index+1)))
                    continue
                
                for lineNum, data in GOTOS[fileIdx][Typefromtab(A_Index+1)]
                {
                    if matchText(data.text, find)
                        LV_Add("", data.text, lineNum, data.file)
                }
            }
        }
        
    }
    else {
        if (!ActiveFileIndex)
            return
        
        SplitPath, CurrentFile, fname,
        
        Loop, 5
        {
            if (!GOTOS[ActiveFileIndex].HasKey(Typefromtab(A_Index+1)))
                continue
            
            for lineNum, data in GOTOS[ActiveFileIndex][Typefromtab(A_Index+1)]
            {
                if matchText(data.text, find)
                    LV_Add("", data.text, lineNum, data.file)
                
            }
        }
    }
    LV_ModifyCol(1, 350)
    LV_ModifyCol(2, 60)
    LV_ModifyCol(3, "AutoHdr")
    LV_Count := LV_GetCount()
    SB_SetText(SearchTerm " ?=> LV_Rows_#[" LV_Count "]")
    guicontrol,,query, %SearchTerm% ?=> LV_Rows_#[%lv_count%]
    GuiControl, hide, busy
}

ToggleModeSingle:
ToggleModeFull:
ToggleMode:
    Gui,submit, nohide
    if (ViewMode = "A_single") && (A_thislabel = "TogglemodeSingle")
        return
    if (ViewMode = "A_full") && (A_thislabel = "Togglemodefull")
        return
    
    if (ViewMode = "A_full")
    {
        gosub getNppFile
        
        if (NppFile != "")
        {
            CurrentFile := NppFile
        }
        else
        {
            IniRead, A_file, %inifile%, aJump_Config, A_file
            CurrentFile := (A_file != "ERROR" && A_file != "") ? A_file : ""
        }
        if (CurrentFile != "")
            IniWrite, %CurrentFile%, %inifile%, aJump_Config, A_file
        if (CurrentFile != "" && !FileIsCached(CurrentFile))
            GoTo_Readfile(CurrentFile)
        
        ActiveFileIndex := FileIsCached(CurrentFile)
        
        loadfile(currentfile)
    }
    else
    {
        if !(FullListViewBuilt)
            gosub BuildFullListView
        SetMode("A_full")
    }
return


CreateCache(fileIndex, type, text, line, filename) {
    
    if (type = "func")
        display := "() " text
    else if (type = "label")
        display := "> " text
    else if (type = "hotkey")
        display := ":: " text
    else if (type = "hotstr")
        display := "$ " text
    else if (type = "include")
        display := "# " text
    else
        display := text
    
    
    
    if !(GOTOS[fileIndex].HasKey(type))
        GOTOS[fileIndex][type] := {}
    
    GOTOS[fileIndex][type][line] := {text: display, file: filename}
}











loadFullpathfromContextMenu:
    LoadFile(fullpath)
return



gGUIEscape:
gGuiClose:
    SaveGotoPos()
    WinMinimize, ahk_id %HGGG%
return

gGuiSize:
    GuiControl Move, MainList, % "w" A_GuiWidth-10
    GuiControl Move, SearchTerm, % "w" A_GuiWidth-10
    GuiControl Move, tl1, % "w" A_GuiWidth-10
    GuiControl Move, tl2, % "w" A_GuiWidth-10
    GuiControl Move, clickedline, % "w" A_GuiWidth-10
return






LV_Handler:
LV_SingleClick:
    Row := LV_GetNext(0)
    if !Row
        return
    IniRead, A_FileClicked, %IniFile%, aJump_Config, A_FileClicked
    
    LV_GetText(it, Row, 1)
    LV_GetText(line, Row, 2)
    LV_GetText(Fullpath, Row, 3)
    
    if (A_FileClicked != Fullpath)
    {
        iniwrite, %Fullpath%, %inifile%, aJump_Config, A_FileClicked
        A_FileClicked := Fullpath
    }
    
    removeprefix()
    splitpath, fullpath, name, dir, ext, stem
    FileReadLine, FullLineWithComment, %fullpath%, %line%
    
    if RegExMatch(FullLineWithComment, "\s;(.*)$", match)
        InlineComment := Trim(match1)
    else
        InlineComment := ""
    
    
    GuiControl,, fname, A_File: %name%
    GuiControl,, adir, A_Dir: %dir%
    
    FullLineWithComment := Trim(FullLineWithComment)
    guicontrol,,clickedline, -ln[%line%]¦%FullLineWithComment%¦
    
    GuiControl,, tmf, CurrentFile=%CurrentFile%
    guicontrol,, tmp, Fullpath=%fullpath%
    
    if (A_GuiEvent = "DoubleClick")
    {
        if (GetKeyState("Control", "P"))
        {
            ThenHide := 1
        }
        If FileExist(fullPath)
            OpenTEtoLine(fullpath, line)
        else
            tooltip, CurrentFile var has been lost!!! -line %A_LineNumber% %A_thislabel%
        
        
        if (thenHide)
        {
            Gui,Hide
            thenhide := 0
        }
    }
return



openCurrentFileToFoundText:
    Gui,submit, nohide
    
    if (SearchTerm = "")
    {
        tip("Search Box Is Empty!", 1000)
        return
    }
    
    if instr(searchterm, "|")
    {
        Array := StrSplit(Searchterm, "|")
        PreSearchTerm := Trim(Array[1])
        SearchTerm := Trim(array[2])
    }
    If !FileExist(fullpath)
        Fullpath := CurrentFile
    
    If FileExist(fullpath)
        OpenFileToFoundText(fullPath,SearchTerm)
    else
        Tip("ERR!! The FullPath Var from listview cannot be found!" 7000)
return




EditaJump:
    Gui, submit, nohide
    OpenFileToFoundText(SourceScript, SearchTerm)
return


runthismenuitem:
    clickedtext := A_thismenuitem
    goto skippedgettingclicktext
return

runThisTExt:
    GuiControlGet, clickedText,, %A_GuiControl%
    if RegExmatch(clickedtext, "-n\s")
        Return
skippedgettingclicktext:
    clickedText := RegexReplace(clickedText, "i)^run,\s")
    clickedText := RegexReplace(clickedText, "i)^run\s")
    Array := StrSplit(clickedText, A_space, , 3)
    line := array[2]
    file := array[3]
    line := RegExReplace(line, "-n")
    file := StrReplace(file,"""")
    If FileExist(file) && (line != "")
        Run, Notepad++.exe -n%line% "%file%"

return

ShowRightClickMenu:
gGuiContextMenu:
    gosub BuildGGMenu
    Menu, gg, show
return

gBuildContextMenu:
BuildGGMenu:
    Gui,submit,nohide
    Global isalabel := 0
    ActiveEditor := ""
    Global FuncWP := ""
    SkipFuncCheck := 0
    WinGet, ActiveEditor, ProcessName, A
    Row := LV_GetNext()
    LV_GetText(it, Row, 1)
    LV_GetText(line, Row, 2)
    LV_GetText(fullPath, row, 3)
    LV_Count := LV_GetCount()
    
    If FileExist(fullPath)
        splitpath, fullpath, iname, idir, iext, istem
    
    
    fullpath := Trim(fullpath)
    it := RegExReplace(it, "\s;.*")
    
    RemovePrefix()
    FileReadLine, FullLine, %fullpath%, %line%
    
    
    if RegExMatch(FullLine, "^(.*\))", m)
        FuncWP := RegExReplace(fullline, "\).*?$", ")")
    
    
    Menu, tray, UseErrorLevel, on
    Menu, gg, add,
    Menu, gg, deleteall
    if (Row)
    {
        LV_MenuRow := Row
        global InFileList
        Menu, ggpp, add
        Menu, ggpp, DeleteAll
        Menu, ggpp, add, Open To Line in NP4, GOOO
        Menu, ggpp, Icon, Open To Line in NP4, %notepad4%,,%is%
        Menu, ggpp, add, Open To Line in VSCode, GOOO
        Menu, ggpp, Icon, Open To Line in VSCode, %vscode%,,%is%
        Menu, ggpp, add, Open to Line in SciTE, gooo
        Menu, ggpp, Icon, Open to Line in SciTE, %scite%,,%is%
        
        Menu, gg, add, Open To Line in NP++`t^Go, GOOO
        If FileExist(notepadpp)
            Menu, gg, Icon, Open To Line in NP++`t^Go, %notepadpp%,,%is%
        Menu, gg, add, Open To ++`t>>>, :ggpp
        
        If FileExist(dngrep)
        {
            Menu, gg, add, Search ☉Item ¦ ^\File.in dnGrep, SearchItemIndnGrep
            Menu, gg, Icon, Search ☉Item ¦ ^\File.in dnGrep, %dngrep%,,%is%
        }
        
        Menu, gg, add, Open Folder, OpenLVFolder
        If FileExist(dopus) && FileExist(icons "\DOpus_Spikes_256x256.ico")
            Menu, gg, Icon, Open Folder, %icons%\DOpus_Spikes_256x256.ico,,%is%
        else
            Menu, gg, Icon, Open Folder, Explorer.exe,,%is%
        
        
        
        If FileExist(XScript)
        {
            if !InStr(fullpath, "\Sideloads\")
                && !InStr(fullpath, "\iniEditor\")
                && !InStr(fullpath, "\Change")
                && instr(fullpath, ahk)
                && iname != "xpp.ahk"
                && iname != "AltSend++.ahk"
                && RegExmatch(it, "\b:\s?$")
            {
                Menu, gg, add, Run %it% in Main ?, SendItemToMain
                Menu, gg, Icon, Run %it% in Main ?, %Icons%\RunBox16x16.ico,,%is%
                Menu, gg, Icon, Run %it% in Main ?, %Icons%\RunBox16x16.ico,,%is%
            }
            
            if instr(fullpath, "\Sideloads\")
                && instr(fullpath, "\xpp.ahk")
                && InStr(fullpath, "\iniEditor\")
            {
                Menu, gg, add, Run ahk File ?, Dummy
            }
        }
        
        Menu, gg, add,
        Menu, gg, add, %it%`titem-c, CopyA_ThisMenuItemLeftofTab
        
        If FileExist(it)
        {
            Menu, gg, delete, %it%`titem-c
            Menu, gg, add, %it%`tEdit#, EditIncludeFromMenu
            SkipFuncCheck := 1
        }
        if (FuncWP != "") && !(SkipFuncCheck)
        {
            Menu, gg, delete, %it%`titem-c
            Menu, gg, add, %FuncWP%`tF()-c, CopyA_ThisMenuItemLeftofTab
        }
        Menu, gg, add, %line%`tline-c, CopyA_ThisMenuItemLeftofTab
        Menu, gg, add, %fullPath%`tfullPath-c,CopyA_ThisMenuItemLeftofTab
    }
    else
    {
        Menu, gg, add, Nothing is selected in ListView!, dummy
        Menu, gg, default, Nothing is selected in ListView!
        Menu, gg, Icon, Nothing is selected in ListView!, %icons%\iconerror.ico,,32
    }
    
    Menu, gg, add,
    if (ViewMode = "A_full") && (fullpath != CurrentFile)
    {
        Menu, gg, add, Load into Single ViewMode , loadFullpathfromContextMenu
        Menu, gg, Icon, Load into Single ViewMode , %icons%\goto.ico,,%is%
    }
    
    Menu, gg, add, Save Current Listview`t^+E #+SA, SaveListView
    Menu, gg, Icon, Save Current Listview`t^+E #+SA, %Icons%\lc_savebasicas_26x26.ico,,%is%
    If FileExist(aJumpTempSave)
    {
        Menu, gg, add, Open Last LV_QuickSave`t^=ODir ^+=Del, RunQuickSave
        Menu, gg, Icon, Open Last LV_QuickSave`t^=ODir ^+=Del, %TE%,,%is%
    }
    
    
    Menu, gg, add,
    
    Menu, gg, add, Edit [aJump_Config] Settings, EditaJumpSettings
    If FileExist(iie)
        Menu, gg, Icon, Edit [aJump_Config] Settings, %iie%,,%is%
    else
        Menu, gg, Icon, Edit [aJump_Config] Settings, %icons%\iniicon.ico,,%is%
    
    if !InStr(InFileList,fullpath)
    {
        Menu, gg, add, Add To Script List ..\%iname%, AppendToScriptList
        Menu, gg, Icon, Add To Script List ..\%iname%, %Icons%\gmic-gimp-list-add_32x32.ico,,%is%
    }
    
    If FileExist(ajumplist)
    {
        Menu, gg, add, Edit aJumpScriptList, EditaJumpList
        Menu, gg, Icon, Edit aJumpScriptList, %Icons%\document text white S-DOX_II_DE_32_70_32x32.ico,,%is%
    }
    else
    {
        Menu, gg, add, aJumpScriptList is Missing!!!, EditaJumpList
        Menu, gg, Icon, aJumpScriptList is Missing!!!, %icons%\attention.ico,,28
        Menu, gg, default, aJumpScriptList is Missing!!!
    }
    Menu, gg, add,
    if (viewmode = "A_full")
    {
        Menu, gg, add, Reindex aJumpScriptList, ReBuildFullListView
        Menu, gg, Icon, Reindex aJumpScriptList, %Icons%\sync refresh_256x256.ico,,%is%
    }
    if (ViewMode = "A_single")
    {
        Menu, gg, add, Refresh A_file, ReFreshFileView
        Menu, gg, Icon, Refresh A_file, %Icons%\view-refresh xfav_32x32.ico,,%is%
    }
    Menu, gg, add,
    if (DevMode) {
        If FileExist(SourceScript)
        {
            if (A_iscompiled)
            {
                Menu, gg, add, Edit Source Script, EditaJump
                Menu, gg, Icon, Edit Source Script, %texteditor%,,%is%
            }
            else
            {
                Menu, gg, add, Edit Script, EditaJump
                Menu, gg, Icon, Edit Script, %texteditor%,,%is%
            }
        }
        If FileExist(xscript)
        {
            if !(A_IsCompiled)
            {
                Menu, gg, add, Compile,CompileGTF
                Menu, gg, Icon, Compile, %A_AHKPath%,,%is%
            }
            else
            {
                Menu, gg, add, Re-Compile && Run, CompileGTF
                Menu, gg, Icon, Re-Compile && Run, %Icons%\compile4.ico,,%is%
            }
        }
        
    }
    Menu, gb, add
    Menu, gb, deleteall
    
    
    Menu, gb, add, A_App=%ActiveEditor%`t-d,dummy
    Menu, gb, disable, A_App=%ActiveEditor%`t-d
    Menu, gb, add, TE=%texteditor%`t-d,dummy
    Menu, gb, add, ** Var Checks **,dummy
    Menu, gb, Icon, ** Var Checks **, %Icons%\todo_list_256x256.ico
    Menu, gb, disable, ** Var Checks **
    Menu, gb, add, CurrentFile=%currentfile%`t-d,dummy
    Menu, gb, add, LV_FullPath=%fullpath%`t-d,dummy
    Menu, gb, add, A_FileClicked=%A_FileClicked%`t-d,dummy
    if instr(fullPath, "X:\AHK\xINC\")
    {
        StringReplace, shortfile, fullPath, X:\AHK\xInc\, `%xINC`%\
        Menu, gb, add, Local Shortfile=%shortfile%`t-d, dummy
    }
    Menu, gb, add,
    Menu, gb, add, Filename=%filename%`t-d,dummy
    Menu, gb, add, dir=%dir%`t-d,dummy
    Menu, gb, add, SL_#[%ScriptListCount%]`t-d,dummy
    Menu, gb, add, ViewMode=%ViewMode%`t-d,dummy
    Menu, gb, add, %SearchTerm% ?=> LV_Rows_#[%lv_count%]`t-d,dummy
    
    Menu, gg, add,
    Menu, gg, add, Exit\Quit`t!F4, Exit
    Menu, gg, Icon, Exit\Quit`t!F4, %Icons%\exitapp.ico,,%is%
    Menu, gg, add, Tray`t>>>, :tray
    Menu, gg, Icon, Tray`t>>>, %Icons%\xfce4-systray_64x64.ico,,%is%
    
    if (DevMode)
    {
        Menu, gg, add,
        Menu, gg, add, Debug Dummy`t>>>, :gb
        Menu, gg, Icon, Debug Dummy`t>>>, %Icons%\bug.ico,,16
    }
    Menu, tray, UseErrorLevel, off
return

EditIncludeFromMenu:
    selected := A_ThisMenuItem
    parts := StrSplit(selected, "`t")
    XXX1 := parts[1]
    XXX2 := parts[2]
    run, %te% "%xxx1%"
return
SearchBoxIndnGrep:
    IniRead, dnGREPMatch, %IniFile%, dnGREP_Globals, dnGREPMatch
    IniRead, dnGREPIgnoreASD, %IniFile%, dnGREP_Globals, dnGREPIgnoreASD
    run, %dngrep% /f "%ahk%" /st PlainText /pi "%dnGREPIgnoreASD%" /pm %dnGREPMatch% /s* %searchterm%
return

SearchItemIndnGrep:
    IniRead, dnGREPMatch, %IniFile%, dnGREP_Globals, dnGREPMatch
    IniRead, dnGREPIgnoreASD, %IniFile%, dnGREP_Globals, dnGREPIgnoreASD
    if (GetKeyState("Control", "P"))
    {
        run, %dngrep% /f "%ahk%" /st PlainText /pi "%dnGREPIgnoreASD%" /pm %dnGREPMatch% /s* \%iname%
        return
    }
    run, %dngrep% /f "%ahk%" /st PlainText /pi "%dnGREPIgnoreASD%" /pm %dnGREPMatch% /s* %it%
return


dummy:
return

OpenLVFolder:
    If FileExist(dopus)
        run, %dopusrt% /cmd Go "%fullpath%" NEWTAB=findexisting TOFRONT
    else
        run, %idir%
return


AppendToScriptList:
    FileAppend, `n%fullpath%, %aJumpList%
    Tip("Added to list: " fullpath, 3000)
    LoadScriptListMap()
return






ListLinesX()
{
    listLines
    sleep 500
    WinMove, A, , 2035, 1281, 1080, 720
    return
}

RemoveToolTip:
    tooltip
return



reload:
tooltip GoTo - AHK Reloading...
sleep 400
tooltip
reload
return






opendir:
    run, "C:\Program Files\GPSoftware\Directory Opus\dopusrt.exe" /acmd go "%dir%\%filename%" NEWTAB=tofront,findexisting,findinactive
    gui,hide
return




showtraymenu:
    menu, tray, show
return






RemovePrefix()
{
    global it
    it := RegexReplace(it, "i)# #Include\s")
    
    it := RegexReplace(it, "i)^\(\)\s")
    it := RegexReplace(it, "i)^>\s")
    it := RegexReplace(it, "i)^::\s")
    it := RegexReplace(it, "i)^\$\s")
}
RemoveSuffix()
{
    global it
    it := RegexReplace(it, "\b:\s?.*$")
    it := RegexReplace(it, "\(\)$")
}

RunQuickSave:
    if (GetKeyState("Control", "P") && GetKeyState("Shift", "P"))
    {
        FileDelete, %aJumpTempSave%
        return
    }
    if (GetKeyState("Control", "P"))
    {
        run, %atemp%
        return
    }
    try run, %aJumpTempSave%
return


SaveListView:
    OutputFile := aJumpTempSave
    Gui, g: Default
    Gui, submit, nohide
    Gui, ListView, MainList
    if (GetKeyState("Control", "P") && GetKeyState("Shift", "P"))
    {
        andEdit := 1
    }
    if (GetKeyState("Lwin", "P") && GetKeyState("Shift", "P"))
    {
        
        FileSelectFile, OutputFile, S16, goto_list.txt, Save List As, Text Files (*.txt)
        if (OutputFile = "")
            return
    }
    if (GetKeyState("Control", "P"))
    {
        If FileExist(OutputFile)
            run %OutputFile%
        return
    }
    if !InStr(OutputFile, ".")
        OutputFile .= ".txt"
    guicontrol, show, busy
    count := LV_GetCount()
    if (count = 0)
    {
        tip("There's nothing here to save.", 2000)
        return
    }
    FileDelete, %OutputFile%
    FormatTime, timestamp, %Date%, dddd, MMMM d, yyyy, h:mm tt
    FileAppend, %CurrentFile%`nSearchTerm=%Searchterm%`t%timestamp%`nListview Items`n`;--------------------------------------------------`n, %OutputFile%
    
    Loop % LV_GetCount()
    {
        
        tip("saving listview... " A_index)
        LV_GetText(it, A_Index, 1)
        LV_GetText(line, A_Index, 2)
        LV_GetText(fullpath, A_index, 3)
        ; FileAppend, %it%�Run`, Notepad++.exe -n%line% "%fullpath%"`n, %OutputFile%
        FileAppend, %it%`n, %OutputFile%
    }
    if (andEdit)
    {
        run, %OutputFile%
        andEdit := 0
    }
    guicontrol, hide, busy
    tip("Saved " LV_GetCount() " items to:`n" OutputFile, 2000)
return



SaveListViewWithContext:
    Gui, ListView, MainList
    
    FileSelectFile, OutputFile, S16, goto_list_detailed.txt, Save As
    if (OutputFile = "")
        return
    
    FileDelete, %OutputFile%
    FileAppend, Item`tLine`n, %OutputFile%
    CurrentFile := ""
    Loop % LV_GetCount()
    {
        LV_GetText(item, A_Index, 1)
        LV_GetText(line, A_Index, 2)
        
        if (CurrentFile != ActiveFileIndex) {
            CurrentFile := ActiveFileIndex
            fileName := GOTOS.filelist[CurrentFile]
            FileAppend, `n=== %fileName% ===`n, %OutputFile%
        }
        
        FileAppend, Line %line%: %item%`n, %OutputFile%
    }
return





HksInGoto:
    SendToScript("func|BuildHotkeysInFileMenu|xxx|" SourceScript "|1",MainScript)
    sleep 800
return

ShowASDMenuViaGoto:
    sendtomain("ShowASDMenu")
return
SendToMainShowAEMenu:
    
    SendToScript("ShowAEMenu", "xxx.ahk - AutoHotkey")
return



CompileGTF:
    Menu, tray, noicon
    SendToScript("func|CompileX|" SourceScript "", Main)
exitapp
return











#IfWinExist > A_Jumper > ahk_class AutoHotkeyGUI
#IfWinExist

#If WinActive("ahk_id " hGGG)
    
    $F10:: ; set view mode to A_full, (HOLD) for 1 Sec to ReBuildFullListView, (DoubleTap) to edit aJump ScriptList
        Gui, %hGGG%:Default
        KeyWait F10, T1
        if ErrorLevel
        {
            SoundBeep
            BuildFullListView(1)
            Return
        }
        else
        {
            KeyWait F10, D T0.15
            if ErrorLevel
            {
                if (ViewMode = "A_full")
                {
                    FocusEdit()
                    
                }
                else
                {
                    if !(FullListViewBuilt)
                        gosub BuildFullListView
                    setmode("A_full")
                    FocusEdit()
                }
                
            }
            else
            {
                gosub EditaJumpList
                Return
            }
        }
        KeyWait F10
    return
    
    F7:: ; sent view move to single, refresh active file
        if (viewmode = "A_full")
            gosub togglemode
        
        loadfile(currentfile)
        FocusEdit()
    
    return
    
    
    F8:: ;; Toggle View Mode A_single<>A_full
        gosub Togglemode
    return
    
    ~down::
        Gui,g: Default
        GuiControlGet, FocusedControl, FocusV
        if (FocusedControl = "SearchTerm")
            GuiControl, Focus, MainList
    return
    
    ; f9::
        ; If FileExist(xinc "\menu\alt Editor.ahk")
            ; gosub SendToMainShowAEMenu
        ; else
            ; Sendinput, {F9}
    ; return
    
    wtf1235:
        GuiControlGet,A_Focus, Focus
        if (A_Focus = Edit1)
        {
            Guicontrol, focus, SysListView321
        }
    return
    
    ^g:: ;; Go To \ Open to the line of selected list view item in your TE
    Enter:: ;; Go To \ Open to the line of selected list view item in your TE
        gosub GOOO
    return
    
    ; !+X::
    ; SendaJumpSearchBoxToDnGrep:
        ; Gui, submit, nohide
        ; if (searchterm = "")
        ; {
            ; Tip("EmptyBox. Nothing to search", 2000)
            ; return
        ; }
        ; gosub SearchBoxIndnGrep
    ; return
    
    ; !x::
        ; GetItem()
        ; removeprefix()
        ; it := RegexReplace(it, "\b:\s?.*$", ":")
        ; if (it != "")
            ; gosub SearchItemIndnGrep
        ; else
            ; Tip("ListView Item Not Acquired!", 2500)
    ; return
    
    GetItem()
    {
        global row, it, line, fullpath
        Row := LV_GetNext(0)
        LV_GetText(it, Row, 1)
        return it
    }
    ^c:: ;; Copy Details of the selected listview item
        ControlGetFocus, focusedCtrl, ahk_id %hGGG%
        if (focusedCtrl = "SysListView321")
            gosub CopySelectedItem
        else
            sendinput, ^c
    return
    
    CopySelectedItem:
        Row := LV_GetNext(0)
        LV_GetText(it, Row, 1)
        LV_GetText(line, Row, 2)
        LV_GetText(fullpath, row, 3)
        FileReadLine, fullline, %fullpath%, %line%
        
        clipboard := it " (Line " line ")`nin file= " fullpath "`nfullline=" fullline
        ToolTip, Copied: %clipboard%
        SetTimer, RemoveToolTip, -1500
    return
    
    
    
    
    
    
    
    
    
    
    ^n:: ;; activate or run NP++
        if winexist("ahk_class Notepad++")
            Winactivate
        else
            Run, Notepad++.exe
    return
    ^d:: ; open the folder of the selected listview script
        IniRead, A_FileClicked, %IniFile%, aJump_Config, A_FileClicked
        If !FileExist(A_FileClicked)
        {
            tip("The Active File Cannot Be Found!", 2500)
            return
        }
        splitpath, A_fileclicked, ,clickeddir
        If FileExist(dopus)
            Run, %dopusrt% /cmd GO "%A_FileClicked%" NEWTAB=findexisting TOFRONT
        else
            run, %clickeddir%
    return
    
    !u:: ;; Toggle Debug info Showing on GUI
        gosub ToggleDebugOnGuI
    return
    
    !F4:: ; Exit A_Jumper
    exitapp
    return
    
    
    ; ^!F1::
    ; debughell:
        ; Gui,submit,nohide
        ; global Row := LV_GetNext(0)
        
        ; LV_GetText(it, Row, 1)
        ; LV_GetText(line, Row, 2)
        ; global CurrentFile, row
        
        ; info := "Row: " Row "`n"
        ; info .= "Item: " it "`n"
        ; info .= "Line: " line "`n"
        ; info .= "File: " CurrentFile "`n"
        ; info .= "Exists: " FileExist(CurrentFile) "`n"
        ; info .= "SearchTerm=" SearchTerm "=`n"
        ; box(info)
    ; return

    
    ^f:: ;; Focus Search Box
        Gui, %hGGG%:Default
        FocusEdit()
    return
    
    !c:: ;; Clear SearchBox
    ; Gui, %hGGG%:Default
        guicontrol,focus,SearchTerm
        send, ^a
        sleep 10
        send, {BS}
    return
    
    ^F5:: ;; Reload A_Jumper
        gosub reload
    return
    
    F5:: ;; Refresh current active file
        gosub ReFreshFileView
    return
    
    F11:: ;; Edit aJump.ini
    EditaJumpSettings:
        If FileExist(iie)
        {
            if WinExist(" - iniEditor ahk_exe iniEditor.exe")
            {
                WinActivate
                SendtoScript("func|loadinisection|" inifile "|aJump_Config", "iniEditor.exe")
            }
            else
                run, %iie% /s aJump_Config "%inifile%"
        }
        else
        {
            run, %te% "%inifile%"
        }
    return
    
    ^F11:: ;; edit INI file alt
        OpenFiletoFoundText(inifile, "[aJump_Config]")
    return
    
    ; f12:: 
        ; gosub HksInGoto
    ; return
#if

#IfWinActive AHK_group editors
    F7:: ; (G) Activate A_Jumper, Set viewmode to Single, Refresh TE Active File
        global activefile := ""
        GetActiveTEFile()
        DetectHiddenWindows,on
        if WinExist("ahk_id " hGGG)
        {
            Winshow
            WinActivate
            Gui, %hggg%:Default
            if (ViewMode = "A_full")
            {
                If FileExist(nppfile) {
                    loadfile(nppfile)
                    FocusEdit()
                }
                else
                {
                    setmode("A_single")
                    loadfile(nppfile)
                    FocusEdit()
                }
            }
            else
            {
                
                if (NppFile = Currentfile)
                {
                    loadfile(currentfile)
                    FocusEdit()
                }
                else
                {
                    loadfile(nppfile)
                    FocusEdit()
                    update_gui("")
                }
                gosub ReFreshFileView
            }
            return
        }
        FocusEdit()
        DetectHiddenWindows,off
    return
    
    
    F10:: ;; (G) Activate A_Jumper, set view mode to full
        DetectHiddenWindows, on
        if WinExist("ahk_id " hGGG)
        {
            Winshow
            WinActivate
            if !(FullListViewBuilt)
                gosub BuildFullListView
            if !(viewmode = "A_full")
                SetMode("A_full")
            FocusEdit()
        }
        DetectHiddenWindows, off
    return
    
    
    #!j:: ;; (G) send selected text from TE to A_Jumper
    SearchSelectionInAJump:
        gosub GetNppFile
        backupclipboard()
        Send, ^c
        clipwait,0.5
        if (Clipboard != "")
            LoadIntoGuiText := Clipboard
        restoreclipboard()
        DetectHiddenWindows,on
        if WinExist("ahk_id " hGGG)
        {
            Winshow
            WinActivate
            if (NppFile != CurrentFile)
            {
            }
            FocusEdit()
            guicontrol, ,searchterm
            ControlSetText, Edit1, %LoadIntoGuiText%
            sleep 30
            sendinput, {end}
        }
        DetectHiddenWindows,off
    return

#IfWinActive


EditaJumpScriptList:
EditaJumpList:
    
    run, %te% "%aJumpList%"
return

ReFreshFileView:
    if (ViewMode = "A_full")
        goto ReBuildFullListView
    GoTo_Readfile(CurrentFile)
    ActiveFileIndex := FileIsCached(CurrentFile)
    lv_delete()
    sleep 300
    setmode("A_single")
return

ReBuildFullListView:
    BuildFullListView(1)
return
BuildFullASDView:
BuildFullListView:
    BuildFullListView()
return
BuildFullListView(Reindex:=0)
{
    global aJumpList, fileToRead, scriptlistcount, FullListViewBuilt, SLCount, ViewMode
    guicontrol, show, busy
    if FileExist(aJumpList) {
        FileRead, fileList, %aJumpList%
        
        Loop, Parse, fileList, `n, `r
        {
            fileToRead := Trim(A_LoopField)
            if (fileToRead = "" || !FileExist(fileToRead))
                continue
            
            scriptlistcount++
            CoordMode, tooltip, client
            tooltip, Reading\Indexing aJumpList... ##(%A_index%), 100, 100
            GoTo_Readfile(fileToRead)
            
            if (ActiveFileIndex = 0) {
                CurrentFile := fileToRead
                ActiveFileIndex := FileIsCached(fileToRead)
            }
        }
        
        
        if (reindex)
        {
            lv_delete()
            sleep 300
            setmode("A_full")
        }
        ToolTip
        guicontrol,,SLCount,SL_#[%ScriptListCount%]
        Global FullListViewBuilt := 1
    }
    else
        Tip("aJumpList=" aJumpList "`nwas not Found!!!", 7000)
    guicontrol, hide, busy
}


watchNppFile:
    if !WinExist("ahk_class Notepad++")
        return
    if WinExist("ahk_class Notepad++") {
        guicontrol,show,busy
        WinGetTitle, Title, ahk_class Notepad++
        if RegExMatch(Title, "([A-Z]:\\[^*]+\.ahk)", match)
            Global A_NppFile := match1
    }
    guicontrol,hide,busy

return
getNppFile:
    NppFile := ""
    if WinExist("ahk_class Notepad++") {
        WinGetTitle, Title, ahk_class Notepad++
        if RegExMatch(Title, "([A-Z]:\\[^*]+\.ahk)", match)
            NppFile := match1
        else
        {
            Tip("NP++ Doesn't have an .ahk file active. -ln" A_LineNumber)
        }
    }
Return
GetActiveTEFile()
{
    WinGetActiveTitle, Title
    if RegExMatch(Title, "([A-Z]:\\[^*]+\.ahk)", match)
        NppFile := match1
    else
    {
        Tip("NP++ Doesn't have an .ahk file active. -ln" A_LineNumber, 1000)
    }
}

loadTEFile:
LoadNppfile:
    If !ProcessExist("Notepad++.exe")
        Run, notepad++.exe
    
    if WinExist("ahk_class Notepad++")
    {
        WinGetTitle, Title, - Notepad++ ahk_class Notepad++
        if RegExMatch(Title, "([A-Z]:\\[^*]+\.ahk)", foundPath)
            if FileExist(foundPath) {
                tip("Loading ... " foundpath, 1500)
                loadFile(foundpath)
            }
            else
                tip("NP++ Doesn't have an .ahk file active.")
    }
return
LoadActiveTEFile:
    if WinExist("AHK_group Editors")
    {
        WinGetTitle, Title, %editors%
        if RegExMatch(Title, "([A-Z]:\\[^*]+\.ahk)", foundPath)
            if FileExist(foundPath) {
                
                tip("Loading ... " foundpath, 1500)
                loadFile(foundpath)
            }
            else
                tip("NP++ Doesn't have an .ahk file active.")
    }
return

loadASDFile:
    iniread, ASDfile, %inifile%, aJump_Config, LoadFromASDMenu
    If FileExist(ASDfile)
    {
        inidelete, %inifile%, aJump_Config, LoadFromASDMenu
        LoadFile(ASDfile)
    }
return

exit:
exitapp
return



ToggleDarkMode:

return

TextFileMenu(MenuName,File,LineLimit:="")
{
    Global History_Menu_LineLimit
    Menu, %MenuName%, UseErrorLevel, on
    
    Menu, %MenuName%, add
    Menu, %MenuName%, deleteall
    Menu, %MenuName%, add, ^+ Text File Menu`t[Edit], EditTextFileMenu
    Menu, %MenuName%, Icon, ^+ Text File Menu`t[Edit], %Icons%\document outlines text_file_type_256x256.ico,,32
    Menu, %MenuName%, disable, ^+ Text File Menu`t[Edit]
    
    
    
    Menu, %MenuName%, add,
    lines := 0
    
    if (linelimit)
        linelimit := LineLimit
    else
        linelimit := 111
    
    FileRead, textlines, %File%
    Loop, Parse, textlines, `n, `r
    {
        line := Trim(A_LoopField)
        
        
        if (line != "")
        {
            StringReplace, line,line,`%A_tab`%,%A_tab%,all
            lines++
            If FileExist(line)
                Menu, %MenuName%, add, %line%, TFMAction
            else
            {
                Menu, %menuname%, add, !# - %line%, CopyLine
                Menu, %menuname%, Icon, !# - %line%, %icons%\attention.ico,,16
                
            }
        }
        
        if (linelimit)
        {
            if (lines > linelimit)
                break
        }
    }
    
    
    Menu, %MenuName%, add,
    Menu, %MenuName%, add, Lines=%lines%//LineLimit=%LineLimit%, dummy
    Menu, %MenuName%, icon, Lines=%lines%//LineLimit=%LineLimit%, %texteditor%
    splitpath, File, f_name, f_dir
    Menu, %MenuName%, add, %f_dir%\%f_name%, EditTFMFile
    
    
    
    
    Menu, %MenuName%, UseErrorLevel, off
}

CopyLine:
    line := A_ThisMenuItem
    line := StrReplace(line, "!# - ")
    clipboard =
    sleep 40
    clipboard := Trim(line)
return
TFMAction:
    global LineToPaste := A_ThisMenuItem
    global LineToPaste := Trim(LineToPaste)

SkipLineToPasteSplit:
    if (GetKeyState("Shift", "P"))
    {
        clipboard =
        sleep 40
        Clipboard := LineToPaste
        ClipWait,1
        If (clipboard != "")
        {
            Tooltip Copied... %LineToPaste%
            SetTimer, RemoveToolTip, -1500
        }
        return
    }
    
    
    if WinActive("> A_Jumper > ahk_class AutoHotkeyGUI")
    {
        LoadFile(LineToPaste)
        return
    }
    Clipboardbackup := ClipboardAll
    sleep 300
    clipboard := LineToPaste
    send, ^v
    sleep 100
    clipboard := Clipboardbackup
    sleep 500
Return

EditTFMFile:
    file := A_thismenuitem
    Run, %texteditor% "%File%"
return

EditTextFileMenu:
    run, %te% "%A_linefile%"
return









LoadFromFileList:
    TextFileMenu("ajl",aJumpList,LineLimit:="")
    Menu, ajl, show
return


ReSetINI:
    If FileExist(inifile)
        FileRecycle, %inifile%
    sleep 750
makeINI:
    global defaultINILayout
    defaultINILayout =
(
;; Be sure to reload A_Jumper to apply settings when changing them here.
;; ....Additionally to RESET to Default Settings....
;; 1st, EXIT A_Jumper! ***
;; 2nd, Rename or Delete this file. The program will name a new one when launched again.

[aJump_Config]
ggX=500
ggY=500

; inifile= `%A_ScriptDir`%\aJump.ini
;; if you want to use a custom .ini copy the [sections] from this file into your own. Put the full path in the key above and un-comment it. When reload A_Jumper it will start reading from that ini.

ActiveViewMode=A_single
A_File=
A_FileClicked=
A_FileIN=
ShowInlineComments=1
UseFuzzy=0
; Default(fallback) Font_LV=Consolas
Font_LV=Ubuntu Mono
FontColor_LV=8AFFB0
FontSize_LV=11
Font_Footer=Fira Mono
FontColor_Footer=0078D7
DefaultGUIWidth=675
ListViewRows=13
ShowGridLines=0
Pin=0
Menu_IconSize=24
HideTooltips=0
AutoClearTooltips=1
ClearToolTipTimer=5000
;; Auto-> ClearTooltipsTimer is in Milliseconds , 5000 = 5s

PreloadFullFileList=0
;; If your file list is large (eg, 90+ files and\or 60,000+ lines) reading\loading will take a moment. If you often use this app in single file mode set PreloadFullFileList to 0 then it only loads once needed, when switching to Full Mode.

ScriptList=%A_ScriptDir%\aJumpScriptList.txt
;; Add a list of .ahk files, 1 per line, in this, `%A_ScriptDir`%\aJumpScriptList.txt, file.
;; A_Jumper will read them each and display its findings when your in A_Full Mode.

;; You can also save multiple project file lists and switch out which one is active
;; by setting it to this ScriptList=  key here.


GroupAdd_Editors_exe=VSCodium.exe|Code.exe|notepad++.exe|notepad4.exe|geany.exe|SciTE.exe|Adventure.exe|sublime_text.exe|AHK-Studio.exe|bcompare.exe
GroupAdd_Editors_class=Notepad++|SciTEWindow
;; These two GroupAdd keys affect the Context Sensitive Hotkeys that call A_Jumper forward when a text editor is active. at the moment they are... F7, to view the active .ahk file in Single View Mode (*this works best when using Notepad++, more editor support coming soon.*), && F10 to Activate A_Jumper in Full Mode where its reads and displays the from your ScriptList.txt file.

;; put these options here for tinkering. they might be buggy
DebugOnGuI=0
; ShowQueryResultsOnStatsBar=0
; UseThemedStatusBar=0
; StartMinimized=0

[Programs]
;; text editors and other 3d party programs this ahk app could interactive with.
;; IMPORTANT, at least set the paths to your text editors in this section or the jump to line function will not work! also set your fav text edtior in the top TextEditor= KEY
;; this other programs listed are optional, and so far only a couple have integrated support, such as dnGrep

; DefaultTextEditor=C:\Program Files\Notepad++\notepad++.exe
;; aJumper was built with and at the moment is tweaked to work best with Notepad++.exe!!!
;; the Default TextEditor can be changed below.
;;as of 01-03-2026 this list of text editor as support for opening to selected line number from the list view
; Notepad++ ( default )
; SciTE 4 Autohotkey
; Notepad4
; Sublime Text
; Geany
; AHK-Studio (limited buggy, not fully tested)
;; and LIMITED Support with..
; VS Code
; VS Codium
;; these two can open to a line. but cannot follow the active Document from the editor.
;; these two also have better built in jump tools soo...

TextEditor=C:\Program Files\Notepad++\notepad++.exe
iniTextEditor=X:\PFP\Notepad4\Notepad4.exe
iie=X:\AHK\xINC\inieditor\inieditor.exe
iieS=X:\AHK\xINC\inieditor\inieditor.ahk
adventure=X:\PFP\AHK APPS\Adventure [Editor]\Adventure.exe
AhkStudio=X:\PFP\AHK APPS\AHK Studio\AHK-Studio.exe
astrogrep=X:\PFP\AstroGrep\AstroGrep.exe
bcompare=C:\Program Files\Beyond Compare 5\BCompare.exe
bcompareclip=C:\Program Files\Beyond Compare 5\BCClipboard.exe
ditto=X:\PFP\Ditto\Ditto.exe
dnGREP=C:\Program Files\dnGrep\dnGREP.exe
dopus=C:\Program Files\GPSoftware\Directory Opus\dopus.exe
dopusrt=C:\Program Files\GPSoftware\Directory Opus\dopusrt.exe
everything=C:\Program Files\Everything 1.5a\Everything.exe
EV=C:\Program Files\Everything 1.5a\Everything.exe
everything15a=C:\Program Files\Everything 1.5a\Everything.exe
flow=X:\PFP\FlowLauncher\app-1.19.5\Flow.Launcher.exe
Geany=X:\PFP\Geany\bin\geany.exe
listary=X:\PFP\Listary\Listary.exe
Notepad4=X:\PFP\Notepad4\Notepad4.exe
NotepadPP=C:\Program Files\Notepad++\notepad++.exe
OnlyOffice=C:\Program Files\ONLYOFFICE\DesktopEditors\editors.exe
QuickLook=C:\Users\%A_username%\AppData\Local\Programs\QuickLook\QuickLook.exe
Scite=C:\Program Files\AutoHotkey\SciTE\SciTE.exe
SublimeText=X:\PFP\Sublime Text\sublime_text.exe
typora=X:\PFP\Typora\Typora.exe
VsCode=X:\PFP\Code\VSCodium.exe
VSCodium=X:\PFP\Code\VSCodium.exe
ahk2exe=C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe

)
    
    FileAppend,%defaultINILayout%,%inifile%
    sleep 1000
return

buttonsuspendkeys:
    suspend
return

ShowHotkeysInThisFileMenu:
Jumptohotkeyrunnermenu:
iflive()
sleep 30
cleanuppathstring()
A_File := clipboard
RestoreClipboard()
sleep 100

if FileExist(A_File)
	{
		splitpath,A_File,,dir,ext,stem
        if (ext = "exe")
        {
            sourceAHK := dir "\" stem ".ahk"
            If FileExist(sourceAHK)
            {
            ; box("sourceAHK found=" sourceAHK)
            BuildHotkeysInFileMenu("lkfromSourceAHK", sourceAHK)
            Menu, lkfromSourceAHK, add, ; line -------------------------
            Menu, lkfromSourceAHK, add, ; line -------------------------
            Menu, lkfromSourceAHK, add, View SourceAHK from EXE Selection`t-d,dummy
            Menu, lkfromSourceAHK, Icon, View SourceAHK from EXE Selection`t-d, %Icons%\dialog-information_256x256.ico,,32
            Menu, lkfromSourceAHK, disable, View SourceAHK from EXE Selection`t-d
            Menu, lkfromSourceAHK, show
            return
            
            }
        
        }
		if (ext = "ahk")
        {

            BuildHotkeysInFileMenu("lkfromselection", A_file)
            Menu, lkfromselection, show
        }
	}
else
{
	tooltip !FileExist . or . not A.ahk File
	SetTimer, RemoveToolTip, -2500
}
return


BuildHotkeysInFileMenu(menuName, AHKFilePath, Show:=0) {
	If (IsLL)
		Tip("* Loading... Menu, %lk_inFile% menuName`n`t" AHKFilePath " // " menuName)
    global listary, is, iconerror, icons, texteditor,
    global hotkeyMenuMaps  ; Single global object to hold all menu maps
    
    ; Initialize the global maps object if it doesn't exist
    if (!IsObject(hotkeyMenuMaps))
        hotkeyMenuMaps := {}
    
    ; Create a unique map for this menu
    if (!IsObject(hotkeyMenuMaps[menuName]))
        hotkeyMenuMaps[menuName] := {}
    Menu, tray, UseErrorLevel, on
    FileRead, fileContent, %AHKFilePath%
    if (ErrorLevel) {
        Menu, %menuName%, Add
        Menu, %menuName%, DeleteAll
        Menu, %menuName%, Add, ; line -------------------------
        Menu, %menuName%, Add, ERR! Reading Active File!, dummy
        Menu, %menuName%, Icon, ERR! Reading Active File!, %iconerror%,, 32
        return
    }
    
    A_IsInSD := InStr(AHKFilePath, A_ScriptDir)
    
    SplitPath, AHKFilePath, A_linename,dir,
    StringReplace,dir,dir,%A_ScriptDir%,,
    
    Menu, %menuName%, Add
    Menu, %menuName%, DeleteAll
    if (A_IsInSD)
    {
        Menu, %menuName%, Add, ^+ Hotkeys in .%dir%\%A_linename%`t^+, EditFileInHeadingLK
        Menu, %menuName%, Icon, ^+ Hotkeys in .%dir%\%A_linename%`t^+, %Icons%\HotKeys auto List_101 xfav_32x32.ico,, 28
    }
    else
    {
        Menu, %menuName%, Add, ^+ .Hotkeys in ...\%A_linename%`t^+, EditFileInHeadingLK
        Menu, %menuName%, Icon, ^+ .Hotkeys in ...\%A_linename%`t^+, %Icons%\HotKeys auto List_101 xfav_32x32.ico,, 28
        ; Menu, %menuName%, Add, .Hotkeys in %dir%\%A_linename%, dummy ;; toshow full path
        ; Menu, %menuName%, Icon, .Hotkeys in %dir%\%A_linename%, %Icons%\HotKeys auto List_101 xfav_32x32.ico,, 28

    }
    Menu, %menuName%, Add, ; line -------------------------
    
    hotkeyCount := 0

    Loop, Parse, fileContent, `n, `r
    {
        line := A_LoopField

        ; if (RegExMatch(line, "i)^\s*([^;|:]\S*?::)", match)) { ;; matches keys
        ; if (RegExMatch(line, "i)^\s*(#if\w*\s|[^;|:]\S*?::)", match)) { ;; matches keys and #if dirictives
        ; if (RegExMatch(line, "i)^\s*(#if\w*.*|[^;|:]\S*?::)", match)) { ;; same as above, get whole line NO matches if in comments
        ; if (RegExMatch(line, "i)^[^;]*?(^#if\w*.*|[^;|:]\S*?::)", match)) { ;; matching = word\sword:: which is wrtong eg, tooltip A_thishotkey::, hokteys mu start a line (spaced ok) with no word before it 
        if (RegExMatch(line, "i)^[^;]*?(^#if\w*.*|[^;|:]\S*?::)", match)) { 
        ; if (RegExMatch(line, "i)^\s*([^;|:]\S*?::|#if\w*.*)", match)) {
            hotkeyRaw := RegExReplace(match1, "^\s*", "")
            hotkeySend := StrReplace(hotkeyRaw, "::", "")
            lineNumber := A_Index
            trimmedLine := Trim(line)
            ; StringReplace, trimmedLine, trimmedLine, :: `;`;, : `;, All
            ; StringReplace, trimmedLine, trimmedLine, :: ;;, : ;, All
            ; trimmedline := RegExReplace(trimmedline, "::\S*?`;`;", ": `;") mine broken
            
            trimmedline := RegExReplace(trimmedline, "\s+", " ")
            trimmedline := RegExReplace(trimmedline, "`;`;", "`;")
            menuItemName := trimmedLine . A_Tab . "L#:" . lineNumber
            
            Menu, %menuName%, Add, %menuItemName%, LiveHotkeymenuRunnerAction
            if Instr(menuitemname, "#if")
                Menu, %menuname%, icon, %menuItemName%, %Icons%\tag_hash_fatcow_32x32.ico
            ; Store in the menu-specific map
            hotkeyMenuMaps[menuName][menuItemName] := {hotkey: hotkeySend, lineNumber: lineNumber, filePath: AHKFilePath, menuName: menuName}
            
            hotkeyCount++
        }
    }
        Menu, %menuName%, Add, ; line -------------------------
        ; Menu, %menuName%, Add, Load File into A_Jumper, loadintoajumper
        ; Menu, %menuName%, Icon, Load File into A_Jumper, %icons%\ajump.ico,,%is% ;; broken, AHKFilePath is being set somewhere else in the script

    if (hotkeyCount > 0) {
        Menu, %menuName%, Add, .Total Hotkeys in this file: %hotkeyCount%`t^+{Edit}, Edithotkeysinfilesmenu
        Menu, %menuName%, Icon, .Total Hotkeys in this file: %hotkeyCount%`t^+{Edit}, %icons%\about.ico
        Menu, %menuName%, Add, .Mods: Open2Line# in TE`, ^=Send Hotkey, dummy
        Menu, %menuName%, Icon, .Mods: Open2Line# in TE`, ^=Send Hotkey, %texteditor%
    }
    
    if (hotkeyCount = 0) {
        Menu, %menuName%, Add, ; line -------------------------
        Menu, %menuName%, Add, No Hotkeys found in this file., dummy
        Menu, %menuName%, default, No Hotkeys found in this file.
        Menu, %menuName%, Icon, No Hotkeys found in this file., %iconerror%,,32
    }
    Menu, tray, UseErrorLevel, off
    if (show = 1)
        Menu, %menuName%, show
}

;===========================================================================
;===========================================================================
;===========================================================================

EditFileInHeadingLK:
if (GetKeyState("Control", "P") && GetKeyState("Shift", "P"))
	{
		OpenTEToLine(A_linefile, A_LineNumber) ;; 🡱 menu  ¦¦  🡳 label
		return
	}
run, %te% "%AHKFilePath%"
return

Edithotkeysinfilesmenu:
run, %texteditor% "%A_linefile%"
return

loadintoajumper:
Run %aJumpEXE% "%AHKFilePath%"
return
;===========================================================================
;===========================================================================
;===========================================================================
; Updated handler that works with multiple menus
; Updated handler that works with multiple menus
LiveHotkeymenuRunnerAction:  ;; this one is LIVE !!! ;; old labels moved to scribbles
    global hotkeyMenuMaps, keystosend
    selectedMenuItem := A_ThisMenuItem    ; Find which menu this item belongs to by searching all maps
    if (GetKeyState("Control", "P"))
	{
        parts := StrSplit(selectedMenuItem, ":")  ; Split at :
        keystosend := parts[1]
        ; box(keystosend)
        keywait, control
		modifiers := ""		; Parse modifiers and key
		key := keystosend
        ;; todo, need to remove ahks spical key hook symbols, ~$* , before modifiers are separated from the hotkey
        StringReplace, key, key, ~,,
        StringReplace, key, key, $,,
        StringReplace, key, key, *,,
        
		if InStr(key, "^") {		; Extract modifiers (^+!#) from the key
			modifiers .= "^"
			key := StrReplace(key, "^", "")
		}
		if InStr(key, "+") {
			modifiers .= "+"
			key := StrReplace(key, "+", "")
		}
		if InStr(key, "!") {
			modifiers .= "!"
			key := StrReplace(key, "!", "")
		}
		if InStr(key, "#") {
			modifiers .= "#"
			key := StrReplace(key, "#", "")
		}

        ; box("keytosend=%modifiers%{%key%}`n`nRaw KeyToSend=" KeyToSend "`nParts with Mods=" modifiers "{" key "}`n`nor should I send, " modifiers key) ;; debugging 
        
        Send, %modifiers%{%key%} ; this does nothing from XPP++ but it worked from main ? yes this works from my main script, but not my side script

        ; SendInput, %modifiers%{%key%} ; this does nothing from XPP++
        ; SendInput, %modifiers%%key% ;  this also sent text:PrintScreen
        ; Send, %modifiers%%key% ; this send text:PrintScreen
        ; send, %keystosend% ; 
		return
	}
    for menuName, menuMap in hotkeyMenuMaps {
        if (menuMap.HasKey(selectedMenuItem)) {
            itemInfo := menuMap[selectedMenuItem]
            hotkey := itemInfo.hotkey
            lineNumber := itemInfo.lineNumber
            filePath := itemInfo.filePath
    
    ; box("A_tmi=" selectedMenuItem "`n`nfrom script " A_ScriptName "`n`nfilepath=" filepath "  . line=" linenumber " & hotkey=" hotkey "`n`nTE=" texteditor "`n`nTE_Name=" TE_Name) ;; debugging vars as this menu I live in multiple co-running scripts. xnote that if use else where TE_Name with split paths needs tp bein in auto exe of each.
                   
            OpenTEToLine(filePath, lineNumber)     ; Open to line in editor using the stored filePath
            
            return
        }
    }
    
    ; MsgBox, Could not find hotkey info for: %selectedMenuItem%
    box("Could not find hotkey info for:  " selectedMenuItem "", 5)
return

; Example usage:
; BuildHotkeysInFileMenu("hk1", "C:\Scripts\MyScript1.ahk")
; BuildHotkeysInFileMenu("hk2", "C:\Scripts\MyScript2.ahk")
; Menu, MainMenu, Add, Script 1 Hotkeys, :hk1
; Menu, MainMenu, Add, Script 2 Hotkeys, :hk2

;---------------------------------------------------------------------------



GetFileIcon(File) {
    ; listlines, off
    global iconerror
    VarSetCapacity(FileInfo, A_PtrSize + 688, 0)
    Flags := 0x101  ; SHGFI_ICON and SHGFI_SMALLICON
    if DllCall("shell32\SHGetFileInfoW", "WStr", File, "UInt", 0, "Ptr", &FileInfo, "UInt", A_PtrSize + 688, "UInt", Flags) {
        hIcon := NumGet(FileInfo, 0, "UPtr")
        if hIcon != 0
            return "HICON:" hIcon
    }
    ; Fallback if icon retrieval fails
    return %iconerror%  ; ? iconerror : A_AhkPath
    ; listlines, on
} 


CopyA_ThisMenuItemAmper:
	selected := A_ThisMenuItem
	parts := StrSplit(selected, "`t")
	CopyThis := Trim(parts[1])
	; box(copythis)
	; amper := A_ThisMenuItem
	; StringReplace, amper, amper, &,,all
	clipboard =
	sleep 30
	Clipboard := CopyThis
	ClipWait,0.5
	if (Clipboard != "")
	{
		tooltip, %clipboard%
		SetTimer, RemoveToolTip, -2500
	}
Return
; copy right of tab, copy left of tab
CopyA_ThisMenuItemLeftofTab:
CopyA_ThisMenuItemRightofTab:
selected := A_ThisMenuItem
parts := StrSplit(selected, "`t")  ; Split at `t split at tab
Left := Trim(parts[1])
Right := Trim(parts[2]) ; Box("XXX1=" XXX1 "`nXXX2=" XXX2, 4) ;debug Check
; tip("left¦" left "`nright¦" right "`ntmi¦" A_thismenuitem "`n selected" selected)
clipboard =
sleep 40
if (A_ThisLabel = "CopyA_ThisMenuItemLeftofTab")
    clipboard := Left
if (A_ThisLabel = "CopyA_ThisMenuItemRightofTab")
    clipboard := right
	ClipWait,0.5
	if (Clipboard != "")
	{
		tooltip, %clipboard%
		SetTimer, RemoveToolTip, -2500
	}
return

CopyA_ThisMenuItem:
	clipboard =
	sleep 30
	Clipboard := Trim(A_ThisMenuItem)
	ClipWait,0.5
	if (Clipboard != "")
	{
		tooltip, %clipboard%
		SetTimer, RemoveToolTip, -2500
	}
Return

runwithUIA:
run, "C:\Program Files\AutoHotkey\AutoHotkeyU64_UIA.exe" "%A_ScriptFullPath%"
RETURN
;; ==================================================

;///////////////////////// CLIPBOARD FUNCTION ;/////////////////////////

;------------------------- CAPS KEY FUCNCTIONS--------CAPSLOCK-------------------------------------
;; start the paste of eclm
IfLive() ;; function ;; checks if Auto Copy is running
{
	global ClipSaved
    global AutoCopyWhenOpeningCMenu
	global ForceLiveMenu
	; Global filename, dir, ext, filestem, drive
    if (AutoCopyWhenOpeningCMenu || ForceLiveMenu) ;; #todo, update this in SHARE
    {
        ; do nothing continue with the Auto Copied clipboard data
		; msgbox Your menu is live!`nThe clipboard will be used for the next menu item that requires text. (without send ^c again)`n`nclipboard:  %clipboard%
    }
    else ; if not live
    {
        CopyClipboardCLM()  ; Copy before continuing
    }
}

CopyClipboardCLM() ;; Function
{
global ClipSaved  ;Ensure global is used if ClipSaved is accessed elsewhere
Global filename, dir, ext, filestem, drive, lastfolder, highlighted ;, selected
global ClipSaved := ""

ClipSaved := ClipboardAll  ; Save the current clipboard contents
sleep getdelaytime() * 1000
; sleep 50
; sleep 369 ; todo broken fix adjust time longer if needed
Clipboard := ""  ; Clear the clipboard
Sleep 30  ; Adjust the sleep time if needed
; WinGet, id, ID, A
; WinGetClass, class, ahk_id %id%
; if (class ~= "(Cabinet|Explore)WClass|Progman|dopus.lister")
	; Send {F2}
Sendinput ^{vk43} ; Sendinput  ^c ; Sendinput ^{vk43}  ; Send Ctrl+C COPY
ClipWait, 0.5
  ; Check if clipboard is empty, a tab, or just whitespace
if (ErrorLevel || Clipboard = "" || Clipboard = A_Tab || RegExMatch(Clipboard, "^\s+$")) ; if ErrorLevel
	{
		Tooltip, Copy Failed!`nOr you did not have text selected.`nYour Previous Clipboard Content is Restored. ;, 2, 18
		SetTimer, RemoveToolTip, -1500
		Clipboard := ClipSaved  ; Restore the clipboard
        sleep getdelaytime() * 1000 ;; removed it it add more delay
		ClipSaved := ""  ; clear the variable
		sleep 20
		return
	}
}

PasteClipboardCLM() ;; function
{
global ClipSaved
sleep 20
		; WinGet, id, ID, A  ; Get the ID of the active window ; errorlevel checks
		; WinActivate, ahk_id %id%  ; Activate the window
		; sleep 300
; WinGet, id, ID, A
; WinGetClass, class, ahk_id %id%
; if (class ~= "(Cabinet|Explore)WClass|Progman|dopus.lister")
	; Send {F2}
send, ^v ; Sendinput, ^{vk43} ; send, ^v, ; Sendinput, ^{vk43} ; Sendinput, ^v  ; Send Paste
sleep getdelaytime() * 1000
; sleep 200
; Sleep 500  ; Give the system time to paste the clipboard content
Clipboard := ClipSaved  ; {Restore the saved clipboard contents}
sleep 200 ; 300 ; old 10-08-2025 
ClipSaved := ""  ; Clear the variable
; sleep 20
}

RestoreClipboard() ;; function
{
global Clipsaved
clipboard := ""
sleep 30
Clipboard := ClipSaved
sleep getdelaytime() * 1000
; sleep 1000
sleep 100
ClipSaved := ""  ; Clear the variable
; sleep 50
}

BackupClipboard() ;; Function
{
Global ClipSaved
Clipsaved := "" ; clear the last ClipSaved
sleep 20
ClipSaved := ClipboardAll ; save the current clipboard to memory
sleep 200 ; 400 ; old changed 10-08-2025
Clipboard := "" ; empty the clipboard, ready to revive content
sleep 20
}

pasteasplaintext() ;; function
{
global ClipSaved
ClipSaved := ClipboardAll  ; save original clipboard contents
sleep 300
Clipboard := Clipboard  ; remove formatting
sleep 100
Send ^v  ; send the Ctrl+V command
Sleep 100  ; give some time to finish paste (before restoring clipboard)
Clipboard := ClipSaved  ; restore the original clipboard contents
sleep 100
ClipSaved := ""  ; clear the variable
}

basiccopy() ;; function
{
Global ClipSaved
SendInput, ^c ;Send ^{vk43} ;Ctrl C ;  Send {Ctrl down}c{Ctrl up}  ; Send ^{vk43} ; Send ^c
; return
}

basiccut() ;; Function
{
Global ClipSaved
SendInput, ^x
; return
}

basicpaste() ;; Function
{
Global ClipSaved
Send ^{vk56} ;Ctrl V ; SendInput, ^v, send, ^v ; Send {Ctrl down}v{Ctrl up}
; return
}

basicSelectAll() ;; function
{
; sendinput, {blind}{Control down}{a}{control up} ; send ^a

}

getfileinfo() ;; function
{
    Global ClipSaved, filename, dir, ext, filestem, drive, A_File, lastfolder, highlighted
    iflive()
    sleep 100
    cleanupPATHstring()
    sleep 100
    ; SplitPath, Clipboard, filename, dir, ext, filestem, drive
}

cleanupPATHstring() ;; function
{
;; new function from claude 01-31-2025, 5th fix for windows enviVars, seems likes its fixed, old fucntion is OKTD
Global ClipSaved, filename, dir, ext, filestem, drive, lastfolder, A_File, highlighted, match, match1, icons,
; Basic cleanup
Clipboard := RegExReplace(RegExReplace(Clipboard, "\r?\n"," "), "(^\s+|\s+$)")  ; remove line breaks\returns
Clipboard := RegExReplace(Clipboard, "^(?:'*)|('*$)")  ; remove single quotes
Clipboard := StrReplace(clipboard,"""")  ; remove double quotes
Clipboard := RegExReplace(Clipboard, ",\s*$")  ; Remove trailing comma and spaces

    If (SubStr(Clipboard, 1, 8) = "file:///")
	{ ; Handle file:/// URLs
        decodeURLpath(clipboard)
        goto splitcleaned_int
    }
    If InStr(Clipboard, "%A_ScriptDir%")
	{ ; Handle AHK variables
        clipboard := StrReplace(Clipboard, "%A_ScriptDir%", A_ScriptDir)
        dir := RegexReplace(clipboard, "\\[^\\]*$", "")
    }
	If InStr(clipboard, "%icons%")
	{ ; Handle x AHKs x variable
		clipboard := StrReplace(clipboard, "%icons%", A_ScriptDir "\Icons")
		dir := RegexReplace(clipboard, "\\[^\\]*$", "")
	}
    Loop
	{ ; Handle environment variables
        ; Match any %variable% pattern
        if RegExMatch(Clipboard, "i)%(\w+)%", match) {  ;; %ahk%\xxx.ahk ;testing-debug
            ; Get the environment variable value
            EnvGet, envValue, %match1%
            if (envValue != "") {
                ; Replace the %variable% with its value
                Clipboard := StrReplace(Clipboard, match, envValue)
                continue
            } else {
                tooltip, ERR! @Line#:  %A_linenumber%`nEnvironment variable %match1% not found
                SetTimer, RemoveToolTip, -1500
                break
            }
        }
        break
    }

splitcleaned_int:
    SplitPath, Clipboard, filename, dir, ext, stem, drive
    lastfolder := dir
    lastfolder := RegExReplace(lastfolder, ".*\\([^\\]+)\\?$", "$1")

}



decodeURLpath(IPath) {
; Create a working copy of the input
workingPath := IPath

; Handle file:/// URLs
If (SubStr(workingPath, 1, 8) = "file:///") {
	workingPath := SubStr(workingPath, 9)
}

; Decode all URL-encoded special characters allows in windows filenames
workingPath := StrReplace(workingPath, "%20", " ")   ; Space
workingPath := StrReplace(workingPath, "%21", "!")   ; Exclamation mark
workingPath := StrReplace(workingPath, "%23", "#")   ; Hash/pound
workingPath := StrReplace(workingPath, "%24", "$")   ; Dollar sign
workingPath := StrReplace(workingPath, "%25", "%")   ; Percent
workingPath := StrReplace(workingPath, "%26", "&")   ; Ampersand
workingPath := StrReplace(workingPath, "%27", "'")   ; Single quote
workingPath := StrReplace(workingPath, "%28", "(")   ; Opening parenthesis
workingPath := StrReplace(workingPath, "%29", ")")   ; Closing parenthesis
workingPath := StrReplace(workingPath, "%2B", "+")   ; Plus sign
workingPath := StrReplace(workingPath, "%2C", ",")   ; Comma
workingPath := StrReplace(workingPath, "%2D", "-")   ; Hyphen/minus
workingPath := StrReplace(workingPath, "%E2%80%93", "–")   ; extended dash –
workingPath := StrReplace(workingPath, "%2E", ".")   ; Period
workingPath := StrReplace(workingPath, "%3D", "=")   ; Equals sign
workingPath := StrReplace(workingPath, "%40", "@")   ; At symbol
workingPath := StrReplace(workingPath, "%5B", "[")   ; Opening square bracket
workingPath := StrReplace(workingPath, "%5D", "]")   ; Closing square bracket
workingPath := StrReplace(workingPath, "%5E", "^")   ; Caret
workingPath := StrReplace(workingPath, "%60", "`")   ; Backtick
workingPath := StrReplace(workingPath, "%7B", "{")   ; Opening curly brace
workingPath := StrReplace(workingPath, "%7D", "}")   ; Closing curly brace
workingPath := StrReplace(workingPath, "%7E", "~")   ; Tilde
workingPath := StrReplace(workingPath, "%C2%A6", "¦") ; Vertical bar symbol
workingPath := StrReplace(workingPath, "%2F", "/")   ; Forward slash
workingPath := StrReplace(workingPath, "%5F", "_")   ; Underscore
workingPath := StrReplace(workingPath, "%3B", ";")   ; Semicolon
workingPath := StrReplace(workingPath, "%3A", ":")   ; Colon
workingPath := StrReplace(workingPath, "%3F", "?")   ; Question mark
workingPath := StrReplace(workingPath, "%3C", "<")   ; Less than
workingPath := StrReplace(workingPath, "%3E", ">")   ; Greater than
workingPath := StrReplace(workingPath, "%7C", "|")   ; Pipe
workingPath := StrReplace(workingPath, "/", "\")     ; Convert forward slashes to backslashes

return workingPath
}

/*
;; decoding url paths
; decodeURLpath(IPath) ;; usage Examples decodeurlpath() ;; function
; myPath := "file:///C:/Some%20Folder/file.txt"
; decodedPath := decodeURLpath(myPath)
; Example 1: Using a variable that already exists
filename := "myfile.txt"                   ; Create a variable first
decodedPath := decodeURLpath(filename)     ; Send that variable to the function

; Example 2: Using a string directly
decodedPath := decodeURLpath("myfile.txt") ; Send a string directly

; Example 3: Variable can come from anywhere
InputBox, userFile, Enter filename         ; Get filename from user input
decodedPath := decodeURLpath(userFile)     ; Send that input to function

; Example 4: Could be from another function
getSelectedFile() {
    return "selected.txt"
}
decodedPath := decodeURLpath(getSelectedFile())
*/


; Copies the selected text to a variable while preserving the clipboard. ; Handy function.
GetText(ByRef MyText = "")
{
    SavedClip := ClipboardAll
    Clipboard =
    Send ^c
    ClipWait 0.5
    If ERRORLEVEL
    {
        Clipboard := SavedClip
        MyText =
        Return
    }
    MyText := Clipboard
    Clipboard := SavedClip
    Return MyText
}

; Pastes text from a variable while preserving the clipboard.
PutText(MyText)
{
   SavedClip := ClipboardAll 
   Clipboard =              ; For better compatability
   Sleep 20                 ; with Clipboard History
   Clipboard := MyText
   Send ^v
   Sleep 300
   Clipboard := SavedClip
   Return
}



;===========================================================================
;===========================================================================
;===========================================================================

;--------------------------------------------------


;This makes sure sure the same window stays active after showing the InputBox.
;Otherwise you might get the text pasted into another window unexpectedly.
SafeInput(Title, Prompt, Default = "")
{
   ActiveWin := WinExist("A")
   InputBox OutPut, %Title%, %Prompt%,,, 120,,,,, %Default%
   WinActivate ahk_id %ActiveWin%
   Return OutPut
}



;///////////////////////////////////////////////////////////////////////////
;; get delay time fuction for dynamic sleeps
;; xnote todo, this I also being used in x ahks x capslock menu.ahk, .... this should be in SHARED FUCN??
; viewdelaytime:
; getdelaytime()
; msgbox Delay_Time: %delay_time%`ndelaytick: %delaytick% ;`n freq: %freq%
; return
;-------------------------
/*
;;; raw code from forum, below is edit by AUTOHOTKEY Gurus
; delaytime()
; {
; global
; DllCall("QueryPerformanceFrequency", "Int64*", freq)
; DllCall("QueryPerformanceCounter", "Int64*", CounterBefore)
; Sleep 1000
; DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)
; MsgBox % "Elapsed QPC time is " . (CounterAfter - CounterBefore) / freq * 1000 " ms"
; }
*/

GetDelayTime() ;; function
{
	listlines, off
;; Demonstrates QueryPerformanceCounter(), which gives more precision than A_TickCount's 10 ms., source: https://www.autohotkey.com/docs/v1/lib/DllCall.htm
;; video ref: https://www.youtube.com/watch?v=TKxiqnZLcz8 , title: How to Creating a self-Adjusting Sleep that adjusts to your Computer's Load
;; !!!! usage example = sleep getdelaytime() * 1000 ;; the * 1000 matches the bottomline of the fucntion both can be delected
	global delay_time, delaytick
	DllCall("QueryPerformanceFrequency", "Int64*", freq := 0)
	DllCall("QueryPerformanceCounter", "Int64*", CounterBefore := 0)
	loop 1000
		delaytick := A_Index
	DllCall("QueryPerformanceCounter", "Int64*", CounterAfter := 0)
	; MsgBox "Elapsed QPC time is "  (CounterAfter - CounterBefore) / freq * 1000 " ms" ; debug view output from docs

	return delay_time := (CounterAfter - CounterBefore) / freq * 1000
	listlines, on
}
;///////////////////////////////////////////////////////////////////////////


;; ==================================================

#Include Lib\AddTooltip.ahk
#Include Lib\GuiButtonIcon.ahk
