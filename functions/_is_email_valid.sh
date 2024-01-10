#!/usr/bin/env bash

function _is_email_valid {
  # Define the regular expression pattern for a basic email validation
  local email_pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"

  # Check if the input string matches the email pattern
  if [[ $1 =~ $email_pattern ]]; then
    return 0  # Valid email address
  else
    return 1  # Invalid email address
  fi
}

# Export the function to be used by child scripts
export -f _is_email_valid

