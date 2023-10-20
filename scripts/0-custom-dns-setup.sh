#!/bin/bash

# Display task name
echo -e '\n+----------------------+'
echo '|   Custom DNS Setup   |'
echo '+----------------------+'

function _activate() {

    # Get the name of network interface that is UP
    interfacename=$(ip link show | grep 'state UP' | awk '{print $2}' | awk -F ':' '{print $1}')

    # Install dependencies
    sudo apt-get update && sudo apt-get -y install resolvconf

    # Setup
    sudo sed -i "$ a nameserver 1.1.1.1" /etc/resolvconf/resolv.conf.d/head

    # Deactivate network interface
    sudo ifdown "$interfacename"

    # Reactivate network interface
    sudo ifup "$interfacename"

}

function _deactivate() {

    sudo apt-get -y purge resolvconf && sudo apt-get -y autoremove
    
}

case "$1" in
    -activate)
        _activate
        ;;

    -deactivate)
        _deactivate
        ;;
esac