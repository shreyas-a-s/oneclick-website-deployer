#!/usr/bin/env bash

function _input_drupal_country {
  # Create an array of country codes
  country_codes=$(jq 'keys_unsorted[]' countries.json | tr '\n' ' ')

  # Validate http status code to see if ipinfo.io is reachable
  response=$(curl -s -w "%{http_code}" ipinfo.io)
  http_status=$(echo "$response" | tail -c 4)

  if [ "$http_status" -eq 200 ]; then
    # Try to automatically detect country using curl, jq commands
    drupal_country=$(curl -s ipinfo.io | jq -r '.country')
  fi

  if [[ ! " ${country_codes[@]} " =~ " $drupal_country " ]]; then
    # Load JSON data into a Bash associative array
    declare -A countries
    countries=$(jq -r 'to_entries | map("\(.key) \(.value)") | .[]' countries.json)

    # Create an array with country codes and names
    country_items=()
    while read -r line; do
        country_code=$(echo "$line" | cut -d' ' -f1)
        country_name=$(echo "$line" | cut -d' ' -f2-)
        country_items+=("$country_code" "$country_name")
    done <<< "$countries"

    # Whiptail menu
    drupal_country=$(whiptail --title "SELECT COUNTRY" --menu "\n  (UP/DOWN ARROW KEYS to select, ENTER to confirm)" 18 55 9 "${country_items[@]}" 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 1 ]; then
      exit 1
    fi
  fi

  # Change country code to country name
  drupal_country=$(jq -r --arg key "$drupal_country" '.[$key]' countries.json)

  # Export drupal country variable to be used by child scripts
  export drupal_country
}

# Export the function to be used by child scripts
export -f _input_drupal_country

