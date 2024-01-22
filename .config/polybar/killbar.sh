#! /bin/bash

u=$(cat /tmp/traybar.pid)
kill -9 $u
