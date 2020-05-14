#!/bin/bash

feh --bg-scale ~/Pictures/wallpapers/background.jpg

declare -i count=2
declare -i seconds=1

while ((count)); do
    xrandr >/dev/null
    sleep $seconds
    ((count--))
done

xrandr --output HDMI-1 --right-of eDP-1 --auto --primary
feh --bg-scale ~/Pictures/wallpapers/background.jpg
