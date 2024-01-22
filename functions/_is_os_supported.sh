#!/usr/bin/env bash

function _is_os_supported {
  # Store OS name in a variable
  os_name=$(grep -E '\bNAME\b' /etc/os-release | awk -F '"' '{print $2}')

  # Store debian version in a variable
  if command -v apt-get > /dev/null; then
    debian_version=$(awk -F '.' '{print $1}' < /etc/debian_version)
    [[ "$debian_version" == *"buster"* ]] && debian_version=10
    [[ "$debian_version" == *"bullseye"* ]] && debian_version=11
    [[ "$debian_version" == *"bookworm"* ]] && debian_version=12
    [[ "$debian_version" == *"trixie"* ]] && debian_version=13
  fi

  # Give warning if OS is not supported
    _set_whiptail_colors_bg_red # Change whiptail bg color to RED
    if ! command -v apt-get > /dev/null; then # Checking is OS is not Debian-based
      whiptail --title "WARNING" --yesno \
        --defaultno \
        --yes-button "Continue" \
        --no-button "Cancel" \
        "This doesn't seem to be a Debian-based Linux system. This system is [$os_name]. Installation might not work properly. But you can continue with the installation if you want.\
        \n       (ARROW KEYS to move, ENTER to confirm)" \
        11 56
      exitstatus=$?
      if [ $exitstatus = 1 ]; then
        exit 1
      fi
    elif [ "$debian_version" -ne 11 ]; then # Checking if OS is debian but not version 11
      whiptail --title "WARNING" --yesno \
        --defaultno \
        --yes-button "Continue" \
        --no-button "Cancel" \
        "Drupal 7 (and thereby Tripal 3) works best in Debian 11. This system is [Debian $debian_version]. Installation might not work properly in this system. But you can continue with the installation if you want.\
        \n\n       (ARROW KEYS to move, ENTER to confirm)" \
        12 56
      exitstatus=$?
      if [ $exitstatus = 1 ]; then
        exit 1
      fi
    fi
    _set_whiptail_colors_default # Restore default colorscheme
}

export -f _is_os_supported

