#!/bin/bash

if [ "$1" == "up" ]; then
  CMD="up -d"
elif [ "$1" == "down" ]; then
  CMD="down -v"
else
  CMD=$1
fi

if [ -f /srv/planet/pwd/credentials.yml ]; then
  docker compose -f /srv/planet/planet.yml -f /srv/planet/pwd/credentials.yml -p planet $CMD
else
  docker compose -f /srv/planet/planet.yml -p planet $CMD
  docker wait 'planet_db-init_1'
  docker start 'planet_db-init_1'
fi
