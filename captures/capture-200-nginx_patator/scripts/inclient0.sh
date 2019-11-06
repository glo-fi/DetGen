#!/bin/bash



./patator.py http_fuzz url=172.16.238.50/FILE0 0=/usr/share/wordlists/directory-list-2.3-medium.txt -x ignore:code=404 -x ignore,retry:code=500

