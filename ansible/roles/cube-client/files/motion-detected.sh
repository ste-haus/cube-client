#!/bin/bash

RATE_LIMIT=30
NOW=`date +%s`
HISTORY_FILE=/tmp/last-motion
CONTROL_SERVER_PORT=4444
MOTION_NOTIFICATION_ENDPOINT=

if [ ! -f $HISTORY_FILE ]; then
    echo 0 > $HISTORY_FILE
    chmod 666 $HISTORY_FILE
fi

# log motion event
typeset -i THEN=$(tail -1 $HISTORY_FILE)
echo $NOW > $HISTORY_FILE

BACKOFF=$(( $THEN + $RATE_LIMIT ))
if [ "$NOW" -gt "$BACKOFF" ]; then
    # turn on display
    echo "on" | nc -q 1 localhost $CONTROL_SERVER_PORT

    # send motion event server
    if [ ! -z "$MOTION_NOTIFICATION_ENDPOINT" ]; then
        curl -XPOST $MOTION_NOTIFICATION_ENDPOINT -m 1 -d "hostname=`hostname`"
    fi
fi
