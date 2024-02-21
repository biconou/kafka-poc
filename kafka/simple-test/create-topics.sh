#!/bin/bash


docker-compose exec broker kafka-topics \
  --delete \
  --bootstrap-server localhost:9092 \
  --topic test-commandes-mb

docker-compose exec broker kafka-topics \
  --create \
  --bootstrap-server localhost:9092 \
  --replication-factor 1 \
  --partitions 1 \
  --topic test-commandes-mb

docker-compose exec broker kafka-topics \
  --delete \
  --bootstrap-server localhost:9092 \
  --topic test-commandes-mb-count

docker-compose exec broker kafka-topics \
  --create \
  --bootstrap-server localhost:9092 \
  --replication-factor 1 \
  --partitions 1 \
  --topic test-commandes-mb-count

docker-compose exec broker kafka-topics \
  --delete \
  --bootstrap-server localhost:9092 \
  --topic test-commandes-mb-count-chars

docker-compose exec broker kafka-topics \
  --create \
  --bootstrap-server localhost:9092 \
  --replication-factor 1 \
  --partitions 1 \
  --topic test-commandes-mb-count-chars
