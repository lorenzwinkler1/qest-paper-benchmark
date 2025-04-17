[This repository](https://github.com/lorenzwinkler1/qest-paper-benchmark) is the artifact submited for the paper "Positive Almost-Sure Termination of Polynomial Random Walks".

While for the submission a docker container is included, all the commands can be run outside of the docker container, and work locally, when all dependencies are installed (have a look at the Dockerfile for that - for python I suggest using `venv`).

The tool itself is also available [in the termination branch of polar](https://github.com/probing-lab/polar/tree/termination), where you can find an installation guide in the Readme.md file.

- [Content](#content)
- [Loading the docker image](#loading-the-docker-image)
  - [Obtain a shell in the container](#obtain-a-shell-in-the-container)
- [Running the tool](#running-the-tool)
  - [Command-Line flags](#command-line-flags)
- [Reproducing our results](#reproducing-our-results)
  - [Genetic Algorithm](#genetic-algorithm)
    - [Setting up the Gurobi license (Optional, but recommended for reproduction)](#setting-up-the-gurobi-license-optional-but-recommended-for-reproduction)
      - [Checking, if the license works](#checking-if-the-license-works)
    - [Generate the benchmarks](#generate-the-benchmarks)
    - [Testing the mounts (Smoke test)](#testing-the-mounts-smoke-test)
    - [Running all genetic-algorithm jobs (Duration: ~700 core-hours)](#running-all-genetic-algorithm-jobs-duration-700-core-hours)
      - [Running less extensive experiments (Duration: ~90 core-hours / ~20 core-hours)](#running-less-extensive-experiments-duration-90-core-hours--20-core-hours)
      - [Failing jobs](#failing-jobs)
    - [Collecting the results](#collecting-the-results)
    - [Creating the plots](#creating-the-plots)
  - [Empirical bounds (Duration: ~2 core-hours)](#empirical-bounds-duration-2-core-hours)
    - [Generating the plots](#generating-the-plots)
- [Rebuilding the docker image](#rebuilding-the-docker-image)


# Content
- `genetic_algorithm/` A folder containing the python and R source code for running the experiments involving polar (also the actual tool, `polar`, hence our source code is contained as a submodule)
- `random_walk/` A folder containing the python and R source code for running the random walk experiments
- `artifactcontainer.tar` The saved docker image (only container in artifact, not in git repository)
- `README.md` This file, it contains information how to run the submission, and how to reproduce our content from the paper
- `License`
- `Dockerfile` A file to rebuild the image `artifactcontainer.tar`
- `run_all_jobs.sh` A file to invoke all experiments using `polar`
- `run_empirical_bounds.sh` A file to invoke all random-walk experiments
- `/examples/` A folder containing examples on which the tool can be run. If you want to test your own polynomial random walk, place it here.

# Loading the docker image
The image can be loaded using 
```
docker image load -i artifactcontainer.tar
```

The image has the tag `polynomial-random-walks:latest`

## Obtain a shell in the container
Obtain a shell inside the docker container. Alternatively, all subsequent commands could be run using `docker run [all the mounts] [command]`, but then the mounts have to be specified each time.

create the following local directories:
- `./gurobi_license`
- `./generated_benchmarks`
- `./output`

Run the following commands, replacing the placeholders with the absolute folder paths
```
docker run --mount type=bind,src=[absolute path to gurobi_license folder],dst=/opt/gurobi --mount type=bind,src=[absolute path to generated_benchmarks folder],target=/usr/src/app/genetic_algorithm/generated_benchmarks --mount type=bind,src=[absolute path to output folder],target=/usr/src/app/output --mount type=bind,src=[absolute path to local examples folder],dst=/usr/src/app/examples -i -t polynomial-random-walks:latest bash
```

# Running the tool

The tool leverages a linear solver. This can be passed via the `--solver` flag. Any value, which is accepted by [OR-tools](https://developers.google.com/optimization), can be passed here, but we require great numerical stability, hence some solvers do not work as desired. The default solver is `CLP`, as it can be used without installation, and performs quite stable. The faster solver `GUROBI` was used for the experimental results in our paper, and you can find information to install it below.

The tool can be invoked with `CLP` using:

```
python genetic_algorithm/polar/polar.py examples/example_1_paper.prob --termination_variance
```

Or when using gurobi:
```
python genetic_algorithm/polar/polar.py genetic_algorithm/polar/benchmarks/polynomial_random_walks/example_1_paper.prob --termination_variance --solver GUROBI
```

When you want to compute an `explicit` bound, you need to additionally pass the `--exact` flag:
```
python genetic_algorithm/polar/polar.py examples/example_1_paper.prob --termination_variance --exact
```
python genetic_algorithm/polar/polar.py examples/example_1_paper.prob --termination_variance
Notice the mount of the `example`-folder: Here you can add polynomial random walks, or have a look at some of our example.

## Command-Line flags

The following flags can be used for our termination tool:

- `--termination_variance` Required to start the termination-action in polar
- `--exact` Polar tries to find an explicit bound
- `--solver` Set the linear solver
- `--seed` For reproducability

Additionally, the genetic algorithm can be controlled.
Most importantly, there are the flags
- `--num_generations` Number of generations (default 20).
- `--mutation_rate` Number of mutations (default 5, i.e. 5 times the population size of new mutated entries per iteration)
- `--crossover_rate` Number of crossovers (default 2, i.e. 2 times the popoulation size of new children with two random parents each)
- `--min_pop` (default 20), `--max_pop` (100) and `--degree_population_shrink` (1): The population size, decreasing from `max_pop` to `min_pop` over the number of generations, as a function of degree `degree_population_shrink`.
- `--min_gran` (default 40), `--max_gran` (200) and `--degree_granularity_growth` (1): The population size, increasing from `min_gran` to `max_gran` over the number of generations, as a function of degree `degree_granularity_growth`.

# Reproducing our results
Our results can be reproduced, however we used the commercial solver `GUROBI` in our paper, for which a license must be obtained.

If unable to obtain the license, you can still try to obtain the same results, through using the solver `CLP`. You just need an empty `./gurobi_license/`-folder, for the mount to work, and replace all occurances of `GUROBI` with `CLP` in the commands.


## Genetic Algorithm
This section provides instructions how to reproduce the results of Tables 1 and 2, and Figure 9 in the appendix.

### Setting up the Gurobi license (Optional, but recommended for reproduction)

A `WLS Academic`-License will be required to use Gurobi. During license setup, a connection via an *academic network* is required.
Later, a network connection (not necessarily academic) is required when running the tool (due to licensing reasons).

- Create an account on gurobi.com with your academic E-Mail Adress
  - Make sure to select ACADEMIC for your account type
- Via https://portal.gurobi.com/iam/licenses/request request a **WLS academic license**. 
- On https://license.gurobi.com/manager/licenses/ you should see your license. You can click on Download, then enter an application name. Then click and Download again in the popup, to obtain a license file. 
- You get a license file containing the following three lines:
```
WLSACCESSID=<access-id>
WLSSECRET=<secret>
LICENSEID=<license-id>
```
- copy this license file into a folder `./gurobi_license/` on the host machine
- this ensures, that the license file is passed to the container, due to the mount.

#### Checking, if the license works

The following command has to work. Be advised, that when using `GUROBI`, network connection might be required.
```
python genetic_algorithm/polar/polar.py genetic_algorithm/polar/benchmarks/polynomial_random_walks/example_1_paper.prob --termination_variance --solver GUROBI
```

### Generate the benchmarks

```
python genetic_algorithm/generate_benchmarks.py
```

### Testing the mounts (Smoke test)
Next, test if the results are properly saved in the `output` folder
```
python genetic_algorithm/benchmark_variance_based.py [GUROBI|CLP] output genetic_algorithm/generated_benchmarks/generated_2_3_0_exact.json
```

**Check if an output file was generated in the `./output/genetic_algorithm/generated_benchmarks/`-folder.** If not, re-check the mounts.

### Running all genetic-algorithm jobs (Duration: ~700 core-hours)

_You find under `./results_paper/output_all.csv` already our output file. If you just want to run the evaluation copy it into the `output` folder and proceed to [creating the plots](#creating-the-plots)_

Schedule all files. The first argument is the solver to use, and the second argument is the number of simultaneous jobs
```
./run_all_jobs.sh [GUROBI|CLP] [number of jobs]
```

The prints all Ids of scheduled jobs. Due to a limit in the number of open file descriptors, *this can appear to have stalled*, but this probably is not the case. After a few minutes, you should see the first result files in the output directory.

#### Running less extensive experiments (Duration: ~90 core-hours / ~20 core-hours)
To reproduce the main result of the the paper - tables 1 and 2, you can also just run one instance of the most cost-intensive solver, or an even less cost intensive solver.
While the results will not be exactly the same as in the table, they will produce somewhat similar results.
_The_

Schedule all files. The first argument is the solver to use, and the second argument is the number of simultaneous jobs
```
./run_jobs_less.sh [GUROBI|CLP] [number of jobs]
```
or for the even less cost intensive solver:
```
./run_jobs_minimum.sh [GUROBI|CLP] [number of jobs]
```

The prints all Ids of scheduled jobs. Due to a limit in the number of open file descriptors, *this can appear to have stalled*, but this probably is not the case. After a few minutes, you should see the first result files in the output directory.

#### Failing jobs

There are two reason for jobs to usually fail. The first involves the programs, which involve the terms n**(1/4) and n**(1/2). We can not compute closed form expressions for their summation, hence the exact approximation failes. Those jobs correspond to the files "generated\_0\_\*\_exact.json" and "generated\_1\_\*\_exact.json" and they will *always* fail.

A job can also fail, when numerical issues arise in the bound computation. That is, the validation of the inductive bound fails - This is not supposed to happen, but especially when using a different solver than GUROBI, it can be the case. In our test run with `GUROBI`, this happened in $1/900$ run (`generated_16_7_4_asymp.json`). If this issue appear in practice, rerunning the script (with a different seed, if it was set) should fix the issue.

### Collecting the results
There is a helper script, to collect all json-result files and merge them into one csv file:

```
find output/genetic_algorithm/ -name "*.json" | python genetic_algorithm/gather_benchmark_data.py > output/output_all.csv
```
This places the output file in `./output/output_all.csv`

### Creating the plots
The following command creates the plots, and simultaneously outputs the smallest found exponents and explicit bounds
```
Rscript genetic_algorithm/plot_scripts/running_times_quality.r
```
The plots are created in the `./output/` directory

## Empirical bounds (Duration: ~2 core-hours)
These experiments perform a polynomial random walk with a specific sample size, to approximate the probability $P(T\geq n)$, as displayed in various figures in the paper.

Here, just the `output` mount is required. The inputs are already contained in the docker image, and can be seen in the accompanying folders.

```
./run_empirical_bounds.sh [number of jobs]
```
The output files measure the probability $P(T\geq n)$, but loking at them manually isn't very helpful. Therefore there are again two scripts for plotting.

**Due to high memory consumption, this can fail in the docker container when a high number of parallel jobs is selected.** If this happens, maybe increase the memory of the container, or just run one job at once (`./run_empirical_bounds.sh 1`)

### Generating the plots

There are two scripts used for creating plots:

```
Rscript random_walk/plot_scripts/plot_random_walk_bound.r
```

and 

```
Rscript random_walk/plot_scripts/random_walk_explicit_bounds.r
```

For both scripts, the plots are again placed in `./output/`


# Rebuilding the docker image 

Clone this repository (including submodules)
```
git clone --recurse-submodules https://github.com/lorenzwinkler1/qest-paper-benchmark.git
```

Build the docker image (can take 20-30 minutes, to install the dependencies)
```
docker build . -t polynomial-random-walks:latest
```

Save the image to a tar file

```
docker save polynomial-random-walks:latest -o artifactcontainer.tar
```
