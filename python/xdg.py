#!/usr/bin/env python3

import os
import pathlib

# [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables)
# [XDG Base Directory](https://wiki.archlinux.org/index.php/XDG_Base_Directory)

XDG_CACHE_HOME = pathlib.Path(f"{os.environ.get('XDG_CACHE_HOME', pathlib.Path.home()/'.cache')}")
XDG_CONFIG_HOME = pathlib.Path(f"{os.environ.get('XDG_CONFIG_HOME', pathlib.Path.home()/'.config')}")
XDG_DATA_HOME = pathlib.Path(f"{os.environ.get('XDG_DATA_HOME', pathlib.Path.home()/'.local/share/')}")
