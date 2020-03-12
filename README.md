# Docker demo image for Tuleap

More info about Tuleap on [tuleap.org](https://www.tuleap.org)

This image is provided for demo & tests purpose. It's not meant for production.

# How to use it

To create a new container

    docker run --name tuleap-aio enalean/tuleap-aio:centos7

Get it's IP address

    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' tuleap-aio

Set this ip address for `tuleap.local` in your `/etc/hosts`

And open your browser to https://tuleap.local and accept the self-signed certificate.

You can log in with `admin` user and the site admin password you can find with

    docker exec tuleap-aio cat /root/.tuleap_passwd

## Options

### Mysql Password

The default setup comes with a lame password, you can override it with env `MYSQL_ROOT_PASSWORD`

### Persistant data

You can persist data with a data container set to /data. eg:

    docker run --name tuleap-aio -v demo-data:/data enalean/tuleap-aio:centos7

# Migration from centos6 image

If you had data on a centos6 based image you cannot run the centos7 image with those data.
It might be possible to do the migration but as it's a demo image, it shouldn't be necessary.

# Development

All the init sequence is now managed inside Tuleap sources, for developers that want to work on
it they should mount the sources like (from within Tuleap sources):

    docker run -ti --name tuleap-aio -v $PWD:/usr/share/tuleap enalean/tuleap-aio:centos7
