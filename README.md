This repo serves as a benchmark suite for the variance-based-termination of polar.

To call all benchmarks, one might use the task spooler:

```
find benchmarks/ | xargs -I{} tsp python benchmark_variance_based.py output {}
```