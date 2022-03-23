#!/usr/env/bin fish

# make output folder
set date (date +%Y%m%d-%H%M%S)
set folder $HOME/Videos/Recordings/studio-capture-all-$date/
mkdir -p $folder || exit

function prompt-mic-target -a output_file
    pw-record --list-targets | tail -n +2 | while read line
        string match --regex '\d.*' $line
    end | bemenu -p 'Which is your mic?' | string match --regex '\d*'
end

# prompt for mic target
set mic_target (prompt-mic-target)

# start dslr webcam
gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 2 -f v4l2 /dev/video0 &

# video monitor
ffplay -i /dev/video0 &

# open pipewire graph, just in case
qpwgraph &

# start screen recording
wf-recorder -a"desktop-audio-proxy" -f"$folder/desktop.mp4" &

# camera recording
ffmpeg -i /dev/video0 -vcodec libx264 $folder/webcam.mp4 &

# mic recording
pw-record --target $mic_target $folder/mic.ogg &

wait
