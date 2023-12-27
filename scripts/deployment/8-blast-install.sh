#!/usr/bin/env bash

# Display task name
echo -e '\n+------------------------+'
echo '|   Blast Installation   |'
echo '+------------------------+'

# Variables
DRUPAL_HOME=/var/www/html

# Store script's directory path into a avriable
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )")

# Read name of drupal directory if not already read
if [[ -z ${drupalsitedir} ]]; then
  read -r -p "Enter the name of the directory in which drupal website was installed: " drupalsitedir
fi

# Install dependencies
if command -v apt-get > /dev/null; then
  sudo apt-get install -y wget git
fi

# Install NCBI BLAST+
if command -v apt-get > /dev/null; then
  sudo apt-get install -y ncbi-blast+
fi

# Change to drupal directory
cd "$DRUPAL_HOME"/"$drupalsitedir"/ || exit

# Install tripal_blast
mkdir -p sites/all/modules/tripal_blast
git clone https://github.com/tripal/tripal_blast.git sites/all/modules/tripal_blast
drush pm-download libraries -y
mkdir -p sites/default/files/tripal/
mkdir -p sites/default/files/tripal_blast
sudo chgrp -R www-data sites/default/files/

# Enable tripal_blast
drush pm-enable blast_ui -y

# Set new drupal file_temporary_path (Done as a replacement for setting PrivateTmp=false)
mkdir -p sites/default/files/tmp/
sudo chgrp www-data sites/default/files/tmp/
chmod g+w sites/default/files/tmp/
drush variable-set file_temporary_path "$DRUPAL_HOME"/"$drupalsitedir"/sites/default/files/tmp --root="$DRUPAL_HOME"/"$drupalsitedir"

# Set blast+ bin folder in tripal_blast ui
echo -e '\n+------------------------+'
echo '|   Tripal_Blast Setup   |'
echo '+------------------------+'
drush variable-set blast_path /usr/bin/ --root="$DRUPAL_HOME"/"$drupalsitedir"

# Install cvitjs library which is a dependency of tripal_blast
."$SCRIPT_DIR"/components/install-lbry-cvitjs.sh

# Setup a sample blast database to educate users
."$SCRIPT_DIR"/components/setup-sample-blast-db.sh

