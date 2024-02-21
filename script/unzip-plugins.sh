#!/bin/bash


mkdir -p ${KAFKA}/connect/confluent-hub-components-extra/

unzip -n ${HOME}/plugins/confluentinc-kafka-connect-jdbc-10.0.1.zip -d ${KAFKA}/connect/confluent-hub-components-extra/
unzip -n ${HOME}/plugins/streamthoughts-kafka-connect-file-pulse-1.5.0.zip -d ${KAFKA}/connect/confluent-hub-components-extra/
unzip -n ${HOME}/plugins/confluentinc-kafka-connect-elasticsearch-11.0.1.zip -d ${KAFKA}/connect/confluent-hub-components-extra/

