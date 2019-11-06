#!/bin/bash

export DURATION="$1"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
REPEAT="$2"

FILES=downloads/*


[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

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

function file_transfer {
    echo "Transfering torrent file to seeders..."
    for f in $(find $FILES -name *.torrent) 
    do
        NAME=$(basename $f)
        cp $f share/torrents/
        rm -rf $f
        chmod 777 share/torrents/$NAME
    done

    D_ID1=$(docker ps -aqf "name=torrent_client1")

    docker cp share/torrents $D_ID1:/torrents
    
}

function file_download {
    echo "Starting download..."
    docker exec -it $D_ID1 /var/lib/torrentClient.sh $DURATION
}

trap '{ echo "Interrupted."; teardown; exit 1; }' INT


function torrent_create {
    cd downloads
    for f in $(find . -not -name *.torrent) 
    do 
        NAME=$(basename $f)
        transmission-create -t "http://tracker:6969/announce/" -t "udp://tracker:6969/announce/" -t "http://0.0.0.0:6969/announce/" $NAME
	chmod 777 $NAME.torrent
        transmission-remote 9096 -a $NAME.torrent
done
    cd ..
}

function torrent_delete {

    for f in $(find $FILES -name *.torrent) 
    do
        NAME=$(basename $f)
        rm -rf $f
        rm -rf share/torrents/$NAME
    done
}


for ((i=1; i<=REPEAT; i++))
do
    echo "Repeat Nr " $i
    export REPNUM=$i
    bringup;
    torrent_create;
    file_transfer;
    file_download;
    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION
    teardown;
    torrent_delete;
done
