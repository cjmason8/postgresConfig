#!/bin/bash

RANCHER_ACCESS_KEY=AA57D92145E412E26C0D
RANCHER_SECRET_KEY=N519UCmNmqq2AD7ti8EYxEVUv1PwyFpcJyGWeqUm
RANCHER_URL=http://localhost:8080/v2-beta/projects/1a5
BASE_DIR=${PWD}

echo "Force pulling..."
rancher-compose --url ${RANCHER_URL} --access-key ${RANCHER_ACCESS_KEY} --secret-key ${RANCHER_SECRET_KEY} -p postgres -f ${BASE_DIR}/docker-compose.yml pull

echo "Starting deployment..."
rancher-compose --url ${RANCHER_URL} --access-key ${RANCHER_ACCESS_KEY} --secret-key ${RANCHER_SECRET_KEY} -r ${BASE_DIR}/rancher-compose..yml -p postgres -f ${BASE_DIR}/docker-compose.yml up --upgrade -d --pull --batch-size 1

if [ $? -eq 0 ]; then
  echo "Deploy success! Confirming..."
  rancher-compose --url ${RANCHER_URL} --access-key ${RANCHER_ACCESS_KEY} --secret-key ${RANCHER_SECRET_KEY} -p postgres -f ${BASE_DIR}/docker-compose.yml up --confirm-upgrade -d --batch-size 1
else
  echo "Deploy failed :( rolling back..."
  rancher-compose --url ${RANCHER_URL} --access-key ${RANCHER_ACCESS_KEY} --secret-key ${RANCHER_SECRET_KEY} -p postgres -f ${BASE_DIR}/docker-compose.yml up --rollback -d --batch-size 1
fi
