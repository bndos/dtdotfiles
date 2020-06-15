#!/bin/bash

picom --config ~/.config/picom/picomdwm.conf&
# initscreen.sh
feh --bg-scale ~/Pictures/wallpapers/background.jpg&
nightmode --recover&
flashfocus&
restart-emax&
dunst&
udiskie&
# light -N 5&
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1&
dropbox&

dte(){
    dte="$(date +"%l:%M%p")"
    echo -e "$dte"
}

while true; do
    xsetroot -name "$(dte)"
    sleep 15s
done &
