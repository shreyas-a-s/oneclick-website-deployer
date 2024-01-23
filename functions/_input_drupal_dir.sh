#!/usr/bin/env bash

function _input_drupal_dir {
  while true; do
    DRUPAL_HOME=$(whiptail --title "DRUPAL WEBSITE DETAILS" --inputbox \
      "\nEnter the name of the directory to which\n  drupal website needs to be installed:\
      \n        (Press ENTER to continue)" \
      12 45 \
      "$DRUPAL_HOME" \
      3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 1 ]; then
      exit 1
    fi

    # Check if input is empty
    if [ -n "$DRUPAL_HOME" ]; then
      break
    else
      whiptail --msgbox "   Please enter a value" 7 30
    fi

    # Check if directory exists
    if [ -d "$WEB_ROOT"/"$DRUPAL_HOME" ]; then
      whiptail --msgbox "   Directory exists." 7 27
    else
      break
    fi
  done

  DRUPAL_HOME=$(echo "$DRUPAL_HOME" | tr ' ' '-') # Replaces 'spaces' with 'hyphens'
  export DRUPAL_HOME
}

export -f _input_drupal_dir

