R.<x> = PolynomialRing(QQ)
f = eval(input("What is the function: "))
K = NumberField(f, 'a') # a is a root of f
OK = K.ring_of_integers()

p = input("Enter an integer prime p to find (p): ")

print(OK.ideal(p).factor())
