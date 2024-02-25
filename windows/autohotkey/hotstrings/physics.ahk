#Hotstring O

; https://github.com/scikit-hep/hepunits/blob/master/src/hepunits/constants/constants.py
::\c_light::299792458 * m / s
::\avogadro::6.02214076e23 / mole
::\h_planck::6.62607015e-34 * joule * s
::\k_boltzmann::1.380649e-23 * joule / kelvin

CelciusToFarenheit(temp){
    return (Float(temp) * 9/5) + 32
}
::\cf::{
    ; send selection to clipboard and convert Celsius to Fahrenheit
    SendInput("^c")
    Sleep(100)
    MsgBox(A_CLIPBOARD . " °C = " . (Float(A_CLIPBOARD)*9)/5 + 32 . "°F")
}

FarenheitToCelcius(temp){
    return (Float(temp) - 32) * 5/9
}
::\fc::{
    ; send selection to clipboard and convert Celsius to Fahrenheit
    SendInput("^c")
    Sleep(100)
    MsgBox(A_CLIPBOARD . " °F = " . (Float(A_CLIPBOARD)-32) * 5/9 . "°C")
}

; LHC

::\lhc_frequency_brilcalc::11245.613
LHC_FREQUENCY_BRILCALC := 11245.613

::\lhc_circumference_brilcalc::299792458/11245.613 ≈ 26658.614163585393
LHC_CIRCUMFERENCE_BRILCALC := 299792458 / lhc_frequency_brilcalc

LumiSection(lhc_freq := LHC_FREQUENCY_BRILCALC){
    return 2**18 / lhc_freq
}
::\lumisection_brilcalc::{
    SendInput(LumiSection(LHC_FREQUENCY_BRILCALC))
}

LumiNibble(lhc_freq := LHC_FREQUENCY_BRILCALC){
    return 2**12 / lhc_freq
}
::\luminibble_brilcalc::{
    SendInput(LumiNibble(LHC_FREQUENCY_BRILCALC))
}

::\lhc_rf_frequency::400788860 ; https://accelconf.web.cern.ch/IPAC10/papers/tupeb056.pdf
::\lhc_frequency::400788860/35640 ≈ 11245.478675645343

::\lhc_circumference::26658.883 ; http://cds.cern.ch/record/782076/files/CERN-2004-003-V1-ft.pdf [table 2.4]
::\lhc_frequency_from_circumference::299792458/26658.883 ≈ 11245.499595763258

::\lumisection::(3564)*(25e-9)*(2**18) ≈ (35640/400788860)*(2**18) ≈ (26658.883/299792458)*(2**18) ≈ 23.3
::\luminibble::(3564)*(25e-9)*(2**12) ≈ (35640/400788860)*(2**12) ≈ (26658.883/299792458)*(2**12) ≈ 0.364
