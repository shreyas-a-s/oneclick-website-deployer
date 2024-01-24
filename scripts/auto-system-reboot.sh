#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "AUTOMATIC SYSTEM REBOOT"
fi

whiptail --title "INSTALLATION COMPLETE" --yesno \
  --no-button "Later" \
  "Reboot the system for site installation\n   to fully take effect. Reboot now? \
  \n (ARROW KEYS to move, ENTER to confirm)" \
  9 44
exitstatus=$?
if [ $exitstatus = 0 ]; then
  sudo reboot
else
  printf "\nUser chose not to reboot.\n\n"
fi

