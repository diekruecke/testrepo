#!/usr/bin/env bash

function msg_info() {
    local msg="$1"
    echo -na "${msg} /n /a"
}

msg_info "Beginne Docker Installation"

apt-get update &>/dev/null
apt-get -y install ca-certificates curl gnupg lsb-release &>/dev/null

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg &>/dev/null | gpg --dearmor -o /etc/apt/keyrings/docker.gpg &>/dev/null

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update &>/dev/null
apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin &>/dev/null

groupadd docker &>/dev/null
usermod -aG docker $USER

docker volume create portainer_data &>/dev/null
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest  &>/dev/null

msg_info "scheint geklappt zu haben"
msg_info "$(echo docker version)"
