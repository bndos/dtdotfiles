
#!/bin/sh

B='#27283099'  # blank
C='#3F414F22'  # clear ish
D='#1C211F55'  # default
T='#ffffffff'  # text
W='#880000bb'  # wrong
V='#1C211FBB'  # verifying

i3lock \
    --insidevercolor=$C   \
    --ringvercolor=#ffffffff\
    \
    --insidewrongcolor=$C \
    --ringwrongcolor=$W   \
    \
    --insidecolor=#00000000     \
    --ringcolor=#ffffff11\
    --linecolor=#ffffff77        \
    --separatorcolor=#ffffffff\
    \
    --verifcolor=$T        \
    --wrongcolor=$T        \
    --timecolor=$T        \
    --datecolor=$T        \
    --layoutcolor=#ffffffff\
    --keyhlcolor=#ffffffee \
    --bshlcolor=#ffffffee   \
    \
    --screen 1            \
    --clock               \
    --indicator           \
    --timestr="%H:%M"  \
    --datestr="%A, %m %Y" \
    --veriftext="..." \
    --wrongtext="" \
    --timepos="x+685:y+300" \
    --indpos="x+685:y+400" \
    --radius=30 \
    -c 000000 \
    # -i ~/Pictures/tex.png \

    #--blur 5              \
	#--keylayout 2         \
	# --textsize=20
    # --modsize=10
    # --timefont=comic-sans
    # --datefont=monofur
    # etc
    
