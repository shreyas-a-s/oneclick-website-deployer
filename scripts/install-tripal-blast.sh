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

# Install tripal_blast
drush dl tripal_blast
mkdir -p sites/default/files/tripal/tripal_blast
sudo chgrp -R www-data sites/default/files/
chmod g+w sites/default/files/tripal/tripal_blast

# Enable tripal_blast
drush pm-enable blast_ui -y

# Set blast+ bin folder in tripal_blast ui
drush variable-set blast_path "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/bin/ --root="$DRUPAL_HOME"/"$drupalsitedir"

# Restart tripal_daemon to fix an error that happens
# if we start a blast run without rebooting system
drush daemon stop tripal_daemon
drush daemon start tripal_daemon

