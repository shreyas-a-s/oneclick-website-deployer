#!/bin/bash

# Display task name
echo '-----------------------'
echo '   Drush Installation   '
echo '-----------------------'

# Installation
wget https://github.com/drush-ops/drush/releases/download/8.4.12/drush.phar
chmod +x drush.phar
sudo mv drush.phar /usr/local/bin/drush
