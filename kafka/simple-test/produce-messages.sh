#!/bin/bash

TOPIC=test-commandes-mb

echo TOPIC=${TOPIC}
echo "+++++++++++++++++++++++"
docker run --tty --network=host edenhill/kafkacat:1.6.0 kafkacat \
        -P \
        -b localhost:9092 \
        -t test-commandes-mb


kafkacat -b localhost:9092 -t test-commandes-mb -K: -P
