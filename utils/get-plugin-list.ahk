#Requires AutoHotkey v2.0

ib := InputBox("Please enter the plugin folder path:", "Audio Plugin Scanner", "w400 h100")

if (ib.Result != "OK" || Trim(ib.Value) == "") {
    return
}

targetDir := Trim(ib.Value)

if !DirExist(targetDir) {
    MsgBox("The path does not exist.", "Error", "Iconi")
    return
}

pluginList := ""
targetExts := "i)^(dll|vst3|aaxplugin|clap)$"

Loop Files, targetDir "\*.*", "R" {
    if RegExMatch(A_LoopFileExt, targetExts) {
        SplitPath(A_LoopFileName, , , , &nameNoExt)
        pluginList .= nameNoExt "`n"
    }
}

if (pluginList != "") {
    outText := "Source Directory: " targetDir "`n--------------------------------------------------`n`n" pluginList
    timestmp := FormatTime(, "yyyy-MM-dd_HH-mm-ss")

    outDir := A_ScriptDir "\outputs"

    if !DirExist(outDir) {
        DirCreate(outDir)
    }

    outFile := outDir "\plugin-list_" timestmp ".txt"

    FileAppend(outText, outFile, "UTF-8")
    Run('"' outFile '"')
} else {
    MsgBox("No audio plugins found in:`n" targetDir, "Scan Complete", "Iconi")
}
