package com.github.biconou.kafka.streams;

import io.confluent.kafka.schemaregistry.ParsedSchema;
import io.confluent.kafka.schemaregistry.client.CachedSchemaRegistryClient;
import io.confluent.kafka.schemaregistry.client.SchemaRegistryClient;
import io.confluent.kafka.schemaregistry.client.rest.exceptions.RestClientException;
import io.confluent.kafka.streams.serdes.avro.GenericAvroSerde;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.StreamsConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.Date;
import java.util.Properties;

/**
 */
public class SchemaRegistryTest {

    static final Logger log = LoggerFactory.getLogger(SchemaRegistryTest.class);
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


        SchemaRegistryClient schemaRegistryClient = new CachedSchemaRegistryClient(REGISTRY_URL, 10000);
        try {
            ParsedSchema schemaBySubjectAndId = schemaRegistryClient.getSchemaBySubjectAndId("commande-op-join-value", 3);
            System.out.println(schemaBySubjectAndId);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (RestClientException e) {
            e.printStackTrace();
        }

    }
}
