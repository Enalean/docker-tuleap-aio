# Docker demo image for Tuleap

More info about Tuleap on [tuleap.org](https://www.tuleap.org)

**This image is under development**

# Todo

* cron for systemevents
  * Current status: depend on partial rewrite of cron management on Tuleap
  * Out of the box it won't process any kind of system events
* git (ssh & stuff)
* svn
* other plugins
* data volume

# How to use it

    # Build & Run
    docker build -t tuleap-aio-c7
    docker run --name tuleap-aio -ti --rm tuleap-aio-c7
    
    # Get IP and set for 'tuleap.local' in /etc/hosts
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' tuleap-aio
    