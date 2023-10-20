#!/bin/bash

# Display task name
echo -e '\n+----------------------+'
echo '|   Custom DNS Setup   |'
echo '+----------------------+'

# Get the name of network interface that is UP
interfacename=$(ip link show | grep 'state UP' | awk '{print $2}' | awk -F ':' '{print $1}')

# Install dependencies
sudo apt-get update && sudo apt-get -y install resolvconf

# Setup
sudo sed -i "$ a nameserver 1.1.1.1" /etc/resolvconf/resolv.conf.d/head

# Deactivate network interface
sudo ifdown $interfacename

# Reactivate network interface
sudo ifup $interfacename
