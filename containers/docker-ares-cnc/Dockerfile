FROM python:2

COPY server /server

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

RUN cd server && ./ares.py initdb


