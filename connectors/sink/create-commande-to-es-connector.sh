#!/bin/bash

curl -X DELETE http://localhost:8083/connectors/commande-to-es

curl \
    -i -X PUT -H "Accept:application/json" \
    -H  "Content-Type:application/json" http://localhost:8083/connectors/commande-to-es/config \
    -d '{
        "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
        "tasks.max": "1",
        "topics": "commande",
        "connection.url": "http://elasticsearch:9200",
        "name": "commande-to-es",
        "type.name": "_doc"
    }'
