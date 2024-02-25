
~MBUTTON::{
    ; hold middle-click to paste [https://autohotkey.com/board/topic/87990-hold-down-key-to-trigger-script/?p=558401]
    if not KeyWait("MBUTTON", "T0.2"){
        SendInput("+{INS}")
    }
}

^+v::{
    ; CTRL+SHIFT+V: paste public Dropbox link from corresponding file path in clipboard
    if InStr(A_CLIPBOARD, "dropbox\public", "Off"){
        clipboard := A_CLIPBOARD
        clipboard := StrReplace(clipboard, "A:\Dropbox\Public\", "")
        clipboard := StrReplace(clipboard, "\", "/")
        clipboard := StrReplace(clipboard, " ", "%20")
        clipboard := "https://adelannoy.com/" . clipboard
        SendInput(clipboard)
    }
}

+!INS::{
    ; SHIFT+ALT+INS: convert space and [illegal/reserved filename characters](https://learn.microsoft.com/en-us/windows/win32/fileio/naming-a-file) in cliboard to [URL percent encoding](http://www.w3schools.com/tags/ref_urlencode.asp)
    clipboard := A_CLIPBOARD
    clipboard := StrReplace(clipboard, " ", "%20")
    clipboard := StrReplace(clipboard, "<", "%3C")
    clipboard := StrReplace(clipboard, ">", "%3E")
    clipboard := StrReplace(clipboard, ":", "")
    clipboard := StrReplace(clipboard, '"', "%3A")
    clipboard := StrReplace(clipboard, "/", "%2F")
    clipboard := StrReplace(clipboard, "\", "%5C")
    clipboard := StrReplace(clipboard, "|", "%7C")
    clipboard := StrReplace(clipboard, "?", "%3F")
    clipboard := StrReplace(clipboard, "*", "%2A")
    SendInput(clipboard)
}
