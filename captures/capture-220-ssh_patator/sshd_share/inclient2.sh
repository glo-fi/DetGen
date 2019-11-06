#!/bin/sh

cd /usr/share/scripts

USER=$1
PASS=$(shuf -n 1 unix_passwords.txt)


adduser $USER <<END_SCRIPT
$PASS
$PASS
Y
END_SCRIPT


usermod -aG sudo $USER
