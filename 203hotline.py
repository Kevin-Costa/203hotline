#!/usr/bin/python

import matplotlib.pyplot as plt
import os, sys
import re
import time
import math
import numpy as np

##########################################################################

def fact(n):
    i = 1
    result = 1
    while (i <= n):
        result *=  i
        i += 1
    return (result)

def fact2(n, k):
    i = n
    result = 1
    while (i > (n - k)):
        result *= i
        i -= 1
    return (result)

def simplefact(n, k):
    if (n > (n - k)):
        res = fact2(n, k) / fact(k)
    else:
        res = fact(n) / (fact(k) * fact(n - k))
    return (res)

def coef_bino(n, k):
    res = fact2(n, k) / fact(k)
    return (res)

##########################################################################

def poisson(k, m):
    return (math.exp(-m)*m**k)/math.factorial(k)

if len (sys.argv) == 2:
    try:
       tps = int(sys.argv[1])
    except:
        print("Votre argument 1 doit etre un entier strictement positif")
        sys.exit(1)
    if tps <= 0:
        print("Votre argument 1 doit etre un entier strictement positif")
        sys.exit(1)
    if (int(sys.argv[1]) > 64000):
        print "\033[1;31mOverflow detected\033[1;0m"
        sys.exit(1)
    tps /= 3600.0
    encpoi = 0.0
    poiss = list()
    k = 0
    kl = list()
    m = (tps * 3500) / 8
    taille_pois = list()
    debut = time.time()
    while (k < 51): #graphique poisson
        result = poisson(k, m)
        poiss.append(result)
        taille_pois.append(k)
        kl.append(k)
        if (k > 25):
            encpoi += result
        k += 1
    fin = time.time()
    p = m / 3500
    k = 0
    res = 0.0
    bino = list()
    taille_bin = list()
    debutbin = time.time()
    while (k < 51): #graphique bino
        result = coef_bino(3500, k) *  p**k * (1.0 - p)** (3500 - k)
        bino.append(result)
        taille_bin.append(k)
        if (k > 25):
            res += result
        k += 1
    finbin = time.time()
    if (int(sys.argv[1]) > 320):
        res = 1
        encpoi = 1
    print ("\033[1;33mloi binomiale :\n\ttemps de calcul : \033[1;31m%.2f ms" % ((finbin - debutbin) * 1000))
    print ("\t\033[1;33mprobabilite d'encombrement = \033[1;31m%.1f%%\033[0m" % (res * 100))
    print ("\033[1;33mloi poisson :\n\ttemps de calcul : \033[1;31m%.2f ms" % ((fin - debut) * 1000))
    print ("\t\033[1;33mprobabilite d'encombrement = \033[1;31m%.1f%%\033[0m" % (encpoi * 100))
    try:
        os.environ["DISPLAY"]
    except KeyError:
        print('\033[1;31mProbleme avec l\'environnement\033[0m')
        sys.exit(1);
    billy = np.arange(len(taille_pois))
    taille_bar = 0.40
    fig, tamo = plt.subplots()
    tamo.bar(billy + taille_bar, bino, taille_bar, color='r', label='Loi binomiale')
    tamo.bar(billy, poiss, taille_bar, color='b', label='Loi poisson')
    tamo.set_xticks(billy + taille_bar)
    tamo.set_xticklabels(taille_pois)
    tamo.autoscale_view()
    plt.legend()
    plt.title("203hotline")
    plt.ylabel("Probabilite")
    plt.xlabel("Nombre d'appel simultanes")
    plt.show()


elif len (sys.argv) == 3:
    f = 0
    try:
        k = int(sys.argv[1])
    except:
        print("\033[1;31mvotre 1er argument doit etre un nombre positif et superieur au 2nd argument\033[0m")
        f = 1
    try:
        n = int(sys.argv[2])
    except:
        print("\033[1;31mvotre 2nd argument doit etre un nombre positif et inferieur au 1er argument\033[0m")
        f = 1
    if (f != 1):
        if (n < k):
            print("\033[1;31mvotre 1er argument est superieur au 2nd\033[0m")
            f = 1
        if (n < 0):
            print("\033[1;31mvotre 2nd argument ne peux pas etre inferieur a 0\033[0m")
            f = 1
        if (k < 0):
            print("\033[1;31mvotre 1nd argument ne peux pas etre inferieur a 0\033[0m")
            f = 1
    if f == 1:
        sys.exit(1)
    result = coef_bino(n, k)
    print("\033[1;33mcombinaison de \033[1;31m%d\033[33m parmis \033[1;31m%d\033[33m : \033[1;31m%d\033[0m" % (k, n, result))

else:
    print("\033[1;31mUSAGE: ./203hotline.py <tps>")
    print("USAGE: ./203hotline.py <nb> <nb>\033[0m")
    sys.exit(1)
