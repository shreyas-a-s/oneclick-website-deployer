#!/usr/bin/env bash

function _is_os_supported {
  # Store OS name in a variable
  os_name=$(grep -E '\bNAME\b' /etc/os-release | awk -F '"' '{print $2}')

  # Store debian version in a variable
  if command -v apt-get > /dev/null; then
    debian_version=$(awk -F '.' '{print $1}' < /etc/debian_version)
  fi

  # Give warning if OS is not supported
  if command -v whiptail > /dev/null; then # Display messages using whiptail
    if ! command -v apt-get > /dev/null; then # Checking is OS is not Debian-based
      whiptail --title "WARNING" --yesno --defaultno --yes-button "Continue" --no-button "Cancel" "This doesn't seem to be a Debian Linux system. This system is [$os_name]. Installation might not work properly. But you can continue with the installation if you want." 10 56
      exitstatus=$?
      if [ $exitstatus != 0 ]; then
        exit 1
      fi
    elif [ "$debian_version" -ne 11 ]; then # Checking if OS is debian but not version 11
      whiptail --title "WARNING" --yesno --defaultno --yes-button "Continue" --no-button "Cancel" "Drupal 7 (and thereby Tripal 3) works best in Debian 11. This system is [Debian $debian_version]. Installation might not work properly in this system. But you can continue with the installation if you want." 10 56
      exitstatus=$?
      if [ $exitstatus != 0 ]; then
        exit 1
      fi
    fi
  else # Display messages using command-line
    if ! command -v apt-get > /dev/null; then # Checking is OS is not Debian-based
      printf "This doesn't seem to be a Debian Linux system. Installation might not work properly. But you can continue with the installation if you want. Continue (yes/no): "
      read -r continue_or_not
      case $continue_or_not in
        no|n|NO)
          exit 1 ;;
      esac
    elif [ "$debian_version" -ne 11 ]; then # Checking if OS is debian but not version 11
      printf "Drupal 7 (and thereby Tripal 3) works best in Debian 11. This system is Debian %s. Installation might not work properly in this system. But you can continue with the installation if you want. Continue? (yes/no): " "$debian_version"
      read -r continue_or_not
      case $continue_or_not in
        no|n|NO)
          exit 1 ;;
      esac
    fi
  fi
}

export -f _is_os_supported

