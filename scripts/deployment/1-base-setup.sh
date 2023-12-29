#!/usr/bin/env bash

# Display task name
echo -e '\n+----------------+'
echo '|   Base Setup   |'
echo '+----------------+'

# Install dependencies
if command -v apt-get > /dev/null; then # Install for debian-based distros
  sudo apt-get -y install apache2 libapache2-mod-php # Install apache
  php_version=$(apt-cache show php | grep version | awk '{print $4}' | awk -F ')' '{print $1}') # Store php version into a variable
  sudo apt-get -y install php phppgadmin php-apcu php-cli php-curl php-dev php-gd php-pgsql php-uploadprogress php-xml php"$php_version"-mbstring php"$php_version"-zip # Install php
fi

# Setup the system
cd /etc/apache2/mods-enabled || exit
sudo ln -s ../mods-available/rewrite.load # Enable Rewrite module for apache
sudo sed -i '$i<Directory /var/www/html>\n   Options Indexes FollowSymLinks MultiViews\n   AllowOverride All\n   Order allow,deny\n   allow from all\n</Directory>' /etc/apache2/sites-available/000-default.conf # Set web root directory
sudo sed -i "/memory_limit/ c\memory_limit = $memorylimit\M" /etc/php/"$php_version"/apache2/php.ini # Set max amount of RAM a PHP script can consume
sudo touch /var/log/php-errors.log # Fix for "The PHP error_log at  is not writable!"
sudo sed -i "/error_log\ =\ php/ c\error_log\ =\ /var/log/php-errors.log" /etc/php/"$php_version"/cli/php.ini

# Restart apache for the new configurations to take effect
sudo service apache2 restart

