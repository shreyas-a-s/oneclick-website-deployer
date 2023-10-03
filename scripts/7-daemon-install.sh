#!/bin/bash

# Variables
sed -i '$a\DRUPAL_HOME=/var/www/html' ~/.bashrc && DRUPAL_HOME=/var/www/html

# Display task name
echo -e '\n+--------------------------------+'
echo '|   Tripal_Daemon Installation   |'
echo '+--------------------------------+'

# Get user input
read -r -p "Enter the name of the directory in which drupal website was installed: " drupalsitedir

# Installation
cd "$DRUPAL_HOME"/"$drupalsitedir"/ || exit
drush pm-download libraries -y
drush pm-enable libraries -y
wget -O sites/all/libraries/PHP-Daemon.tar.gz https://github.com/shaneharter/PHP-Daemon/archive/v2.0.tar.gz
tar -zxvf sites/all/libraries/PHP-Daemon.tar.gz -C sites/all/libraries/
mv sites/all/libraries/PHP-Daemon-2.0 sites/all/libraries/PHP-Daemon
rm sites/all/libraries/PHP-Daemon.tar.gz
drush pm-download drushd -y
drush pm-enable drushd tripal_daemon -y

# Start the Daemon
drush trpjob-daemon start

# Set daemon to autostart during boot
echo "@reboot $USER /usr/local/bin/drush trpjob-daemon start --root=$DRUPAL_HOME/$drupalsitedir" | sudo tee /etc/cron.d/tripal-daemon-autostart > /dev/null
