#!/usr/bin/env python3

import os


class TXT:
    '''Set text format and text via tput'''
    # [terminfo - terminal capability database](https://invisible-island.net/ncurses/man/terminfo.5.html#h3-Terminfo-Capabilities-Syntax)
    # [tput](https://linuxcommand.org/lc3_adv_tput.php#text-effects)
    reset = os.popen('tput sgr0').read() # turn off all attributes
    blink = os.popen('tput blink').read() # turn on blinking
    bold = os.popen('tput bold').read() # turn on bold (extra bright) mode
    dim  = os.popen('tput dim').read() # turn on half-bright mode
    invis = os.popen('tput invis').read() # turn on blank mode (characters invisible)
    ital = os.popen('tput sitm').read() # enter italic mode
    rev  = os.popen('tput rev').read() # turn on reverse video mode (reverses background & foreground)
    stout = os.popen('tput smso').read() # begin standout mode (reverse and bold)
    sub = os.popen('tput ssubm').read() # enter subscript mode
    sup = os.popen('tput ssupm').read() # enter superscript mode
    uline = os.popen('tput smul').read() # begin underline mode

    class FG:
        '''Set foreground color'''
        black, red, green, yellow, blue, magenta, cyan, white = (os.popen(f'tput setaf {c}').read() for c in range(0,8))
        grey, lred, lgreen, lyellow, lblue, lmagenta, lcyan, lwhite = (os.popen(f'tput setaf {c}').read() for c in range(8,16))

    class BG:
        '''Set background color'''
        black, red, green, yellow, blue, magenta, cyan, white = (os.popen(f'tput setab {c}').read() for c in range(0,8))
        grey, lred, lgreen, lyellow, lblue, lmagenta, lcyan, lwhite = (os.popen(f'tput setab {c}').read() for c in range(8,16))

    def testColor():
        _ = [print(os.popen(f'tput setab {b}').read() + " "*int(os.popen('tput cols').read()) + os.popen('tput sgr0').read()) for b in range(0,16)]
        for f in range(0,16):
            for b in range(0,16):
                end = '\n' if b == 15 else ' '
                print(os.popen(f'tput setab {b}; tput setaf {f}').read() + f'f{f:02}b{b:02}' + os.popen('tput sgr0').read(), end=end)

