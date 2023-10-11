#!/bin/bash

# Variables
sed -i '$a\DRUPAL_HOME=/var/www/html' "$HOME"/.bashrc && DRUPAL_HOME=/var/www/html

# Take user choice before continuing
function continueORNot {
   read -r -p "Continue? (yes/no): " choice
   case "$choice" in 
     "yes" ) echo "Moving on to next step..";;
     "no" ) echo "Exiting.."; exit 1;;
     * ) echo "Invalid Choice! Keep in mind this is case-sensitive."; continueORNot;;
   esac
}

# Test site maintenance username
function checkSMAUsername {
    read -r -p "Enter the site maintenance account username that you've given to the website: " smausername
    drush trp-run-jobs --username="$smausername" &> /dev/null
    exitstatus=$?
    [ $exitstatus -eq 1 ] && echo "Wrong Username! " && checkSMAUsername
}

# Change directory
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )") && cd "$SCRIPT_DIR" || exit

# Display task name
echo -e '\n+-------------------------+'
echo '|   Tripal Installation   |'
echo '+-------------------------+'

# Get user input
if [[ -z ${drupalsitedir} ]]; then
	read -r -p "Enter the name of the directory in which drupal website was installed: " drupalsitedir
fi
if [[ -z ${psqldb} ]]; then
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

# Check site maintenance username before proceeding
checkSMAUsername

# Chado installation
echo -e '\n+----------------------+'
echo '|   Installing Chado   |'
echo '+----------------------+'
sudo -u postgres psql -c "CREATE SCHEMA chado;"
sudo -u postgres psql -c "ALTER SCHEMA chado OWNER TO $psqluser;"
sudo -u postgres psql -f sites/all/modules/tripal/tripal_chado/chado_schema/default_schema-1.3.sql
sudo -u postgres psql -f sites/all/modules/tripal/tripal_chado/chado_schema/initialize-1.3.sql
drush updatedb
echo -e "\nNow we are going to prepare chado."
continueORNot

# Chado preparation
echo -e '\n+---------------------+'
echo '|   Preparing Chado   |'
echo '+---------------------+'
drush trp-prepare-chado --user="$smausername" --root="$DRUPAL_HOME"/"$drupalsitedir"
drush cache-clear all
