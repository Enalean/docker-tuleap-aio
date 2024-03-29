## Tuleap All In One ##
FROM centos:7

EXPOSE 22 80 443

ENV MYSQL_ROOT_PASSWORD=welcome0
ENV TLP_SYSTEMCTL=docker-centos7

COPY Tuleap.repo /etc/yum.repos.d/

# initscripts is implicit dependency of openssh-server for ssh-keygen (/etc/rc.d/init.d/functions)

RUN /usr/sbin/groupadd -g 900 -r codendiadm && \
    /usr/sbin/groupadd -g 902 -r gitolite && \
    /usr/sbin/groupadd -g 903 -r dummy && \
    /usr/sbin/groupadd -g 904 -r ftpadmin && \
    /usr/sbin/groupmod -g 50  ftp && \
    /usr/sbin/useradd -u 900 -c 'Tuleap user' -m -d '/var/lib/tuleap' -r -g "codendiadm" -s '/bin/bash' -G ftpadmin,gitolite codendiadm && \
    /usr/sbin/useradd -u 902 -c 'Git' -m -d '/var/lib/gitolite' -r -g gitolite gitolite && \
    /usr/sbin/useradd -u 903 -c 'Dummy Tuleap User' -M -d '/var/lib/tuleap/dumps' -r -g dummy dummy && \
    /usr/sbin/useradd -u 904 -c 'FTP Administrator' -M -d '/var/lib/tuleap/ftp' -r -g ftpadmin ftpadmin && \
    /usr/sbin/usermod -u 14 -c 'FTP User' -d '/var/lib/tuleap/ftp' -g ftp ftp && \
    yum install -y epel-release centos-release-scl sudo https://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum install -y \
    cronie \
    initscripts \
    openssh-server \
    postfix \
    rsyslog \
    supervisor \
    rh-mysql57-mysql-server \
    tuleap-plugin-tracker \
    tuleap-plugin-agiledashboard \
    tuleap-plugin-git \
    tuleap-plugin-pullrequest \
    tuleap-plugin-gitlab \
    tuleap-plugin-plugin-embed \
    tuleap-plugin-hudson-git \
    tuleap-plugin-frs \
    tuleap-plugin-docman \
    tuleap-plugin-api-explorer \
    tuleap-plugin-svn \
    tuleap-theme-burningparrot \
    tuleap-theme-flamingparrot && \
    localedef -i fr_FR -c -f UTF-8 fr_FR.UTF-8 && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config # Need to keep this one so image scanner are happy

RUN echo 'INSERT INTO platform_banner(importance, message) VALUES ("critical", "This platform is based on docker image <a href=https://hub.docker.com/r/enalean/tuleap-aio>enalean/tuleap-aio</a> that is no longer maintained. Please report this issue to Tuleap admins and check <a href=https://hub.docker.com/r/tuleap/tuleap-community-edition>new docker image</a>");' >> /usr/share/tuleap/src/db/mysql/database_initvalues.sql

COPY 202106161700_tuleap_aio_end_of_maintenance.php /usr/share/tuleap/src/db/mysql/updates/2021/202106161700_tuleap_aio_end_of_maintenance.php

CMD [ "/usr/bin/tuleap-cfg", "docker:tuleap-aio-run" ]
