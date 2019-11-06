#!/bin/bash

export DURATION="$1"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
REPEAT="$2"
COMMAND="$3"

[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

function bringup {
    echo "Start the containerised applications..."
    export DATADIR="$PWD/data"
    docker-compose --no-ansi --log-level ERROR up -d --force-recreate
}

function teardown {
    echo "Take down the containerised applications and networks..."
    # NB: this removes everything so it is hard to debug from this script
    # TODO: add a `--debug` option instead use `docker-compose stop`.
    docker-compose --no-ansi --log-level ERROR down --remove-orphans -v
    echo "Done."
}

trap '{ echo "Interrupted."; teardown; exit 1; }' INT

for ((i=1; i<=REPEAT; i++))
do
    ################
    echo "Repeat Nr " $i
    export REPNUM=$i
    bringup;
    echo "Capturing data now for $DURATION seconds...."
#    docker exec -ti cnc /bin/sh -c "python /usr/share/scripts/command.py $Password $COMMAND"
    sleep $DURATION
    teardown;
done

