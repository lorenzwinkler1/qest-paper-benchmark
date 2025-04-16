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

# Setting up the Gurobi license

A `WLS Academic`-License will be required to use Gurobi. During license setup, a connection via an *academic network* is required.

- Create an account on gurobi.com with your academic E-Mail Adress
- Via https://portal.gurobi.com/iam/licenses/request request a WLS academic license. 
- On https://license.gurobi.com/manager/licenses/ you should see your license. You can click on Download, to obtain an api-key.
- You get a license file containing the following three lines:
```
WLSACCESSID=<access-id>
WLSSECRET=<secret>
LICENSEID=<license-id>
```
- copy this license file to your working directory
- This file can be directly used as an environment variable file. Just make sure, that whenever running `docker run`, to include the following argument: `--env-file gurobi.lic` 

```
docker run qestcontainer:latest 
```


# Reproducing our results

## Generate the benchmarks
Run the following command, to create all the benchmarks. Make sure, that the folders `./generated_benchmarks/` and `./output/` exist in your working directory. The benchmarks will be saved as json files in `./generated_benchmarks/`.

```
docker run --mount type=bind,src=./generated_benchmarks/,target=/usr/src/app/genetic_algorithm/generated_benchmarks --mount type=bind,src=./output/,target=/usr/src/app/output  -i -t qestcontainer:latest python genetic_algorithm/generate_benchmarks.py
```

## Testing the mounts
Next, test if the results are properly saved in the `output` folder
```
docker run --mount type=bind,src=./generated_benchmarks/,target=/usr/src/app/genetic_algorithm/generated_benchmarks --mount type=bind,src=./output/,target=/usr/src/app/output  -i -t qestcontainer:latest python genetic_algorithm/benchmark_variance_based.py CLP output genetic_algorithm/generated_benchmarks/generated_2_3_4_exact.json
```

## Running all jobs

Then schedule all files. The first argument is the solver to use, and the second argument is the number of simultaneous jobs
```
docker run --mount type=bind,src=./generated_benchmarks/,target=/usr/src/app/genetic_algorithm/generated_benchmarks --mount type=bind,src=./output/,target=/usr/src/app/output -i -t qestcontainer:latest ./run_all_jobs.sh [GUROBI|CLP] [number of jobs]
```

The prints all Ids of scheduled jobs. Due to a limit in the number of open file descriptors, *this can appear to have stalled*, but this probably is not the case. After a few minutes, you should see the first result files in the output directory.

### Failing jobs

There are two reason for jobs to usually fail. The first involves the programs, which involve the terms n**(1/4) and n**(1/2). We can not compute closed form expressions for their summation, hence the exact approximation failes. Those jobs correspond to the files "generated\_0\_\*\_exact.json" and "generated\_1\_\*\_exact.json" and they will *always* fail.

A job can also fail, when numerical issues arise in the bound computation. That is, the validation of the inductive bound fails - This is not supposed to happen, but especially when using a different solver than GUROBI, it can be the case. In our test run, this did not happen.

## Collecting the results
There is a helper script, to collect all json-result files and merge them into one csv file:

```
docker run --mount type=bind,src=./generated_benchmarks/,target=/usr/src/app/genetic_algorithm/generated_benchmarks --mount type=bind,src=./output/,target=/usr/src/app/output -i -t qestcontainer:latest find output/genetic_algorithm/ -name "*.json" | python genetic_algorithm/gather_benchmark_data.py > output/output_all.csv
```

## Creating the plots
The following command creates the plots, and simultaneously outputs the smallest found exponents and explicit bounds
```
docker run --mount type=bind,src=./generated_benchmarks/,target=/usr/src/app/genetic_algorithm/generated_benchmarks --mount type=bind,src=./output/,target=/usr/src/app/output -i -t qestcontainer:latest Rscript genetic_algorithm/plot_scripts/running_times_quality.r
```

# Empirical bounds

```
cd random_walk
```

```
find inputs/ -name "*.json" | xargs -I{} tsp python empirical_bound_p_t.py output {}
```

