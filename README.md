# Docker image for Tuleap

Deploy a Tuleap inside a docker container

More info about Tuleap on [tuleap.org](https://www.tuleap.org)

# How to use it

## Standalone container directly from the docker hub

First run:

    $> docker volume create --name tuleap-data
    $> docker run -ti -e VIRTUAL_HOST=localhost -p 80:80 -p 443:443 -p 22:22 -v tuleap-data:/data enalean/tuleap-aio

Will run the container, just open http://localhost and enjoy!

You can get the site administrator credentials to log in the first time with:

    $> docker exec -ti <container_name> cat /data/root/.tuleap_passwd

On other, regular runs:

    $> docker run -ti -e VIRTUAL_HOST=localhost -p 80:80 -p 443:443 -p 22:22 -v tuleap-data:/data enalean/tuleap-aio

## Using docker-compose

First you need to clone the git repository.

     $> git clone https://github.com/Enalean/docker-tuleap-aio tuleap-aio
     $> cd tuleap-aio

Set a mysql root password in environment:

     $> export MYSQL_ROOT_PASSWORD=$(cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 15 | head -1)

Then run:

     $> docker-compose up

It will create everything needed then will wait after a ``Starting Tuleap: [OK]``

You can open [https://localhost](https://localhost) and login with site admin password you will get with

     $> docker-compose exec tuleap cat /data/root/.tuleap_passwd
