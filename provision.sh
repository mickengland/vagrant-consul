#!/bin/bash

# Set variables
consul_version=0.8.3
export DEBIAN_FRONTEND=noninteractive

# Upgrade packages and instal utilities
apt-get update
apt-get upgrade -y
apt-get install -y unzip
 
# Copy the upstart script
cp /vagrant/consul.conf /etc/init/consul.conf
cp /vagrant/consul.service /etc/systemd/system/consul.service
 
# Get the consul binary
cd /usr/local/bin
wget -q https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip

unzip *.zip
rm *.zip
 
# Make the Consul directory.
mkdir -p /etc/consul.d
mkdir -p /var/consul
 
# Copy the server configuration.
cp $1 /etc/consul.d/config.json
 
# Enable and Start Consul with UI
sudo systemctl enable consul.service
sudo service consul start
