#!/bin/bash

# Variables
DRUPAL_HOME=/var/www/html

# Display task name
echo -e '\n+------------------------+'
echo '|   Blast Installation   |'
echo '+------------------------+'

# Get user input
if [[ -z ${drupalsitedir} ]]; then
	read -r -p "Enter the name of the directory in which drupal website was installed: " drupalsitedir
fi

# Install BLAST+
sudo apt-get update && sudo apt-get -y install wget curl
mkdir -p "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast
wget --no-remove-listing ftp.ncbi.nlm.nih.gov/blast/executables/LATEST
wget https://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/"$(grep x64-linux.tar.gz LATEST | awk 'NR==1{print $2}' | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')"
tar zxvpf ncbi-blast-*+-x64-linux.tar.gz
cp -r ncbi-blast-*+/bin "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/
rm -rf ncbi-blast-*+/ ncbi-blast-*+-x64-linux.tar.gz
rm LATEST

# Setting up PATH variable
sed -i "$ a PATH=$DRUPAL_HOME/$drupalsitedir/tools/blast/bin:\$PATH" ~/.bashrc && PATH="$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/bin:$PATH

# Install tripal_blast
cd "$DRUPAL_HOME"/"$drupalsitedir"/ || exit
mkdir -p sites/all/modules/tripal_blast
sudo apt update && sudo apt install -y git
git clone https://github.com/tripal/tripal_blast.git sites/all/modules/tripal_blast
drush pm-download libraries -y
drush pm-enable blast_ui -y
mkdir -p sites/default/files/tripal/
mkdir -p sites/default/files/tripal_blast
sudo chgrp -R www-data sites/default/files/

# Set new drupal file_temporary_path (Done as a replacement for setting PrivateTmp=false)
mkdir -p sites/default/files/tmp/
sudo chgrp www-data sites/default/files/tmp/
chmod g+w sites/default/files/tmp/
drush variable-set file_temporary_path "$DRUPAL_HOME"/"$drupalsitedir"/sites/default/files/tmp --root="$DRUPAL_HOME"/"$drupalsitedir"

# Gathering test database
mkdir -p "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/blastdb/16S_ribosomal_RNA
cd "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/blastdb/16S_ribosomal_RNA || exit
echo -e '\n+------------------------------------------------+'
echo '|   Downloading sample data. Wait a little bit   |'
echo '+------------------------------------------------+'
update_blastdb.pl --passive --decompress 16S_ribosomal_RNA
blastdbcmd -db 16S_ribosomal_RNA -entry nr_025000 -out 16S_query.fa

# User configuration
echo -e '\n+------------------------+'
echo '|   Tripal_Blast Setup   |'
echo '+------------------------+'
drush variable-set blast_path "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/bin/ --root="$DRUPAL_HOME"/"$drupalsitedir"

# Sample Blast Database Setup
echo -e '\n+---------------------------+'
echo '|   Sample Blast DB Setup   |'
echo '+---------------------------+'
whiptail --title "Sample Blast DB Setup" --msgbox --ok-button "OK" --notags "1. Go to http://localhost/""$drupalsitedir""/node/add/blastdb\n2. Fill out the form like this:\n- Human-readable Name: 16S_ribosomal_RNA\n- File Prefix including Full Path: ""$DRUPAL_HOME""/""$drupalsitedir""/tools/blast/blastdb/16S_ribosomal_RNA/16S_ribosomal_RNA\n- Set 'Type of the blast database' to Nucleotide.\n3. Got to bottom of page and click 'Save'\n4. After the installation is completed and system is rebooted, you can go to http://localhost/""$drupalsitedir""/blast/nucleotide/nucleotide and test out blast by Entering a FASTA sequence (or uploading one) & Selecting the newly added Database from dropdown under Nucleotide BLAST Databases & Clicking 'BLAST'\n5. Hit 'OK' after completing these steps." 18 78