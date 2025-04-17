#!/bin/bash

echo "Scheduling jobs with tsp. Num simultaneous jobs: $2"

tsp -S $2

find genetic_algorithm/generated_benchmarks/ -name "*_*_9_0_*.json" | xargs -I{} tsp python genetic_algorithm/benchmark_variance_based.py $1 output {}

echo "Waiting for all jobs to finish..."



while true; do
    queued=$(tsp | grep -c queued)
    running=$(tsp | grep -c running)
    finished=$(tsp | grep -c finished)

    total=$((queued + running + finished))
    
    echo "Status: $queued queued | $running running | $finished finished"

    # Break loop when no queued or running jobs left
    if [[ $queued -eq 0 && $running -eq 0 ]]; then
        break
    fi

    sleep 10
done

echo "All $finished jobs finished!"

# Optional: keep container alive (comment out to let it exit)
tail -f /dev/null
