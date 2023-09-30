#!/bin/bash

# Variables
sed -i '$a\DRUPAL_HOME=/var/www/html' ~/.bashrc && DRUPAL_HOME=/var/www/html

# Take user choice before continuing
function continueORNot {
   read -r -p "Continue? (yes/no): " choice
   case "$choice" in 
     "yes" ) echo "Moving on to next step..";sleep 2;;
     "no" ) echo "Exiting.."; exit 1;;
     * ) echo "Invalid Choice! Keep in mind this is case-sensitive."; continueORNot;;
   esac
}

# Display task name
echo '------------------------'
echo '   Drupal Installation   '
echo '------------------------'

# Get user input
read -r -p "Enter the name of new directory to which drupal website needs to be installed: " drupalsitedir

# Installation
sudo chown -R "$USER" "$DRUPAL_HOME"
cd "$DRUPAL_HOME" || exit
mv index.html index.html.orig
wget http://ftp.drupal.org/files/projects/drupal-7.98.tar.gz
tar -zxvf drupal-7.98.tar.gz
mv drupal-7.98/ "$drupalsitedir"/
cp "$drupalsitedir"/sites/default/default.settings.php "$drupalsitedir"/sites/default/settings.php
mkdir "$drupalsitedir"/sites/default/files/
sudo chgrp www-data "$drupalsitedir"/sites/default/files/
sudo chmod 777 "$drupalsitedir"/sites/default/files/settings.php
sudo chmod g+rw "$drupalsitedir"/sites/default/files/
echo '---------------'
echo '   Site Setup   '
echo '---------------'
echo "Go to http://localhost/""$drupalsitedir""/install.php and complete initial setup of website by providing newly created database details, new site maintenance account details, etc"
echo "IMP NOTE: Make sure to note down site maintenance account username."
echo "After completing initial setup, come back and type 'yes' to continue."
continueORNot
sudo chmod 755 "$drupalsitedir"/sites/default/default.settings.php