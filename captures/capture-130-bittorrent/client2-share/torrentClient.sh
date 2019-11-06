#!/bin/bash

FILES=torrents/*

transmission-daemon -y -p 9098 -P 31969

for f in $FILES
do
    NAME=$(basename $f)
    transmission-remote 9098 -a /torrents/$NAME
done

sleep $1
