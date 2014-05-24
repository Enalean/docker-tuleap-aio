## Tuleap All In One ##

## Re-use tuleap base for caching ##
FROM enalean/docker-tuleap-base:1.0

MAINTAINER Manuel Vacelet, manuel.vacelet@enalean.com

# Update to last version
RUN yum -y update; yum clean all

RUN rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
RUN rpm -i http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
ADD rpmforge.repo /etc/yum.repos.d/

RUN yum install -y mysql-server; yum clean all

ADD Tuleap.repo /etc/yum.repos.d/
RUN yum install -y tuleap-install; yum clean all
RUN yum install -y tuleap-core-subversion; yum clean all
RUN yum install -y tuleap-plugin-agiledashboard; yum clean all
RUN yum install -y tuleap-plugin-hudson; yum clean all
RUN yum install -y tuleap-theme-flamingparrot; yum clean all
RUN yum install -y tuleap-plugin-graphontrackers; yum clean all
RUN yum install -y tuleap-customization-default; yum clean all
RUN yum install -y tuleap-documentation; yum clean all
RUN yum install -y restler-api-explorer; yum clean all

RUN yum install -y sudo; yum clean all
RUN /sbin/service sshd start && yum install -y --enablerepo=rpmforge-extras tuleap-plugin-git; yum clean all

RUN yum install -y rsyslog; yum clean all

ADD supervisord.conf /etc/supervisord.conf

ADD . /root/app
WORKDIR /root/app

VOLUME [ "/data" ]

EXPOSE 22 80

CMD ["/root/app/run.sh"]
