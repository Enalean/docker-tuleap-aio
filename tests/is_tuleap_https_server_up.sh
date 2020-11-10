#!/bin/bash

set -euxo pipefail

/usr/bin/tuleap-cfg docker:tuleap-aio-run &

is_server_ready() {
    while : ; do
        echo "Waiting on the server"
        sleep 1
        code=$(curl -k -s -o /dev/null -w "%{http_code}" --resolve tuleap.local:443:127.0.0.1 https://tuleap.local || true)
        [[ $code -ne 200 ]] || break
    done
}

is_server_ready

curl -k --resolve tuleap.local:443:127.0.0.1 https://tuleap.local | grep "Tuleap Community Edition"
