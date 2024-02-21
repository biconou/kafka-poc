#!/bin/bash

. ./env.sh


rm ${DATA}/test.db
cp ${WRK_DATA}/test.db ${DATA}

rm ${WRK_DATA}/*.csv

./unzip-plugins.sh

echo "stop entire stack"
${compose} down -v

echo "start entire stack"
${compose} up --build -d

echo "création des topics"
./create-topics.sh

connect-ready=0
until [[ ${connect} = 200 ]]; do
  echo "Wait until Kafka Connect is ready ..." 
  connect=`curl -s -o /dev/null -w "%{http_code}" localhost:8083/`
  sleep 1
done
echo "... Kafka Connect is ready"

./create-connectors.sh


