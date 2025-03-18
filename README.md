This repo serves as a benchmark suite for the variance-based-termination of polar.

To call all benchmarks, one might use the task spooler:

```
find benchmarks/ -name "*.json" | xargs -I{} tsp python benchmark_variance_based.py output {}
```

To create a csv file (e.g. for plotting):

```
find output/benchmarks/ -name "*.json" | python gather_benchmark_data.py > output.csv
```