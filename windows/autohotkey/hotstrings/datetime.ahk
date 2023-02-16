#Hotstring ?

::\dt::{
    SendInput(FormatTime(A_NOW, "yyyyMMddHHmmss"))
}

::\d.t::{
    SendInput(FormatTime(A_NOW, "yyyyMMdd.HHmmss"))
}

::\d-t::{
    SendInput(FormatTime(A_NOW, "yyyyMMdd-HHmmss"))
}

::\date::{
    SendInput(FormatTime(A_NOW, "yyyy-MM-dd"))
}

::\uts::{
    SendInput(DateDiff(A_NOWUTC, "19700101000000", "s")) ; [Compares two date-time values and returns the difference](https://www.autohotkey.com/docs/v2/lib/DateDiff.htm)
}
