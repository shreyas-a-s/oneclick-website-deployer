#!/usr/bin/env bash

# Store script's directory path into a avriable
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )")

# Install dependencies present in distro repository
if command -v apt-get > /dev/null; then
  sudo apt-get install -y wget git
fi

# Install NCBI BLAST+
if command -v apt-get > /dev/null; then
  sudo apt-get install -y ncbi-blast+
fi

# Change to drupal directory
cd "$DRUPAL_HOME"/"$drupalsitedir"/ || exit

# Install & enable libraries module
drush pm-download -y libraries
drush pm-enable -y libraries

# Install cvitjs library which is a dependency of tripal_blast
."$SCRIPT_DIR"/install-lbry-cvitjs.sh

