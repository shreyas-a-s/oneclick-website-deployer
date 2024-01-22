#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "INSTALLING - TRIPAL BLAST"
fi

# Store current directory in a variable
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )")

# Change to drupal directory
cd "$DRUPAL_HOME"/"$drupalsitedir"/ || exit

# Install NCBI Blast+
mkdir -p tools
cp -r "$SCRIPT_DIR"/../components/blast+ ./tools/

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
drush variable-set blast_path "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast+/bin/ --root="$DRUPAL_HOME"/"$drupalsitedir"

# Restart tripal_daemon to fix an error that happens
# if we start a blast run without rebooting system
drush daemon stop tripal_daemon
drush daemon start tripal_daemon

