#!/bin/bash
#
# Author: Alessandro Paganelli (alessandro.paganelli@gmail.com)
# 2021/08/09
#

#------------------------------------------------------------------------------
VPNR_PROG_NAME="vpnr"
VPNR_PROG_PATH="/path/to/your/vpnr.sh"
LOCKFILE=/tmp/vpnr_running.lock

#------------------------------------------------------------------------------
# Misc
is_vpnr_running="false"

#------------------------------------------------------------------------------
# Functions

function check_vpnr_running()
{
	local pid=$1
	echo "Checking for PID=$pid"
	vpnr_running=$(ps -ef | grep "$pid" | grep $VPNR_PROG_NAME)
	if [[ ! -z "$vpnr_running" ]]; then
		is_vpnr_running="true"
	fi
}

#------------------------------------------------------------------------------
# Actual script

if [[ -f "$LOCKFILE" ]]; then
	pid=$(cat "$LOCKFILE")
	check_vpnr_running "$pid"
fi

if [[ ! "$is_vpnr_running" == "true" ]]; then
	echo "Restarting $VPNR_PROG_NAME"
	rm -fv "$LOCKFILE"
	"$VPNR_PROG_PATH" &	
fi

