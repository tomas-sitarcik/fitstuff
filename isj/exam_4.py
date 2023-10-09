import math 
import functools

calls = 0
def limit_calls(max_calls = 2, error_message_tail = 'called too often'):
    def actual_decorator(func):
        def actual(*args):
            calls += 1
            if calls >= max_calls:
                    print(f"{func.super().__name__}.TooManyCallsError: function {func.name} - {error_message_tail}")
            return actual
        return actual_decorator
          


@limit_calls(1, 'that is too much')
def pyth(a, b):
        c = math.sqrt(a**2 + b**2)
        return c
print(pyth(3,4))
print(pyth(6,8))