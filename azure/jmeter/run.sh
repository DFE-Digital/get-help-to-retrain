#!/bin/bash

NAME="jmetertest"
IMAGE="justb4/jmeter:latest"

rootPath=$1
testFile=$2
host=$3

echo "Root path: $rootPath"
echo "Test file: $testFile"
echo "Host: $host"


docker run --rm --name $NAME -i -v $rootPath:/test -w /test $IMAGE -Dlog_level.jmeter=DEBUG \
  -Jhost=dev1.nrs-ghtr.org.uk \
  -n -t /test/jmeter-performance-tests.jmx -l ./test-plan.jtl -j ./jmeter.log -e -o ./report

echo "==== HTML Test Report ===="
echo "See HTML test report in ./report/index.html"
