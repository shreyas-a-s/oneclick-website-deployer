#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "SETTING UP - CRON"
fi

# Store drupal cron key into new variable
drupal_cron_key=$(drush variable-get cron_key --root="$DRUPAL_HOME"/"$drupalsitedir" | awk '{print $2}')

# Set up cronjob to do drupal cron tasks
echo "0,30 * * * * /usr/bin/wget -O - -q http://localhost/""$drupalsitedir""/cron.php?cron_key=""$drupal_cron_key" | sudo tee /etc/cron.d/drupal-cron-tasks > /dev/null

# Prompt user to disable drupal's built-in cron otherwise websiste might get slowed down
whiptail --title "Cron Run" --msgbox --ok-button "OK" --notags "1. Go to http://localhost/""$drupalsitedir""/admin/config/system/cron\n2. Set the drop down value titled 'Run cron every' to 'Never' and save the configuration.\n3. Hit 'OK' after completing these steps." 10 65

# Check if cron setup was a success
if wget -O - -q http://localhost/"$drupalsitedir"/cron.php?cron_key="$drupal_cron_key"; then
  echo "Cron Setup Successful."
fi

