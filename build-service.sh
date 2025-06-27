#!/bin/bash
echo "Iniciando a build do serviço database ..."
docker compose up -d database

# Espera o container database existir
CONTAINER=$(docker compose ps -q database)
while [ -z "$CONTAINER" ]; do
  echo "Container database não encontrado, aguardando..."
  sleep 5
  CONTAINER=$(docker compose ps -q database)
done

STATUS=$(docker inspect --format='{{.State.Health.Status}}' $CONTAINER)
while [ "$STATUS" != "healthy" ]; do
  echo "$STATUS"
  echo "Aguardando o serviço de banco de dados ..."
  sleep 10
  STATUS=$(docker inspect --format='{{.State.Health.Status}}' $CONTAINER)
done

export APP_DB_URL="jdbc:postgresql://$(hostname -I | awk '{print $1}'):5432/esus"

echo "Iniciando o build do serviço webservice ..."
docker compose up -d webserver

# Espera o container webserver existir
CONTAINER=$(docker compose ps -q webserver)
while [ -z "$CONTAINER" ]; do
  echo "Container webserver não encontrado, aguardando..."
  sleep 5
  CONTAINER=$(docker compose ps -q webserver)
done

STATUS=$(docker inspect --format='{{.State.Health.Status}}' $CONTAINER)
while [ "$STATUS" != "healthy" ]; do
  echo "$STATUS"
  echo "Aguardando o serviço de webservice ..."
  sleep 10
  STATUS=$(docker inspect --format='{{.State.Health.Status}}' $CONTAINER)
done

echo "Finalizado a build dos serviço."
