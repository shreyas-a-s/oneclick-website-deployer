#!/bin/bash
echo "####################################################################"
echo "# This works only on the latest debian (currently it's version 12) #"
echo "####################################################################"

# Variables
sed -i '$a\DRUPAL_HOME=/var/www/html' "$HOME"/.bashrc && DRUPAL_HOME=/var/www/html

# Functions
function continueORNot {
   read -r -p "Continue? (yes/no): " choice
   case "$choice" in 
     "yes" ) echo "Moving on to next step..";sleep 2;;
     "no" ) echo "Exiting.."; exit 1;;
     * ) echo "Invalid Choice! Keep in mind this is case-sensitive."; continueORNot;;
   esac
}

function checkSMAUsername {
    read -r -p "Enter the site maintenance account username that you've given to the website: " smausername
    echo "Testing username.."
    drush trp-run-jobs --username="$smausername"
    exitstatus=$?
    [ $exitstatus -eq 1 ] && echo "Wrong Username! " && checkSMAUsername
}

# Basic database creation
echo "___Postgres Database Creation___"
read -r -p "Enter a new username: " psqluser
echo "Enter a new password for user $psqluser: "
sudo su - postgres -c "createuser -P $psqluser"
read -r -p "Enter the name for a new database for our website: " psqldb
sudo su - postgres -c "createdb $psqldb -O $psqluser"
psql -U "$psqluser" -d "$psqldb" -h localhost -c "CREATE EXTENSION pg_trgm;"

# Drush installation
cd "$DRUPAL_HOME" || exit
sudo chown -R "$USER" "$DRUPAL_HOME"
wget https://github.com/drush-ops/drush/releases/download/8.4.12/drush.phar
chmod +x drush.phar
sudo mv drush.phar /usr/local/bin/drush

# Drupal Installation
mv index.html index.html.orig
read -r -p "Enter the name of new directory to which drupal website needs to be installed: " drupalsitedir
git clone -b 7.x https://github.com/drupal/drupal.git ./"$drupalsitedir"/
cd "$drupalsitedir"/ || exit
cp sites/default/default.settings.php sites/default/settings.php
cd sites/default/ || exit
mkdir files/
sudo chgrp www-data files/
sudo chmod 777 settings.php
sudo chmod g+rw files/
echo "Go to http://localhost/""$drupalsitedir""/install.php and complete initial setup of website by providing newly created database details, new site maintenance account details, etc"
echo "IMP NOTE: Make sure to note down site maintenance account username."
echo "After completing initial setup, come back and type 'yes' to continue."
continueORNot
sudo chmod 755 settings.php

# Installing and enabling dependencies of tripal
cd "$DRUPAL_HOME"/"$drupalsitedir/sites/all/modules/" || exit
drush pm-download entity views ctools ds field_group field_group_table field_formatter_class field_formatter_settings ckeditor jquery_update
drush pm-enable entity views views_ui ctools ds field_group field_group_table field_formatter_class field_formatter_settings ckeditor jquery_update

# Installing and enabling tripal and tripal chado
drush pm-download tripal
cd "$DRUPAL_HOME"/"$drupalsitedir/" || exit
drush pm-enable tripal tripal_chado tripal_ds tripal_ws

# Chado Installation
checkSMAUsername
echo "Go to http://localhost/""$drupalsitedir""/ > Tripal > Data Storage > Chado > Install Chado. Then click on Install Chado 1.3 and follow the on-screen instructions to create a job to install chado."
echo "NOTE: THERE IS NO NEED TO RUN THE DRUSH COMMAND."
echo "After completing on-screen instructions, come back and type 'yes' to continue."
continueORNot
drush trp-run-jobs --username="$smausername"
drush updatedb

# Chado Preparation
echo "Go to http://localhost/""$drupalsitedir""/ > Tripal > Data Storage > Chado > Prepare Chado. Then click on Prepare this site and follow the on-screen instructions to create a job to install chado."
echo "NOTE: THERE IS NO NEED TO RUN THE DRUSH COMMAND."
echo "After completing on-screen instructions, come back and type 'yes' to continue."
continueORNot
drush trp-run-jobs --username="$smausername"

# The End
echo "Installation completed. Exiting.."
