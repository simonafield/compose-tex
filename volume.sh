#!/bin/bash

set -e

# Create .env file with UID and GID
echo "UID=$(id -u)" > .env
echo "GID=$(id -g)" >> .env

docker compose \
    --env-file .env \
    -f compose-tex/docker-compose.yml \
    run --rm \
    alpine-volume
