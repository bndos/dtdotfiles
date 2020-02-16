#!/bin/bash

declare -i count=2
declare -i seconds=1

while ((count)); do
    xrandr >/dev/null
    sleep $seconds
    ((count--))
done

xrandr --output HDMI1 --right-of eDP1 --auto --primary
xrandr --output eDP1 --off
feh --bg-scale ~/Pictures/wallpapers/background.jpg
