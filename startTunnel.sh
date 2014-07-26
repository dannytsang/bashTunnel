#!/bin/bash

# Load Tunnel script
. "$(dirname "$0")"/bashTunnel.sh
# How often it should run the script to check the tunnel in seconds
SLEEP_TIME=60

while true
do
	## Run the 'ls' command remotely.  If it returns non-zero, then create a new connection
	/usr/bin/ssh -p $CHECK_PORT $END_POINT_USERNAME@localhost ls
	if [[ $? -ne 0 ]]; then
	    echo Creating new tunnel connection
	    createTunnel
	fi

	echo "Sleeping for ${SLEEP_TIME} secs"
	sleep $SLEEP_TIME
done