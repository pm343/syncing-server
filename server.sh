#!/bin/sh
set -e

DOCKER_VERSION=`docker --version`

if [ "$?" -ne "0" ]; then
  echo "Please install Docker before proceeding."
  exit 1
fi

checkConfigFiles() {
  if [ ! -f "docker/api-gateway.env" ]; then echo "Could not find api-gateway environment file. Please run the './server.sh setup' command and try again." && exit 1; fi
  if [ ! -f "docker/auth.env" ]; then echo "Could not find auth environment file. Please run the './server.sh setup' command and try again." && exit 1; fi
  if [ ! -f "docker/syncing-server-js.env" ]; then echo "Could not find syncing-server-js environment file. Please run the './server.sh setup' command and try again." && exit 1; fi
}

COMMAND=$1 && shift 1

case "$COMMAND" in
  'setup' )
    echo "Initializing default configuration"
    if [ ! -f "docker/api-gateway.env" ]; then cp docker/api-gateway.env.sample docker/api-gateway.env; fi
    if [ ! -f "docker/auth.env" ]; then cp docker/auth.env.sample docker/auth.env; fi
    if [ ! -f "docker/syncing-server-js.env" ]; then cp docker/syncing-server-js.env.sample docker/syncing-server-js.env; fi
    echo "Default configuration files created as docker/*.env files. Feel free to modify values if needed."
    ;;
  'start' )
    checkConfigFiles
    echo "Starting up infrastructure"
    docker-compose up -d
    echo "Infrastructure started. Give it a moment to warm up. If you wish please run the './server.sh logs' command to see details."
    ;;
  'status' )
    echo "Services State:"
    docker-compose ps
    ;;
  'logs' )
    docker-compose logs -f
    ;;
  'update' )
    echo "Downloading latest images of Standard Notes services."
    docker-compose pull
    echo "Images up to date"
    ;;
  'stop' )
    echo "Stopping all service"
    docker-compose kill
    echo "Services stopped"
    ;;
  * )
    echo "Unknown command"
    ;;
esac

exec "$@"
