#!/usr/bin/env bash

set -o errexit
set -o nounset

declare -r host=localhost
declare -i port=5672

for ((i = 0; i < 11; i++))
do
    port="$((5672 + (i % 3)))"
    queue="test_$i"
    uri="--uri amqp://$host:$port"
    {
        cd $HOME/development/rabbitmq/rabbitmq-perf-test
        mvn exec:java -Dexec.mainClass='com.rabbitmq.perf.PerfTest' -Dexec.args="$uri --predeclared --queue test_$i --producers 1 --consumers 0 --size 1024 --pmessages 1024"
    } &
done
wait
echo Done.