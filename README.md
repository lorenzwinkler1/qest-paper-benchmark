This repo serves as a benchmark suite for the variance-based-termination of polar.


# Genetic algorithm
First generate the benchmark data:
```
cd genetic_algorithm
mkdir generated_benchmarks
python generate_benchmarks.py
```


To call all benchmarks, one might use the task spooler:

```
find generated_benchmarks/ -name "*.json" | xargs -I{} tsp python benchmark_variance_based.py output {}
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

