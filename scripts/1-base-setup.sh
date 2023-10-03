#!/bin/bash

# Display task name
echo -e '\n+----------------+'
echo '|   Base Setup   |'
echo '+----------------+'

# Variables
phpversion=$(apt show php | awk 'NR==2{print $2}' | awk -F ':' '{print $2}' | awk -F '+' '{print $1}')

# Get user input
if [[ -z ${memorylimit} ]]; then
	read -r -p "How much memory to allocate to the website (in MB)? " memorylimit
fi

# Installation
sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y install apache2 php php-dev php-cli libapache2-mod-php php"$phpversion"-mbstring php-pgsql php-gd php-xml php-curl php-apcu php-uploadprogress phppgadmin wget
cd /etc/apache2/mods-enabled && sudo ln -s ../mods-available/rewrite.load
sudo sed -i '$i<Directory /var/www/html>\n   Options Indexes FollowSymLinks MultiViews\n   AllowOverride All\n   Order allow,deny\n   allow from all\n</Directory>' /etc/apache2/sites-available/000-default.conf
sudo sed -i "/memory_limit/ c\memory_limit = $memorylimit\M" /etc/php/"$phpversion"/apache2/php.ini
sudo service apache2 restart
