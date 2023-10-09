import re
camel_re = '(?<=[a-z])(?=[A-Z])'
fruits='AppleOrangeBananasStrawberryPeach'
print(re.sub(camel_re, ' ', fruits))