import sys
import os

from benchmark_input import BenchmarkInput, BenchmarkOutput

# Get the directory of the benchmark script
script_dir = os.path.dirname(os.path.abspath(__file__))

# Add my_tool to the Python path
my_tool_path = os.path.join(script_dir, "polar")
sys.path.insert(0, my_tool_path)

from time import time_ns
import numpy as np
import csv
import json
import pathlib
from termination.variance_based.exponent_approximation.genetic_algorithm import estimate_bound_exponent_inductive_bound_genetic
from sympy import Symbol, sympify
from termination.variance_based.exponent_approximation.genetic_algorithm_config import MinMaxQuadraticAlgorithmConfig, GeneticAlgorithmConfig


c_0 = 10e-7
delta_1 = 10e-5
delta_prime = 10e-5
NUM_REPETITIONS = 10
N = Symbol("n", integer=True, positive=True)


if len(sys.argv)!=3:
    raise Exception("output dir and exactly one benchmark file required")

OUTPUT_DIR = sys.argv[1]
FILE = sys.argv[2]
OUTFILE_NAME = os.path.join(OUTPUT_DIR, FILE)

with open(FILE) as fp:
    input_data = BenchmarkInput(**json.load(fp))


def perform_experiment(q1, percentage, q2, geneticAlgorithmConfig: GeneticAlgorithmConfig, initial, exact_n0, seed):
    print(q1)
    print(q2)
    time_start = time_ns()
    
    witness = estimate_bound_exponent_inductive_bound_genetic(percentage, geneticAlgorithmConfig, q1, q2, initial,
                                                              exact_n0 = exact_n0, seed=seed)

    time_total = (time_ns() - time_start)/10**6

    return time_total, witness

times = []
exponents = []
n0s = []
explicit_bounds = []
rng = np.random.default_rng(input_data.seed)
for i in range(input_data.num_runs):
    time, witness = perform_experiment(sympify(input_data.q1, locals={'n': N}),
                                       input_data.percentage,
                                       sympify(input_data.q2, locals={'n': N}),
                            MinMaxQuadraticAlgorithmConfig(input_data.num_generations, input_data.min_granularity, input_data.max_granularity, 
                                                            input_data.min_population, input_data.max_population,
                                                            input_data.mutation_multiplier, input_data.crossover_multiplier,
                                                            input_data.population_decrease_degree,input_data.granularity_increase_degree), input_data.initial, input_data.exact_n0, int(rng.random()*1e16))
    times.append(time)
    exponents.append(witness.m)
    explicit_bounds.append(None if not witness.terminates() or not input_data.exact_n0 else witness.get_exp_stopping_time_bound(1))
    n0s.append(None if not witness.terminates() or not input_data.exact_n0 else witness.n0)

output = BenchmarkOutput(**input_data.model_dump(by_alias=True), times=times, exponents = exponents, explicitBounds=explicit_bounds,
                         n0s=n0s)

pathlib.Path(OUTFILE_NAME).parents[0].mkdir(parents=True, exist_ok=True)
with open(OUTFILE_NAME, "w") as out_fp:
    out_fp.write(output.model_dump_json(by_alias=True))
