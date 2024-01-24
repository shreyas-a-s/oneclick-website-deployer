#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "INSTALLING - WEBFORM MODULE FOR DRUPAL"
fi

# Change directory
cd "$WEB_ROOT"/"$DRUPAL_HOME" || exit

# Install module
drush pm-download -y webform
drush pm-enable -y webform

