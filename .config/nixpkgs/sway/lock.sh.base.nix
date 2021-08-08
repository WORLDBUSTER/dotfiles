{ colors, ... }:

''
#!/usr/bin/env bash

fork='-f'
startup=false
background="$HOME/.lock_screen.png"

if pgrep -x swaylock >/dev/null
then
    echo "swaylock is already running"
    exit
else
    # parse args
    while (( "$#" )); do
        case "$1" in
            -n|--no-fork)
                echo "swaylock won't fork"
                fork=""
                shift
                ;;
            -s|--startup)
                fork=""
                startup=true
                shift
                echo
        esac
    done
fi

if [ "$startup" = false ] ; then
    paplay "/usr/share/sounds/musicaflight/stereo/Lock.oga" &
fi

primary="${colors.base05}c0"
primaryFaded="${colors.base05}20"
secondary="${colors.palette.primary}20"
transparent="00000000"
orange="${colors.palette.warning}"

swaylock $fork -i "$background" \
    -e \
    -t \
    --scaling=fill \
    -L \
    -l \
    -c 000000 \
\
    --ring-color=$transparent \
    --ring-wrong-color=${colors.palette.alert}aa \
    --ring-ver-color=$transparent \
    --ring-caps-lock-color=$transparent \
    --ring-clear-color=$orange \
\
    --indicator-radius 128 \
    --indicator-thickness 4 \
\
    --inside-color=$transparent \
    --inside-ver-color=$transparent \
    --inside-wrong-color=$transparent \
    --inside-clear-color=$transparent \
    --inside-caps-lock-color=$transparent \
\
    --key-hl-color=$primaryFaded \
    --bs-hl-color=$secondary \
    --caps-lock-key-hl-color=$orange \
    --caps-lock-bs-hl-color=$secondary \
    --separator-color=$transparent \
    -n \
\
    --text-color=$primary \
    --text-ver-color=$transparent \
    --text-clear-color=$transparent \
    --text-wrong-color=$transparent \
    --text-caps-lock-color=$orange \
\
    --font "sans Thin" \
    --font-size 128 \

if [ "$startup" = true ] ; then
    pw-play "$HOME/Music/MuseSounds/stereo/Hello.oga" &
fi
''
