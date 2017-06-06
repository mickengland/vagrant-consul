#!/bin/bash

# Set variables
consul_version=0.8.3
vault_version=0.7.2
export DEBIAN_FRONTEND=noninteractive

# Upgrade packages and install utilities
apt-get update
apt-get upgrade -y
apt-get install -y unzip
 
# Copy the systemd scripts
cp /vagrant/consul.conf /etc/init/consul.conf
cp /vagrant/consul.service /etc/systemd/system/consul.service
cp /vagrant/vault.service /etc/systemd/system/vault.service

# Get the consul binaries
cd /usr/local/bin
wget -q https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip

unzip *.zip
rm *.zip
 
# Make the Consul directory.
mkdir -p /etc/consul.d
mkdir /var/consul
 
# Copy the server configuration.
cp $1 /etc/consul.d/config.json
 
# Enable and Start Consul with UI
sudo systemctl enable consul.service
sudo service consul start

# Copy vault configs
mkdir -p /etc/vault.d
cp /vagrant/vault.hcl /etc/vault.d/vault.hcl

# Copy ssl certs
mkdir -p /var/lib/vault/ssl
cp /vagrant/vault.crt /var/lib/vault/ssl/vault.crt
cp /vagrant/vault.key /var/lib/vault/ssl/vault.key
cat /var/lib/vault/ssl/vault.crt >> /etc/ssl/certs/ca-certificates.crt

# Get latest vault
cd /usr/local/bin
wget -q https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_linux_amd64.zip

unzip *.zip
rm *.zip

# Enable and Start Vault 
sudo systemctl enable vault.service
sudo service vault start

# Initialize the Vault
export VAULT_ADDR='https://127.0.0.1:8200'
vault init
