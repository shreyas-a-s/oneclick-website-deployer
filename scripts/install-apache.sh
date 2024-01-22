#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "INSTALLING - APACHE"
fi

# Install apache
if command -v apt-get > /dev/null; then # Install for debian-based distros
  sudo apt-get -y install apache2 libapache2-mod-php
fi

# Setup apache
cd /etc/apache2/mods-enabled || exit
sudo ln -s ../mods-available/rewrite.load # Enable Rewrite module for apache
sudo sed -i "\$i<Directory $DRUPAL_HOME>\n   Options Indexes FollowSymLinks MultiViews\n   AllowOverride All\n   Order allow,deny\n   allow from all\n</Directory>" /etc/apache2/sites-available/000-default.conf # Set web root directory

# Restart apache for the new configurations to take effect
sudo service apache2 restart

