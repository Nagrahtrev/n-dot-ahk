#Requires AutoHotkey v2.0

selectedDir := DirSelect(, 3, "Select folder to scan")
if !selectedDir
    return

outText := A_ScriptDir "\folder-list.txt"
folderData := ""

Loop Files, selectedDir "\*", "D" {
    folderData .= A_LoopFileName "`n"
}

if (folderData != "") {
    if FileExist(outText)
        FileDelete outText

    FileAppend folderData, outText, "UTF-8"
    
    Run outText
} else {
    MsgBox "No subfolders found in:`n" selectedDir, "Scan Result", "Iconi"
}