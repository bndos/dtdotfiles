#!/bin/bash

xrdb ~/.Xresources
autorandr --load desktop
xsetroot -cursor_name left_ptr
nitrogen --restore
xset -dpms
xset s off
# picom --config ~/.config/picom/picomdwm.conf&
picom&
xscreensaver -no-splash&
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
# xset s 600
