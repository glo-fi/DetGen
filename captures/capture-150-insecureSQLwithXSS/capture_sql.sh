#!/bin/bash

export SCENARIO="$1"
DURATION="$2"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
REPEAT="$3"


[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1


function add_delays {
    echo "Adding delays to the network..."
    DELAY1=$((RANDOM % 100 + 1))
    DELAY2=$((RANDOM % 100 + 1))
#    DELAY3=$((RANDOM % 100 + 1))
    DELAY4=$((RANDOM % 100 + 1))

    ./container_tc.sh mysql2 $DELAY1
    ./container_tc.sh capture-150-insecuresqlwithxss_apache_1 $DELAY2
#    ./container_tc.sh capture-150-insecuresqlwithxss_admin_user_1 $DELAY3
    ./container_tc.sh capture-150-insecuresqlwithxss_attacker_1 $DELAY4
}

trap '{ echo "Interrupted."; teardown; exit 1; }' INT

for ((i=1; i<=REPEAT; i++))
do
    echo "Repeat Nr " $i
    export REPNUM=$i
    docker-compose up -d
#    add_delays;

    sleep 80
    
    PREFIX="[Entrypoint] GENERATED ROOT PASSWORD: "
    FULL_PASS=$(docker logs mysql2 2>&1 | grep GENERATED)
    FULL_PASS=${FULL_PASS#"$PREFIX"}
    echo "$FULL_PASS"
    echo "Should Have Printed..."
    docker exec -it mysql2 /home/share/sql_script2.sh $FULL_PASS
    echo "Capturing data now for $DURATION seconds...."
    docker exec -it capture-150-insecuresqlwithxss_attacker_1 python /usr/share/scripts/attack$SCENARIO.py
    sleep $DURATION

    docker-compose down
done

