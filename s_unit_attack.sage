K.<x> = CyclotomicField(8)
G = K.galois_group()
OK = K.ring_of_integers()


def log_embedding(f, sgens):
    log_embeddings = []

    log_embeddings.append(float(log(abs(G[int(0)](f) * conjugate(G[int(0)](f))))))
    log_embeddings.append(float(log(abs(G[int(3)](f) * conjugate(G[int(3)](f))))))

    for i in range(0,len(sgens)):
        log_embeddings.append(float(log(sgens[i].norm()^(-( K.valuation(sgens[i])(f))))))
    
    return vector(log_embeddings)

def log_lattice(units, sgens):
    log_lattice_out = []
    for unit in units[1:] + sgens:
        log_lattice_out.append(log_embedding(unit, sgens))

    log_lattice_out.append([1, 1, 1, 1, 1, 1, 1, 1])
    return matrix(log_lattice_out)

def s_unit_attack(alpha, units, sgens):
    t = vector([0, 0, 0, 0, 0, 0, 0, 0])
    condition = True
    iterations = 0
    while condition:
        iterations += 1
        lm = log_lattice(units, sgens)
        t = lm.solve_left(log_embedding(alpha, sgens))
        
        rounded_t = [round(x) for x in t]
        closest_element = 1
        for i in range(0, len(units[1:])):
            closest_element *= units[i] ** rounded_t[i]

        for j in range(0, len(sgens)):
            new_j = j + len(units[1:])
            closest_element *= sgens[j] ** rounded_t[new_j]
        
        unit = K(closest_element)
        alpha = alpha / unit
        
        print('t:', t)
        print('rounded_t:', rounded_t)
        print('closest_element:', closest_element)
        print('unit:', unit)
        print('new alpha:', alpha)

        rounded_norm = norm(vector(rounded_t[:3]))
        real_norm = norm(t[:3])
        condition = rounded_norm > 0.1
        
        print('rounded_norm:', rounded_norm)
        print('real_norm:', real_norm)


    return alpha, t, iterations

alpha = -18*x^3-15*x^2-12*x-6
#alpha = OK.random_element()
print('alpha:', alpha)
units = [1 + x + x^(-1), 1 + x^3 + x^(-3)]
sgens = [(x^2 + x - 1), (x^3 + x^2 + 1), (2 - x), (2 - x^3), (2 + x^3), (2 + x)]

alpha_out, t, iterations = s_unit_attack(alpha, units, sgens)
print('alpha_out:', alpha_out)
print('t:', t)
print('iterations:', iterations)