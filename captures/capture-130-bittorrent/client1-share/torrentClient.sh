#!/bin/bash

sleep 20

FILES=torrents/*

transmission-daemon -y -p 9097 -P 31968

for f in $FILES
do
    NAME=$(basename $f)
    transmission-remote 9097 -a /torrents/$NAME
done

