#!/usr/bin/env bash

# First, add the GPG key for the official Docker repository to the system:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add the Docker repository to APT sources:
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Next, update the package database with the Docker packages from the newly added repo:
sudo apt-get -qq update

# Finally, install Docker:
sudo apt-get -qq install -y docker-ce

# Create a fresh Docker tomcatsample container
sudo docker network create dockernet
sudo docker run -d \
    -p 8080:8080 \
    --name tomcatsample --network dockernet \
    tomcat:9.0.8-jre8 &>/dev/null

# Pause 10 seconds to allow Tomcat to start up
sleep 10

# Deploy the war to Tomcat
sudo docker cp oracleConfig.properties tomcatsample:/usr/local/tomcat/webapps/oracleConfig.properties
sudo docker cp passwordAPI.war tomcatsample:/usr/local/tomcat/webapps/passwordAPI.war

# Pause 10 seconds to allow Tomcat to digest
sleep 10
