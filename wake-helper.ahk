OnMessage(0x218, WM_POWERBROADCAST)

WM_POWERBROADCAST(wParam, lParam, msg, hwnd) {
    if (wParam = 0x12) {
        global PatrolCount := 0
        SetTimer(HideSoundID, 1000)
    }
}

HideSoundID() {
    global PatrolCount
    PatrolCount++
    
    targetWin := "SoundID Reference ahk_exe SoundID Reference.exe"
    
    if WinExist(targetWin) {
        WinHide(targetWin)
    }
    
    if (PatrolCount >= 30) {
        SetTimer(HideSoundID, 0)
    }
}