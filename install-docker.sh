#!/bin/bash
# uninstall all conflicting packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
# installation

# Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

# Install Docker Engine, Docker CLI, containerd.io, docker-buildx-plugin, and docker-compose-plugin
if [[ -z $version ]]; then
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
else
    version_string=$(apt-cache madison docker-ce | awk '{ print $3 }' | grep $version)
    if [[ ! $version =~ ^[0-9]{2}\.[0-9]{1,2}\.[0-9]{1,2}$ ]] || [[ -z $version_string ]]; then
        echo "Invalid version"
        exit 1
    fi
    sudo apt-get install docker-ce=$version_string docker-ce-cli=$version_string containerd.io docker-buildx-plugin docker-compose-plugin -y
fi

# Manage Docker as a non-root user
sudo usermod -aG docker $USER
newgrp docker

# Verify Docker installation by displaying the version
docker --version
docker compose version