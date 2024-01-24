#!/usr/bin/env bash

function _is_dir_name_valid {
local dir_name="$1"
  # Check if the directory name contains only valid characters
  if [[ ! "$dir_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    return 1
  fi

  # Check if the directory name doesn't start with a hyphen
  if [[ "$dir_name" == -* ]]; then
    return 1
  fi

  # If all checks pass, the directory name is valid
  return 0
}

# Export the function to be used by child scripts
export -f _is_dir_name_valid

