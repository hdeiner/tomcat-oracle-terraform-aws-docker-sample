#!/usr/bin/env bash

# First, add the GPG key for the official Docker repository to the system:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add the Docker repository to APT sources:
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Next, update the package database with the Docker packages from the newly added repo:
sudo apt-get -qq update

# Finally, install Docker:
sudo apt-get -qq install -y docker-ce

# Start up private Docker registry image for MSSQLSVR
sudo docker network create dockernet
echo Create a fresh Docker Oracle container
sudo docker run \
    -d -p 1521:1521 -p 8080:8080 -e ORACLE_ALLOW_REMOTE=true \
    --name oraclesample  \
    alexeiled/docker-oracle-xe-11g &>/dev/null

echo "Waiting for Oracle to start"
fifo=/tmp/tmpfifo.$$
mkfifo "${fifo}" || exit 1
sudo docker logs oraclesample --follow >${fifo} &
dockerpid=$!
grep -m 1 "Oracle started successfully!" "${fifo}"
sudo kill -9 "${dockerpid}"
rm "${fifo}"
