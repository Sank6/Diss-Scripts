K.<x> = CyclotomicField(16)
G = K.galois_group()
OK = K.ring_of_integers()

t = vector([0, 0, 0, 0])

def log_embedding(f):
    log_embeddings = [float(log(abs(f * conjugate(f))))]
    for i in [3, 1, 2]:
        log_embeddings.append(float(log(abs(G[int(i)](f) * conjugate(G[int(i)](f))))))
    return vector(log_embeddings)

def log_lattice(units):
    log_lattice_out = []
    for unit in units:
        log_lattice_out.append(log_embedding(unit))

    log_lattice_out.append([1, 1, 1, 1])
    return matrix(log_lattice_out)

def unit_attack(alpha, units):
    condition = True
    iterations = 0
    while condition:
        iterations += 1
        lm = log_lattice(units)
        t = lm.solve_left(log_embedding(alpha))
        
        rounded_t = [round(x) for x in t]
        closest_element = units[0] ** rounded_t[0] * units[1] ** rounded_t[1] * units[2] ** rounded_t[2]
        unit = K(closest_element)
        alpha = alpha / unit

        # print('t:', t)
        # print('rounded_t:', rounded_t)
        # print('closest_element:', closest_element)
        # print('unit:', unit)
        # print('new alpha:', alpha)

        rounded_norm = norm(vector(rounded_t[:3]))
        real_norm = norm(t[:3])
        condition = rounded_norm > 0.1
        
        # print('rounded_norm:', rounded_norm)
        # print('real_norm:', real_norm)


    return alpha, t, iterations

alpha = -11*x^7 - 3*x^6 + 3*x^5 + 3*x^4 - 2*x^3 - 6*x^2 + x + 7
#alpha = OK.random_element()
print('alpha:', alpha)
units = [1 + x + x^(-1), 1 + x^3 + x^(-3), 1 + x^5 + x^(-5)]

alpha_out, t, iterations = unit_attack(alpha, units)
print('alpha_out:', alpha_out)
print('t:', t)
print('iterations:', iterations)