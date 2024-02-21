package com.github.biconou.kafka.streams;

import io.confluent.kafka.streams.serdes.avro.GenericAvroSerde;
import org.apache.avro.Schema;
import org.apache.avro.generic.GenericRecord;
import org.apache.avro.generic.GenericRecordBuilder;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.KafkaStreams;
import org.apache.kafka.streams.StreamsBuilder;
import org.apache.kafka.streams.StreamsConfig;
import org.apache.kafka.streams.kstream.KStream;
import org.apache.kafka.streams.kstream.KTable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Date;
import java.util.Properties;

/**
 */
public class CommandeStreams {

    static final Logger log = LoggerFactory.getLogger(CommandeStreams.class);
    private static String APPLICATION = "commande-application";
    private static String REGISTRY_URL = "http://localhost:8081";
    static {
        APPLICATION += new Date().getTime();
    }

    public static void main(String[] args) {
        Properties properties = new Properties();
        log.info("APPLICATION {}",APPLICATION);
        properties.put(StreamsConfig.APPLICATION_ID_CONFIG,APPLICATION);
        properties.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG,"localhost:9092");
        properties.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass());
        properties.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, GenericAvroSerde.class);
        properties.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG,"earliest");
        properties.put("schema.registry.url", REGISTRY_URL);

        //SchemaRegistryClient schemaRegistryClient = new CachedSchemaRegistryClient(REGISTRY_URL, 10000);

        Schema.Parser parser = new Schema.Parser();
        Schema schema = parser.parse("{\n" +
                "    \"type\": \"record\",\n" +
                "    \"name\": \"CommandeOPJoin\",\n" +
                "    \"namespace\": \"com.github.biconou\",\n" +
                "    \"fields\": [\n" +
                "        {\"name\": \"societe_livraison\", \"type\":\"string\"},\n" +
                "        {\"name\": \"numero_commande\", \"type\":\"string\"},\n" +
                "        {\"name\": \"code_avancement\", \"type\":\"string\"},\n" +
                "        {\"name\": \"numero_version\", \"type\":\"string\"},\n" +
                "        {\"name\": \"date_accordee_client\", \"type\":\"string\"},\n" +
                "        {\"name\": \"date_creation_oms\", \"type\":\"string\"},\n" +
                "        {\"name\": \"statut\", \"type\":\"string\"}\n" +
                "    ]\n" +
                "}");

        log.info("Start");

        StreamsBuilder builder = new StreamsBuilder();

        // Commande
        KStream<String, GenericRecord> commandeStream = builder.stream("commande");
        KTable<String, GenericRecord> commandeTable = commandeStream.groupByKey().reduce((value1, value2) -> value2);
        commandeTable.toStream().peek((key, value) -> log.trace("COMMANDE / {} ## {}",key,value));

        // OP
        KStream<String, GenericRecord> opStream = builder.stream("op");
        KTable<String, GenericRecord> opTable = opStream.groupByKey().reduce((value1, value2) -> value2);
        opTable.toStream().peek((key, value) -> log.trace("OP / {} # {}",key,value));

        commandeTable.leftJoin(opTable, (commandeValue, opValue) -> {
            GenericRecordBuilder recordBuilder = new GenericRecordBuilder(schema);
            recordBuilder.set("societe_livraison", commandeValue.get("societe_livraison"));
            recordBuilder.set("numero_commande", commandeValue.get("numero_commande"));
            recordBuilder.set("code_avancement", commandeValue.get("code_avancement"));
            recordBuilder.set("numero_version", commandeValue.get("numero_version_mb"));
            recordBuilder.set("date_accordee_client", commandeValue.get("date_accordee_client"));
            if (opValue != null) {
                recordBuilder.set("date_creation_oms", opValue.get("date_creation_oms"));
                recordBuilder.set("statut", opValue.get("statut"));
            } else {
                recordBuilder.set("date_creation_oms", "NULL");
                recordBuilder.set("statut", "NULL");
            }
            return recordBuilder.build();
        }).toStream().peek((key, value) -> log.debug("JOIN / {} # {}",key,value))
        .to("commande-op-join");


        KafkaStreams kafkaStreams = new KafkaStreams(builder.build(),properties);
        kafkaStreams.start();

        // shutdown hook to correctly close the streams application
        Runtime.getRuntime().addShutdownHook(new Thread(kafkaStreams::close));
    }
}
