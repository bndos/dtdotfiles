#!/bin/bash

xrdb ~/.Xresources
autorandr --load desktop
xsetroot -cursor_name left_ptr
nitrogen --restore
# picom --config ~/.config/picom/picomdwm.conf&
picom&
dropbox start&
flashfocus&
nightmode --recover&
restart-emax&
dunst&
udiskie&
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1&
dropbox&
pavucontrol&
python -m keyring --disable&
setxkbmap -layout us
xmodmap ~/.Xmodmap
xset s 600
