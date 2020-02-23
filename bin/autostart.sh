#!/bin/bash

initscreen.sh&
dunst&
dropbox&
nightmode --recover&
flashfocus&
restart-emax&
picom&
udiskie&
light -N 5&
/usr/lib/polkit-kde-authentication-agent-1&

dte(){
    dte="$(date +"%l:%M%p")"
    echo -e "$dte"
}

while true; do
    xsetroot -name "$(dte) $(battery)"
    sleep 15s
done &
