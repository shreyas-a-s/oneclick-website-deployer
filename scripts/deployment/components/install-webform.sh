#!/usr/bin/env bash

# Change directory
cd "$DRUPAL_HOME"/"$drupalsitedir" || exit

# Install the module
drush pm-download -y webform
drush pm-enable -y webform

