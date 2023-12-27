#!/usr/bin/env bash

# Display title
echo -e '\n+----------------------+'
echo '|   Installing Chado   |'
echo '+----------------------+'

# Actual installation
while [[ $(drush variable-get --root="$DRUPAL_HOME"/"$drupalsitedir" | grep chado_schema_exists | awk '{print $2}') == "true" ]]; do
  whiptail --title "Install Chado" --msgbox --ok-button "OK" --notags "1. Go to http://localhost/""$drupalsitedir""/admin/tripal/storage/chado/install\n2. Click the drop-down menu under Installation/Upgrade.\n3. Select 'New Install of Chado v1.3'.\n4. Click 'Install/Upgrade Chado'.\n-  NOTE: THERE IS NO NEED TO RUN THE DRUSH COMMAND.\n5. Hit 'OK' after completing these steps." 13 65
  drush trp-run-jobs --username="$smausername" --root="$DRUPAL_HOME"/"$drupalsitedir" &> /dev/null
done

# Checking if installation was successful
if [ $? -eq 0 ]; then
  echo "Chado Installation Successful."
else
  echo "Chado Installation Failed."
fi

