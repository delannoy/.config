#!/usr/bin/env ipython3

import logging
import os
import pathlib

# [Configuring IPython](https://ipython.readthedocs.io/en/stable/config/index.html#configuring-ipython)
# [Terminal options](https://ipython.readthedocs.io/en/stable/config/options/index.html)

c = get_config()

logging.getLogger('parso').setLevel(logging.WARNING) # [Unexpected logging outputs after setting log level to debug](https://github.com/ipython/ipython/issues/10946#issuecomment-568336466)

c.Application.log_level = 20 # [Set the log level by value or name](https://ipython.readthedocs.io/en/stable/config/options/index.html#configtrait-Application.log_level)
c.Application.log_format = '[%(name)s]%(highlevel)s %(message)s' # [The Logging format template](https://ipython.readthedocs.io/en/stable/config/options/index.html#configtrait-Application.log_format)
c.Application.log_datefmt = '%Y-%m-%d %H:%M:%S' # [The date format used by logging formatters for %(asctime)s](https://ipython.readthedocs.io/en/stable/config/options/index.html#configtrait-Application.log_datefmt)

c.TerminalIPythonApp.display_banner = True # [Whether to display a banner upon starting IPython](https://ipython.readthedocs.io/en/stable/config/options/index.html#configtrait-TerminalIPythonApp.display_banner)

c.InteractiveShell.warn_venv = True # [Warn if running in a virtual environment with no IPython installed (so IPython from the global environment is used)](https://ipython.readthedocs.io/en/stable/config/options/index.html#configtrait-InteractiveShell.warn_venv)

c.InteractiveShellApp.exec_PYTHONSTARTUP = True # [Run the file referenced by the PYTHONSTARTUP environment variable at IPython startup.](https://ipython.readthedocs.io/en/stable/config/options/terminal.html#configtrait-InteractiveShellApp.exec_PYTHONSTARTUP)

c.InteractiveShellApp.extensions = [ # [A list of dotted module names of IPython extensions to load](https://ipython.readthedocs.io/en/stable/config/options/terminal.html#configtrait-InteractiveShellApp.extensions)
        'autoreload', # [IPython extension to reload modules before executing user code](https://ipython.readthedocs.io/en/stable/config/extensions/autoreload.html)
        'rich'] # [Rich also includes an IPython extension that will do this same pretty install + pretty tracebacks](https://rich.readthedocs.io/en/stable/introduction.html#ipython-extension)

c.InteractiveShellApp.exec_lines = [ # [lines of code to run at IPython startup](https://ipython.readthedocs.io/en/stable/config/options/terminal.html#configtrait-InteractiveShellApp.exec_lines)
        '%autoreload 2'] # [Reload all modules (except those excluded by %aimport) every time before executing the Python code typed](https://ipython.readthedocs.io/en/stable/config/extensions/autoreload.html)

c.InteractiveShell.history_length = int(1E6) # [Total length of command history](https://ipython.readthedocs.io/en/stable/config/options/index.html#configtrait-InteractiveShell.history_length)
c.InteractiveShell.history_load_length = int(1E4) # [The number of saved history entries to be loaded into the history buffer at startup](https://ipython.readthedocs.io/en/stable/config/options/index.html#configtrait-InteractiveShell.history_load_length)
c.HistoryManager.hist_file = str(pathlib.Path(os.environ['XDG_STATE_HOME']) / 'python/history.sqlite') # [Path to file to use for SQLite history database](https://ipython.readthedocs.io/en/stable/config/options/index.html#configtrait-HistoryAccessor.hist_file)
