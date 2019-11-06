#!/bin/bash

export DURATION="$1"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
REPEAT="$2"


[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

function add_delays {
    echo "Adding delays to the network..."
    DELAY1=$((RANDOM % 100 + 1))
    DELAY2=$((RANDOM % 100 + 1))
    DELAY3=$((RANDOM % 100 + 1))

     # Our tc-netem scripts that add delays to network.
    ./container_tc.sh mysql $DELAY1
    ./container_tc.sh capture-140-securesql_apache_1 $DELAY2
    ./container_tc.sh capture-140-securesql_admin_user_1 $DELAY3
}



trap '{ echo "Interrupted."; teardown; exit 1; }' INT

for ((i=1; i<=REPEAT; i++))
do
    echo "Repeat Nr " $i
    export REPNUM=$i
    docker-compose up -d
    add_delays;
    sleep 60
    
    PREFIX="[Entrypoint] GENERATED ROOT PASSWORD: "
    FULL_PASS=$(docker logs mysql 2>&1 | grep GENERATED)
    FULL_PASS=${FULL_PASS#"$PREFIX"}
    echo "$FULL_PASS"
    docker exec -it mysql /home/share/sql_script.sh $FULL_PASS
    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION

    docker-compose down
done

