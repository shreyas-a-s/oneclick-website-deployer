#!/usr/bin/env bash

# Read and test site maintenance account username is valid
function _input_site_maintenance_username {
  titleSMA="Site Maintenance Account"
  while ! ( { drush user-information "$smausername" --root="$DRUPAL_HOME"/"$drupalsitedir" | grep -q administrator; } &> /dev/null ); do
    smausername=$(whiptail --title "$titleSMA" --inputbox "\nEnter the site maintenance account username that you've given to the website: " 10 48 3>&1 1>&2 2>&3)
      titleSMA="Wrong Username"
  done
}

# Export variables
export smausername

# Export the function to be used by child scripts
export -f _input_site_maintenance_username

