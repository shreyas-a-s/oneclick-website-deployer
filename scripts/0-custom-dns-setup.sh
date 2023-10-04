#!/bin/bash

# Display task name
echo -e '\n+----------------------+'
echo '|   Custom DNS Setup   |'
echo '+----------------------+'

# Install dependencies
sudo apt-get update && sudo apt-get -y install resolvconf

# Setup
sudo sed -i "$ a nameserver 1.1.1.1" /etc/resolvconf/resolv.conf.d/head

# End
echo "Reboot the system for new DNS settings to take effect."