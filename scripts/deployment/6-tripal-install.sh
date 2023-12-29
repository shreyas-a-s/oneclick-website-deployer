#!/usr/bin/env bash

# Display task name
echo -e '\n+-------------------------+'
echo '|   Tripal Installation   |'
echo '+-------------------------+'

# Change directory
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )") && cd "$SCRIPT_DIR" || exit

# Source functions
if [ -d ../../functions ]; then
  for fn in ./functions/*; do
    . "$fn"
  done
fi

# Change directory to drupal directory
cd "$DRUPAL_HOME"/"$drupalsitedir" || exit

# Install dependencies
drush pm-download -y entity views ctools ds field_group field_group_table field_formatter_class field_formatter_settings ckeditor jquery_update
drush pm-enable -y entity views views_ui ctools ds field_group field_group_table field_formatter_class field_formatter_settings ckeditor jquery_update

# Tripal installation
drush pm-download tripal -y
drush pm-enable -y tripal tripal_chado tripal_ds tripal_ws

# Check site maintenance username before proceeding
_input_site_maintenance_username

# Install Tripal chado
echo -e '\n+----------------------+'
echo '|   Installing Chado   |'
echo '+----------------------+'

while [[ $(drush variable-get --root="$DRUPAL_HOME"/"$drupalsitedir" | grep chado_schema_exists | awk '{print $2}') == "true" ]]; do
  whiptail --title "Install Chado" --msgbox --ok-button "OK" --notags "1. Go to http://localhost/""$drupalsitedir""/admin/tripal/storage/chado/install\n2. Click the drop-down menu under Installation/Upgrade Action.\n3. Select 'New Install of Chado v1.3'.\n4. Click 'Install/Upgrade Chado'.\n-  NOTE: THERE IS NO NEED TO RUN THE DRUSH COMMAND.\n5. Hit 'OK' after completing these steps." 13 65
  drush trp-run-jobs --username="$smausername" --root="$DRUPAL_HOME"/"$drupalsitedir" &> /dev/null
done

# Checking if chado installation was successful
if [ $? -eq 0 ]; then
  echo "Chado Installation Successful."
else
  echo "Chado Installation Failed."
fi

# Prepare Tripal Chado
echo -e '\n+---------------------+'
echo '|   Preparing Chado   |'
echo '+---------------------+'

# Save initial network configuration into a string
initial_network_config=$(ip addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Actual execution
while true; do
  goodtogo=true
  _test_raw_github
  if [ "$goodtogo" = false ]; then
    # Ask the user if they want to try different network setup
    if (whiptail --title "Unable to proceed" --yesno --yes-button "Retry" --no-button "Continue" "\n- Unable to connect to raw.githubusercontent.com.\n- For preparing website with chado, connecting to it\n  is necessary.\n- You can 'Continue' if you want but it is advisable\n  to change network configuration and 'Retry'." 13 57) then
      continue
    else
      break
    fi
  else
    break
  fi
done
drush trp-prepare-chado --user="$smausername" --root="$DRUPAL_HOME"/"$drupalsitedir"
drush cache-clear all --root="$DRUPAL_HOME"/"$drupalsitedir"

# Save current network configuration into a string
current_network_config=$(ip addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# If network change is detected, promt user if they want to change network back
if [ "$current_network_config" != "$initial_network_config" ]; then
  whiptail --title "Just a Pause" --msgbox "\n- We've noticed that you've switched network before.\n- This would be a good time to change it back if you wish.\n- Do that and click 'Ok'." 11 61
  whiptail --title "Just checking" --msgbox --ok-button "Yes" "         Are you sure?" 8 35
  while ! ({ ping -c 1 -w 2 example.org; } &> /dev/null); do :; done
fi

# Fix for "Trying to access array offset on value of type null" error that gets displayed
# when we refresh overlay menus (eg: localhost/drupal/bio_data/1#overlay-context=&overlay=admin/tripal)
# source: https://www.drupal.org/project/field_formatter_settings/issues/3166628
cd "$DRUPAL_HOME"/"$drupalsitedir"/sites/all/modules/field_formatter_settings || exit
patch -p1 < ./field_formatter_settings.patch

