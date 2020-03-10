#!/bin/bash
CONTROL_SERVER_PORT=4444
echo "start" | nc -q 1 localhost $CONTROL_SERVER_PORT
