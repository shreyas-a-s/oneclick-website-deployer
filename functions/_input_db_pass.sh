#!/usr/bin/env bash

function _input_db_pass {
  if command -v whiptail > /dev/null; then
    PGPASSWORD=$(whiptail --title "USER INPUT" --passwordbox \
      "\nEnter a password for the new user:\n\n    (Press ENTER to continue)" \
      11 38 \
      "$PGPASSWORD" \
      3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 1 ]; then
      exit 1
    fi
  else
    read -r -p "Enter a password for the new user: " PGPASSWORD
  fi

  # Hide PGPASSWORD by replacing characters with *
  HIDDEN_PGPASSWORD=$(for _ in $(seq "$(printf "%s" "$PGPASSWORD" | wc -m)"); do printf "*"; done)

  # Escape special characters in PGPASSWORD using printf.
  ESCAPED_PGPASSWORD=$(printf "%q" "$PGPASSWORD")

  # Export all variables
  export PGPASSWORD
  export HIDDEN_PGPASSWORD
  export ESCAPED_PGPASSWORD
}

export -f _input_db_pass

