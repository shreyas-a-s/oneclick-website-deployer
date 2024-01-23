#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "INSTALLING - TRIPAL BLAST"
fi

# Change to drupal directory
cd "$WEB_ROOT"/"$DRUPAL_HOME"/ || exit

# Install NCBI Blast+
if command -v apt-get > /dev/null; then # Install for debian-based distros
  sudo apt-get install -y ncbi-blast+
fi

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
drush variable-set blast_path "$(dirname $(which blastn))/" --root="$WEB_ROOT"/"$DRUPAL_HOME"

# Restart tripal_daemon to fix an error that happens
# if we start a blast run without rebooting system
drush daemon stop tripal_daemon
drush daemon start tripal_daemon

