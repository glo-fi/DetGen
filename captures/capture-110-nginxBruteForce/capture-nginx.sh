#!/bin/bash

DURATION="$1"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
REPEAT="$2"


[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

function generate_password {
    echo "Generating Random Password..."
    PASS=$(python generate_password.py)
    echo "Password is $PASS"
    htpasswd -b -c conf/.htpasswd admin $PASS
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

function add_delays {
    echo "Adding delays to the network..."
    DELAY1=$((RANDOM % 100 + 1))
    DELAY2=$((RANDOM % 100 + 1))

    ./container_tc.sh capture-110-nginxbruteforce_nginx_1 $DELAY1
    ./container_tc.sh capture-110-nginxbruteforce_b_forcer_1 $DELAY2
}



trap '{ echo "Interrupted."; teardown; exit 1; }' INT

for ((i=1; i<=REPEAT; i++))
do
    echo "Repeat Nr " $i
    export REPNUM=$i
    generate_password;
    bringup;
    add_delays;
    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION
    teardown;
done

