#!/bin/sh

USER="notadmin"
PASS="notpassword"

adduser $USER <<END_SCRIPT
$PASS
$PASS
Y
END_SCRIPT


usermod -aG sudo $USER
