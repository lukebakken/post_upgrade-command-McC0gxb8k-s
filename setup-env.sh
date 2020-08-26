#!/usr/bin/env bash

set -o errexit
set -o nounset

declare -r host=shostakovich1
declare -ri port=15672

for ((i = 0; i < 10; i++))
do
    queue="queue_test_$i"
    exchange="exchange_test_$i"

    echo -n "Declaring queue $queue..."
    rabbitmqadmin -H $host -P $port declare queue name="$queue" durable=true
    echo Done.

    echo -n "Declaring exchange $exchange..."
    rabbitmqadmin -H $host -P $port declare exchange name="$exchange" type=topic durable=true
    echo Done.

    for ((j = 0; j < 10; j++))
    do
        {
            declare -r rk="route_test_$j"
            echo -n "Binding queue $queue to exchange $exchange with routing key $rk..."
            rabbitmqadmin -H $host -P $port declare binding source="$exchange" destination="$queue" routing_key="$rk"
            echo Done.
        } &
    done
    wait
done

echo -n Declaring ha-two policy...
rabbitmqadmin -H $host -P $port declare policy name=ha-two pattern='.*' definition='{"ha-mode":"exactly","ha-params":2,"ha-sync-mode":"automatic"}' priority=0 apply-to=queues
echo Done.
