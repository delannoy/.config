#!/usr/bin/env ipython3

import logging

# [Configuring IPython](https://ipython.readthedocs.io/en/stable/config/index.html#configuring-ipython)

# [Module: `core.magic`](https://ipython.readthedocs.io/en/stable/api/generated/IPython.core.magic.html)

# [How to automatically reload modules in IPython?](https://stackoverflow.com/a/43020072/13019084)
c.InteractiveShellApp.extensions = ['autoreload'] # [A list of dotted module names of IPython extensions to load.](https://ipython.readthedocs.io/en/stable/config/options/terminal.html#configtrait-InteractiveShellApp.extensions)
c.InteractiveShellApp.exec_lines = ['%autoreload 2', # [lines of code to run at IPython startup.](https://ipython.readthedocs.io/en/stable/config/options/terminal.html#configtrait-InteractiveShellApp.exec_lines)
                                    '%load_ext rich'] # [Rich also includes an IPython extension that will do this same pretty install + pretty tracebacks](https://rich.readthedocs.io/en/stable/introduction.html#ipython-extension)

c.InteractiveShellApp.exec_PYTHONSTARTUP = True # [Run the file referenced by the PYTHONSTARTUP environment variable at IPython startup.](https://ipython.readthedocs.io/en/stable/config/options/terminal.html#configtrait-InteractiveShellApp.exec_PYTHONSTARTUP)

# [Unexpected logging outputs after setting log level to debug](https://github.com/ipython/ipython/issues/10946)
logging.getLogger('parso').setLevel(logging.WARNING) # https://github.com/ipython/ipython/issues/10946#issuecomment-568336466
