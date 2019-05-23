## Tuleap All In One ##
FROM centos:7

EXPOSE 22 80 443

ENV MYSQL_ROOT_PASSWORD=welcome0

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
    tuleap-theme-burningparrot \
    tuleap-theme-flamingparrot && \
    sed -i -e 's/\[embedded\]//' /etc/opt/rh/rh-mysql57/my.cnf.d/rh-mysql57-mysql-server.cnf && \
    echo 'sql-mode="NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"' >> /etc/opt/rh/rh-mysql57/my.cnf.d/rh-mysql57-mysql-server.cnf && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/inet_interfaces = localhost/inet_interfaces = all/' /etc/postfix/main.cf && \
    rm -f /home/codendiadm/.ssh/id_rsa_gl-adm* /var/lib/gitolite/.ssh/authorized_keys

# https://www.projectatomic.io/blog/2014/09/running-syslog-within-a-docker-container/
# https://github.com/rsyslog/rsyslog-docker/blob/master/base/centos7/Dockerfile
RUN rm -f /etc/rsyslog.d/listen.conf
COPY rsyslog.conf /etc/rsyslog.conf

COPY ./supervisor.d/*.ini /etc/supervisord.d/

COPY *.sh /usr/local/bin/

CMD [ "/usr/local/bin/run.sh" ]

ENV TLP_SYSTEMCTL=docker-centos7

# # python-pip is from epel, so it has to be installed after epel-release
# RUN yum install -y mysql-server \
#     epel-release \
#     centos-release-scl \
#     postfix \
#     openssh-server \
#     rsyslog \
#     passwd \
#     cronie && \
#     yum install -y supervisor && \
#     yum clean all

# # Gitolite will not work out-of-the-box with an error like
# # "User gitolite not allowed because account is locked"
# # Given http://stackoverflow.com/a/15761971/1528413 you might want to trick
# # /etc/shadown but the following pam modification seems to do the trick too
# # It's better for as as it can be done before installing gitolite, hence
# # creating the user.
# # I still not understand why it's needed (just work without comment or tricks
# # on a fresh centos install)

# # Second sed is for cron
# # Cron: http://stackoverflow.com/a/21928878/1528413

# # Third sed if for epel dependencies, by default php-pecl-apcu provides
# # php-pecl-apc but we really want apc not apcu

# RUN sed -i '/session    required     pam_loginuid.so/c\#session    required     pam_loginuid.so' /etc/pam.d/sshd && \
#     sed -i '/session    required   pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/crond && \
#     sed -i '/\[main\]/aexclude=php-pecl-apcu' /etc/yum.conf && \
#     /sbin/service sshd start && \
#     rpm --rebuilddb && \
#     yum install -y \
#     --exclude="tuleap-plugin-referencealias*, tuleap-plugin-im, tuleap-plugin-forumml, tuleap-plugin-fulltextsearch, tuleap-plugin-fusionforge_compat, tuleap-plugin-git, tuleap-plugin-proftpd, tuleap-plugin-tracker-encryption, tuleap-plugin-webdav, tuleap-core-mailman, tuleap-core-cvs" \
#     tuleap-install \
#     tuleap-plugin-* \
#     tuleap-theme-flamingparrot \
#     tuleap-theme-burningparrot \
#     tuleap-documentation \
#     tuleap-customization-default \
#     tuleap-api-explorer && \
#     yum clean all && \
#     sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config && \
#     sed -i 's/inet_interfaces = localhost/inet_interfaces = all/' /etc/postfix/main.cf && \
#     rm -f /etc/ssh/ssh_host_* && \
#     rm -f /etc/ssl/certs/localhost.crt /etc/pki/tls/private/localhost.key && \
#     rm -f /home/codendiadm/.ssh/id_rsa_gl-adm* /var/lib/gitolite/.ssh/authorized_keys

# VOLUME [ "/data" ]

# EXPOSE 22 80 443

# CMD ["/usr/share/tuleap/tools/docker/tuleap-aio/run.sh"]
