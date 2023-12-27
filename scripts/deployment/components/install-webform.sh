#!/usr/bin/env bash

# Variables
DRUPAL_HOME=/var/www/html

# Read name of drupal directory if not already read
if [[ -z ${drupalsitedir} ]]; then
  read -r -p "Enter the name of the directory in which drupal website need to be installed: " drupalsitedir
fi

# Change directory
cd "$DRUPAL_HOME"/"$drupalsitedir" || exit

# Install the module
drush pm-download -y webform
drush pm-enable -y webform

