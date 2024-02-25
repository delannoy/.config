#!/usr/bin/env python3

import atexit
import os
import pathlib
import readline

def history():
    '''Read `histFile` and write history at exit'''
    # [automatically load and save a history file](https://docs.python.org/3/library/readline.html#example)
    # [History file](https://docs.python.org/3/library/readline.html?highlight=readline#history-file)
    histFile = os.environ.get('_PYHISTFILE', f'{pathlib.Path.home()}/.python_history')
    readline.read_history_file(histFile)
    readline.set_history_length(-1)
    atexit.register(readline.write_history_file, histFile)

def historyBKP():
    '''Append most recent history item to `histFileBKP` if different from the last line'''
    histFileBKP = os.environ.get('_PYHISTFILEBKP', f'{pathlib.Path.home()}/.python_history_bkp')
    lastItemHist = readline.get_history_item(readline.get_current_history_length()).strip()
    lastItemHistBkp = os.popen('tail -1 "${_PYHISTFILEBKP}" 2>/dev/null').read().strip()
    if lastItemHist != lastItemHistBkp:
        readline.append_history_file(1, histFileBKP) # [readline.append_history_file()](https://docs.python.org/3/library/readline.html#readline.append_history_file)
