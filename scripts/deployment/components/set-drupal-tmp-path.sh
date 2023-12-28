#!/usr/bin/env bash

# Set new drupal file_temporary_path (Done as a replacement for setting PrivateTmp=false)
mkdir -p "$DRUPAL_HOME"/"$drupalsitedir"/sites/default/files/tmp/
sudo chgrp www-data "$DRUPAL_HOME"/"$drupalsitedir"/sites/default/files/tmp/
chmod g+w "$DRUPAL_HOME"/"$drupalsitedir"/sites/default/files/tmp/
drush variable-set file_temporary_path "$DRUPAL_HOME"/"$drupalsitedir"/sites/default/files/tmp --root="$DRUPAL_HOME"/"$drupalsitedir"

