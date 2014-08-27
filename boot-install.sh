#!/bin/bash

set -e

function generate_passwd {
   cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 15 | head -1
}

mkdir -p /data/etc/httpd/
mkdir -p /data/home
mkdir -p /data/lib
mkdir -p /data/etc/logrotate.d
mkdir -p /data/root && chmod 700 /data/root

pushd . > /dev/null
cd /var/lib
mv /var/lib/mysql /data/lib && ln -s /data/lib/mysql mysql
[ -d /var/lib/gitolite ] && mv /var/lib/gitolite /data/lib && ln -s /data/lib/gitolite gitolite
popd > /dev/null

# Apply tuleap patches (should be temporary until integrated upstream)
pushd . > /dev/null
cd /usr/share/tuleap
/bin/ls /root/app/patches/*.patch | while read patch; do
    patch -p1 -i $patch
done
popd > /dev/null

# Install Tuleap
bash ./setup.sh --disable-selinux --sys-default-domain=$VIRTUAL_HOST --sys-org-name=Tuleap --sys-long-org-name=Tuleap

# Setting root password
root_passwd=$(generate_passwd)
echo "root:$root_passwd" |chpasswd
echo "root: $root_passwd" >> /root/.tuleap_passwd

# Place for post install stuff
./boot-postinstall.sh

# Create fake file to avoid error below when moving
touch /etc/aliases.codendi

# Ensure system will be synchronized ASAP
/usr/share/tuleap/src/utils/php-launcher.sh /usr/share/tuleap/src/utils/launch_system_check.php

service mysqld stop
service httpd stop
service crond stop

### Move all generated files to persistant storage ###

# Conf
mv /etc/httpd/conf            /data/etc/httpd
mv /etc/httpd/conf.d          /data/etc/httpd
mv /etc/tuleap                /data/etc
mv /etc/aliases               /data/etc
mv /etc/aliases.codendi       /data/etc
mv /etc/logrotate.d/httpd     /data/etc/logrotate.d
mv /etc/libnss-mysql.cfg      /data/etc
mv /etc/libnss-mysql-root.cfg /data/etc
mv /etc/my.cnf                /data/etc
mv /etc/nsswitch.conf         /data/etc
mv /etc/crontab               /data/etc
mv /etc/passwd                /data/etc
mv /etc/shadow                /data/etc
mv /etc/group                 /data/etc
mv /root/.tuleap_passwd       /data/root

# Data
mv /home/groups    /data/home
mv /home/users     /data/home
mv /home/codendiadm /data/home
mv /var/lib/tuleap /data/lib

# Will be restored by boot-fixpath.sh later
[ -h /var/lib/mysql ] && rm /var/lib/mysql
[ -h /var/lib/gitolite ] && rm /var/lib/gitolite
