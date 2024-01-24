#!/usr/bin/env bash

function _input_drupal_country {

  # Try to automatically detect country using curl, jq commands
  drupal_country_code=$(curl -s ipinfo.io | jq -r '.country')

  # Use jq to check if the country code exists in the JSON
  cc_exists=$(jq --arg key "$drupal_country_code" 'has($key)' ./components/countries.json)

  if [ "$cc_exists" = "false" ]; then
    # Load JSON data into a string
    countries=$(jq -r 'to_entries | map("\(.key) \(.value)") | .[]' ./components/countries.json)

    # Create an array with country codes and names
    country_items=()
    while read -r line; do
        country_code=$(echo "$line" | cut -d' ' -f1)
        country_name=$(echo "$line" | cut -d' ' -f2-)
        country_items+=("$country_code" "$country_name")
    done <<< "$countries"

    # Whiptail menu
    drupal_country_code=$(whiptail --title "SELECT COUNTRY" --menu "\n  (UP/DOWN ARROW KEYS to select, ENTER to confirm)" 18 55 9 "${country_items[@]}" 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 1 ]; then
      exit 1
    fi
  fi

  # Change country code to country name
  drupal_country_name=$(jq -r --arg key "$drupal_country_code" '.[$key]' ./components/countries.json)

  # Export drupal country variables to be used by child scripts
  export drupal_country_code
  export drupal_country_name
}

# Export the function to be used by child scripts
export -f _input_drupal_country

