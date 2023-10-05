#!/bin/bash

# Variables
sed -i '$a\DRUPAL_HOME=/var/www/html' ~/.bashrc && DRUPAL_HOME=/var/www/html

# Take user choice before continuing
function continueORNot {
   read -r -p "Continue? (yes/no): " choice
   case "$choice" in 
     "yes" ) echo "Moving on to next step..";;
     "no" ) echo "Exiting.."; exit 1;;
     * ) echo "Invalid Choice! Keep in mind this is case-sensitive."; continueORNot;;
   esac
}

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
sed -i "s/\$databases\ =\ array();/\n\$databases['default']['default']\ =\ array(\n\t'driver'\ =>\ 'pgsql',\n\t'database'\ =>\ '$psqldb',\n\t'username'\ =>\ '$psqluser',\n\t'password'\ =>\ '$PGPASSWORD',\n\t'host'\ =>\ 'localhost',\n\t'prefix'\ =>\ '',\n);/" sites/default/settings.php
echo "1. Go to http://localhost/""$drupalsitedir""/install.php"
echo "2. Ensure that 'Standard' option is selected and click 'Save and continue'."
echo "3. You will next be asked to select the language you want to choose. Choose 'English'."
echo "4. You will see a progress bar as Drupal is installed."
echo "5. Once it completes, a configuration page with some final settings will be visible."
echo "6. Provide details appropriate to your site and note down the Site Maintenance Account details."
echo "7. Click 'Save and continue.'"
echo "8. After completing initial setup, come back and type 'yes' to continue."
continueORNot
sudo chmod 755 sites/default/settings.php