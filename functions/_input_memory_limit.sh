#!/usr/bin/env bash

function _input_memory_limit {
  memory_limit_title="USER INPUT"
  memory_limit_msg=""
  total_memory="$(command free --mega | awk 'NR==2{print $2}')"

  while true; do
    memorylimit=$(whiptail --title "$memory_limit_title" --inputbox \
      "\n$memory_limit_msg""How much memory to allocate to the website (in MB)?\
      \n         (Press ENTER to continue)" \
      12 46 \
      "$memorylimit" \
      3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 1 ]; then
      exit 1
    fi
    _set_whiptail_colors_bg_red # Change whiptail bg color to RED
    if [[ ! "$memorylimit" =~ ^[0-9]+$ ]] &> /dev/null; then
      memory_limit_title="ERROR"
      memory_limit_msg="Only integer values are accepted.\n"
      continue
    elif [ "$memorylimit" -ge "$total_memory" ]; then
      memory_limit_title="ERROR"
      memory_limit_msg="Value is Larger than Total RAM ($total_memory""MB).\n"
      continue
    else
      _set_whiptail_colors_default # Restore default colorscheme
      break
    fi
  done
  export memorylimit
}

export -f _input_memory_limit

