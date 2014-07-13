bashTunnel
==========

BASH script for checking and creating a SSH tunnel.


~~~~~ {.ditaa .no-separation}

    Computer A                                 Computer B
 ----------------     Tunnel : port 22      ----------------
|   LOCAL_PORT   | ======================= | END_POINT_PORT |
|      3306      |   3306 DATA 3306 DATA   |      3306      |
|                | ======================= |                |
|                |                         |                |
|                |  Tunnel : port 19922    |                |
|                | ======================= |                |
|                |  Check tunnel is alive  |                |
|                | ======================= |                |
 ----------------                           ----------------
 
 ~~~~~
 
It creates 2 tunnels:
 1. "Data" port used to shift traffic back and forth E.g MySQL
 2. Check tunnel to keep tunnel alive and to make sure the tunnel is still up.
