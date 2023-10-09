#!bin/python3
import functools

def log_and_count(**keyword_args):
    
    def actual_decorator(func):
        key = func.__name__
        counts = None
        if "key" in keyword_args:
            key = keyword_args["key"]
        if "counts" in keyword_args:
            counts = keyword_args["counts"]
        @functools.wraps(func)
        def actual(*args, **kwargs):
            print(f"called {func.__name__} with {args} and {kwargs}")
            if counts is not None:
                if key in counts.dct:
                    counts.dct[key] += 1
                else:
                    counts.dct[key] = 1
        return actual
    return actual_decorator

class Counter:

    dct = {}
    def __str__(self) -> str:
        return (f"Counter({self.dct.__str__()})")

my_counter = Counter()

@log_and_count(key = 'basic functions', counts = my_counter)
def f1(a, b=2):
    return a ** b

@log_and_count(key = 'basic functions', counts = my_counter)
def f2(a, b=3):
    return a ** 2 + b

@log_and_count(counts = my_counter)
def f3(a, b=5):
    return a ** 3 - b

f1(2)
f2(2, b=4)
f1(a=2, b=4)
f2(4)
f2(5)
f3(5)
f3(5,4)

print(my_counter)