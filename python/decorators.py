#!/usr/bin/env python3

import functools
import inspect
import logging
import timeit
import typing

from fmt import TXT

logging.basicConfig(level=logging.DEBUG, format='%(message)s', datefmt='[%Y-%m-%d %H:%M:%S]')

def timer(func: typing.Callable = None, _args: bool = False) -> typing.Callable:
    '''Measure execution time of a function. Optionally, print passed args and kwargs.'''
    # [Timing Functions](https://realpython.com/primer-on-python-decorators/#timing-functions)
    # [How to Write a Decorator with an Optional Argument?](https://pybit.es/articles/decorator-optional-argument/)

    if func is None:
        return functools.partial(timer, _args=_args)

    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        t0 = timeit.default_timer()
        value = func(*args, **kwargs)
        t1 = timeit.default_timer()
        if _args:
            signature = '(' + str.join(', ', [repr(a) for a in args] + [f"{k}={v!r}" for k, v in kwargs.items()]) + ')'
        else:
            signature = inspect.signature(func) # [Introspecting callables with the Signature object](https://docs.python.org/3/library/inspect.html#introspecting-callables-with-the-signature-object)
        logging.info(f'{TXT.FG.grey}{func.__module__}.{func.__name__}{signature}: {t1-t0}s{TXT.reset}')
        return value
    return wrapper

def unit(unit: str) -> typing.Callable:
    '''Register a unit on a function'''
    # [Adding Information About Units](https://realpython.com/primer-on-python-decorators/#adding-information-about-units)
    def set_unit(func: typing.Callable):
        func.unit = unit
        return func
    return set_unit
