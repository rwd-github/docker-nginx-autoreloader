#!/bin/bash

set -e

echo "  NGINXNAMEFILTER:  ${NGINXNAMEFILTER}"
echo "  WATCHVOLUMES:     ${WATCHVOLUMES}"


pids=
stop() {
    for pid in ${pids}; do
        echo "Received SIGINT or SIGTERM. Shutting down $pid"
        # Set TERM
        kill -SIGTERM "${pid}"
        # Wait for exit
        wait "${pid}"
        # All done.
        echo "Done."
    done
}
trap stop SIGINT SIGTERM


/workdir/inotifywait.sh &
pids+=" ${!}"


wait ${pids} 
for pid in ${pids}; do
    echo "wait $pid"
    wait $pid
done



