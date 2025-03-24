# This file is used to generate benchmarks file, which later can be run (in a distributed way when using tsp)

import os
from benchmark_input import BenchmarkInput


SEED = 0
OUTPUT_DIR = "generated_benchmarks"

# a random walk is described through its two polynomials and the probability p, as well as the initial expression
# the same could be achieved through calling polar directly - we use the benchmarking-wrapper
# to better collect the results
RANDOM_WALKS = [# at first the five from subfigure a)
                (0,"n**(1/4)",0.5,"-n**(1/4)", 100),
                (1,"n**(1/2)",0.5,"-n**(1/2)", 100),
                (2,"n",0.5,"-n", 100),
                (3,"n**2",0.5,"-n**2", 100),
                (4,"n**5",0.5,"-n**5", 100),

                # the missing ones from different initial values
                (5,"n",0.5,"-n", 10),
                (6,"n",0.5,"-n", 1000),
                (7,"n",0.5,"-n", 10000),

                # different drift
                (8,"n**2+2*n+20",0.5,"-n**2+2*n+20",1000),
                (9,"n**2+20",0.5,"-n**2+20",1000),
                (10,"n**2+n",0.5,"-n**2+n",1000),

                # slope-change
                (11,"n**3+1000000*n",0.5,"-n**3-1000000*n", 100000000),
                (12,"1000000*n",0.5,"-1000000*n", 100000000),
                (13,"n**3",0.5,"-n**3", 100000000),

                # different values of p - all have the same variance, namely 2*n**6
                (14,"n**3/0.5", 0.5, "n**3/0.5", 100000000),
                (15,"n**3/0.1", 0.1, "-n**3/0.9)", 100000000),
                (16,"n**3/0.9", 0.9, "-n**3/0.1", 100000000),
                (17,"n**3/0.01", 0.01, "-n**3/0.99", 100000000),
                (18,"n**3/0.99", 0.99, "-n**3/0.01", 100000000),
                (19,"n**3/0.001", 0.001, "-n**3/0.999", 100000000),
                (20,"n**3/0.999", 0.999, "-n**3/0.001", 100000000),
                (21,"n**3/0.0001", 0.0001, "-n**3/0.9999", 100000000),
                (22,"n**3/0.9999", 0.9999, "-n**3/0.0001", 100000000),
                ]

NUM_RUNS = 5

# (num_generations, min_population, max_population, population_decrease_degree, min_granularity, max_granularity, granularity_increase_degree, mutation_multiplier, crossover_multiplier)
GENETIC_ALGORITHM_CONFIGS = [
    (100, 20, 20, 1, 50, 50, 1, 5, 2),
    (100, 20, 20, 1, 50, 400, 1, 5, 2),
    (100, 20, 20, 1, 400, 400, 1, 5, 2),
    (100, 20, 100, 1, 50, 50, 1, 5, 2),
    (100, 20, 100, 1, 50, 400, 1, 5, 2),
    (100, 20, 100, 1, 400, 400, 1, 5, 2),
    (100, 100, 100, 1, 50, 50, 1, 5, 2),
    (100, 100, 100, 1, 50, 400, 1, 5, 2),
    (100, 100, 100, 1, 400, 400, 1, 5, 2),
]


curr_seed = SEED
for (j,(num_generations, min_population, max_population, population_decrease_degree, min_granularity, max_granularity, granularity_increase_degree, mutation_multiplier, crossover_multiplier)) in enumerate(GENETIC_ALGORITHM_CONFIGS):
    for id, q1, p, q2, initial in RANDOM_WALKS:
        for i in range(NUM_RUNS):
            curr_seed+=2
            input = BenchmarkInput(
              id=id, q1 = q2, q2=q2, percentage=p, initial = initial, exactN0 = False, numGenerations=num_generations,
              minPopulation=min_population, maxPopulation=max_population, populationDecreaseDegree=population_decrease_degree,
              minGranularity=min_granularity, maxGranularity=max_granularity, granularityIncreaseDegree=granularity_increase_degree,
              seed = curr_seed, mutationMultiplier=mutation_multiplier,crossoverMultiplier=crossover_multiplier, numRuns=1
            )
            filename = f"generated_{id}_{j}_{i}_asymp.json"
            with open(os.path.join(OUTPUT_DIR, filename), "w") as out_fp:
                out_fp.write(input.model_dump_json(by_alias=True))

            if initial is not None:
                input = BenchmarkInput(
                id=id, q1 = q2, q2=q2, percentage=p, initial = initial, exactN0 = True, numGenerations=num_generations,
                minPopulation=min_population, maxPopulation=max_population, populationDecreaseDegree=population_decrease_degree,
                minGranularity=min_granularity, maxGranularity=max_granularity, granularityIncreaseDegree=granularity_increase_degree,
                seed = curr_seed+1, mutationMultiplier=mutation_multiplier,crossoverMultiplier=crossover_multiplier, numRuns=1
                )
                filename = f"generated_{id}_{j}_{i}_exact.json"
                with open(os.path.join(OUTPUT_DIR, filename), "w") as out_fp:
                    out_fp.write(input.model_dump_json(by_alias=True))

