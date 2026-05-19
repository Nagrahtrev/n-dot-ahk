#SuspendExempt
RShift & F9::Run "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\AutoHotkey Window Spy.lnk"
RShift & F10::Pause
RShift & F11::Reload
RShift & F12::Suspend
#SuspendExempt False

SetNumLockState "AlwaysOn"

^#!NumpadSub:: {
    Send "{LCtrl Up}{RCtrl Up}{LAlt Up}{RAlt Up}{LShift Up}{RShift Up}{LWin Up}{RWin Up}{CapsLock Up}"
    SoundBeep(1000, 150)
    SoundBeep(2000, 300)
    Msgbox "Modifier keys have been reset!"
    SetTimer () => ToolTip(), -5000
}

; -------------------------------------------------------------------------------
;                        ==== CAPSLOCK AS MODIFIER ====
; -------------------------------------------------------------------------------

global EnableCapsToggle := true

if (!EnableCapsToggle) {
    SetCapsLockState "AlwaysOff"
}

*CapsLock:: {
}

*CapsLock Up:: {
    static lstRelease := 0

    if (EnableCapsToggle) {
        if (A_PriorKey = "CapsLock" && A_TickCount - lstRelease < 250) {
            SetCapsLockState !GetKeyState("CapsLock", "T")
            SoundBeep(1500, 200)
            lstRelease := 0
        } else {
            lstRelease := A_TickCount
        }
    }
}

#HotIf GetKeyState("CapsLock", "P")

d::Send "#d"
s::Send "{F23}"    ;; PixPin, take screenshots
t::Send "^#t"    ;; PowerToys, always on top
p::Send "^+{F9}"    ;; Keepass, auto-type
[::Send "^+{F10}"    ;; Keepass, auto-type password
k::Run "C:\Program Files\KeePass\KeePass.exe"
b::Run "powercfg.cpl"
n::Run "C:\Program Files\Notepad3\Notepad3.exe"
m::Run "G:\AutoHotkey\_tmp\Outlook (new).lnk"
Left::Send "{Media_Prev}"
Right::Send "{Media_Next}"
Up::Send "{Volume_Up}"
Down::Send "{Volume_Down}"
Space::Send "{Media_Play_Pause}"
Home::Run "G:\000_Gadgets\MultiMonitorTool\Toggle-Primary-Monitor.bat"
End::Run "G:\000_Gadgets\MultiMonitorTool\Toggle-Secondary-Monitor.bat"

q:: {    ;; Sonarworks
    RunOrActivate("C:\Program Files\Sonarworks\SoundID Reference\Systemwide\SoundID Reference.exe", "ahk_exe SoundID Reference.exe")
    Send "{Space}"
    Sleep 100
    WinHide("ahk_exe SoundID Reference.exe")
}

e::RunOrActivate("C:\Program Files\OneCommander\OneCommander.exe", "ahk_exe OneCommander.exe")
c::RunOrActivate("C:\Program Files\Google\Chrome\Application\chrome.exe", "ahk_exe chrome.exe")
f::RunOrActivate("C:\Program Files\Everything\Everything.exe", "ahk_exe Everything.exe")

w:: {
    targetHwnd := WinExist("A")
    if !targetHwnd {
        return
    }

    winClass := WinGetClass(targetHwnd)
    if (winClass = "WorkerW" || winClass = "Shell_TrayWnd" || winClass = "Progman") {
        return
    }

    CoordMode("Mouse", "Screen")
    MouseGetPos(&mouseX, &mouseY)

    monitorCount := MonitorGetCount()
    targetMonitor := 1

    Loop monitorCount {
        MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
        if (mouseX >= Left && mouseX <= Right && mouseY >= Top && mouseY <= Bottom) {
            targetMonitor := A_Index
            break
        }
    }

    MonitorGetWorkArea(targetMonitor, &WL, &WT, &WR, &WB)
    WinGetPos(,, &winW, &winH, targetHwnd)

    minMax := WinGetMinMax(targetHwnd)
    if (minMax = 1) {
        WinRestore(targetHwnd)
        WinGetPos(,, &winW, &winH, targetHwnd)
    }

    newX := WL + (WR - WL - winW) / 2
    newY := WT + (WB - WT - winH) / 2

    if (newY < WT) {
        newY := WT
    }

    if (newX < WL) {
        newX := WL
    }

    WinMove(newX, newY,,, targetHwnd)

    if (minMax = 1) {
        WinMaximize(targetHwnd)
    }
}

#HotIf

; -------------------------------------------------------------------------------
;                               ==== FUNCTIONS ====
; -------------------------------------------------------------------------------

RunOrActivate(Target, WinTitle) {
    if WinExist(WinTitle) {
        WinActivate()
    } else {
        try {
            Run(Target)
            if WinWait(WinTitle, , 3) {
                WinActivate()
            }
        } catch {
            return
        }
    }
}

PasteText(text) {
    savedClip := ClipboardAll()
    A_Clipboard := ""
    A_Clipboard := text
    ClipWait(1)
    SendEvent "^v"
    Sleep 150
    A_Clipboard := savedClip
    savedClip := ""
}

; -------------------------------------------------------------------------------
;                             ==== HOTSTRINGS ====
; -------------------------------------------------------------------------------

#Hotstring EndChars `s
#Include *i hotstrings.ahk

::\d:: {
    PasteText(FormatTime(,"yyMMdd") "_")
}