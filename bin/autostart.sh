#!/bin/bash

xrdb ~/.Xresources&
autorandr --load desktop
xsetroot -cursor_name left_ptr&
# picom --config ~/.config/picom/picomdwm.conf&
picom&
dropbox start&
flashfocus&
nitrogen --restore&
nightmode --recover&
restart-emax&
dunst&
udiskie&
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1&
dropbox&
pavucontrol&
setxkbmap -layout us
