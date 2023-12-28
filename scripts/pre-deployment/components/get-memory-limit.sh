#!/usr/bin/env bash

memory_limit_title="User Input"
memory_limit_msg=""
total_memory="$(command free --mega | awk 'NR==2{print $2}')"

while true; do
  memorylimit=$(whiptail --title "$memory_limit_title" --inputbox "\n$memory_limit_msg""How much memory to allocate to the website (in MB)? " 11 46 "$memorylimit" 3>&1 1>&2 2>&3) 
  if [ "$memorylimit" -ne "$memorylimit" ] &> /dev/null; then
    memory_limit_title="ERROR"
    memory_limit_msg="Only integer values are accepted.\n"
    continue
  elif [ "$memorylimit" -ge "$total_memory" ]; then
    memory_limit_title="ERROR"
    memory_limit_msg="Value is Larger than Total RAM ($total_memory""MB).\n"
    continue
  else
    break
  fi
done

export memorylimit

