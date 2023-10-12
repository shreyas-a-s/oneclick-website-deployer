#!/bin/bash

# Variables
phpversion=$(apt-cache show php | grep version | awk '{print $4}' | awk -F ')' '{print $1}')

# Display task name
echo -e '\n+------------------------+'
echo '|   Drush Installation   |'
echo '+------------------------+'

# Installation
wget https://github.com/drush-ops/drush/releases/download/8.4.12/drush.phar
chmod +x drush.phar
sudo mv drush.phar /usr/local/bin/drush

# Fix for "The PHP error_log at  is not writable!"
sudo touch /var/log/php-errors.log
sudo chown $USER /var/log/php-errors.log
sudo sed -i "/error_log\ =\ php/ c\error_log\ =\ /var/log/php-errors.log" /etc/php/"$phpversion"/cli/php.ini
