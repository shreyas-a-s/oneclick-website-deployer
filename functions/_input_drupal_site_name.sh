#!/usr/bin/env bash

function _input_drupal_site_name {
  while true; do
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

    # Check if input is empty
    if _is_variable_nonempty "$drupal_site_name"; then
      break
    fi
  done

  export drupal_site_name # Export drupal site name to be used by child scripts
}

# Export the function to be used by child scripts
export -f _input_drupal_site_name

