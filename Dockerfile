FROM python:3.12.10-bookworm

WORKDIR /usr/src/app

RUN mkdir gurobi_install
WORKDIR gurobi_install
RUN wget https://packages.gurobi.com/11.0/gurobi11.0.3_linux64.tar.gz
RUN tar xvfz gurobi11.0.3_linux64.tar.gz

# Setup for tsp     /home/lwinkler/gurobi_install
RUN apt-get update
RUN apt-get install task-spooler

WORKDIR /usr/src/app

ENV GUROBI_HOME=/usr/src/app/gurobi_install/gurobi1103/linux64
ENV PATH="/usr/src/app/gurobi_install/gurobi1103/linux64/bin:$PATH"
ENV LD_LIBRARY_PATH="/usr/src/app/gurobi_install/gurobi1103/linux64/lib"


COPY genetic_algorithm/polar/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir pydantic

# Install R
RUN apt-get install -y r-base r-base-dev
# Install libraries

RUN R -e "install.packages('ggplot2',dependencies=TRUE, repos='http://cran.rstudio.com/')" &&\
     R -e "if (!'ggplot2' %in% rownames(installed.packages())) stop('ggplot2 not installed')"
RUN R -e "install.packages('MASS',dependencies=TRUE, repos='http://cran.rstudio.com/')"&&\
     R -e "if (!'MASS' %in% rownames(installed.packages())) stop('MASS not installed')"
RUN R -e "install.packages('cowplot',dependencies=TRUE, repos='http://cran.rstudio.com/')" &&\
     R -e "if (!'cowplot' %in% rownames(installed.packages())) stop('cowplot not installed')"
RUN R -e "install.packages('dplyr',dependencies=TRUE, repos='http://cran.rstudio.com/')" &&\
     R -e "if (!'dplyr' %in% rownames(installed.packages())) stop('dplyr not installed')"
RUN R -e "install.packages('scales',dependencies=TRUE, repos='http://cran.rstudio.com/')" &&\
     R -e "if (!'scales' %in% rownames(installed.packages())) stop('scales not installed')"

COPY genetic_algorithm/plot_scripts/running_times_quality.r genetic_algorithm/plot_scripts/running_times_quality.r

COPY genetic_algorithm/polar genetic_algorithm/polar
COPY genetic_algorithm/*.py genetic_algorithm/
COPY run_all_jobs.sh run_all_jobs.sh
RUN chmod +x run_all_jobs.sh
COPY random_walk/inputs/ random_walk/inputs/
COPY random_walk/*.py random_walk/
COPY run_empirical_bounds.sh run_empirical_bounds.sh
RUN chmod +x run_empirical_bounds.sh

RUN mkdir genetic_algorithm/generated_benchmarks

COPY random_walk/*.py random_walk/

CMD [ "", "./your-daemon-or-script.py" ]
