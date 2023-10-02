#!/bin/bash

# Variables
sed -i '$a\DRUPAL_HOME=/var/www/html' ~/.bashrc && DRUPAL_HOME=/var/www/html

# Display task name
echo -e '\n+------------------------+'
echo '|   Blast Installation   |'
echo '+------------------------+'

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
mkdir -p sites/all/modules/tripal_blast
sudo apt update && sudo apt install -y git
git clone https://github.com/tripal/tripal_blast.git sites/all/modules/tripal_blast
drush pm-download libraries -y
drush pm-enable blast_ui -y
mkdir -p sites/default/files/tripal/
sudo chgrp -R www-data sites/default/files/

# Gathering test database
mkdir -p "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/blastdb/16S_ribosomal_RNA
cd "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/blastdb/16S_ribosomal_RNA || exit
echo -e '\n+------------------------------------------------+'
echo '|   Downloading sample data. Wait a little bit   |'
echo '+------------------------------------------------+'
"$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/bin/update_blastdb.pl --passive --decompress 16S_ribosomal_RNA
"$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/bin/blastdbcmd -db 16S_ribosomal_RNA -entry nr_025000 -out 16S_query.fa

# User configuration
echo -e '\n+------------------------+'
echo '|   Tripal_Blast Setup   |'
echo '+------------------------+'
echo "1. Go to http://localhost/""$drupalsitedir""/admin/tripal/extension/tripal_blast"
echo "2. Copy & paste this path in the 'Enter the path of the BLAST program' form: ""$DRUPAL_HOME""/""$drupalsitedir""/tools/blast/bin/"
echo "3. Click 'Save Configuration' at the bottom of the page."

# Sample Blast Database Setup
echo -e '\n+---------------------------+'
echo '|   Sample Blast DB Setup   |'
echo '+---------------------------+'
echo "1. Go to http://localhost/""$drupalsitedir""/node/add/blastdb"
echo "2. Fill out the form like this:"
echo "- Human-readable Name: 16S_ribosomal_RNA"
echo "- File Prefix including Full Path: ""$DRUPAL_HOME""/""$drupalsitedir""/tools/blast/blastdb/16S_ribosomal_RNA/16S_ribosomal_RNA"
echo "- Set 'Type of the blast database' to Nucleotide."
echo "- Got to bottom of page and click 'Save'"
echo "3. Go to http://localhost/""$drupalsitedir""/blast/nucleotide/nucleotide and test out the blast install by Entering a FASTA sequence (or uploading one) & Selecting the newly added Database from dropdown under Nucleotide BLAST Databases & Clicking 'BLAST'"
