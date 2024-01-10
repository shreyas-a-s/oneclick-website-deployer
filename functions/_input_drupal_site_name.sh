#!/usr/bin/env bash

function _input_drupal_site_name {
  while true; do
    if command -v whiptail > /dev/null; then
      drupal_site_name=$(whiptail --title "DRUPAL WEBSITE DETAILS" --inputbox \
        "\nEnter a Name for your Drupal website:\n   (Example: My Beautiful Website)\
        \n      (Press ENTER to continue)" \
        12 41 \
        "$drupal_site_name" \
        3>&1 1>&2 2>&3)
      exitstatus=$?
      if [ $exitstatus = 1 ]; then
        exit 1
      fi
    else
      printf "\nEnter a Name for your Drupal website(eg: My Beautiful Website) : "
      read -r drupal_site_name
    fi

    # Check if input is empty
    if [ -n "$drupal_site_name" ]; then
      break
    else
      whiptail --msgbox "   Please enter a value" 7 30
    fi
  done

  export drupal_site_name # Export drupal site name to be used by child scripts
}

# Export the function to be used by child scripts
export -f _input_drupal_site_name

