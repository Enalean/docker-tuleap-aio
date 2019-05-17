#!/bin/bash

set -x
set -o errexit
set -o nounset
set -o pipefail

if [ ! -d /var/opt/rh/rh-mysql57/lib/mysql/mysql ]; then
    /usr/local/bin/mysql-init.sh

    sed -i -e 's%/usr/bin/systemctl%/usr/bin/true%' /usr/share/tuleap/tools/setup/el7/include/define.sh
    /usr/share/tuleap/tools/setup.el7.sh -y --server-name=tuleap.local --mysql-server=localhost --mysql-password=${MYSQL_ROOT_PASSWORD}

    scl enable rh-mysql57 -- mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown
    while kill -0 $(cat /var/run/rh-mysql57-mysqld/mysqld.pid); do
        sleep 1
    done
fi

exec /usr/bin/supervisord --nodaemon --configuration /etc/supervisord.conf
