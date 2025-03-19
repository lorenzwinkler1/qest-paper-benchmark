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
    n0s: List[Optional[float]]

    @classmethod
    def csv_header(cls):
        return ('degree', 'percentage', 'initial', 'exact_n0', 'num_generations', 'min_population', 'max_population', 
                'population_decrease_degree', 'min_granularity', 'max_granularity', 'granularity_increase_degree',
                'seed', 'mutation_multiplier', 'crossover_multiplier', 'time', 'exponent', 'explicit_bound', 'n0', 'i')
    
    def csv_rows(self):
        for i,(time, exponent, explicit_bound, n0) in enumerate(zip(self.times, self.exponents, self.explicit_bounds, self.n0s)):
            yield (self.degree, self.percentage, self.initial, self.exact_n0, self.num_generations, self.min_population, self.max_population,
                    self.population_decrease_degree, self.min_granularity, self.max_granularity, self.granularity_increase_degree, self.seed, self.mutation_multiplier,
                    self.crossover_multiplier, time, exponent, explicit_bound, n0, i)