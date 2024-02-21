
# base documents

https://docs.confluent.io/platform/current/connect/quickstart.html

https://docs.confluent.io/platform/current/quickstart/ce-docker-quickstart.html

# Quick start

```
cd cp-all-in-one/cp-all-in-one
docker-compose up -d
```

Control Center : http://localhost:9021

## Prototype

Objectif n°1 : utiliser kafka connect pour charger les deux fichiers CSV de MB dans deux topics respectifs.


J'utilise la community en mode docker
https://docs.confluent.io/platform/current/quickstart/cos-docker-quickstart.html


### Créer un topic

Pour le moment, je passe par la console. On verra pour les scripts après. 
J'ai créé le topic commande


### Créer un connecteur file

Suivre l'article : https://dev.to/fhussonnois/streaming-csv-data-into-kafka-46a5

Insallation de Kafka Connect File Pulse connector avec confluent hub
https://www.confluent.io/hub/streamthoughts/kafka-connect-file-pulse


Les messages sont sérializés dans une base de données SQLLite

Utiliser une clé pour la commande et utiliser un update quand on détecte deux fois la même commande


Objectif Final : avoir une table qui combine les données des deux flux 
- commande
- OP




## Enregistrement dans la base de données

On utilise Kafka Connect avec le 
[JDBC Sink Connector for Confluent Platform](https://docs.confluent.io/kafka-connect-jdbc/current/sink-connector/index.html)



## Kafka streams

Quick start

https://docs.confluent.io/platform/current/streams/quickstart.html#streams-quickstart




