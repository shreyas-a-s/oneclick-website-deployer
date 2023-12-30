#!/usr/bin/env bash

# Read and test site maintenance account username is valid
function _input_site_maintenance_username {
  titleSMA="SITE MAINTENANCE ACCOUNT CREDENTIALS"
  while ! ( { drush user-information "$smausername" --root="$DRUPAL_HOME"/"$drupalsitedir" | grep -q administrator; } &> /dev/null ); do
    smausername=$(whiptail --title "$titleSMA" --inputbox \
      "\nEnter the site maintenance account username that you've given to the website:\
      \n\n         (Press ENTER to continue)" \
      12 48 \
      3>&1 1>&2 2>&3)
      titleSMA="WRONG USERNAME"
      _set_whiptail_colors_red_bg # Change whiptail bg color to RED
  done
  _set_whiptail_colors_default # Restore default colorscheme

  export smausername # Export smausername to be used by child scripts
}

# Export the function to be used by child scripts
export -f _input_site_maintenance_username

