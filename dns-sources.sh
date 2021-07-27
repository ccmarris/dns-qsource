#!/bin/sh
#######################################
# Output apparent source IPs of queries
# Author: Chris Marrison, John Neerdael
# Last Modified: 20210727
# v0.1.0
#######################################

EXITCODE=0

# If no arguments provided Try and determine DNS server from local resolver
B1TD=${1:-`grep nameserver /etc/resolv.conf | head -1 | cut -d" " -f2`}

LOCAL=${2:-8.8.8.8}
QUERY=${3:-o-o.myaddr.l.google.com}
QTYPE=${4:-txt}

# Attempt to get source IP via DNS Server
SIP=`dig @${B1TD} ${QUERY} ${QTYPE} +short | tr -d '"'`
# Check exitcode
if [ $? == 0 ]
then
	# Output results and Geo data from ip-api.com
	echo "B1TD DNS Source: $SIP"
	curl http://ip-api.com/csv/${SIP}

	LIP=`dig @${LOCAL} ${QUERY} ${QTYPE} +short | sed '/^"edns0/d' | tr -d '"'`
	# Check exitcode
	if [ $? == 0 ]
	then
		# Output results and Geo data from ip-api.com
		echo "Google/Local DNS Source: $LIP"
		curl http://ip-api.com/csv/${LIP}
	else
		echo "Problem querying ${LOCAL}"
		EXITCODE=2
	fi
	
else
	echo "Problem querying ${B1TD}"
	EXITCODE=1
fi

exit $EXITCODE
