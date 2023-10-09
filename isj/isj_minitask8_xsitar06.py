# minitask 8
import warnings
import functools

def deprecated(function):
    @functools.wraps(function)
    def trace(*args, **kwargs):
        warnings.simplefilter('always', DeprecationWarning)
        print(f"Call to deprecated function: {format(function.__name__)}.")
        print(f"with args: {args}")
        print(f"with kwargs: {kwargs}")
        print(f"returning: {function(*args, **kwargs)}")
        warnings.simplefilter('default', DeprecationWarning)
        return function(*args, **kwargs)
    return trace


@deprecated
def some_old_function(x, y):
    return x + y

some_old_function(1,y=2)

# should print:
# Call to deprecated function: some_old_function
# with args: (1,)
# with kwargs: {'y': 2}
# returning: 3 
