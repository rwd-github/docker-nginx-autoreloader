#!/bin/sh

set -e

INOTIFY_EVENTS_DEFAULT="create,delete,modify,move"
#INOTIFY_OPTONS_DEFAULT='--monitor --exclude=*.sw[px]'
INOTIFY_OPTONS_DEFAULT='--monitor --exclude=.swp  --recursive'

#
# Display settings on standard out.
#
echo "settings"
echo "========"
echo
echo "  NGINXNAMEFILTER:  ${NGINXNAMEFILTER}"
echo "  WATCHVOLUME:      ${WATCHVOLUME}"
echo "  Inotify_Events:   ${INOTIFY_EVENTS:=${INOTIFY_EVENTS_DEFAULT}}"
echo "  Inotify_Options:  ${INOTIFY_OPTONS:=${INOTIFY_OPTONS_DEFAULT}}"
echo


#
# Inotify part.
#
echo "[Starting inotifywait...]"
inotifywait -e ${INOTIFY_EVENTS} ${INOTIFY_OPTONS} "${WATCHVOLUME}" | \
    while read -r notifies;
    do
    	echo "$notifies"
        echo "notify received, reload config"
        IDs=$(docker ps --filter name=${NGINXNAMEFILTER} --format '{{.ID}}')
        echo $IDs
        for ID in $IDs; do
			echo "do $ID"
			docker exec $ID nginx -t
			if [ $? -eq 0 ]
			then
				echo "Reloading Nginx Configuration"
				docker exec $ID nginx -s reload
			fi
        done
    done
