#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "INSTALLING - DRUSH"
fi

# Install dependencies
if command -v apt-get > /dev/null; then # Install for debian-based distros
  sudo apt-get install -y wget
fi

# Install drush
wget https://github.com/drush-ops/drush/releases/download/8.4.12/drush.phar
chmod +x drush.phar
sudo mv drush.phar /usr/local/bin/drush

