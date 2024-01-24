#!/usr/bin/env bash

function _is_internet_available {
  printf "Checking internet connectivity. Please wait ...\n"
  if ! curl -Is https://www.google.com | head -n 1 | grep -q '200' > /dev/null; then
    printf "\nUnable to connect to internet. Connect to internet before continuing.\n"
    exit 1
  fi
}

export -f _is_internet_available

