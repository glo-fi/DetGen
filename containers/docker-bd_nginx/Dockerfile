FROM nginx:latest
 
RUN apt-get update && apt-get install -y curl wget python2.7 python-pip

COPY agent agent

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt
