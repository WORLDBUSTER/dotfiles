{ colors, ... }:

''
#! /usr/bin/env fish

if pgrep -x swaylock > /dev/null
    echo "swaylock is already running"
    exit
end

# parse args
argparse "n/no-fork" "s/startup" -- $argv; or exit $status

set fork_arg
if set -q $_flag_no_fork
    echo "swaylock won't fork"
    set fork_arg ""
else
    set fork_arg '-f'
end

set background "$HOME/.lock_screen.jpg"

if ! set -q _flag_startup
    pw-play "/usr/share/sounds/musicaflight/stereo/Lock.oga" &
else
    echo "running in startup mode"
end

set background "${colors.palette.background}"
set primary "${colors.base05}c0"
set primary_faded "${colors.base05}80"
set secondary "${colors.palette.primary}80"
set transparent "00000000"
set warning "${colors.palette.warning}"

# take screenshot and blur it
grim $background
convert $background \
    -resize 5% \
    -fill $background \
    -colorize 25% \
    -blur 10x2 \
    -resize 2000% \
    $background

swaylock $fork_arg \
    --image "$background" \
\
    --ignore-empty-password \
    --scaling=fill \
    --disable-caps-lock-text \
    --indicator-caps-lock \
    --color 000000 \
\
    --ring-color=$transparent \
    --ring-wrong-color=${colors.palette.alert}aa \
    --ring-ver-color=$transparent \
    --ring-caps-lock-color=$transparent \
    --ring-clear-color=$warning \
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
    --key-hl-color=$primary_faded \
    --bs-hl-color=$secondary \
    --caps-lock-key-hl-color=$warning \
    --caps-lock-bs-hl-color=$secondary \
    --separator-color=$transparent \
    -n \
\
    --text-color=$primary \
    --text-ver-color=$transparent \
    --text-clear-color=$transparent \
    --text-wrong-color=$transparent \
    --text-caps-lock-color=$warning \
\
    --font "sans Thin" \
    --font-size 128 \

if set -q _flag_startup
    pw-play "$HOME/Music/MuseSounds/stereo/Hello.oga"
end
''
