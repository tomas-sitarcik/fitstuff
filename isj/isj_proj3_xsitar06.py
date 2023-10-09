#!/usr/bin/env python3

# ukol za 2 body
def first_odd_or_even(numbers):
    """Returns 0 if there is the same number of even numbers and odd numbers
       in the input list of ints, or there are only odd or only even numbers.
       Returns the first odd number in the input list if the list has more even
       numbers.
       Returns the first even number in the input list if the list has more odd 
       numbers.

    >>> first_odd_or_even([2,4,2,3,6])
    3
    >>> first_odd_or_even([3,5,4])
    4
    >>> first_odd_or_even([2,4,3,5])
    0
    >>> first_odd_or_even([2,4])
    0
    >>> first_odd_or_even([3])
    0
    """

    even_count = 0
    odd_count = 0

    for number in numbers:
        if (number % 2) == 0:
            even_count += 1
        else:
            odd_count += 1

    if (even_count == odd_count) or (even_count == 0 and odd_count > 0) or (even_count > 0 and odd_count == 0):
        return 0
    
    if even_count > odd_count:
        for number in numbers:
            if (number % 2) == 1:
                return number
    else:
        for number in numbers:
            if (number % 2) == 0:
                return number
        



# ukol za 3 body
def to_pilot_alpha(word):
    """Returns a list of pilot alpha codes corresponding to the input word

    >>> to_pilot_alpha('Smrz')
    ['Sierra', 'Mike', 'Romeo', 'Zulu']
    """

    pilot_alpha = ['Alfa', 'Bravo', 'Charlie', 'Delta', 'Echo', 'Foxtrot',
        'Golf', 'Hotel', 'India', 'Juliett', 'Kilo', 'Lima', 'Mike',
        'November', 'Oscar', 'Papa', 'Quebec', 'Romeo', 'Sierra', 'Tango',
        'Uniform', 'Victor', 'Whiskey', 'Xray', 'Yankee', 'Zulu']

    pilot_alpha_list = []

    for letter in word:
        for code in pilot_alpha:
            if code[0].lower() == letter.lower():
                pilot_alpha_list.append(code)
                break
     
    return pilot_alpha_list


if __name__ == "__main__":
    import doctest
    doctest.testmod()
