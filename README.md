## Setup
(Make sure you have Docker installed.)
```shell
docker build -t some/tag .
```

## Getting Started
0. Enter your docker container
```shell
docker run --rm -it some/tag
```

1. Create mutatants of a certain .c file.
Result mutants are stored under `$ROOT/results/mutants/`.
```shell
make mutate input=/path/to/source.c
```

2. Symbolically execute the original file and the mutants created in the previous step.
Results are stored in `$ROOT/results/summary.csv`.
```shell
make sym_exec
```

3. Compare the hashes to get the results.
Results are stored (overwritten) in `$ROOT/results/summary.csv`.
```shell
make compare
```