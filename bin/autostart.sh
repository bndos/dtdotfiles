#!/bin/bash

# initscreen.sh&
feh --bg-scale ~/Pictures/wallpapers/background.jpg&
nightmode --recover&
flashfocus&
restart-emax&
picom&
udiskie&
light -N 5&
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1&
dropbox&
qutebrowser --target window moodle.polymtl.ca/login&
qutebrowser --target window https://www.imp.polymtl.ca/login.php&
ao&
google-calendar&

dte(){
    dte="$(date +"%l:%M%p")"
    echo -e "$dte"
}

while true; do
    xsetroot -name "$(dte) $(battery)"
    sleep 15s
done &
