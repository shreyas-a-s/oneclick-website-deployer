#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "INSTALLING - TRIPAL BLAST"
fi

# Install dependencies
if command -v apt-get > /dev/null; then
  sudo apt-get install -y git unzip wget  # Install some necessary programs
fi

# Change to drupal directory
cd "$DRUPAL_HOME"/"$drupalsitedir"/ || exit

# Install NCBI Blast+
mkdir -p tools/blast
wget --no-remove-listing ftp.ncbi.nlm.nih.gov/blast/executables/LATEST
wget https://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/"$(grep x64-linux.tar.gz LATEST | awk 'NR==1{print $2}' | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')"
tar zxvpf ncbi-blast-*+-x64-linux.tar.gz
cp -r ncbi-blast-*+/bin tools/blast/
rm -rf ncbi-blast-*+/ ncbi-blast-*+-x64-linux.tar.gz
rm LATEST

# Install & enable libraries module (dependency of tripal_blast)
drush pm-download -y libraries
drush pm-enable -y libraries

# Install cvitjs library (dependency of tripal_blast)
wget https://github.com/awilkey/cvitjs/archive/master.zip
unzip -q master.zip
rm master.zip
mv cvitjs-master sites/all/libraries/cvitjs

# Install tripal_blast
mkdir -p sites/all/modules/tripal_blast
git clone https://github.com/tripal/tripal_blast.git sites/all/modules/tripal_blast
mkdir -p sites/default/files/tripal/
mkdir -p sites/default/files/tripal_blast
sudo chgrp -R www-data sites/default/files/

# Enable tripal_blast
drush pm-enable blast_ui -y

# Set blast+ bin folder in tripal_blast ui
drush variable-set blast_path "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/bin/ --root="$DRUPAL_HOME"/"$drupalsitedir"

