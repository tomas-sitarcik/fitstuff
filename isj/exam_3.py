class A(object):
    def __init__(self):
        print("entering A")
        super().__init__()
        print("leaving A")

class B(A):
    def __init__(self):
        print("entering B")
        super().__init__()
        print("leaving B")

class C(object):
    def __init__(self):
        print("no super() in C")

class D(object):
    def __init__(self):
        print("entering D")
        super().__init__()
        print("leaving D")

class E(B, C, D):
    def __init__(self):
        print("entering E")
        super().__init__()
        print("leaving E")

e = E()