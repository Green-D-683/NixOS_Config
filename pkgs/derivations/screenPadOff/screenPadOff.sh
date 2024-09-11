#!/usr/bin/env bash

sPad=$(kscreen-doctor -o | grep --before-context=5 "1080x2160@50")
#echo "$sPad"
portPlus=$(echo "$sPad" | grep "Output:")
portPlusSplit=$(echo "$portPlus" | sed "s| |\o12|g")
port=$(echo "$portPlusSplit" | sed -n 3p)
#echo "$port"

kscreen-doctor output.${port}.disable