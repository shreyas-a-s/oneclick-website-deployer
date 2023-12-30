#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "AUTOMATIC SYSTEM REBOOT"
fi

if command -v whiptail > /dev/null; then
  whiptail --title "INSTALLATION COMPLETE" --yesno \
  --no-button "Later" \
  "Reboot the system for site installation\n   to fully take effect. Reboot now? \
  \n (ARROW KEYS to move, ENTER to confirm)" \
  9 44
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

