#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "INSTALLING - TRIPAL"
fi

# Store directory in which script is stored into a variable
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )")

# Change directory to drupal directory
cd "$DRUPAL_HOME"/"$drupalsitedir" || exit

# Install dependencies
if command -v apt-get > /dev/null; then
  sudo apt-get install -y bind9-dnsutils
fi
drush pm-download -y entity views ctools ds field_group field_group_table field_formatter_class field_formatter_settings ckeditor_lts jquery_update
drush pm-enable -y entity views views_ui ctools ds field_group field_group_table field_formatter_class field_formatter_settings ckeditor jquery_update

# Tripal installation
drush pm-download tripal-7.x-3.10 -y
drush pm-enable -y tripal tripal_chado tripal_ds tripal_ws

# Install Tripal chado
drush php-eval "module_load_include('inc', 'tripal_chado', 'includes/tripal_chado.install'); tripal_chado_load_drush_submit('Install Chado v1.3');" --username="$drupal_user" --root="$DRUPAL_HOME"/"$drupalsitedir"
drush trp-run-jobs --username="$drupal_user" --root="$DRUPAL_HOME"/"$drupalsitedir"

# Checking if chado installation was successful
exitstatus=$?
if [ $exitstatus -eq 0 ]; then
  printf "\nChado Installation Successful.\n\n"
else
  printf "\nChado Installation Failed.\n\n"
fi

# Prepare Website to work with chado
./prepare-chado.sh

# Fix for "Trying to access array offset on value of type null" error that gets displayed
# when we refresh overlay menus (eg: localhost/drupal/bio_data/1#overlay-context=&overlay=admin/tripal)
# source: https://www.drupal.org/project/field_formatter_settings/issues/3166628
cd "$DRUPAL_HOME"/"$drupalsitedir"/sites/all/modules/field_formatter_settings || exit
patch -p1 < "$SCRIPT_DIR"/field_formatter_settings.patch

