; -------------------------------------------------------------------------------
;                           ==== SCRIPT SETTINGS ====
; -------------------------------------------------------------------------------

#Requires AutoHotkey v2.0
Persistent
SetWorkingDir A_ScriptDir
InstallKeybdHook
#UseHook
#SingleInstance force
#MaxThreadsPerHotkey 2
CoordMode "Mouse", "Window"

#Include registrations.ahk
#Include *i global-hotkeys.ahk
#Include *i wake-helper.ahk

if(A_IsCompiled) {
    A_TrayMenu.Insert("&Suspend Hotkeys", "List of Keys", keylist)
    A_TrayMenu.Insert("&Suspend Hotkeys", "Documentation", doc)
    A_TrayMenu.Insert("&Suspend Hotkeys")
} else {
    A_TrayMenu.Insert("&Window Spy", "List of Keys", keylist)
    A_TrayMenu.Insert("&Window Spy", "Documentation", doc)
    A_TrayMenu.Insert("&Window Spy")
}

keylist(*) {
    Run "https://www.autohotkey.com/docs/v2/KeyList.htm"
}

doc(*) {
    Run "https://www.autohotkey.com/docs/v2/"
}

IsAbletonActive(*) {
    try {
        activeHwnd := WinActive("A")
        if !activeHwnd
            return false
            
        clsName := WinGetClass(activeHwnd)
        exeName := WinGetProcessName(activeHwnd)
        
        if (clsName = "Ableton Live Window Class")
            return true
            
        if RegExMatch(exeName, "i)^Ableton Live.*\.exe$")
            return true
    }
    return false
}

RegisterHotkeys()

; -------------------------------------------------------------------------------
;                          ==== AUTO IME SWITCHER ====
; -------------------------------------------------------------------------------

if (AutoEnglishIme) {
    global ImeHookCallback := CallbackCreate(CheckAbletonFocus)
    DllCall("SetWinEventHook"
        , "UInt", 0x0003, "UInt", 0x0003
        , "Ptr", 0
        , "Ptr", ImeHookCallback
        , "UInt", 0, "UInt", 0
        , "UInt", 0)
}

CheckAbletonFocus(*) {
    static wasAbletonActive := false
    
    enIME := 0x4090409
    defaultIME := 0x8040804
    
    try {
        isAbleton := IsAbletonActive()
        
        if (isAbleton && !wasAbletonActive) {
            PostMessage(0x50, 0, enIME, , "A")
            wasAbletonActive := true
        } else if (!isAbleton && wasAbletonActive) {
            PostMessage(0x50, 0, defaultIME, , "A")
            wasAbletonActive := false
        }
    }
}

; -------------------------------------------------------------------------------
;                             ==== MENU BUILDER ====
; -------------------------------------------------------------------------------

menuText := FileRead(A_ScriptDir "\menu-config.txt")
myMenu := CreateMenuFromFile(menuText)

CreateMenuFromFile(configText) {
    mainMenu := Menu()
    menuStack := [mainMenu]
    currentLevel := 0

    Loop parse, configText, "`n", "`r" {
        line := Trim(A_LoopField)

        if (line == "" or SubStr(line, 1, 1) == "#")
            continue

        indent := (StrLen(A_LoopField) - StrLen(LTrim(A_LoopField))) // 4

        if (indent > currentLevel + 1)
            Throw Error("Invalid indentation level at line " A_Index " (Current Level: " currentLevel ", Target Level: " indent ")")
        
        while (indent < currentLevel) {
            menuStack.Pop()
            currentLevel--
        }
        
        if RegExMatch(line, "^-+$") {
            menuStack[-1].Add()
            continue
        }

        isSubmenu := SubStr(line, -1) == ">"

        if isSubmenu {
            subName := Trim(SubStr(line, 1, -1))
            subMenu := Menu()
            menuStack[-1].Add(subName, subMenu)
            menuStack.Push(subMenu)
            currentLevel++
            continue
        }
        
        if RegExMatch(line, "(.*):(.*)", &match) {
            handler := Trim(match[1])
            name := Trim(match[2])
        } else {
            handler := ""
            name := Trim(line)
        }

        if (handler == "C") {
            menuStack[-1].Add(name, (*) => 0)
            menuStack[-1].Disable(name)
            menuStack[-1].SetIcon(name, "Shell32.dll", 44)
            continue
        }
        
        if (isSubmenu) {
            ;; Done
        } else if (handler = "C") {
            ;; Done
        } else {
            callback := handler ? MenuHandler.Bind(handler, name) : (*) => ""
            menuStack[-1].Add(name, callback)
        }
    }

    return mainMenu
}

