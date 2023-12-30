#!/usr/bin/env bash

function _input_memory_limit {
  if command -v whiptail > /dev/null; then
    memory_limit_title="USER INPUT"
    memory_limit_msg=""
    total_memory="$(command free --mega | awk 'NR==2{print $2}')"

    while true; do
      memorylimit=$(whiptail --title "$memory_limit_title" --inputbox \
        "\n$memory_limit_msg""How much memory to allocate to the website (in MB)?" \
        11 46 \
        "$memorylimit" \
        3>&1 1>&2 2>&3)
      _set_whiptail_colors_red_bg # Change whiptail bg color to RED
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
  else
    memory_limit_title=""
    memory_limit_msg=""
    total_memory="$(command free --mega | awk 'NR==2{print $2}')"
    while true; do # This while loop enables checking if memory limit entered valid
      printf "$memory_limit_title\n$memory_limit_msg""How much memory to allocate to the website? (in MB): "
      read -r memorylimit
      if [ "$memorylimit" -ne "$memorylimit" ] &> /dev/null; then
        memory_limit_title='\nERROR!! '
        memory_limit_msg="Only integer values are accepted.\n"
        continue
      elif [ "$memorylimit" -ge "$total_memory" ]; then
        memory_limit_title='\nERROR!! '
        memory_limit_msg="Value is Larger than Total RAM ($total_memory""MB).\n"
        continue
      else
        break
      fi
    done
  fi
  export memorylimit
}

export -f _input_memory_limit

