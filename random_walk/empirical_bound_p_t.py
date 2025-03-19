# Compute an empirical bound for P(T>=t) for a specific random walk

import csv
import json
import os
import pathlib
from sympy import Symbol
import sys

import numpy as np
from sympy import lambdify, sympify

from empirical_bound_data import EmpiricalBoundInput


N = Symbol("n")

if len(sys.argv)!=3:
    raise Exception("output dir and exactly one benchmark file required")

OUTPUT_DIR = sys.argv[1]
FILE = sys.argv[2]
OUTFILE_NAME = os.path.join(OUTPUT_DIR, FILE)+".csv"

with open(FILE) as fp:
    input_data = EmpiricalBoundInput(**json.load(fp))

q1_func = lambdify(N,sympify(input_data.q1))
q2_func = lambdify(N,sympify(input_data.q2))
rand_gen = np.random.default_rng(input_data.seed)

population = np.full(input_data.sample_size,input_data.initial_value)

pathlib.Path(OUTFILE_NAME).parents[0].mkdir(parents=True, exist_ok=True)
with open(OUTFILE_NAME, "w") as out_fp:
    writer = csv.writer(out_fp)
    writer.writerow(("i", "p_t"))
    for i in range(input_data.max_iterations):
        if i%10 == 0:
            print(i, len(population))
        writer.writerow((i, len(population)/input_data.sample_size))
        if len(population)==0:
            exit(0)
        indicator = rand_gen.random(len(population)) < input_data.p
        step1 = q1_func(i)
        step2 = q2_func(i)
        population[indicator] += step1
        population[~indicator] += step2

        population = population[population>=0]


