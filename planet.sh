#!/bin/bash

if [ "$1" == "up" ]; then
  COMMAND="up -d"
elif [ "$1" == "down" ]; then
  COMMAND="down -v"
else
  COMMAND=$1
fi

if [ -f /srv/planet/pwd/credentials.yml ]; then
  docker compose -f /srv/planet/planet.yml -f /srv/planet/pwd/credentials.yml -p planet $1
else
  docker compose -f /srv/planet/planet.yml -p planet $1
  docker wait 'planet_db-init_1'
  docker start 'planet_db-init_1'
fi
