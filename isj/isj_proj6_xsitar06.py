#!bin/python3

import collections

class Polynomial:

    polynom = {}

    def __init__(self, *args, **kwds):
        if kwds:
            self.polynom = kwds
        elif args:
            self.polynom = self.pack_arguments(args)

        self.remove_zero_values()
        

    def pack_arguments(self, args) -> dict:
        args_dict = {}
        if type(args[0]) == int:
            for i in range(len(args)):
                args_dict["x"+str(i)] = args[i]
            return args_dict
        else:
            arg_list = args[0]
            for i in range(len(arg_list)):
                args_dict["x"+str(i)] = arg_list[i]
            return args_dict
    

    def __add__(self, poly) -> dict:
        
        sum_dict = {}
        if len(self.polynom) > len(poly.polynom):
            polyA = self.polynom
            polyB = poly.polynom
        else:
            polyB = self.polynom
            polyA = poly.polynom

        for item_key in polyA:
            if item_key in polyB:
                sum_dict[item_key] = polyA[item_key] + polyB[item_key]
            else:
                sum_dict[item_key] = polyA[item_key]
        
        for item_key in polyB:
            if item_key not in sum_dict:
                sum_dict[item_key] = polyB[item_key]

        new_poly = Polynomial()
        new_poly.polynom = sum_dict

        new_poly.remove_zero_values()

        return new_poly

    def __pow__(self, power) -> bool:
        
        if len(self.polynom) == 0:
            return 0

        if power < 0:
            raise ValueError

        res_dict = {}

        for item_key in self.polynom:
            res_dict[item_key] = self.polynom[item_key] ** power

        self.polynom = res_dict

        self.remove_zero_values()

        return self

    def multiply_by(self, value1, value2):
        v1_pow, v1_val = value1 
        v2_pow, v2_val = value2 

        v1_pow = self.get_key_exponent(v1_pow)
        v2_pow = self.get_key_exponent(v2_pow)

        total_pow = v1_pow + v2_pow
        total_value = v1_val * v2_val

        return (self.exponentify(total_pow), total_value)

    def power_poly_values(self, power):

        res = Polynomial()

        if power < 0:
            return x
        elif power == 1:
            res.polynom = self.polynom

        for item_key in self.polynom:
            if power == 0:
                self.polynom[item_key] = 1
            else:
                orig_value = (item_key, self.polynom[item_key])
                new_value = orig_value
                for i in range(power - 1):
                    new_value = self.multiply_by(new_value, orig_value)
                res.polynom[new_value[0]] = new_value[1]
        

        return res


    def get_key_exponent(self, key):
        return int(key[1])
    
    def exponentify(self, power):
        return "x" + str(power)

    def __eq__(self, poly) -> bool:
        if len(self.polynom) != len(poly.polynom):
            return False
        else:
            for item_key in self.polynom:
                if self.polynom[item_key] != poly.polynom[item_key]:
                    return False
        
            return True

    def __str__(self) -> str:
        string = ""

        if len(self.polynom) == 0:
            return "0"

        self.polynom = dict(sorted(self.polynom.items()))
        sep = ""
        for item_key in self.polynom.__reversed__():

            power = int(item_key[1])
            value = self.polynom[item_key]
            
            if value != 0:
                if value < 0:
                    sep = " - "
                if power == 1:
                    string += sep + self.remove_1(str(abs(value))) + "x"
                elif power == 0:
                    string += sep + str(abs(value))
                else:
                    string += sep + self.remove_1(str(abs(value))) + "x^" + str(power)
                sep = " + "

        return string

    def remove_1(self, string):
        if string == "1":
            return ""
        return string

    def derivative(self) -> dict:

        if len(self.polynom) == 1:
            self.remove_zero_values
            self.polynom.keys == ["x0"]
            return Polynomial(0)
            

        new_poly = Polynomial()

        self.polynom = dict(sorted(self.polynom.items()))

        for item_key in self.polynom:

            power = int(item_key[1])
            value = self.polynom[item_key]
            new_key = self.shift_down(item_key)

            if new_key != 0:
                new_poly.polynom[new_key] = value * power

        new_poly.remove_zero_values()
        return new_poly

    def shift_down(self, string):

        if string != "x0":
            return  string[0] + str(int(string[1])-1)
        else:
            return 0

    def remove_zero_values(self):
        keys = []
        for item_key in self.polynom:
            if self.polynom[item_key] == 0:
                keys.append(item_key)
        for key in keys:
            del self.polynom[key];