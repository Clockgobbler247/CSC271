#!/bin/bash

# Secure the DNS settings
sudo groupadd dns
sudo usermod -aG dnseditor dns 
sudo chown -R root:dns etc/bind/
sudo chmod -R 770 /etc/bind/

