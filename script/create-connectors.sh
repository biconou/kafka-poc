#!/bin/bash

. ./env.sh

for i in `find ${HOME}/connectors/ -name create-*-connector.sh -print`
do
  echo $i
  ./$i
done