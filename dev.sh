#!/bin/bash


export STACKNAME=nginx-autoreloader

function build {
	docker service rm nginx-autoreloader_nginxreloader
#	sleep 3
#	docker image rm rwd1/${STACKNAME}:local
	docker build -t rwd1/${STACKNAME}:local .
}

function deploy {
	docker stack deploy --compose-file=docker-compose.yml ${STACKNAME}
}


case "$1" in
	b)
		build
		;;
	d)
		deploy
		;;
	bd)
		build && deploy
		sleep 3
		docker logs -f $(docker ps --filter name=${STACKNAME}_nginxreloader --format '{{.ID}}')
		;;
	*)
		echo "unknown command: $1"
esac
