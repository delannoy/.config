#!/usr/bin/env python3

import os
import pathlib
import urllib.request

import rich.progress

from log import log

# [rich.progress.Progress](https://rich.readthedocs.io/en/stable/reference/progress.html#rich.progress.Progress)
progress = rich.progress.Progress(
            rich.progress.TextColumn(text_format='[bold blue]{task.fields[filename]}'),
            rich.progress.BarColumn(bar_width=60),
            rich.progress.TaskProgressColumn(text_format='[progress.percentage]{task.percentage:>3.1f}%'),
            rich.progress.DownloadColumn(),
            rich.progress.TransferSpeedColumn(),
            rich.progress.TimeRemainingColumn(),
            # transient=True,
            # expand=True,
           )

def download(url: str, filepath: pathlib.Path):
    '''Download `url` to `filepath` with a `rich` progress bar.'''
    # https://github.com/Textualize/rich/blob/master/examples/downloader.py
    task_id = progress.add_task(description="download", start=False, filename=filepath)
    progress.console.log(f"Requesting {url}")
    response = urllib.request.urlopen(urllib.request.Request(url, headers={'User-Agent': os.environ['USERAGENT']}))
    progress.update(task_id=task_id, total=float(response.length))
    with progress:
        with open(filepath, 'wb') as out_file:
            progress.start_task(task_id=task_id)
            for chunk in iter(lambda: response.read(2**10), b''):
                out_file.write(chunk)
                progress.update(task_id=task_id, advance=len(chunk))
        progress.console.log(f'Downloaded {filepath}')
