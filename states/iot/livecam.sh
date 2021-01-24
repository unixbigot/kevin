#!/bin/bash
set -x
echo 0 >/sys/class/graphics/fbcon/cursor_blink

DEVICE=${1:-/dev/video0}
FORMAT=${2:-mjpeg}
RESOLUTION=${3:-720}
if [ "$RESOLUTION" = "720" ] ; then
    fbset -g 1280 720 1280 720 16
    VIDEOSIZE=width=1280,height=720,framerate=15/1
elif [ "$RESOLUTION" = "1080" ] ; then
    fbset -g 1920 1080 1920 1080 16
    VIDEOSIZE=width=1920,height=1080,framerate=15/1
fi
if [ "$FORMAT" = "h264" ] ; then
    VIDEOSPEC="video/x-h264,${VIDEOSIZE} ! queue ! h264parse ! omxh264dec"
else
    VIDEOSPEC="image/jpeg,${VIDEOSIZE} ! jpegdec"
fi
exec /usr/bin/gst-launch-1.0 v4l2src ! $VIDEOSPEC ! \
        clockoverlay halignment=right valignment=bottom font-desc="Sans 12" time-format="%A %e %B" ypad=80 ! \
        clockoverlay halignment=right valignment=bottom font-desc="Sans 15" time-format="%I:%M %p" ! \
        videoconvert ! fbdevsink
