#!/bin/bash

# Take user choice before continuing
function continueORNot {
   read -r -p "Continue? (yes/no): " choice
   case "$choice" in 
     "yes" ) echo "Moving on to next step..";;
     "no" ) echo "Exiting.."; exit 1;;
     * ) echo "Invalid Choice! Keep in mind this is case-sensitive."; continueORNot;;
   esac
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
echo "0,30 * * * * $USER /usr/local/bin/drush core-cron --root=$DRUPAL_HOME/$drupalsitedir" | sudo tee /etc/cron.d/drupal-cron-tasks > /dev/null
echo "1. Go to http://localhost/""$drupalsitedir""/admin/config/system/cron"
echo "2. Set the drop down value titled 'Run cron every' to 'Never' and save the configuration."
continueORNot
