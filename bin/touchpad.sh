#!/bin/bash

idd=$(xinput --list | grep 'Elan Touchpad' | awk '{print $5}'| cut -d'=' -f2)

xinput --set-prop $idd "libinput Tapping Enabled" 1
