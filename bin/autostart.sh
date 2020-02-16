#!/bin/bash

initscreen.sh
feh --bg-scale ~/Pictures/wallpapers/background.jpg&
flashfocus&
restart-emax&
picom&
udiskie &
light -N 5 &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

dte(){
    dte="$(date +"%l:%M%p")"
    echo -e "$dte"
}

while true; do
    xsetroot -name "$(dte) $(battery)"
    sleep 15s
done &
