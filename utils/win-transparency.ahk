#Requires AutoHotkey v2.0
#SingleInstance force

if !A_IsAdmin {
    try {
        Run("*RunAs " . A_ScriptFullPath)
    }
    ExitApp()
}

OnMessage(0x0201, (*) => PostMessage(0xA1, 2,,, "A"))

MsgBox("1. Activate the target window.`n2. Press [Alt + T] to adjust.", "Window Transparency Tool", "Iconi")

!t:: {
    if IsSet(TransGui) {
        TransGui.Destroy()
        Sleep(100)
    }

    global TargetHwnd := WinActive("A")
    
    if !TargetHwnd || TargetHwnd == A_ScriptHwnd || WinGetClass(TargetHwnd) == "AutoHotkeyGUI" {
        return
    }

    activeTitle := WinGetTitle(TargetHwnd)

    global TransGui := Gui("+AlwaysOnTop -MinimizeBox", "Opacity: " . SubStr(activeTitle, 1, 50))
    TransGui.SetFont("s11", "Segoe UI")
    TransGui.Add("Text",, "Left: 100% | Right: 0%")

    mySlider := TransGui.Add("Slider", "Range0-255 Value0 w250")
    mySlider.OnEvent("Change", (s, *) => updateOpacity(s.Value))

    updateOpacity(val) {
        if WinExist(TargetHwnd) {
            actualOpacity := 255 - val
            try {
                WinSetTransparent(actualOpacity, TargetHwnd)
            } catch {
           
            }
        }
    }

    TransGui.OnEvent("Close", (*) => resetAndExit())

    resetAndExit() {
        if WinExist(TargetHwnd) {
            try {
                WinSetTransparent(255, TargetHwnd)
            } catch {
            
            }
        }
        ExitApp()
    }

    TransGui.Show()
}