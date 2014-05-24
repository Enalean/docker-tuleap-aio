Docker-Tuleap
==============

Deploy a Tuleap inside a docker container

More info about Tuleap on [tuleap.org](http://www.tuleap.org)

How to use it?
---------------

Just install docker on your system as explained on the [docker](http://docker.io) website. Then run:

    $> docker run -ti -e VIRTUAL_HOST=localhost -p 80:80 -p 443:443 -p 22:22 -v /srv/docker/pink:/data enalean/tuleap-aio

Will run the container, just open http://localhost and enjoy !

Known issues
------------

* SELinux stuff seems not behaving well (raises errors on docker build)
