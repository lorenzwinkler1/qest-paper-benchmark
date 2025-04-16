This repository is the artifact submited for the paper "Positive Almost-Sure Termination of Polynomial Random Walks".



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

## Testing the mounts
```
docker run --mount type=bind,src=./output/,target=/usr/src/app/output  -i -t qestcontainer:latest python genetic_algorithm/benchmark_variance_based.py CLP output genetic_algorithm/generated_benchmarks/generated_0_0_0_asymp.json
```

## Running all jobs
First, set the desired numbers of simulatneous jobs:
```
docker run qestcontainer:latest tsp -S [number of jobs]
```

Then schedule all files
```
docker run --mount type=bind,src=./output/,target=/usr/src/app/output qestcontainer:latest run_all_jobs.sh
```

# Empirical bounds

a similar system is used.
```
cd random_walk
```

```
find inputs/ -name "*.json" | xargs -I{} tsp python empirical_bound_p_t.py output {}
```

