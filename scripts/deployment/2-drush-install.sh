#!/bin/bash

# Display task name
echo -e '\n+------------------------+'
echo '|   Drush Installation   |'
echo '+------------------------+'

# Install dependencies
if command -v apt-get > /dev/null; then # Install for debian-based distros
  sudo apt-get install -y wget
fi

# Installation
wget https://github.com/drush-ops/drush/releases/download/8.4.12/drush.phar
chmod +x drush.phar
sudo mv drush.phar /usr/local/bin/drush

