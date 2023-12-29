#!/bin/bash

# Display task name
echo -e '\n+------------------------+'
echo '|   Drush Installation   |'
echo '+------------------------+'

# Install wget (dependency of this script)
if ! command -v wget > /dev/null; then
  ./components/install-wget.sh
fi

# Installation
wget https://github.com/drush-ops/drush/releases/download/8.4.12/drush.phar
chmod +x drush.phar
sudo mv drush.phar /usr/local/bin/drush

