#!/usr/bin/env bash

set -o errexit
set -o nounset

declare -r host=localhost
declare -i port=15672

echo -n Declaring ha-three policy...
rabbitmqadmin -H $host -P $port declare policy name=ha-three pattern='^test_\d+$' definition='{"queue-mode":"lazy","ha-mode":"all","ha-sync-mode":"automatic"}' priority=0 apply-to=queues

for ((i = 0; i < 11; i++))
do
    port="$((15672 + (i % 3)))"
    queue="test_$i"

    echo -n "Declaring queue $queue..."
    rabbitmqadmin -H $host -P $port declare queue name="$queue" durable=true auto_delete=false
done
