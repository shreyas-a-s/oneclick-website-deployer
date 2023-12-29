#!/usr/bin/env bash

# Display task name
echo -e '\n+------------------------+'
echo '|   Blast Installation   |'
echo '+------------------------+'

# Store script's directory path into a variable
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )")

# Install dependencies
"$SCRIPT_DIR"/components/install-tripal-blast-dependencies.sh

# Change to drupal directory
cd "$DRUPAL_HOME"/"$drupalsitedir"/ || exit

# Install tripal_blast
mkdir -p sites/all/modules/tripal_blast
git clone https://github.com/tripal/tripal_blast.git sites/all/modules/tripal_blast
mkdir -p sites/default/files/tripal/
mkdir -p sites/default/files/tripal_blast
sudo chgrp -R www-data sites/default/files/

# Enable tripal_blast
drush pm-enable blast_ui -y

# Set blast+ bin folder in tripal_blast ui
drush variable-set blast_path /usr/bin/ --root="$DRUPAL_HOME"/"$drupalsitedir"

# Setup a sample blast database to educate users
"$SCRIPT_DIR"/components/setup-sample-blast-db.sh

