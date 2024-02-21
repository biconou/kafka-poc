#!/bin/bash


TOPIC_NAMES="commande;op;commande-op-join"

TOPICS=$(echo ${TOPIC_NAMES} | tr ";" "\n")

for T in ${TOPICS}
do
    echo "Création du topic ${T}"

    docker exec broker kafka-topics \
      --delete \
      --bootstrap-server localhost:9092 \
      --topic ${T}

    docker exec broker kafka-topics \
      --create \
      --bootstrap-server localhost:9092 \
      --replication-factor 1 \
      --partitions 1 \
      --topic ${T}
done