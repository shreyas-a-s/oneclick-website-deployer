#!/usr/bin/env bash

# Test site maintenance account username
function _test_sma_username {
  titleSMA="Site Maintenance Account"
  while ! ( { drush user-information "$smausername" --root="$DRUPAL_HOME"/"$drupalsitedir" | grep -q administrator; } &> /dev/null ); do
    smausername=$(whiptail --title "$titleSMA" --inputbox "\nEnter the site maintenance account username that you've given to the website: " 10 48 3>&1 1>&2 2>&3)
      titleSMA="Wrong Username"
  done
}

