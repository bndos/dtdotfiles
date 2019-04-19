#!/bin/sh
path=$(xdotool getactivewindow getwindowname | awk -F':' '{print $2}')
terminator -e "cd $path;zsh"

