#!/bin/bash


DURATION="$1"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
REPEAT="$2"


[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

function add_delays {
    echo "Adding delays to the network..."
    DELAY1=$((RANDOM % 400 + 101))
    DELAY2=$((RANDOM % 400 + 101))

    ./container_tc.sh capture-250-ntp_ntpd_server_1 $DELAY1
    ./container_tc.sh capture-250-ntp_ntpd_client_1 $DELAY2
}


function bringup {
    echo "Start the containerised applications..."
    export DATADIR="$PWD/data"
    docker-compose --no-ansi --log-level ERROR up -d
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
    echo "Repeat Nr " $i
    export REPNUM=$i
    bringup;
    add_delays;
    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION
    teardown;
done
