#!/bin/bash

cd server

python ares.py runserver -h 0.0.0.0 -p 8080 --threaded

sleep $DURATION