MenuHandler(handler, name, *) {
    if RegExMatch(handler, "^(S|R|P|M)(\d*)$", &match) {
        typeMap := Map(
            "S", ["", false],
            "R", ["adg `"`"", false],
            "P", ["adv `"`"", false],
            "M", ["amxd `"`"", false]
        )

        if (typeObj := typeMap.Get(match[1], "")) {
            dnCount := match[2] ? Integer(match[2]) : 1
            genericLoader(name, typeObj[1], dnCount, typeObj[2])
            return
        }
    }

    switch handler {
        case "2": genericLoader(name, "vst `"`"", 1, true)
        case "3": genericLoader(name, "vst3 `"`"", 1, true)
        case "?": eg(name)
        case "???": omgitis(name)
    }
}

genericLoader(itemName, prefix := "", dnCount := 1, needWinCheck := false) {
    Sleep 150 
    Send "^f"
    Sleep 100

    fullSearch := (prefix != "" && InStr(prefix, '""')) ? StrReplace(prefix, '""', '"' itemName '"') : (prefix != "" ? prefix " " itemName : itemName)

    SendText fullSearch
    Sleep 800    
    Send "{Down}"

    Sleep 300
    Send "{Home}"
    
    Sleep 100

    Loop (dnCount - 1) {
        Send "{Down}"
        Sleep 50
    }

    Sleep 200
    Send "{Enter}"

    if (needWinCheck) {
        if WinWaitNotActive("ahk_class Ableton Live Window Class", , 5)
            WinActivate
        Sleep 100
    }

    Sleep 500
    Send "{Esc}"
}

eg(*) {
    MsgBox "You selected an example item."
}

omgitis(*) {
    static targetText := ""
    
    ChangeButton() {
        if WinExist("ahk_class #32770 ahk_pid " ProcessExist()) {
            SetTimer ChangeButton, 0
            ControlSetText targetText, "Button1"
        }
    }
    
    CustomPop(msg, btnText) {
        targetText := btnText
        SetTimer ChangeButton, 10
        MsgBox(msg, "")
    }

    CustomPop("EXCUSE ME!", "YES?")
    CustomPop("IS THIS YOUR HANDBAG?", "PARDON?")
    CustomPop("IS THIS YOUR HANDBAG?", "YES, IT IS.")
    
    sankyu := "听我说谢谢你，因为有你，温暖了四季`n"
           . "谢谢你，感谢有你，世界更美丽`n"
           . "我要谢谢你，因为有你，爱常在心底`n"
           . "谢谢你，感谢有你，把幸福传递 :)"
           
    CustomPop(sankyu, "谢谢你")
}

; -------------------------------------------------------------------------------
;                            ==== HOTKEY ACTIONS ====
; -------------------------------------------------------------------------------

MyFuncShowPluginPopupMenu(*) {
    myMenu.Show()
}

MyFuncCloseVstWindow(*) {
    vstClass := WinGetClass("A")

    if (InStr(vstClass, "AbletonVstPlugClass") || InStr(vstClass, "Vst3PlugWindow") || InStr(vstClass, "JUCE_"))
        WinClose("A")
}

MyFuncClearAutomation(*) {
    Send "^{BackSpace}"
}

MyFuncSelectAllNExport(*) {
    Send "^+l"
    Sleep 100
    Send "^+r"
}

MyFuncCollectAllNSave(*) {
    MenuSelect "ahk_class Ableton Live Window Class", , "1&", "15&"
}

MyFuncDuplicateTo8(*) {
    Send "^{d 7}"
}

MyFuncSearchVst(*) {
    Send "^f"
    Sleep 10
    SendText "vst "
}

MyFuncDeactivate(*) {
    Send "{0}"
}

MyFuncNonLoopedMidiClip(*) {
    Send "^+m"
    Sleep 10
    Send "^+j"
}

MyFuncCreateXFade(*) {
    SendEvent "^!f"
}

MyFuncNewLaneAutomation(*) {
    Send "{RButton}"
    Sleep 10
    Send "{Down 2}"
    Send "{Enter}"
}

MyFuncAssignTrackColor(*) {
    Send "{RButton}"
    Sleep 10
    Send "{Up 3}"
    Send "{Enter}"
}

MyFuncOpenPreferences(*) {
    Send "^,"
}

MyFuncLocateSidebarLabel(*) {
    MouseClick , Xpos, Ypos, , 0
    Sleep 10
    Send "{Right}" 
}

MyFuncMidiNoteUp(*) {
    Send "{Up}"
}

MyFuncMidiNoteDn(*) {
    Send "{Down}"
}

MyFuncMidiOctaveUp(*) {
    Send "+{Up}"
}

MyFuncMidiOctaveDn(*) {
    Send "+{Down}"
}

MyFuncLoopSwitch(*) {
    Send "^l"
}

#HotIf DisableCtrlQ && IsAbletonActive()
^q::return

#HotIf SwapTabShiftTab && IsAbletonActive()
+Tab::Tab
Tab::+Tab

#HotIf CtrlShiftZRedo && IsAbletonActive()
^+z::^y

#HotIf NoteSplitOpt && IsAbletonActive()
!e:: {
    static active := false
    if (active)
        return
    active := true

    Send "{e Down}"
    Sleep 30
    SendEvent "{Alt Down}"

    while (GetKeyState("e", "P") && GetKeyState("Alt", "P")) {
        Sleep 10
    }

    Send "{vkE8}"
    Send "{e Up}"
    SendEvent "{Alt Up}"
    active := false
}

#HotIf LeftHandDelete && IsAbletonActive()
~`:: {
    A_HotkeyInterval := 200
    if (A_PriorHotkey = ThisHotkey && A_TimeSincePriorHotkey < A_HotkeyInterval)
        Send "{Del}"
}

#HotIf

RndName(len) {
    chars := "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    charLen := StrLen(chars)
    string := ""
    Loop len {
        rnd := Random(1, charLen)
        string .= SubStr(chars, rnd, 1)
    }
    Return string
}

MyFuncRandomNameSampleExporterShortcut(*) {
    if (RandomNameSampleExporter) {
        Send "^l"
        Sleep 50
        Send "^+l"
        Sleep 50
        Send "^+r"
        Sleep 200
        Send "{Enter}"
        Sleep 500

        if (!RandomNameChangeIntoDatetime) {
            Send RndName(RandomNameLength)
        } else {
            SendInput FormatTime( , DatetimeFormat)
        }

        Sleep 500
        Send "{Enter}"
    }
}

MyFuncGetPluginListShortcut(*) {
    if (!GetPluginList)
        return

    folder := DirSelect(,, "Select a folder to scan for plugins:")
    
    if (folder = "")
        return

    pluginList := ""
    exts := "i)^(dll|vst3|aaxplugin|clap)$"

    Loop Files folder "\*.*", "R" {
        if RegExMatch(A_LoopFileExt, exts) {
            SplitPath A_LoopFileName, , , , &nameNoExt
            pluginList .= nameNoExt "`n"
        }
    }

    if (pluginList != "") {
        outText := "Source Directory: " folder "`n--------------------------------------------------`n`n" pluginList
        timestmp := FormatTime(, "yyyy-MM-dd_HH-mm-ss")
        outFile := A_ScriptDir "\mypluglist_" timestmp ".txt"
        
        FileAppend outText, outFile, "UTF-8"
        Run '"' outFile '"'
    } else {
        MsgBox "No plugins found in the selected directory.", "Scan Complete", "Iconi"
    }
}