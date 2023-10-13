#!/bin/bash

# Variables
DRUPAL_HOME=/var/www/html

# Test site maintenance username
function checkSMAUsername {
    titleSMA="Site Maintenance Account"
    while ! ( { drush user-information "$smausername" --root="$DRUPAL_HOME"/"$drupalsitedir" | grep -q administrator; } &> /dev/null ); do
        smausername=$(whiptail --title "$titleSMA" --inputbox "\nEnter the site maintenance account username that you've given to the website: " 10 48 3>&1 1>&2 2>&3)
        titleSMA="Wrong Username"
    done
}

# Display task name
echo -e '\n+---------------------------+'
echo '|   Cron Automation Setup   |'
echo '+---------------------------+'

# Get user input
if [[ -z ${drupalsitedir} ]]; then
	read -r -p "Enter the name of the directory in which drupal website was installed: " drupalsitedir
fi

# Installation
checkSMAUsername && export smausername
echo "0,30 * * * * $USER /usr/local/bin/drush core-cron --root=$DRUPAL_HOME/$drupalsitedir && /usr/local/bin/drush trp-run-jobs --username=$smausername --root=$DRUPAL_HOME/$drupalsitedir" | sudo tee /etc/cron.d/drupal-cron-tasks > /dev/null
whiptail --title "Cron Run" --msgbox --ok-button "OK" --notags "1. Go to http://localhost/""$drupalsitedir""/admin/config/system/cron\n2. Set the drop down value titled 'Run cron every' to 'Never' and save the configuration.\n3. Hit 'OK' after completing these steps." 10 65
drush core-cron --root="$DRUPAL_HOME"/"$drupalsitedir"
