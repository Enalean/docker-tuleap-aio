#!/bin/bash

set -e

# Starts the DB and upgrade the data
start_mysql() {
    echo "Start mysql"
    /usr/bin/python /usr/lib/python2.6/site-packages/supervisor/pidproxy.py /var/run/mysqld/mysqld.pid /usr/bin/mysqld_safe &
    sleep 1
    while ! mysql -ucodendiadm -p$(egrep '^\$sys_dbpasswd' /etc/tuleap/conf/database.inc | sed -e 's/^\$sys_dbpasswd="\(.*\)";$/\1/') -e "show databases" >/dev/null; do
	echo "Wait for the db"
	sleep 1
    done
}

# Stop Mysql
stop_mysql() {
    echo "Stop mysql"
    PID=$(cat /var/run/mysqld/mysqld.pid)
    kill -15 $PID
    while ps -p $PID >/dev/null 2>&1; do
	echo "Waiting for mysql ($PID) to stop"
	sleep 1
    done
}
