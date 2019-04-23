
scrot -d 2 ~/Pictures/screenshots/screenshot`ls ~/Pictures/screenshots/screenshot* | wc -l`_%y-%m-%d_%Hh%M.png

notify-send -t 1000 "screenshot"
