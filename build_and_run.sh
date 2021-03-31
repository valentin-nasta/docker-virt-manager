#!/bin/zsh
docker build -t valentin/virt-manager .

#docker run --rm --name virt-manager-app  valentin/virt-manager
docker stop virt-manager-app && docker rm virt-manager-app

    #--add-host='captain.voipfuture.com:192.168.50.156' \
docker run -d \
    --name=virt-manager-app \
    -p 5800:5800 \
    -p 5900:5900 \
    -v /Users/vmbp/work/docker/appdata:/config:rw \
    -v /dev/urandom:/dev/urandom:ro \
    -v /etc/ssh/ssh_config:/etc/ssh/ssh_config:ro \
    -v ~/.ssh/id_ed25519:/root/.ssh/id_ed25519:ro \
    -v ~/.ssh/known_hosts:/root/.ssh/known_hosts:ro \
    -e USER_ID=501 \
    -e GROUP_ID=20 \
    valentin/virt-manager
