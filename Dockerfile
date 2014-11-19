## Tuleap All In One ##
FROM centos:centos6

MAINTAINER Manuel Vacelet, manuel.vacelet@enalean.com

RUN rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
RUN rpm -i http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm http://mir01.syntis.net/epel/6/i386/epel-release-6-8.noarch.rpm

COPY rpmforge.repo Tuleap.repo /etc/yum.repos.d/

RUN yum install -y mysql-server \
    postfix \
    openssh-server \
    python-pip \
    sudo \
    rsyslog \
    cronie; \
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

RUN sed -i '/session    required     pam_loginuid.so/c\#session    required     pam_loginuid.so' /etc/pam.d/sshd && \
    sed -i '/session    required   pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/crond

# Need to depend on tuleap-core-cvs
RUN /sbin/service sshd start && yum install -y --enablerepo=rpmforge-extras \
    tuleap-install \
    tuleap-core-cvs \
    tuleap-core-subversion \
    tuleap-plugin-agiledashboard \
    tuleap-plugin-hudson \
    tuleap-plugin-git \
    tuleap-plugin-graphontrackers \
    tuleap-theme-flamingparrot \
    tuleap-documentation \
    tuleap-customization-default \
    restler-api-explorer; \
    yum clean all

RUN pip install pip --upgrade ; pip install supervisor

COPY supervisord.conf /etc/supervisord.conf

COPY . /root/app

WORKDIR /root/app

VOLUME [ "/data" ]

EXPOSE 22 80 443

CMD ["/root/app/run.sh"]
