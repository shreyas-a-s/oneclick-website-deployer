#!/usr/bin/env bash

function _is_db_name_valid {
  local db_name="$1"

  # Check if the length is between 1 and 63 characters
  if [[ ${#db_name} -lt 1 || ${#db_name} -gt 63 ]]; then
    echo "Invalid length for database name."
    whiptail --msgbox "Invalid length for database name. It should be 1-63 characters long." 8 38
    return 1
  fi

  # Check if the first character is a letter or an underscore
  if [[ ! "$db_name" =~ ^[a-zA-Z_] ]]; then
    whiptail --msgbox "Database name must start with a\n      letter or underscore." 8 35
    return 1
  fi

  # Check if subsequent characters are letters, underscores, or digits
  if [[ ! "$db_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
    whiptail --msgbox "Invalid characters in the database name.\n    It should only contain letters, \n         underscores and digits." 9 44
    return 1
  fi

  # If all checks pass, the name is valid
  return 0
}

# Export the function to be used by child scripts
export -f _is_db_name_valid

