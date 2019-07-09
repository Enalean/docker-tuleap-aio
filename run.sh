#!/bin/bash

set -x
set -o errexit
set -o nounset
set -o pipefail

# Init sshd server keys
if [ ! -f /etc/ssh/ssh_host_ecdsa_key ]; then
    /usr/sbin/sshd-keygen
fi

# Init mysql data store
if [ ! -d /var/opt/rh/rh-mysql57/lib/mysql/mysql ]; then
    /usr/local/bin/mysql-init.sh

    /usr/sbin/sshd # start ssh for git setup

    /usr/share/tuleap/tools/setup.el7.sh --assumeyes --configure --server-name=tuleap.local --mysql-server=localhost --mysql-password=${MYSQL_ROOT_PASSWORD}

    scl enable rh-mysql57 -- mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown
    while kill -0 $(cat /var/run/rh-mysql57-mysqld/mysqld.pid); do
        sleep 1
    done

    pkill -TERM sshd
fi

exec /usr/bin/supervisord --nodaemon --configuration /etc/supervisord.conf
