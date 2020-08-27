#!/usr/bin/env bash

set -o errexit
set -o nounset

declare -ri msg_count=333333

cd "$HOME/development/rabbitmq/rabbitmq-perf-test"
mvn exec:java -Dexec.mainClass='com.rabbitmq.perf.PerfTest' -Dexec.args="--uris amqp://localhost:5672,amqp://localhost:5673,amqp://localhost:5674  --predeclared --queue-pattern test_%d --queue-pattern-from 0 --queue-pattern-to 11 --flag persistent --producers 12 --consumers 0 --size 1024 --pmessages $msg_count"

echo Done.
