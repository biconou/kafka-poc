package com.github.biconou.kafka.streams;

import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.KafkaStreams;
import org.apache.kafka.streams.StreamsBuilder;
import org.apache.kafka.streams.StreamsConfig;
import org.apache.kafka.streams.kstream.KStream;
import org.apache.kafka.streams.kstream.Materialized;
import org.apache.kafka.streams.kstream.Produced;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Date;
import java.util.Properties;

/**
 */
public class SimpleTest {

    static final Logger log = LoggerFactory.getLogger(SimpleTest.class);
    private static String APPLICATION = "test-commande-application-";
    static {
        APPLICATION += new Date().getTime();
    }

    public static void main(String[] args) {
        Properties properties = new Properties();
        log.info("APPLICATION {}",APPLICATION);
        properties.put(StreamsConfig.APPLICATION_ID_CONFIG,APPLICATION);
        properties.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG,"localhost:9092");
        properties.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass());
        properties.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.String().getClass());

        log.info("Start");

        // build a stream
        StreamsBuilder builder = new StreamsBuilder();
        KStream<String, String> commandesStream = builder.stream("test-commande");

        commandesStream.mapValues(value -> ""+value.chars().count()).to("test-commande-count-chars");

       commandesStream.groupByKey().count(Materialized.as("store-count"))
                .toStream().peek((key, value) -> log.debug("{}",value)).to("test-commande-count", Produced.with(Serdes.String(), Serdes.Long()));

        KafkaStreams kafkaStreams = new KafkaStreams(builder.build(),properties);
        kafkaStreams.start();

        // shutdown hook to correctly close the streams application
        Runtime.getRuntime().addShutdownHook(new Thread(kafkaStreams::close));
    }
}
