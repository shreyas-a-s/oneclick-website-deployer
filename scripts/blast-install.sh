#!/bin/bash

# Variables
sed -i '$a\DRUPAL_HOME=/var/www/html' ~/.bashrc && DRUPAL_HOME=/var/www/html

# Display task name
echo '------------------------------'
echo '   Tripal_Blast Installation   '
echo '------------------------------'

# Set PrivateTmp to false
sudo cp /etc/systemd/system/multi-user.target.wants/apache2.service /etc/systemd/system/
sudo sed -i "/PrivateTmp/ c\PrivateTmp=false" /etc/systemd/system/apache2.service
sudo systemctl daemon-reload
sudo service apache2 restart

# Install BLAST+
read -r -p "Enter the name of the directory in which drupal website was installed: " drupalsitedir
sudo apt update && sudo apt install wget -y
mkdir -p "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast
wget https://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/ncbi-blast-2.*.*+-x64-linux.tar.gz
tar zxvpf ncbi-blast-2.*.*+-x64-linux.tar.gz
cp ncbi-blast-2.*.*+/bin/* "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/
rm -rf ncbi-blast-2.*.*+/ ncbi-blast-2.*.*+-x64-linux.tar.gz

# Install tripal_blast
cd "$DRUPAL_HOME"/"$drupalsitedir"/ || exit
drush pm-download tripal_blast libraries -y
drush pm-enable blast_ui -y
sudo chgrp -R www-data "$drupalsitedir"/sites/default/files/tripal/
echo "Go to http://localhost/""$drupalsitedir""/admin/tripal/extension/tripal_blast."
echo "Copy & paste the below line in the 'Enter the path of the BLAST program' form:"
echo "$DRUPAL_HOME"/"$drupalsitedir""/tools/blast/bin/"
echo "Click 'Save Configuration' at the bottom of the page."
