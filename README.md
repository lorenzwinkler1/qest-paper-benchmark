This repo serves as a benchmark suite for the variance-based-termination of polar.


# Genetic algorithm
To call all benchmarks, one might use the task spooler:

```
cd genetic_algorithm

find benchmarks/ -name "*.json" | xargs -I{} tsp python benchmark_variance_based.py output {}
```

To create a csv file (e.g. for plotting):

```
find output/benchmarks/ -name "*.json" | python gather_benchmark_data.py > output.csv
```

# Empirical bounds

a similar system is used.
```
cd random_walk
```

```
find inputs/ -name "*.json" | xargs -I{} tsp python empirical_bound_p_t.py output {}
```

