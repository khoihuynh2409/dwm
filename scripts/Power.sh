#!/bin/bash
function powermenu {
    options="cancel\nshutdown\nreboot\nsuspend\nlock"
    selected=$(echo -e $options | dmenu)
    if [[ $selected = "shutdown" ]]; then
       loginctl poweroff
    elif [[ $selected = "reboot" ]]; then
       loginctl reboot
    elif [[ $selected = "suspend" ]]; then
       loginctl suspend
    elif [[ $selected = "lock" ]]; then
       i3lock
    elif [[ $selected = "cancel" ]]; then
       return
    fi
}

powermenu
