#!/bin/bash

# Variables
DRUPAL_HOME=/var/www/html

# Display task name
echo -e '\n+---------------------------------+'
echo '|   Tripal_JBrowse Installation   |'
echo '+---------------------------------+'

# Get user input
if [[ -z ${drupalsitedir} ]]; then
	read -r -p "Enter the name of the directory in which drupal website was installed: " drupalsitedir
fi

# Install pre-requisites
sudo apt-get update && sudo apt-get -y install build-essential zlib1g-dev unzip wget curl

# Install jbrowse
curl -L -O https://github.com/GMOD/jbrowse/releases/download/1.16.11-release/JBrowse-1.16.11.zip
unzip JBrowse-1.16.11.zip
rm JBrowse-1.16.11.zip
mkdir -p "$DRUPAL_HOME"/"$drupalsitedir"/tools/
mv JBrowse-1.16.11 "$DRUPAL_HOME"/"$drupalsitedir"/tools/jbrowse
cd "$DRUPAL_HOME"/"$drupalsitedir"/tools/jbrowse || exit
./setup.sh
mkdir -p "$DRUPAL_HOME"/"$drupalsitedir"/sites/default/files/jbrowse/data/
sudo chgrp -R www-data "$DRUPAL_HOME"/"$drupalsitedir"/sites/default/files/jbrowse/
sudo chmod -R g+w "$DRUPAL_HOME"/"$drupalsitedir"/sites/default/files/jbrowse

# Install tripal_jbrowse
wget https://github.com/tripal/tripal_jbrowse/archive/refs/tags/7.x-3.0.zip
unzip 7.x-3.0.zip
rm 7.x-3.0.zip
mv tripal_jbrowse-7.x-3.0 "$DRUPAL_HOME"/"$drupalsitedir"/sites/all/modules/tripal_jbrowse
drush pm-enable -y tripal_jbrowse_mgmt tripal_jbrowse_page
echo -e '\n+--------------------------+'
echo '|   Tripal_JBrowse Setup   |'
echo '+--------------------------+'
drush variable-set tripal_jbrowse_mgmt_settings "{\"data_dir\":\"$DRUPAL_HOME/$drupalsitedir/sites/default/files/jbrowse/data\",\"data_path\":\"$drupalsitedir/sites/default/files/jbrowse/data\",\"bin_path\":\"$DRUPAL_HOME\/$drupalsitedir/tools/jbrowse/bin\",\"link\":\"tools/jbrowse\",\"menu_template\":[]}" --root="$DRUPAL_HOME"/"$drupalsitedir"
whiptail --title "JBrowse Example Data (Volvox)" --msgbox --ok-button "OK" --notags "\nTo see JBrowse example data, go to http://localhost/""$drupalsitedir""/tools/jbrowse/index.html?data=sample_data/json/volvox\n\nTo exit, hit 'OK'." 11 80
