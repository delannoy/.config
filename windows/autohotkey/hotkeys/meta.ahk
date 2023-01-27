
#!r::{
    ; reload script
    TrayTip("reloaded " A_ScriptName, "AutoHotkey", "Mute") ; [Creates a balloon message window near the tray icon](https://www.autohotkey.com/docs/v2/lib/TrayTip.htm) ; "Mute" option disables the notification sound
    Reload ; [Replaces the currently running instance of the script with a new one](https://www.autohotkey.com/docs/v2/lib/Reload.htm)
}

#SuspendExempt ; [Exempts subsequent hotkeys and hotstrings from suspension](https://www.autohotkey.com/docs/v2/lib/_SuspendExempt.htm)
#Esc::{
    ; toggle suspend and pause script
    Suspend(-1) ; [Disables or enables all or selected hotkeys and hotstrings](https://www.autohotkey.com/docs/v2/lib/Suspend.htm)
    Pause(-1) ; [Pauses the script's current thread](https://www.autohotkey.com/docs/v2/lib/Pause.htm)
}
