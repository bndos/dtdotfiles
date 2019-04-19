TOGGLE=~/.config/i3/i3scripts/.night;

date '+%H:%M ';
var=`date "+%H"`;
minutes=`date "+%M"`
if [ $var -gt 16 ] && [ ! -e $TOGGLE ]; then
        touch $TOGGLE;
	redshift -PO 3500;
elif [ $var -gt 6 ] && [ $var -lt 16 ] && [ -e $TOGGLE ]; then
     rm $TOGGLE;
     redshift -x;

fi

# hoursleft=$((22-$var-1))
# minutesleft=$((60-$minutes))
case $BLOCK_BUTTON in
  1) notify-send -t 5000 "`date "+%Y/%m/%d%n%A %d %B"`";;
esac

