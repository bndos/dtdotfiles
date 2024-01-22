#!/usr/bin/env bash
if [ -f /tmp/traybar.pid ]; then
  kill -9 $(cat /tmp/traybar.pid)
  rm /tmp/traybar.pid
  bspc config top_padding 53
else
    polybar --reload tray&
    echo $! > /tmp/traybar.pid
fi
