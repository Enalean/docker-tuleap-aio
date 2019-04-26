#!/bin/bash

# Inspired from SystemD unit /usr/lib/systemd/system/rh-mysql57-mysqld.service

set -x
set -o errexit
set -o nounset
set -o pipefail

sudo -u mysql /usr/bin/scl enable rh-mysql57 -- /opt/rh/rh-mysql57/root/usr/libexec/mysql-check-socket
sudo -u mysql /usr/bin/scl enable rh-mysql57 -- /opt/rh/rh-mysql57/root/usr/libexec/mysqld --initialize-insecure --datadir=/var/opt/rh/rh-mysql57/lib/mysql --user=mysql
sudo -u mysql echo "5.7.24" >"/var/opt/rh/rh-mysql57/lib/mysql/mysql_upgrade_info"

# start to set password
sudo -u mysql /opt/rh/rh-mysql57/root/usr/libexec/mysqld-scl-helper enable rh-mysql57 -- /opt/rh/rh-mysql57/root/usr/libexec/mysqld --daemonize --basedir=/opt/rh/rh-mysql57/root/usr --pid-file=/var/run/rh-mysql57-mysqld/mysqld.pid
sleep 2
scl enable rh-mysql57 -- mysqladmin -u root password $MYSQL_ROOT_PASSWORD

