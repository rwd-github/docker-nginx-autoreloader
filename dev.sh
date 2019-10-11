#!/bin/bash


export STACKNAME=nginx-autoreloader

function build {
	docker build -t rwd1/${STACKNAME} .
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
		build && deploy && docker logs -f $(docker ps --filter name=${STACKNAME}_nginxreloader --format '{{.ID}}')
		;;
	*)
		echo "unknown command: $1"
esac
