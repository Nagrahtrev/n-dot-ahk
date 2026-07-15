#Requires AutoHotkey v2.0

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
Run "C:\Program Files (x86)\FlyingBird\FlyingBird.exe"
SetTimer HideVPN, 50
SetTimer ExitScript, 15000
HideVPN() {
    DetectHiddenWindows False
    if WinExist("ahk_class FLUTTER_RUNNER_WIN32_WINDOW ahk_exe FlyingBird.exe") {
        WinHide()
    }
}

ExitScript() {
    ExitApp
}