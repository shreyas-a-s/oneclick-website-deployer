#!/usr/bin/env bash

# Display task name
echo -e '\n+-------------------------+'
echo '|   Tripal Installation   |'
echo '+-------------------------+'

# Store script's directory path into a variable
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )")

# Source functions
. "$SCRIPT_DIR"/functions/_test_raw_github.sh   # Function to test if raw.githubusercontent.com is accessible
. "$SCRIPT_DIR"/functions/_get_sma_username.sh  # Function to read site maintenamce username and test it

# Change directory to drupal directory
cd "$DRUPAL_HOME"/"$drupalsitedir" || exit

# Install dependencies
drush pm-download -y entity views ctools ds field_group field_group_table field_formatter_class field_formatter_settings ckeditor jquery_update
drush pm-enable -y entity views views_ui ctools ds field_group field_group_table field_formatter_class field_formatter_settings ckeditor jquery_update

# Tripal installation
drush pm-download tripal -y
drush pm-enable -y tripal tripal_chado tripal_ds tripal_ws

# Check site maintenance username before proceeding
_get_sma_username

# Tripal Chado
"$SCRIPT_DIR"/components/install-chado.sh  # Chado installation
"$SCRIPT_DIR"/components/prepare-chado.sh  # Chado preparation

# Apply Patches
"$SCRIPT_DIR"/components/patch-field_formatter_settings.sh

