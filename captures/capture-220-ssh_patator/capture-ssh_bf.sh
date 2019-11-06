#!/bin/bash

SCENARIO="$1"
DURATION="$2"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
REPEAT="$3"
USER="$4"


[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

if ((("$SCENARIO"=="2")) && [ -z "$USER" ])
then
  echo "Scenario 2 requires for a username to be specified..."
  exit
fi

function generate_user_and_begin_ptt {
    echo "Generating random user with password..."
    docker exec -it sshd_bf /usr/share/scripts/inclient$SCENARIO.sh $USER
    sleep 10
    echo "Starting papator..."
    docker exec -it patator_ssh /usr/share/scripts/patator$SCENARIO.sh $USER
      
}

function bringup {
    echo "Start the containerised applications..."
    export DATADIR="$PWD/data"
    docker-compose --no-ansi --log-level ERROR up -d
}

function add_delays {
    echo "Adding delays to the network..."
    DELAY1=$((RANDOM % 100 + 1))
    DELAY2=$((RANDOM % 100 + 1))

    ./container_tc.sh sshd_bf $DELAY1
    ./container_tc.sh patator_ssh $DELAY2
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
    generate_user_and_begin_ptt;
    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION
    teardown;
done

