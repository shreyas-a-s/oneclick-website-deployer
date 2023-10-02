#!/bin/bash

# Variables
sed -i '$a\DRUPAL_HOME=/var/www/html' "$HOME"/.bashrc && DRUPAL_HOME=/var/www/html

# Take user choice before continuing
function continueORNot {
   read -r -p "Continue? (yes/no): " choice
   case "$choice" in 
     "yes" ) echo "Moving on to next step..";sleep 2;;
     "no" ) echo "Exiting.."; exit 1;;
     * ) echo "Invalid Choice! Keep in mind this is case-sensitive."; continueORNot;;
   esac
}

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
read -r -p "Enter the name of the directory in which drupal website was installed: " drupalsitedir

# Install dependencies
cd "$DRUPAL_HOME"/"$drupalsitedir"/sites/all/modules/ || exit
drush pm-download -y entity views ctools ds field_group field_group_table field_formatter_class field_formatter_settings ckeditor jquery_update
drush pm-enable -y entity views views_ui ctools ds field_group field_group_table field_formatter_class field_formatter_settings ckeditor jquery_update

# Tripal installation
drush pm-download tripal -y
cd "$DRUPAL_HOME"/"$drupalsitedir/" || exit
drush pm-enable -y tripal tripal_chado tripal_ds tripal_ws

# Chado installation
checkSMAUsername
echo -e '\n+-------------------+'
echo '|   Install Chado   |'
echo '+-------------------+'
echo "Go to http://localhost/""$drupalsitedir""/admin/tripal/storage/chado/install"
echo "Click the drop-down menu under Installation/Upgrade."
echo "Select 'New Install of Chado v1.3'."
echo "Click 'Install/Upgrade Chado'."
echo "NOTE: THERE IS NO NEED TO RUN THE DRUSH COMMAND."
echo "After completing these steps, come back and type 'yes' to continue."
continueORNot
drush trp-run-jobs --username="$smausername"
drush updatedb

# Chado preparation
echo -e '\n+-------------------+'
echo '|   Prepare Chado   |'
echo '+-------------------+'
echo "Go to http://localhost/""$drupalsitedir""/admin/tripal/storage/chado/prepare"
echo "Click on 'Prepare this site'"
echo "NOTE: THERE IS NO NEED TO RUN THE DRUSH COMMAND."
echo "After completing these steps, come back and type 'yes' to continue."
continueORNot
drush trp-run-jobs --username="$smausername"
drush cache-clear all
