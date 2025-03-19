import csv
import sys
import json
from typing import List

from benchmark_input import BenchmarkOutput


outputs: List[BenchmarkOutput] = []
for file_path in sys.stdin:
    file_path = file_path.strip()
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            output = BenchmarkOutput(**json.load(f))
            outputs.append(output)
    except Exception as e:
        raise Exception(f"Error reading {file_path}: {e}", file=sys.stderr)


writer = csv.writer(sys.stdout)
writer.writerow(BenchmarkOutput.csv_header())
for output in outputs:
    writer.writerows(output.csv_rows())