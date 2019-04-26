#!/bin/bash

set -x
set -o errexit
set -o nounset
set -o pipefail

if [ ! -d /var/opt/rh/rh-mysql57/lib/mysql/mysql ]; then
    /usr/local/bin/mysql-init.sh

    sudo -u mysql /opt/rh/rh-mysql57/root/usr/libexec/mysqld-scl-helper enable rh-mysql57 -- /opt/rh/rh-mysql57/root/usr/libexec/mysqld --basedir=/opt/rh/rh-mysql57/root/usr --pid-file=/var/run/rh-mysql57-mysqld/mysqld.pid &

    sed -i -e 's%/usr/bin/systemctl%/usr/bin/true%' /usr/share/tuleap/tools/setup/el7/include/define.sh
    /usr/share/tuleap/tools/setup.el7.sh -y --server-name=tuleap.local --mysql-server=localhost --mysql-password=${MYSQL_ROOT_PASSWORD}

    scl enable rh-mysql57 -- mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown
fi

exec /usr/bin/supervisord --nodaemon --configuration /etc/supervisord.conf
