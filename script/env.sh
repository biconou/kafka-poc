#!/bin/bash

export HOME=..
export DATA=${HOME}/data
export WRK_DATA=${HOME}/kafka/data
export KAFKA=${HOME}/kafka

compose="docker-compose -f ${KAFKA}/docker-compose.yml"






