#!/usr/bin/env bash

# Display title
echo -e '\n+---------------------+'
echo '|   Preparing Chado   |'
echo '+---------------------+'

initial_network_config=$(ip -o address | grep --invert-match lo)

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

current_network_config=$(ip -o address | grep --invert-match lo)

# Promt user if they want to change network back
if [ "$current_network_config" != "$initial_network_config" ]; then
  whiptail --title "Just a Pause" --msgbox "\n- We've noticed that you've switched network before.\n- This would be agood time to change it back if you wish.\n- Do that and click 'Ok'." 11 61
  whiptail --title "Just checking" --msgbox --ok-button "Yes" "         Are you sure?" 8 35
  while ! ({ ping -c 1 -w 2 example.org; } &> /dev/null); do :; done
fi

