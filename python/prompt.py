#!/usr/bin/env python3

import csv
import datetime
import getpass
import os
import pathlib
import socket
import sys

import history
from fmt import TXT

def fmt(info: str, color: str = TXT.FG.green) -> str:
    return f'{color}{info}{TXT.reset}'

def prompt() -> str:
    '''Define `sys.ps1`'''
    history.historyBKP()
    now = fmt(datetime.datetime.now())
    user = fmt(getpass.getuser())
    host = fmt(socket.gethostname(), color=TXT.FG.red) if os.environ.get('SSH_CONNECTION') else fmt(socket.gethostname())
    pwd = fmt(os.getcwd())
    py = fmt(f'py:{sys.version.split()[0]}')
    os_release = dict(csv.reader(open('/etc/os-release', mode='r'), delimiter='=')) if pathlib.Path('/etc/os-release').exists() else dict() # [How to Parse /etc/os-release](https://dev.to/htv2012/how-to-parse-etc-os-release-3kaj)
    distro = fmt(f"{os_release.get('ID')}:{os_release.get('VERSION_ID')}")
    venv = fmt(f"venv:{os.environ.get('VIRTUAL_ENV').split('/')[-1]}") if os.environ.get('VIRTUAL_ENV') else None

    ps1 = f'[{now}] [{user}@{host}] [{py}] '
    if os_release:
        ps1 += f'[{distro}] '
    if venv:
        ps1 += f'[{venv}] '
    ps1 += f'[{pwd}] '
    return ps1
