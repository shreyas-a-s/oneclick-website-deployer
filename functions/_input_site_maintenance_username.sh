#!/usr/bin/env bash

# Read and test site maintenance account username is valid
function _input_site_maintenance_username {
  titleSMA="SITE MAINTENANCE ACCOUNT CREDENTIALS"
  while ! ( { drush user-information "$smausername" --root="$DRUPAL_HOME"/"$drupalsitedir" | grep -q administrator; } &> /dev/null ); do
    smausername=$(whiptail --title "$titleSMA" --inputbox "\nEnter the site maintenance account username that you've given to the website: " 10 48 3>&1 1>&2 2>&3)
      titleSMA="WRONG USERNAME"
      export OLD_NEWT_COLORS=$(echo $NEWT_COLORS) # Make a backup of whiptail colorscheme
      NEWT_COLORS=$(echo $NEWT_COLORS | sed 's/root=white,gray/root=white,red/') # Change whiptail bg color to RED
  done
  export NEWT_COLORS=$(echo $OLD_NEWT_COLORS) # Restore previous colorscheme
}

# Export variables
export smausername

# Export the function to be used by child scripts
export -f _input_site_maintenance_username

