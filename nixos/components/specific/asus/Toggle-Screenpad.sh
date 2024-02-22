#!/usr/bin/env bash

sPad=$(kscreen-doctor -o | grep "1080x2160@50")
sPadSplit=$(echo $sPad | sed "s| |\o12|g")
portPlus=$(echo "$sPadSplit" | grep --after-context=2 "Output:")
port=$(echo "$portPlus" | sed -n 3p)
#echo "$port"

disabled=$(kscreen-doctor -o | grep "$port" | egrep -o "disabled")
#echo "$disabled"

if [ "${disabled}" = "disabled" ]; then
	disp=$(kscreen-doctor -o | grep "eDP-1")
	#echo $disp
	dispSplit=$(echo $disp | sed "s| |\o12|g")

	#echo "$dispSplit"

	geoPlus=$(echo "$dispSplit" | grep --after-context=1 "Geometry:")

	#echo "${geo}"

	geo=$(echo "$geoPlus" | sed -n 2p)

	#echo $geo

	dims=$(echo "$geo" | sed "s|,|\o12|g")

	#echo $dims

	x=$(echo "$dims" | sed -n 1p| sed 's/\x1b\[[0-9;]*m//g')
	y=$(echo "$dims" | sed -n 2p)

	#echo $x
	#echo $y

	y2=$(python -c "print (""$y""+1080)")
	x2=$(python -c "print (int(int(""$x"")+(1920/2)-(1080/2)))")

	#echo "$x2"
	kscreen-doctor output.${port}.enable output.${port}.mode.0 output.${port}.rotation.right output.${port}.scale.2 output.${port}.position.${x2},${y2}
else
	kscreen-doctor output.${port}.disable
fi

