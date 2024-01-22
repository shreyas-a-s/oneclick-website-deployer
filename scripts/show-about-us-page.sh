#!/usr/bin/env bash

# Input file
input_file="../components/about-us.txt"

# Change directory
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )") && cd "$SCRIPT_DIR" || exit

if command -v whiptail > /dev/null; then # Display 'About Us' using whiptail
  whiptail --title "ABOUT THE TOOL" --textbox --ok-button "Continue" $input_file 20 90
else # Display 'About Us' using command-line
  number_of_columns=$(tput cols)
  line_char_count=$(( $(awk 'NR==1{print length}' "$input_file") - 2 ))
  left_padding_char_count=$(((number_of_columns - line_char_count) / 2 - 2))
  left_padding=$(for _ in $(seq $left_padding_char_count); do printf ' '; done)
  sed "s/^/$left_padding/" $input_file
  printf "Press Any key to continue.."
  read -r
fi

