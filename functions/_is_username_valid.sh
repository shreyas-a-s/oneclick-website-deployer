#!/usr/bin/env bash

function _is_username_valid {
local username="$1"
  # Check if the username contains only valid characters
  if [[ ! "$username" =~ ^[a-zA-Z][a-zA-Z0-9_]+$ ]]; then
    return 1
  fi

  # If all checks pass, the directory name is valid
  return 0
}

# Export the function to be used by child scripts
export -f _is_username_valid

