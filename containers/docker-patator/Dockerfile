FROM ubuntu:latest


USER root

RUN apt-get update && apt-get install -y default-jre \
    libldap-2.4-2 python python-crypto \ 
    python-dns python-impacket python-ipy \
    python-mysqldb python-paramiko python-psycopg2 \ 
    python-pyasn1 python-pycurl python-pysnmp4 unzip \
    freerdp2-x11 libsqlite3-dev libsqlcipher-dev ike-scan \ 
    curl python-pip python-dev build-essential

RUN  apt-get install -y wget

RUN wget https://raw.githubusercontent.com/lanjelot/patator/master/patator.py
RUN chmod +x patator.py

RUN pip install --upgrade pip
RUN pip install pysqlcipher ajpy
RUN python -m pip install cx_Oracle --upgrade

CMD tail -f /dev/null
