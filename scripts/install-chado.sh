#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "INSTALLING - CHADO"
fi

# Install Tripal chado
drush php-eval "module_load_include('inc', 'tripal_chado', 'includes/tripal_chado.install'); tripal_chado_load_drush_submit('Install Chado v1.3');" --username="$drupal_user" --root="$DRUPAL_HOME"/"$drupalsitedir"
drush trp-run-jobs --username="$drupal_user" --root="$DRUPAL_HOME"/"$drupalsitedir"

# Checking if chado installation was successful
exitstatus=$?
if [ $exitstatus -eq 0 ]; then
  printf "\nChado Installation Successful.\n"
else
  printf "\nChado Installation Failed.\n"
fi

# Wait two seconds to allow user to read displayed message
sleep 2

