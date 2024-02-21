#!/bin/bash

TOPIC=commandes-mb-count

echo TOPIC=${TOPIC}
echo "+++++++++++++++++++++++"
docker run --tty --network=host edenhill/kafkacat:1.6.0 kafkacat \
        -b localhost:9092 \
        -t ${TOPIC} \
        -K\t


# docker run --tty --network=host edenhill/kafkacat:1.6.0 kafkacat \
#         -b localhost:9092 \
#         -t ${TOPIC} \
#         -C -J -q -o-1 -s key=s -s value=avro -r http://localhost:8081 \
#         | jq .
