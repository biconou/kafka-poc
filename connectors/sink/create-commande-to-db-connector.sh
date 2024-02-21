#!/bin/bash

curl -X DELETE http://localhost:8083/connectors/commande-to-db

curl \
    -i -X PUT -H "Accept:application/json" \
    -H  "Content-Type:application/json" http://localhost:8083/connectors/commande-to-db/config \
    -d '{
        "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
        "tasks.max": "1",
        "topics": "commande",
        "connection.url": "jdbc:sqlite:/data/test.db",
        "auto.create": "true",
        "name": "commande-to-db",
        "fields.whitelist": "societe_facturation,societe_livraison,code_avancement,numero_commande,numero_version_mb,date_accordee_client"
    }'

curl -X DELETE http://localhost:8083/connectors/commande-to-db-aggregate

curl \
    -i -X PUT -H "Accept:application/json" \
    -H  "Content-Type:application/json" http://localhost:8083/connectors/commande-to-db-aggregate/config \
    -d '{
        "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
        "tasks.max": "1",
        "topics": "commande",
        "connection.url": "jdbc:sqlite:/data/test.db",
        "table.name.format": "${topic}-aggregate",
        "auto.create": "false",
        "name": "commande-to-db-aggregate",
        "fields.whitelist": "societe_facturation,societe_livraison,code_avancement,numero_commande,numero_version_mb,date_accordee_client",
        "pk.fields": "societe_livraison, numero_commande",
        "pk.mode": "record_value",
        "insert.mode": "upsert"
    }'