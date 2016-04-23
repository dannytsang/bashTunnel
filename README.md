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

## Pre-Requisite ##
This assumes OpenSSH has been installed and you've connected to the server.

It's recommended that you create a separate non root account to establish the connection. In the example below it will create a user called "tunnel"
```
#!bash
sudo useradd -m tunnel
```
The -m option will create an account with the defaults. This may differ from systems but requires a home directory and preferable a (BASH) shell on both ends of the tunnel.

The program screen is recommended to run the script whilst logged.

## Install Client ##
The instructions assumes you've logged into the user that will create the tunnel.

1. Generate SSH keys if not done so already:
```
#!bash
ssh-keygen -t rsa -b 4096 -C "email@example.com"
```

Leave all the answers to the questions blank and press enter so that no password is set and in the default directory.

-t is the type of alogorithm, -b is the size/length of the key in bytes -C is a comment which is generally used to identify the key which doesn't have to be an email address.

2. Obtain a copy of the bashTunnel code:
```
#!bash
git clone git@github.com:dannytsang/bashTunnel.git
```

3. Update the config.sh file to your needs with the ports required.

4. Take a copy of the public key required on the server side:
cat ~/.ssh/id_rsa.pub

## Install Server ##
The instructions assumes you've logged into the user that will create the tunnel.

1. Check and create if necessary the authorized_keys file exists in ~/.ssh e.g /home/tunnel/.ssh/authorized_keys

2. Append the contents of the public key on step 4. from the client install section. Save and close this file.

## Starting ##
Go back to the client (as the tunnel user) and use the script startTunnel.sh to connect:
```
#!bash
startTunnel.sh &
```
The ampersand at the end of the command means run it as a background process so your terminal is freed up to run other commands.

To allow the script to run whilst the user is logged off use screen:
```
#!bash
screen -d -m startTunnel.sh
```
The -d and -m allows it run and detach straight away so that other commands could be run.

## Removing Access ##
Log into the server (as the tunnel account).

1. Edit the authorized_keys file usually found in ~/.ssh/authorized_keys

2. Find the entry identified by the key comment or the key itself.

3. Remove the line, save and exit the file.
