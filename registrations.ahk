#Include hotkey-config.ahk

RegisterHotkeys()
{
    HotIf(IsAbletonActive)

    SafeRegister(keyVar, funcObj) {
        if (keyVar != "") {
            Hotkey keyVar, funcObj
        }
    }

    SafeRegister(ShowPluginPopupMenu, MyFuncShowPluginPopupMenu)
    SafeRegister(CloseVstWindow, MyFuncCloseVstWindow)
    SafeRegister(ClearAutomation, MyFuncClearAutomation)
    SafeRegister(SelectAllNExport, MyFuncSelectAllNExport)
    SafeRegister(CollectAllNSave, MyFuncCollectAllNSave)
    SafeRegister(DuplicateTo8, MyFuncDuplicateTo8)
    SafeRegister(SearchVst, MyFuncSearchVst)
    SafeRegister(Deactivate, MyFuncDeactivate)
    SafeRegister(NonLoopedMidiClip, MyFuncNonLoopedMidiClip)
    SafeRegister(CreateXFade, MyFuncCreateXFade)
    SafeRegister(NewLaneAutomation, MyFuncNewLaneAutomation)
    SafeRegister(AssignTrackColor, MyFuncAssignTrackColor)
    SafeRegister(OpenPreferences, MyFuncOpenPreferences)
    SafeRegister(LocateSidebarLabel, MyFuncLocateSidebarLabel)
    SafeRegister(MidiNoteUp, MyFuncMidiNoteUp)
    SafeRegister(MidiNoteDn, MyFuncMidiNoteDn)
    SafeRegister(MidiOctaveUp, MyFuncMidiOctaveUp)
    SafeRegister(MidiOctaveDn, MyFuncMidiOctaveDn)
    SafeRegister(LoopSwitch, MyFuncLoopSwitch)
    SafeRegister(RandomNameSampleExporterShortcut, MyFuncRandomNameSampleExporterShortcut)

    HotIfWinActive
}