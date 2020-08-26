#!/usr/bin/env bash

set -o errexit
set -o nounset

declare -r host=localhost
declare -i port=15672

for ((i = 0; i < 11; i++))
do
    port="$((15672 + (i % 3)))"
    queue="test_$i"

    echo -n "Declaring queue $queue..."
    rabbitmqadmin -H $host -P $port declare queue name="$queue" durable=true
    echo Done.
done

echo -n Declaring ha-three policy...
rabbitmqadmin -H $host -P $port declare policy name=ha-three pattern='^test_\d+$' definition='{"ha-mode":"all","ha-sync-mode":"automatic"}' priority=0 apply-to=queues
echo Done.
