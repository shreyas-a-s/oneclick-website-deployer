#!/bin/bash

# Variables
sed -i '$a\DRUPAL_HOME=/var/www/html' "$HOME"/.bashrc && DRUPAL_HOME=/var/www/html

# Test site maintenance username
function checkSMAUsername {
    read -r -p "Enter the site maintenance account username that you've given to the website: " smausername
    echo "Testing username.."
    drush trp-run-jobs --username="$smausername"
    exitstatus=$?
    [ $exitstatus -eq 1 ] && echo "Wrong Username! " && checkSMAUsername
}

# Display task name
echo -e '\n+-------------------------+'
echo '|   Tripal Installation   |'
echo '+-------------------------+'

# Get user input
if [[ -z ${drupalsitedir} ]]; then
	read -r -p "Enter the name of the directory in which drupal website was installed: " drupalsitedir
fi
if [[ -z ${psqldb} ]]; then
	sudo apt-get -y install postgresql
	read -r -p "Enter the name of postgres database that you have previousily created: " psqldb
	read -r -p "Enter the postgres username: " psqluser
  read -r -p "Enter the password that you set for the postgres user: " PGPASSWORD && export PGPASSWORD
fi

# Install dependencies
cd "$DRUPAL_HOME"/"$drupalsitedir"/sites/all/modules/ || exit
drush pm-download -y entity views ctools ds field_group field_group_table field_formatter_class field_formatter_settings ckeditor jquery_update
drush pm-enable -y entity views views_ui ctools ds field_group field_group_table field_formatter_class field_formatter_settings ckeditor jquery_update

# Tripal installation
drush pm-download tripal -y
cd "$DRUPAL_HOME"/"$drupalsitedir"/ || exit
drush pm-enable -y tripal tripal_chado tripal_ds tripal_ws

# Chado installation
echo -e '\n+-------------------+'
echo '|   Install Chado   |'
echo '+-------------------+'
psql -U "$psqluser" -d "$psqldb" -h localhost -c "CREATE SCHEMA chado AUTHORIZATION $psqluser;"
psql -U "$psqluser" -d "$psqldb" -h localhost -f sites/all/modules/tripal/tripal_chado/chado_schema/default_schema-1.3.sql
psql -U "$psqluser" -d "$psqldb" -h localhost -f sites/all/modules/tripal/tripal_chado/chado_schema/initialize-1.3.sql
drush updatedb

# Chado preparation
checkSMAUsername
echo -e '\n+-------------------+'
echo '|   Prepare Chado   |'
echo '+-------------------+'
drush trp-prepare-chado --user="$smausername" --root="$DRUPAL_HOME"/"$drupalsitedir"
drush cache-clear all
