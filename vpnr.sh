#!/bin/bash
#
# Author: Alessandro Paganelli (alessandro.paganelli@gmail.com)
# 2020/3/11
#
#------------------------------------------------------------------------------
# Used to setup a SSH reverse tunnel to a known public server.
# The topology is as follows:
#
# A (behind firewall or not directly reachable)
# |
# |
# B (public server with sshd)
# |
# |
# C (client)
#------------------------------------------------------------------------------

# This is the port used by SSHd on A 
HIDDEN_NODE_PORT=22
# This is the port used by SSHd on B that we (C) use to connect to A through B (i.e., ssh -p $PROXYPORT user@B
REVERSE_TUNNEL_PORT=6644
# This is the port used by SSHd on B to listen for incoming SSH connections. Normally it is 22.
PROXY_SSHD_PORT=22

# User on B
USER_B=user

# B fqdn or IP
PROXY=publicip.example.org

#------------------------------------------------------------------------------
# Misc
LOCKFILE=/tmp/vpnr_running.lock
LOGFILE=/tmp/vpnr.log

#------------------------------------------------------------------------------
# Functions

function lock_or_quit()
{
	if [[ -f "$LOCKFILE" ]]; then
		echo "Lockfile already present, quitting." | tee -a "$LOGFILE"
		exit 1
	fi

	echo $$ > "$LOCKFILE"
	trap "rm -fv $LOCKFILE" EXIT
}

#------------------------------------------------------------------------------
# Actual script

now=$(date)

echo "---------------------------------------------------------------" | tee -a "$LOGFILE"
echo "        VPNr started on $now"                                    | tee -a "$LOGFILE"
echo                                                                   | tee -a "$LOGFILE"
echo "Using proxy:                   $PROXY"                           | tee -a "$LOGFILE"
echo "Proxy ssh port:                $PROXY_SSHD_PORT"                 | tee -a "$LOGFILE"
echo "Reverse tunnel ssh port:       $REVERSE_TUNNEL_PORT"             | tee -a "$LOGFILE"
echo "Remote (hidden) node ssh port: $HIDDEN_NODE_PORT"                | tee -a "$LOGFILE"

# check for locks
lock_or_quit

ssh -Ng -R *:$REVERSE_TUNNEL_PORT:localhost:$HIDDEN_NODE_PORT -p $PROXY_SSHD_PORT -o ServerAliveInterval=20 $USER_B@$PROXY


