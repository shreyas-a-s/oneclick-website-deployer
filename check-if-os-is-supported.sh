#!/usr/bin/env bash

# Give warning if OS is not supported
if ! command -v apt-get > /dev/null; then
  printf "This doesn't seem to be a Debian Linux system. Installation might not work properly. But you can continue with the installation if you want. Continue (yes/no): " && read -r continue_or_not
  case $continue_or_not in
    no|n|NO)
      exit 1 ;;
  esac
elif [ "$(awk -F '.' '{print $1}' < /etc/debian_version)" -ne 11 ] && ! whiptail --title "Warning" --yesno --yes-button "Continue" --no-button "Cancel" "Drupal 7 (and thereby Tripal 3) works best in Debian 11. This system is Debian $(awk -F '.' '{print $1}' < /etc/debian_version). Installation might not work properly in this system. But you can continue with the installation if you want." 10 56; then
  exit 1
fi


