#!/usr/bin/env bash

# Display task name
echo -e '\n+----------------+'
echo '|   Base Setup   |'
echo '+----------------+'

# Read php version
if command -v apt-cache > /dev/null; then
  php_version=$(apt-cache show php | grep version | awk '{print $4}' | awk -F ')' '{print $1}')
fi

# Read memory limit
if [[ -z ${memorylimit} ]]; then # Checking if memory limit is not already read
  . ../../functions/_input_memory_limit.sh
  _input_memory_limit
fi

# Install and setup apache and dependencies
if command -v apt-get > /dev/null; then # Install for debian-based distros
  sudo apt-get -y install apache2 libapache2-mod-php
fi
cd /etc/apache2/mods-enabled && sudo ln -s ../mods-available/rewrite.load
sudo sed -i '$i<Directory /var/www/html>\n   Options Indexes FollowSymLinks MultiViews\n   AllowOverride All\n   Order allow,deny\n   allow from all\n</Directory>' /etc/apache2/sites-available/000-default.conf

# Install and setup php and dependencies
if command -v apt-get > /dev/null; then # Install for debian-based distros
  sudo apt-get -y install php phppgadmin php-apcu php-cli php-curl php-dev php-gd php-pgsql php-uploadprogress php-xml php"$php_version"-mbstring php"$php_version"-zip
fi

# Setup memory limit
sudo sed -i "/memory_limit/ c\memory_limit = $memorylimit\M" /etc/php/"$php_version"/apache2/php.ini

# Restart apache for the new configurations to take effect
sudo service apache2 restart

