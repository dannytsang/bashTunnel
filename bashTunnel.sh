#!/bin/bash
# Load configuration
. "$(dirname "$0")"/config.sh

# Create tunnel
createTunnel() {
    # Add all ports needed for tunnel. The format of a tunnel should be:
    # -L[LocalPort]:[Host]:[HostPort]
    # Below creates a port on 3306 (MySQL default port)
    /usr/bin/ssh -f -N $SSH_OPTIONS -L$LOCAL_PORT:$END_POINT:$END_POINT_PORT -L$CHECK_PORT:$END_POINT:$CHECK_ENDPOINT_PORT $END_POINT_USERNAME@$END_POINT -p $CHECK_ENDPOINT_PORT
    if [[ $? -eq 0 ]]; then
        echo Tunnel to hostb created successfully
    else
        echo An error occurred creating a tunnel to hostb RC was $?
    fi
}

## Run the 'ls' command remotely.  If it returns non-zero, then create a new connection
/usr/bin/ssh $SSH_OPTIONS -p $CHECK_PORT $END_POINT_USERNAME@localhost ls
if [[ $? -ne 0 ]]; then
    echo Creating new tunnel connection
    createTunnel
fi
