#!/bin/bash

FILES=torrents/*

transmission-daemon -y -p 9099 -P 31970

for f in $FILES
do
    NAME=$(basename $f)
    transmission-remote 9099 -a /torrents/$NAME
done

sleep $1
