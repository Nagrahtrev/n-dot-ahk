#Requires AutoHotkey v2.0
#SingleInstance force
CoordMode "Mouse", "Window"

#SuspendExempt
End::ExitApp
#SuspendExempt False

global IsClicking := false

Home:: {
    global IsClicking := !IsClicking
    
    clickInterval := 100

    if (IsClicking) {
        SetTimer(doClick, clickInterval)
        doClick()
        SoundBeep(1400, 120)
    } else {
        SetTimer(doClick, 0)
        SoundBeep(700, 120)
    }

    doClick() {
        if (IsClicking) {
            Click()
        }
    }
}