#!/usr/bin/env bash

if whiptail --title "Installation Complete" --yesno --no-button "Later" "Reboot the system for site installation to fully take effect. Reboot now?" 8 44; then
  sudo reboot
fi
