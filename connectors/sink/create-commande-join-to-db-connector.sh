#!/bin/bash


curl -X DELETE http://localhost:8083/connectors/commande-op-join-to-db

curl \
    -i -X PUT -H "Accept:application/json" \
    -H  "Content-Type:application/json" http://localhost:8083/connectors/commande-op-join-to-db/config \
    -d '{
        "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
        "tasks.max": "1",
        "topics": "commande-op-join",
        "connection.url": "jdbc:sqlite:/data/test.db",
        "auto.create": "false",
        "name": "commande-op-join-to-db",
        "pk.fields": "societe_livraison, numero_commande",
        "pk.mode": "record_value",
        "insert.mode": "upsert"
    }'