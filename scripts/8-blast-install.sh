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
wget --no-remove-listing ftp.ncbi.nlm.nih.gov/blast/executables/LATEST
wget https://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/"$(grep x64-linux.tar.gz LATEST | awk 'NR==1{print $2}' | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')"
tar zxvpf ncbi-blast-*+-x64-linux.tar.gz
cp -r ncbi-blast-*+/bin "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/
rm -rf ncbi-blast-*+/ ncbi-blast-*+-x64-linux.tar.gz
rm LATEST

# Install tripal_blast
cd "$DRUPAL_HOME"/"$drupalsitedir"/ || exit
drush pm-download tripal_blast libraries -y
drush pm-enable blast_ui -y
mkdir -p sites/default/files/tripal/
sudo chown www-data:www-data -R sites/default/files/
echo '-----------------------'
echo '   Tripal_Blast Setup   '
echo '-----------------------'
echo "Go to http://localhost/""$drupalsitedir""/admin/tripal/extension/tripal_blast"
echo "Copy & paste this path in the 'Enter the path of the BLAST program' form: ""$DRUPAL_HOME""/""$drupalsitedir""/tools/blast/bin/"
echo "Click 'Save Configuration' at the bottom of the page."

# Gathering test database
mkdir -p "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/blastdb/16S_ribosomal_RNA
cd "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/blastdb/16S_ribosomal_RNA
"$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/bin/update_blastdb.pl --passive --decompress 16S_ribosomal_RNA
"$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/bin/blastdbcmd -db 16S_ribosomal_RNA -entry nr_025000 -out 16S_query.fa