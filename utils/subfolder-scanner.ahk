#Requires AutoHotkey v2.0

ib := InputBox("Please enter the folder path:", "Subfolder Scanner", "w400 h100")

if ib.Result != "OK" || Trim(ib.Value) == ""
    return

selectedDir := ib.Value

if !DirExist(selectedDir) {
    MsgBox("The path does not exist.", "Error", "Iconi")
    return
}

outDir := A_ScriptDir "\outputs"
outText := outDir "\folder-list.txt"
folderData := ""

Loop Files, selectedDir "\*", "D" {
    folderData .= A_LoopFileName "`n"
}

if (folderData != "") {
    if !DirExist(outDir) {
        DirCreate(outDir)
    }

    if FileExist(outText)
        FileDelete(outText)

    FileAppend(folderData, outText, "UTF-8")
    Run(outText)
} else {
    MsgBox("No subfolders found in:`n" selectedDir, "Scan Result", "Iconi")
}