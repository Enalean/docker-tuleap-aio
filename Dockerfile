## Tuleap All In One ##
FROM centos:6

COPY Tuleap.repo /etc/yum.repos.d/

# python-pip is from epel, so it has to be installed after epel-release
RUN yum install -y mysql-server \
    epel-release \
    centos-release-scl \
    postfix \
    openssh-server \
    rsyslog \
    passwd \
    cronie && \
    yum install -y supervisor && \
    yum clean all

# Gitolite will not work out-of-the-box with an error like
# "User gitolite not allowed because account is locked"
# Given http://stackoverflow.com/a/15761971/1528413 you might want to trick
# /etc/shadown but the following pam modification seems to do the trick too
# It's better for as as it can be done before installing gitolite, hence
# creating the user.
# I still not understand why it's needed (just work without comment or tricks
# on a fresh centos install)

# Second sed is for cron
# Cron: http://stackoverflow.com/a/21928878/1528413

# Third sed if for epel dependencies, by default php-pecl-apcu provides
# php-pecl-apc but we really want apc not apcu

RUN sed -i '/session    required     pam_loginuid.so/c\#session    required     pam_loginuid.so' /etc/pam.d/sshd && \
    sed -i '/session    required   pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/crond && \
    sed -i '/\[main\]/aexclude=php-pecl-apcu' /etc/yum.conf && \
    /sbin/service sshd start && \
    rpm --rebuilddb && \
    yum install -y \
    tuleap-install-9.14 \
    tuleap-plugin-svn \
    tuleap-plugin-agiledashboard \
    tuleap-plugin-hudson \
    tuleap-plugin-hudson-git \
    tuleap-plugin-hudson-svn \
    tuleap-plugin-git-gitolite3 \
    tuleap-plugin-pullrequest \
    tuleap-plugin-mediawiki \
    tuleap-plugin-graphontrackers \
    tuleap-theme-flamingparrot \
    tuleap-theme-burningparrot \
    tuleap-documentation \
    tuleap-customization-default \
    tuleap-api-explorer && \
    yum clean all && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/inet_interfaces = localhost/inet_interfaces = all/' /etc/postfix/main.cf && \
    rm -f /etc/ssh/ssh_host_* && \
    rm -f /etc/ssl/certs/localhost.crt /etc/pki/tls/private/localhost.key && \
    rm -f /home/codendiadm/.ssh/id_rsa_gl-adm* /var/lib/gitolite/.ssh/authorized_keys

VOLUME [ "/data" ]

EXPOSE 22 80 443

CMD ["/usr/share/tuleap/tools/docker/tuleap-aio/run.sh"]
