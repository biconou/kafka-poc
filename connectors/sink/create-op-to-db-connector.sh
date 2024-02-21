#!/bin/bash

curl -X DELETE http://localhost:8083/connectors/op-to-db


curl \
    -i -X PUT -H "Accept:application/json" \
    -H  "Content-Type:application/json" http://localhost:8083/connectors/op-to-db/config \
    -d '{
        "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
        "tasks.max": "1",   
        "topics": "op",
        "connection.url": "jdbc:sqlite:/data/test.db",
        "auto.create": "true",
        "name": "op-to-db"
    }'

