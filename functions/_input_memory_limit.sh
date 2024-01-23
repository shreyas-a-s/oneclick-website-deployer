#!/usr/bin/env bash

function _input_memory_limit {
  total_memory="$(command free --mega | awk 'NR==2{print $2}')"
  while true; do
    memorylimit=$(whiptail --title "USER INPUT" --inputbox \
      "\nHow much memory to allocate to the website (in MB)?\
      \n         (Press ENTER to continue)" \
      12 46 \
      "$memorylimit" \
      3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 1 ]; then
      exit 1
    fi
    if [[ ! "$memorylimit" =~ ^[0-9]+$ ]] &> /dev/null; then
      whiptail --msgbox "Only numbers are allowed. For example, if you want to specify 1GB, enter 1024." 8 43
      continue
    elif [ "$memorylimit" -ge "$total_memory" ]; then
      whiptail --msgbox "Value is Larger than Total RAM ($total_memory""MB). Specify a value less than $total_memory." 8 46
      continue
    else
      break
    fi
  done
  export memorylimit
}

export -f _input_memory_limit

