#!/bin/bash

# Variables
sed -i '$a\DRUPAL_HOME=/var/www/html' ~/.bashrc && DRUPAL_HOME=/var/www/html

# Display task name
echo '-------------------------------'
echo '   Tripal_Daemon Installation   '
echo '-------------------------------'

# Get user input
read -r -p "Enter the name of the directory in which drupal website was installed: " drupalsitedir

# Installation
drush pm-download libraries -y
drush pm-enable libraries -y
wget -O "$DRUPAL_HOME"/"$drupalsitedir"/sites/all/libraries/PHP-Daemon.tar.gz https://github.com/shaneharter/PHP_Daemon/archive/v2.0.tar.gz
tar -zxvf "$DRUPAL_HOME"/"$drupalsitedir"/sites/all/libraries/PHP-Daemon.tar.gz
drush pm-download drushd -y
drush pm-enable drushd tripal_daemon -y

# Start the Daemon
drush trpjob-daemon start
drush trpjob-daemon status
