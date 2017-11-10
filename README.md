Docker-Tuleap
==============

Deploy a Tuleap inside a docker container

More info about Tuleap on [tuleap.org](https://www.tuleap.org)

How to use it?
---------------

First run:

    $> docker volume create --name tuleap-data
    $> docker run -ti -e VIRTUAL_HOST=localhost -p 80:80 -p 443:443 -p 22:22 -v tuleap-data:/data enalean/tuleap-aio

Will run the container, just open http://localhost and enjoy!

You can get the site administrator credentials to log in the first time with:

    $> docker exec -ti <container_name> cat /data/root/.tuleap_passwd

On other, regular runs:

    $> docker run -ti -e VIRTUAL_HOST=localhost -p 80:80 -p 443:443 -p 22:22 -v tuleap-data:/data enalean/tuleap-aio


Known issues
------------

* SELinux stuff seems not behaving well (raises errors on docker build)
