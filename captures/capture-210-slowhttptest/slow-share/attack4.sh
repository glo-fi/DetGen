#!/bin/bash

slowhttptest -c 1000 -X -i 10 -r 200 -u https://172.16.238.15 -x 24 -p 3
