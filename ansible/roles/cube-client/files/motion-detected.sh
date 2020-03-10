#!/bin/bash

RATE_LIMIT=30
NOW=`date +%s`
HISTORY_FILE=/tmp/last-motion
CONTROL_SERVER_PORT=4444

if [ ! -f $HISTORY_FILE ]; then
    echo 0 > $HISTORY_FILE
    chmod 666 $HISTORY_FILE
fi

typeset -i THEN=$(tail -1 $HISTORY_FILE)
echo $NOW > $HISTORY_FILE

BACKOFF=$(( $THEN + $RATE_LIMIT ))
if [ "$NOW" -gt "$BACKOFF" ]; then
    echo "on" | nc -q 1 localhost $CONTROL_SERVER_PORT
fi
