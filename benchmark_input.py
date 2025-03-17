from typing import Optional
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

class BenchmarkOutput(BenchmarkInput):
    time: float
    exponent: float
    explicit_bound: Optional[float] = Field(alias="explicit_bound")
    n0: Optional[float]