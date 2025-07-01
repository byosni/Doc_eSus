#!/bin/bash
echo "Iniciando o build do serviço webservice ..."
docker compose up -d webserver

CONTAINER=$(docker compose ps -q webserver)
STATUS=$(docker inspect --format='{{.State.Health.Status}}' $CONTAINER)
while [ "$STATUS" != "healthy" ];
do
  echo "$STATUS"
  echo "Aguardando o serviço de webservice ..."
  sleep 10
  STATUS=$(docker inspect --format='{{.State.Health.Status}}' $CONTAINER)
done

echo "Finalizado a build do serviço webserver."
