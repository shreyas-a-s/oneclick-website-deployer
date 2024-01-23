#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "PREPARING - CHADO"
fi

# Save initial network configuration into a string
initial_network_config=$(dig +short myip.opendns.com @resolver1.opendns.com)

# Prepare Tripal Chado
while true; do
  goodtogo=true
  _is_raw.githubusercontent.com_accessible
  if [ "$goodtogo" = false ]; then
    _set_whiptail_colors_bg_red # Change whiptail bg color to RED
    # Ask the user if they want to try different network setup
    whiptail --title "UNABLE TO PROCEED" --yesno \
      --yes-button "Retry" \
      --no-button "Continue" \
      "* Unable to connect to raw.githubusercontent.com.\
      \n* For preparing website with chado, this connection is necessary.\
      \n* You can 'Continue' if you want but it is advisable to change network configuration and 'Retry'.\
      \n         (ARROW KEYS to move, ENTER to confirm)" \
      12 59
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
      continue
    else
      _set_whiptail_colors_default # Restore default colorscheme
      break
    fi
  else
    break
  fi
done
drush trp-prepare-chado --user="$drupal_user" --root="$WEB_ROOT"/"$DRUPAL_HOME"
drush cache-clear all --root="$WEB_ROOT"/"$DRUPAL_HOME"

# Save current network configuration into a string
current_network_config=$(dig +short myip.opendns.com @resolver1.opendns.com)

# If network change is detected, promt user if they want to change network back
if [ "$current_network_config" != "$initial_network_config" ]; then
  whiptail --title "JUST A PAUSE" --msgbox \
    "* We've noticed that you've switched network before.\
    \n* If you wish to change it back, do that and press ENTER." \
    9 61
  while ! ({ curl -Is https://www.google.com | head -n 1 | grep -q '200'; } &> /dev/null); do :; done
fi

