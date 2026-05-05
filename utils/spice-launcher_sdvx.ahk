#Requires AutoHotkey v2.0
#SingleInstance force

gameClass := "ahk_class SOUND VOLTEX EXCEED GEAR - Main Screen"
audioDevice := '"Analog Out 1/2"'
cplExe := "ahk_exe BlackLionUsbAudioCpl.exe"
cplPath := "C:\Program Files\Black Lion Audio\USB Audio Device Driver\x64\BlackLionUsbAudioCpl.exe"

spiceDir := "F:\KONAMI\SDVX\contents"
spicePath := spiceDir "\spice64.exe"
asphyxiaPath := "F:\KONAMI\SDVX\asphyxia-core\asphyxia-core-x64.exe"

RunWait(A_ComSpec " /c C:\Windows\nircmd.exe setdefaultsounddevice " audioDevice, , "Hide")

Run(cplPath)
if WinWait(cplExe, , 5) {
    WinActivate(cplExe)
    Sleep 100
    ; ControlChooseIndex 2, "SysTabControl321", cplExe      ;; Sample Rate
    ; ControlChooseIndex 1, "ComboBox1", cplExe             ;; 44100
    ControlChooseIndex 3, "SysTabControl321", cplExe      ;; Buffer Size
    ControlChooseIndex 2, "ComboBox1", cplExe             ;; 16
    Sleep 500
    WinClose(cplExe)
    
    if WinWait("ahk_exe SoundID Reference.exe", , 5)
        WinHide
}

; GroupAdd "console", "ahk_exe asphyxia-core-x64.exe"
GroupAdd "console", "ahk_exe WindowsTerminal.exe"
GroupAdd "console", "ahk_class ConsoleWindowClass"

; Run(asphyxiaPath)
Run(spicePath, spiceDir)

if WinWait(gameClass, , 30) {
    if WinWait("ahk_group console", , 10)
        WinMinimize("ahk_group console")
    
    Sleep 2000
    WinActivate(gameClass)
    
    if WinWaitActive(gameClass, , 10) {
        enIme := 0x4090409
        try PostMessage(0x50, 0, enIme, , "A")
    }
}

if WinWaitClose(gameClass) {
    WinClose("ahk_group console")

    Run(cplPath)
    if WinWait(cplExe, , 5) {
        WinActivate(cplExe)
        Sleep 100
        ; ControlChooseIndex 2, "SysTabControl321", cplExe    ;; Sample Rate
        ; ControlChooseIndex 2, "ComboBox1", cplExe           ;; 48000
        ControlChooseIndex 3, "SysTabControl321", cplExe    ;; Buffer Size
        ControlChooseIndex 7, "ComboBox1", cplExe           ;; 512
        Sleep 500
        WinClose(cplExe)
        
        if WinWait("ahk_exe SoundID Reference.exe", , 5)
            WinHide
    }
}

ExitApp