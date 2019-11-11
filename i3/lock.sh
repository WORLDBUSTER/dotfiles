#!/usr/bin/env bash

paplay "$HOME/Drive/Music/MuseSounds/Lock.ogg"

FORK=''

if [ $# -gt 0 ]; then
    if [ $1 = "--no-fork" ]; then
        echo "i3lock won't fork"
        FORK='-n'
    fi
fi

# suspend notifications
pkill -u "$USER" -USR1 dunst

tmpbg='/tmp/screen.png'

cp $HOME/.config/wpg/wallpapers/$(wpg -c) $tmpbg
/usr/bin/convert "$tmpbg" \
    -resize 1920x1080^ \
    -gravity center \
    -extent 1920x1080 \
    -fill "#0D100B" \
    -colorize 75% \
    "$tmpbg"

primary="fafdffff"
secondary="c1a49be5"

/usr/bin/i3lock $FORK -t -i "$tmpbg" \
    -e \
    --clock \
    --ringcolor=00000000 \
    --ringwrongcolor=ff0000aa \
    --ringvercolor=$secondary \
\
    --radius 32 \
    --ring-width 4 \
\
    --insidecolor=00000000 \
    --insidevercolor=00000000 \
    --insidewrongcolor=00000000 \
\
    --keyhlcolor=$primary \
    --bshlcolor=$secondary \
    --separatorcolor=00000000 \
    --linecolor=00000000 \
\
    --timecolor=$primary \
    --datecolor=$secondary \
    --verifcolor=$secondary \
    --wrongcolor=ff0000aa \
\
    --timestr="%-I:%M %P" \
    --datestr="%A, %B %-d" \
\
    --time-align=1 \
    --date-align=1 \
    --verif-align=1 \
    --wrong-align=1 \
\
    --indpos="256+r:h-256+r" \
    --timepos="256:256" \
    --datepos="tx:ty+64" \
\
    --time-font="Roboto:Thin" \
    --date-font="Roboto" \
    --verif-font="Roboto" \
    --wrong-font="Roboto" \
\
    --timesize=128 \
    --datesize=24 \
    --verifsize=16 \
    --wrongsize=16 \
\
    --veriftext="" \
    --wrongtext="" \
    --noinputtext="" \

# resume notifications
pkill -u "$USER" -USR2 dunst

