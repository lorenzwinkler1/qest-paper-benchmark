from pydantic import BaseModel


class EmpiricalBoundInput(BaseModel):
    q1: str
    q2: str
    p: float
    sample_size: int
    initial_value: float
    max_iterations: int
    seed: int