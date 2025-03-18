from typing import List, Optional
from pydantic import BaseModel, Field

class BenchmarkInput(BaseModel):
    degree: int
    percentage: float
    initial: Optional[float]
    exact_n0: bool = Field(alias="exactN0")
    num_generations: int = Field(alias="numGenerations")
    min_population: int = Field(alias="minPopulation")
    max_population: int = Field(alias="maxPopulation")
    population_decrease_degree: float = Field(alias="populationDecreaseDegree")
    min_granularity: int = Field(alias="minGranularity")
    max_granularity: int = Field(alias="maxGranularity")
    granularity_increase_degree: float = Field(alias="granularityIncreaseDegree")
    seed: int
    mutation_multiplier: int = Field(alias="mutationMultiplier")
    crossover_multiplier: int = Field(alias="crossoverMultiplier")
    num_runs: int = Field(alias="numRuns")

class BenchmarkOutput(BenchmarkInput):
    times: List[float]
    exponents: List[float]
    explicit_bounds: List[Optional[float]] = Field(alias="explicitBounds")
    n0: List[Optional[float]]