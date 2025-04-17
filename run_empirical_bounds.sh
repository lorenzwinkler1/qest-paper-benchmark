#!/bin/bash

echo "Scheduling jobs with tsp. Num simultaneous jobs: $1"

tsp -S $1

find random_walk/inputs/ -name "*.json" | xargs -I{} tsp python random_walk/empirical_bound_p_t.py output {}

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

    sleep 20
done

echo "All $finished jobs finished!"
