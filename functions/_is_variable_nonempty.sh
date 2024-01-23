#!/usr/bin/env bash

function _is_variable_nonempty {
  local variable_name="$1"
  # Check if variable is empty
  if [ -z "$variable_name" ]; then
    whiptail --msgbox "   Please enter a value" 7 30
    return 1
  else
    return 0
  fi
}

# Export the function to be used by child scripts
export -f _is_variable_nonempty

