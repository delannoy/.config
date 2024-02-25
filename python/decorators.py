#!/usr/bin/env python3

import functools
import inspect
import timeit
import typing

from log import log
from fmt import TXT

def memoize(func: typing.Callable) -> typing.Callable:
    '''Store return value into `cache` corresponding to `args` and return stored value if the provided `args` are keys in `cache`.'''
    # https://towardsdatascience.com/python-decorators-for-data-science-6913f717669a
    cache = dict()
    def wrapper(*args) -> typing.Any:
        if args in cache:
            return cache.get(args)
        else:
            result = func(*args)
            cache[args] = result
            return result
    return wrapper

def retry(max_tries: int = 3, delay_seconds: int = 1) -> typing.Callable:
    '''Retry up to `max_tries` with `delay_seconds` between each function call.'''
    # https://towardsdatascience.com/python-decorators-for-data-science-6913f717669a
    def decorator_retry(func: typing.Callable) -> typing.Callable:
        @functools.wraps(func: typing.Callable)
        def wrapper_retry(*args, **kwargs) -> typing.Any:
            tries = 0
            while tries < max_tries:
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    tries += 1
                    if tries == max_tries:
                        raise e
                    time.sleep(delay_seconds)
        return wrapper_retry
    return decorator_retry

def timer(func: typing.Callable = None, _args: bool = False) -> typing.Callable:
    '''Measure execution time of a function. Optionally, print passed args and kwargs.'''
    # [Timing Functions](https://realpython.com/primer-on-python-decorators/#timing-functions)
    # [How to Write a Decorator with an Optional Argument?](https://pybit.es/articles/decorator-optional-argument/)
    if func is None:
        return functools.partial(timer, _args=_args)
    @functools.wraps(func)
    def wrapper(*args, **kwargs) -> typing.Any:
        t0 = timeit.default_timer()
        value = func(*args, **kwargs)
        t1 = timeit.default_timer()
        if _args:
            signature = '(' + str.join(', ', [repr(a) for a in args] + [f"{k}={v!r}" for k, v in kwargs.items()]) + ')'
        else:
            signature = inspect.signature(func) # [Introspecting callables with the Signature object](https://docs.python.org/3/library/inspect.html#introspecting-callables-with-the-signature-object)
        log.info(f'{TXT.FG.grey}{func.__module__}.{func.__name__}{signature}: {t1-t0}s{TXT.reset}')
        return value
    return wrapper

def unit(unit: str) -> typing.Callable:
    '''Register a unit on a function'''
    # [Adding Information About Units](https://realpython.com/primer-on-python-decorators/#adding-information-about-units)
    def set_unit(func: typing.Callable) -> typing.Callable:
        func.unit = unit
        return func
    return set_unit
