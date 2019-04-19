

gap_inner=12
gap_outer=0

if [ `i3-msg -t get_tree | grep -Po \
    '.*\\"gaps\\":{\\"inner\\":\K(-|)[0-9]+(?=.*\\"focused\\":true)'` -eq 0 ]; then 
    i3-msg gaps inner current set 0; 
    i3-msg gaps outer current set 0; 
else 
    i3-msg gaps inner current set $gap_inner; 
    i3-msg gaps outer current set $gap_outer; 
fi
