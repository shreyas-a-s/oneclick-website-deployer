#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "INSTALLING - PHP"
fi

# Install php
if command -v apt-get > /dev/null; then # Install for debian-based distros
  php_version=$(apt-cache show php | grep version | awk '{print $4}' | awk -F ')' '{print $1}') # Store php version into a variable
  sudo apt-get -y install libapache2-mod-php php phppgadmin php-apcu php-cli php-curl php-dev php-gd php-pgsql php-uploadprogress php-xml php"$php_version"-mbstring php"$php_version"-zip
fi

# Set max RAM a PHP script can consume
sudo sed -i "/memory_limit/ c\memory_limit = $memorylimit\M" /etc/php/"$php_version"/apache2/php.ini

# Fix for "The PHP error_log at  is not writable!"
sudo touch /var/log/php-errors.log
sudo sed -i "/error_log\ =\ php/ c\error_log\ =\ /var/log/php-errors.log" /etc/php/"$php_version"/cli/php.ini

# Restart apache for the new configurations to take effect
sudo service apache2 restart

