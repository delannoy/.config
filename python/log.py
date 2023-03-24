#!/usr/bin/env python3

import logging

import rich.logging

LOG_LEVEL = logging.DEBUG

# [Logging Handler](https://rich.readthedocs.io/en/stable/logging.html)
handler = rich.logging.RichHandler(rich_tracebacks=True, log_time_format="[%Y-%m-%d %H:%M:%S]")
logging.basicConfig(level=LOG_LEVEL, format='%(message)s', handlers=[handler])
log = logging.getLogger()

# https://github.com/ipython/ipython/issues/10946#issuecomment-568336466
logging.getLogger('parso').setLevel(logging.WARNING)
