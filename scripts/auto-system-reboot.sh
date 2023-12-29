#!/usr/bin/env bash

if command -v whiptail > /dev/null; then
  whiptail --title "Installation Complete" --yesno --no-button "Later" "Reboot the system for site installation to fully take effect. Reboot now?" 8 44
  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    sudo reboot
  fi
else
  printf "Installation Complete. Reboot the system for site installation to fully take effect. Reboot now? (yes/no): "
  read -r choice_of_reboot
  case $choice_of_reboot in
    yes|y|YES)
      sudo reboot ;;
  esac
fi

