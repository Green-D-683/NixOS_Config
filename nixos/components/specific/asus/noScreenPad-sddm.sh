#!/usr/bin/env sh

sPad=$(xrandr | grep "60mm x 130mm")
sPadSplit=$(echo $sPad | sed "s| |\o12|g")
port=$(echo "$sPadSplit" | grep --after-context=0 "HDMI")
echo $port /home/daniel/test.txt
xrandr --output "$port" --off