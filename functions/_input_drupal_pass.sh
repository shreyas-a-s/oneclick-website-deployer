#!/usr/bin/env bash

function _input_drupal_pass {
  while true; do
    drupal_pass=$(whiptail --title "DRUPAL WEBSITE DETAILS" --passwordbox \
      "\nEnter a password for the new drupal user:\
      \n        (Press ENTER to continue)" \
      11 45 \
      "$drupal_pass" \
      3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 1 ]; then
      exit 1
    fi

    # Check if input is empty
    if _is_variable_nonempty "$drupal_pass"; then
      break
    fi
  done

  # Hide drupal_pass by replacing characters with *
  hidden_drupal_pass=$(for _ in $(seq "$(printf "%s" "$drupal_pass" | wc -m)"); do printf "*"; done)

  export drupal_pass        # Export drupal password to be used by child scripts
  export hidden_drupal_pass # Export hidden drupal password
}

# Export the function to be used by child scripts
export -f _input_drupal_pass

