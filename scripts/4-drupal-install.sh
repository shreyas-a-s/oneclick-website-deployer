#!/bin/bash

# Variables
sed -i '$a\DRUPAL_HOME=/var/www/html' ~/.bashrc && DRUPAL_HOME=/var/www/html

# Display task name
echo -e '\n+-------------------------+'
echo '|   Drupal Installation   |'
echo '+-------------------------+'

# Get user input
if [[ -z ${drupalsitedir} ]]; then
	read -r -p "Enter the name of the directory in which drupal website need to be installed: " drupalsitedir
fi
if [[ -z ${psqldb} ]]; then
	read -r -p "Enter the name of postgres database that you have previousily created: " psqldb
	read -r -p "Enter the postgres username: " psqluser
  read -r -p "Enter the password that you set for the postgres user: " PGPASSWORD
fi

# Escape special characters in PGPASSWORD using printf.
PGPASSWORD_ESCAPED=$(printf "%q" "$PGPASSWORD")

# Installation
sudo chown -R "$USER" "$DRUPAL_HOME"
cd "$DRUPAL_HOME" || exit
mv index.html index.html.orig
wget http://ftp.drupal.org/files/projects/drupal-7.98.tar.gz
tar -zxvf drupal-7.98.tar.gz
rm drupal-7.98.tar.gz
mv drupal-7.98/ "$drupalsitedir"/
cd "$drupalsitedir" || exit
cp sites/default/default.settings.php sites/default/settings.php
mkdir sites/default/files/
sudo chgrp -R www-data sites/default/files/
sudo chmod 777 sites/default/settings.php
sudo chmod g+rw sites/default/files/
echo -e '\n+----------------+'
echo '|   Site Setup   |'
echo '+----------------+'
sed -i "s/\$databases\ =\ array();/\n\$databases['default']['default']\ =\ array(\n\t'driver'\ =>\ 'pgsql',\n\t'database'\ =>\ '$psqldb',\n\t'username'\ =>\ '$psqluser',\n\t'password'\ =>\ '$PGPASSWORD_ESCAPED',\n\t'host'\ =>\ 'localhost',\n\t'prefix'\ =>\ '',\n);/" sites/default/settings.php
while ! ({ drush variable-get --root="$DRUPAL_HOME"/"$drupalsitedir" | grep -q drupal; } &> /dev/null && sleep 2); do
whiptail --title "Drupal Setup" --msgbox --ok-button "" --notags "1. Go to http://localhost/""$drupalsitedir""/install.php\n2. Ensure that 'Standard' option is selected and click 'Save and continue'.\n3. Select the language you want to choose. Choose 'English'.\n4. You will see a progress bar as Drupal is installed.\n5. Once it completes, a configuration page will be visible.\n6. Provide details appropriate to your site and note down the Site Maintenance Account details.\n7. Click 'Save and continue.'" 15 80;
done
sudo chmod 755 sites/default/settings.php

# Webform Module (for creating Google-form-like Forms)
drush pm-download -y webform
drush pm-enable -y webform
