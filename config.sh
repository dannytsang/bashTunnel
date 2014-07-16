#!/bin/bash
# Port to be forwarded on the source machine.
LOCAL_PORT=3306
# Local port used to check / simulate activity over tunnel. DO NOT use server SSH port.
CHECK_PORT=19922
# Destination SSH port.
CHECK_ENDPOINT_PORT=22
# Destination Server Address.
END_POINT=127.0.0.1
# Username of SSH tunnel user.
END_POINT_USERNAME=tunnel
# Destination port to be routed to.
END_POINT_PORT=3306