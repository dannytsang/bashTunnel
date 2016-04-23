# bashTunnel #

BASH script for checking and creating a SSH tunnel so that a connection between two computers are encrypted. The encrypted tunnel should allow any connections within it and can act as an additional layer of security. An additional benefit is the underlying connection is hidden inside the tunnel from the data / connection.

bashTunnel is a BASH script which creates and checks the tunnel is still up. It attempts to reconnect if it detects the tunnel is down. It requires (Open)SSH installed for it to work.


~~~~~ {.ditaa .no-separation}

      Client                                    Server
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
 2. Check tunnel to keep tunnel alive and to make sure the tunnel is still up. Only when both connections are lost can the script detect and re-establish a tunnel connection.

The connection should be initiated from one computer to another. I'd recommend using the client connecting to the server to initate the connection so that the client can be removed without any impact to the server.

For example if the client was an application server, it could scale by creating multiple application on the fly to handle the load to the same server and then removed when the demand is reduced.

Example:
~~~~~ {.ditaa .no-separation}

     WordPress                                    MySQL                                     NodeJS
 ----------------     Tunnel : port 22      ----------------     Tunnel : port 22      ----------------
|   LOCAL_PORT   | ======================= | END_POINT_PORT | ======================= | END_POINT_PORT |
|      3306      |   3306 DATA 3306 DATA   |      3306      |   3306 DATA 3306 DATA   |      3306      |
|                | ======================= |                | ======================= |                |
|                |                         |                |                         |                |
|                |  Tunnel : port 19922    |                |  Tunnel : port 19922    |                |
|                | ======================= |                | ======================= |                |
|                |  Check tunnel is alive  |                |  Check tunnel is alive  |                |
|                | ======================= |                | ======================= |                |
 ----------------                           ----------------                           ----------------
 
 ~~~~~

# Pre-Requisite #
This assumes OpenSSH has been installed and you've connected to the server.

It's recommended that you create a separate non root account to establish the connection. In the example below it will create a user called "tunnel"
```
sudo useradd -m tunnel
```
The -m option will create an account with the defaults. This may differ from systems but requires a home directory and preferable a (BASH) shell.
