#!/bin/bash

# Display task name
echo '---------------'
echo '   Base Setup   '
echo '---------------'

# Variables
phpversion=$(apt-get -qq show php | awk 'NR==2{print $2}' | awk -F ':' '{print $2}' | awk -F '+' '{print $1}')

# Get user input
read -r -p "How much memory to allocate to the website (in MB)? " memorylimit

# Installation
sudo apt-get -qq update && sudo apt-get -qq upgrade -y && sudo apt-get -qq install apache2 php php-dev php-cli libapache2-mod-php php"$phpversion"-mbstring php-pgsql php-gd php-xml php-curl php-apcu php-uploadprogress phppgadmin wget -y
cd /etc/apache2/mods-enabled && sudo ln -s ../mods-available/rewrite.load
sudo sed -i '$i<Directory /var/www/html>\n   Options Indexes FollowSymLinks MultiViews\n   AllowOverride All\n   Order allow,deny\n   allow from all\n</Directory>' /etc/apache2/sites-available/000-default.conf
sudo sed -i "/memory_limit/ c\memory_limit = $memorylimit\M" /etc/php/"$phpversion"/apache2/php.ini
sudo service apache2 restart
