FROM python:3.12.10-bookworm

WORKDIR /usr/src/app

COPY genetic_algorithm/polar/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./your-daemon-or-script.py" ]
