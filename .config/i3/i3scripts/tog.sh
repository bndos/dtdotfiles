#!/bin/sh

TOGGLE=~/.config/i3/i3scripts/.toggle

if [ ! -e $TOGGLE ]; then
    touch $TOGGLE
    redshift -PO 3000
else
    rm $TOGGLE
    redshift -x
fi
