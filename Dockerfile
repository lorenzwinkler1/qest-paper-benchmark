FROM python:3.12.10-bookworm

WORKDIR /usr/src/app

RUN mkdir gurobi_install
WORKDIR gurobi_install
RUN wget https://packages.gurobi.com/11.0/gurobi11.0.3_linux64.tar.gz
RUN tar xvfz gurobi11.0.3_linux64.tar.gz

# Setup for tsp
RUN apt-get update
RUN apt-get install task-spooler

WORKDIR /usr/src/app

ENV GUROBI_HOME=/usr/src/app/gurobi_install/gurobi1103/linux64
ENV PATH="/usr/src/app/gurobi_install/gurobi1103/linux64/bin:$PATH"
ENV LD_LIBRARY_PATH="/usr/src/app/gurobi_install/gurobi1103/linux64/lib"


COPY genetic_algorithm/polar/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir pydantic

COPY genetic_algorithm/polar genetic_algorithm/polar
COPY genetic_algorithm/*.py genetic_algorithm/
COPY run_all_jobs.sh run_all_jobs.sh
RUN chmod +x run_all_jobs.sh

RUN mkdir genetic_algorithm/generated_benchmarks

COPY random_walk/*.py random_walk/

CMD [ "", "./your-daemon-or-script.py" ]
