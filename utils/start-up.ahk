#Requires AutoHotkey v2.0

;; Open Pomotroid
Run "C:\Users\nvz\AppData\Local\Programs\pomotroid\Pomotroid.exe"
WinWait "ahk_exe Pomotroid.exe"
WinMove 2950, 800
WinHide

;; Open QQ
Run "C:\Program Files\Tencent\QQNT\QQ.exe"
SetTimer HideQQ, 50
HideQQ() {
    DetectHiddenWindows False
    if WinExist("QQ ahk_class Chrome_WidgetWin_1 ahk_exe QQ.exe") {
        WinHide()
    }
}

;; Open VPN
Run "C:\Program Files (x86)\yytclient\yytclient.exe"
SetTimer HideVPN, 50
SetTimer ExitScript, 15000 
HideVPN() {
    DetectHiddenWindows False
    if WinExist("ahk_class FLUTTER_RUNNER_yytclient ahk_exe yytclient.exe") {
        WinHide()
    }
}

ExitScript() {
    ExitApp
}