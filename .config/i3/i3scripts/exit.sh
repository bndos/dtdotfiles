#!/bin/bash

res=$(echo -e "suspend\nlogout\nreboot\npoweroff" | rofi -dmenu -p ">" )

if [ $res = "suspend" ]; then
    # ~/.config/i3/i3scripts/lock1.sh && systemctl suspend
    systemctl suspend
fi

if [ $res = "logout" ]; then
    rm ~/.config/i3/i3scripts/.night
    rm ~/.config/i3/i3scripts/.toggle
    i3-msg exit
fi
if [ $res = "reboot" ]; then
    rm ~/.config/i3/i3scripts/.night
    rm ~/.config/i3/i3scripts/.toggle
    reboot
fi
if [ $res = "poweroff" ]; then
    rm ~/.config/i3/i3scripts/.night
    rm ~/.config/i3/i3scripts/.toggle
    poweroff
fi
exit 0
