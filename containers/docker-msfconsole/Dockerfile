FROM ubuntu:18.04

# PosgreSQL configuration
COPY ./scripts/db.sql /tmp/
COPY ./config/database.yml /usr/share/metasploit-framework/config/

# Installation
RUN apt-get update \
  && apt-get install -y \
    curl postgresql postgresql-contrib postgresql-client \
    apt-transport-https gnupg2\
    nmap nasm\
  && /etc/init.d/postgresql start && su postgres -c "psql -f /tmp/db.sql" \
  && curl -fsSL https://apt.metasploit.com/metasploit-framework.gpg.key | apt-key add - \
  && echo "deb https://apt.metasploit.com/ jessie main" >> /etc/apt/sources.list \
  && apt-get update -qq \
  && apt-get install -y metasploit-framework \
  && apt-get remove -y apt-transport-https postgresql-contrib postgresql-client \




