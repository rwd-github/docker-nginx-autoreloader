#!/bin/bash

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

echo "Found matching instances:"
docker ps --filter name=${NGINXNAMEFILTER} --format 'table {{.ID}}\t{{.Names}}'
echo

#
# Inotify part.
#
echo "[Starting inotifywait...]"
inotifywait -e ${INOTIFY_EVENTS} ${INOTIFY_OPTONS} "${WATCHVOLUME}" | \
    while read -r notifies;
    do
        echo "---  notify received: $notifies"
        IDs=$(docker ps --filter name=${NGINXNAMEFILTER} --format '{{.ID}}')
        echo "Container matching:" ${IDs}
        for ID in $IDs; do
			echo "___  do $ID"
			docker exec $ID nginx -t && {
				echo "Reloading Nginx Configuration"
				docker exec $ID nginx -s reload
			} || echo "no reload!!!"
        done
    done
