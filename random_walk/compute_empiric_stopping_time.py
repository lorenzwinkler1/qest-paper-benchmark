import sys
import csv


if len(sys.argv)!=2:
    raise Exception("random-walk experiment result file required")

FILE = sys.argv[1]

sum = 0
with open(FILE, "r") as fp:
    reader = csv.DictReader(fp)

    for row in reader:
        i = row['i']
        p_t = float(row['p_t'])
        sum += p_t

print(sum-1) # reduce by 1, since i=0 is also present
