#!/bin/bash

if [ -f "$APACHE_PID_FILE" ]; then
	PID=`cat $APACHE_PID_FILE`
	ps --pid $PID|grep "apache2" > /tmp/status
	if [ -s "/tmp/status" ]; then
		exit 0
	fi
fi

exit 1
