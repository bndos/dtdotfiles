
currentlayout=$(xkblayout-state print "%s")

if [ "$currentlayout" == "us" ]
  then
    setxkbmap -layout ca
else
    setxkbmap -layout us
fi


notify-send -t 1000 `xkblayout-state print "%s"`
pkill -SIGRTMIN+11 i3blocks
