#!/bin/bash

curl \
    -i -X PUT -H "Accept:application/json" \
    -H  "Content-Type:application/json" http://localhost:8083/connectors/op-to-topic/config \
    -d '{
        "connector.class":"io.streamthoughts.kafka.connect.filepulse.source.FilePulseSourceConnector",
        "fs.scan.directory.path":"/data/",
        "fs.scan.interval.ms":"10000",
        "fs.scan.filters":"io.streamthoughts.kafka.connect.filepulse.scanner.local.filter.RegexFileListFilter",
        "file.filter.regex.pattern":"op.*\\.csv$",
        "task.reader.class": "io.streamthoughts.kafka.connect.filepulse.reader.RowFileInputReader",
        "offset.strategy":"name",
        "skip.headers": "1",
        "topic":"op",
        "internal.kafka.reporter.bootstrap.servers": "broker:29092",
        "internal.kafka.reporter.topic":"connect-file-pulse-status",
        "fs.cleanup.policy.class": "io.streamthoughts.kafka.connect.filepulse.clean.LogCleanupPolicy",
        "tasks.max": 1,
        "filters":"ParseLine,SetKey",
        "filters.ParseLine.extractColumnName": "headers",
        "filters.ParseLine.trimColumn": "true",
        "filters.ParseLine.separator": ";",
        "filters.ParseLine.type": "io.streamthoughts.kafka.connect.filepulse.filter.DelimitedRowFilter",
        "filters.SetKey.type": "io.streamthoughts.kafka.connect.filepulse.filter.AppendFilter",
        "filters.SetKey.field": "$key",
        "filters.SetKey.value": "{{ $.societe_livraison }};{{ $.numero_commande }}"
    }'
