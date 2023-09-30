#!/bin/bash

# Variables
sed -i '$a\DRUPAL_HOME=/var/www/html' ~/.bashrc && DRUPAL_HOME=/var/www/html

# Display task name
echo '------------------------------'
echo '   Tripal_Blast Installation   '
echo '------------------------------'

# Get user input
read -r -p "Enter the name of the directory in which drupal website was installed: " drupalsitedir

# Set PrivateTmp to false
sudo cp /etc/systemd/system/multi-user.target.wants/apache2.service /etc/systemd/system/
sudo sed -i "/PrivateTmp/ c\PrivateTmp=false" /etc/systemd/system/apache2.service
sudo systemctl daemon-reload
sudo service apache2 restart

# Install BLAST+
sudo apt-get update && sudo apt-get -y install wget curl
mkdir -p "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast
wget -r -A '*-x64-linux.tar.gz' ftp://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/
cd ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/
tar -xzvf ncbi-blast-*+-x64-linux.tar.gz
cp -r ncbi-blast-*+/bin "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/
rm -rf ncbi-blast-*+/ ncbi-blast-*+-x64-linux.tar.gz

# Install tripal_blast
cd "$DRUPAL_HOME"/"$drupalsitedir"/ || exit
drush pm-download tripal_blast libraries -y
drush pm-enable blast_ui -y
mkdir -p "$drupalsitedir"/sites/default/files/tripal/
sudo chgrp -R www-data "$drupalsitedir"/sites/default/files/tripal/
echo '-----------------------'
echo '   Tripal_Blast Setup   '
echo '-----------------------'
echo "Go to http://localhost/""$drupalsitedir""/admin/tripal/extension/tripal_blast"
echo "Copy & paste this path in the 'Enter the path of the BLAST program' form: ""$DRUPAL_HOME""/""$drupalsitedir""/tools/blast/bin/"
echo "Click 'Save Configuration' at the bottom of the page."
