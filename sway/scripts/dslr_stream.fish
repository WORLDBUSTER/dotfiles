#!/usr/bin/env sh
gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 2 -f v4l2 /dev/video0
