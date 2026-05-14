; Right-click the system tray icon and select "List of Keys" for reference
; Or Ctrl+Left-click: https://www.autohotkey.com/docs/v2/KeyList.htm

; -------------------------------------------------------------------------------
;                            ==== CORE HOTKEYS ====
; -------------------------------------------------------------------------------

; Show custom plugin pop-up menu
ShowPluginPopupMenu := ""

; Close active VST plugin window
CloseVstWindow := "~Esc"

; Delete selected automation/envelope (Remapped)
ClearAutomation := "^``"

; Select loop brace and export audio
SelectAllNExport := "^+r"

; Shortcut for "Collect All and Save"
CollectAllNSave := "^!s"

; Duplicate clips in blocks of 8
DuplicateTo8 := "!d"

; Search VST plugins (types "vst " into the browser)
SearchVst := "^+f"

; Deactivate selection (Remapped)
Deactivate := "XButton1"

; Insert non-looped MIDI clip
NonLoopedMidiClip := "XButton2"

; Create crossfade (Remapped)
CreateXFade := "!f"

; Shortcut for "Show Automation in New Lane"
; Note: Hover mouse over the target knob
NewLaneAutomation := "^!a"

; Shortcut for "Assign Track Color"
; Note: Hover mouse over the track title
AssignTrackColor := "F14"

; Open preferences window (Remapped)
OpenPreferences := "F12"

; Quickly click sidebar label
; Setup: Use Window Spy (Right-click tray icon) to get [Mouse Position] -> [Window] coordinates
LocateSidebarLabel := "F1"
    Xpos := 85
    Ypos := 180

; Transpose MIDI notes (Remapped)
MidiNoteUp := "+WheelUp"
MidiNoteDn := "+WheelDown"
MidiOctaveUp := "^+WheelUp"
MidiOctaveDn := "^+WheelDown"

; Toggle loop (Remapped)
LoopSwitch := "F13"

; -------------------------------------------------------------------------------
;                           ==== OPTIONAL FEATURES ====
; -------------------------------------------------------------------------------

; Disable "Quit" shortcut
DisableCtrlQ := true

; Swap [TAB] and [SHIFT+TAB]
SwapTabShiftTab := true

; Redo with [CTRL+SHIFT+Z]
CtrlShiftZRedo := true

; Optimized note splitting
; Press [ALT+E] directly instead of [E] then [Alt]
NoteSplitOpt := true

; Left-hand deletion
; Double-tap the [~] key
LeftHandDelete := false

; Auto-switch to English(US) IME when Live is active
AutoEnglishIme := true

; Quick export audio with randomized names
; Note: Select a time range before exporting.
; Note: Manually export once first to set the default save path.
RandomNameSampleExporter := false
    RandomNameSampleExporterShortcut := "!s"
    RandomNameLength := 6
RandomNameChangeIntoDatetime := true    ;; or use timestamp-based naming
    DatetimeFormat := "yyMMdd_HHmmss"

; Generate audio plugin list from specified directory
; Save that plugin mess before migrating to a new PC!
GetPluginList := false
    GetPluginListShortcut := "^+!p"