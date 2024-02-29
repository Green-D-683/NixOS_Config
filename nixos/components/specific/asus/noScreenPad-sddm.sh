#!/usr/bin/env sh

sPad=$(wlr-randr | grep "60mm x 130mm")
sPadSplit=$(echo $sPad | sed "s| |\o12|g")
port=$(echo "$sPadSplit" | grep --after-context=0 "HDMI")
echo $port /home/daniel/test.txt
wlr-randr --output "$port" --off