#!/bin/bash

BASE_DIR=${PWD}

echo "Force pulling..."
docker compose -p postgres -f ${BASE_DIR}/docker-compose.yml pull

echo "Starting deployment..."
docker compose -p postgres -f ${BASE_DIR}/docker-compose.yml up -d --pull always
