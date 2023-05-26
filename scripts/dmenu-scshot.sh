#!/bin/bash

# This script needs maim, xdotool, xclip, rofi to work

# This script will let you choose screenshot option via rofi
# Usage:
# `an area`: screenshot of selected area (left click and drag the mouse)
# `current window`: screenshot of current focus window
# `full screen`: screenshot of full screen
# `an area (copy)`: like `an area` option but the screenshot will be stored in clipboard
# `current window (copy)`: like `current window` option but the screenshot will be stored in clipboard
# `full screen (copy)`: like `full screen` option but the screenshot will be stored in clipboard

l_scrotloc="/tmp/scrotpic"
# This script will save all screenshots into ~/user/pictures/screenshots by default
scrotdir="$HOME/Pictures/screenshots"
[ -d "$scrotdir" ] || mkdir -p "$scrotdir"

declare -a options=("an area"
                    "current window"
                    "full screen"
                    "an area (copy)"
                    "current window (copy)"
                    "full screen (copy)")

sendNotification() {
    ln -sf "$(readlink -f "$_")" "$l_scrotloc"
    notify-send -i "$l_scrotloc" "$1" "$2"
}

anArea() {
    maim -s $scrotdir/scrot-area-"$(date '+%y%m%d-%H%M-%S').png" &&
    sendNotification "Screenshot" "Saved in ~/Pictures/screenshots"
}

currentWindow() {
    maim -i "$(xdotool getactivewindow)" $scrotdir/scrot-window-"$(date '+%y%m%d-%H%M-%S').png" &&
    sendNotification "Screenshot" "Saved in ~/Pictures/screenshots"
}

fullScreen() {
    maim $scrotdir/scrot-full-"$(date '+%y%m%d-%H%M-%S').png" &&
    sendNotification "Screenshot" "Saved in ~/Pictures/screenshots"
}

anAreaCopy() {
    maim -s | xclip -selection clipboard -t image/png
    sendNotification "Screenshot" "Copied to clipboard"
}

currentWindowCopy() {
    maim -i "$(xdotool getactivewindow)" | xclip -selection clipboard -t image/png
    sendNotification "Screenshot" "Copied to clipboard"
}

fullScreenCopy() {
    maim | xclip -selection clipboard -t image/png
    sendNotification "Screenshot" "Copied to clipboard"
}

main() {
    [ "$1" = "--full" ] && fullScreen && exit 0

    case "$(for i in "${options[@]}"; do echo "$i"; done | \
            dmenu -l ${#options[@]} -p "choose a screenshot option:")" in
        "${options[0]}") anArea ;;
        "${options[1]}") currentWindow ;;
        "${options[2]}") fullScreen ;;
        "${options[3]}") anAreaCopy ;;
        "${options[4]}") currentWindowCopy ;;
        "${options[5]}") fullScreenCopy ;;
    esac
}

main "$@"

