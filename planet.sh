#!/bin/bash

if [ "$#" -lt 1 ]; then
  echo "Argument is required."
  echo ""
  echo "Usage: $0 <up|stop|start|restart|down|(other docker compose command)...>"
  echo "Example: $0 up       Start up the planet services for the first time in the background."
  echo "         $0 stop     Stop planet services."
  echo "         $0 start    Start planet services."
  echo "         $0 restart  Restart planet services."
  echo "         $0 down     Stop planet services and remove containers, networks, volumes, and images created."
  echo ""
  exit 1
fi

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
fi

if docker ps -a --format '{{.Names}}' | grep -q '^planet_db-init_1$'; then
  docker wait 'planet_db-init_1'
  docker start 'planet_db-init_1'
fi
