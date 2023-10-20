#!/bin/bash

# Display task name
echo -e '\n+----------------------+'
echo '|   Custom DNS Setup   |'
echo '+----------------------+'

function _activate() {

    # Install dependencies
    sudo apt-get update && sudo apt-get -y install resolvconf

    # Setup
    sudo cp /etc/resolvconf/resolv.conf.d/head /etc/resolvconf/resolv.conf.d/head.bak
    sudo sed -i "$ a nameserver 1.1.1.1" /etc/resolvconf/resolv.conf.d/head

}

function _deactivate() {

    sudo rm /etc/resolvconf/resolv.conf.d/head
    sudo mv /etc/resolvconf/resolv.conf.d/head.bak /etc/resolvconf/resolv.conf.d/head

}

# Get the name of network interface that is UP
interfacename=$(ip link show | grep 'state UP' | awk '{print $2}' | awk -F ':' '{print $1}')

# Actual invocation
case "$1" in
    -activate)
        _activate
        ;;

    -deactivate)
        _deactivate
        ;;
esac

# Deactivate network interface
sudo ifdown "$interfacename"

# Reactivate network interface
sudo ifup "$interfacename"