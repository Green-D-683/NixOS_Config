#!/usr/bin/env bash

sPad=$(kscreen-doctor -o | grep --before-context=6 "1080x2160@50")
#echo "$sPad"
portPlus=$(echo "$sPad" | grep "Output:")
portPlusSplit=$(echo "$portPlus" | sed "s| |\o12|g")
#echo "$portPlusSplit"
port=$(echo "$portPlusSplit" | sed -n 3p)
#echo "$port"

disabled=$(kscreen-doctor -o | grep --after-context=1 "$port" | sed -n 2p | egrep -o "disabled")
#echo "$disabled"

if [ "${disabled}" = "disabled" ]; then
	disp=$(kscreen-doctor -o | grep --after-context=14 "eDP-1")
	#echo $disp

	geoPlus=$(echo "$disp" | grep "Geometry:" | sed "s| |\o12|g")

	#echo "${geoPlus}"

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

	modeLine=$(kscreen-doctor -o | grep --after-context=6 "$port" | grep "$Modes")
    #echo "$modeLine"
	modeLineCut=$(echo "$modeLine" | grep -oP ".*(?=1080)")
	intSplit=$(echo "$modeLineCut" | grep -oE "[0-9]+")
	mode=$(echo "$intSplit" | head -5 | tail -1)

	#echo "$x2"
	kscreen-doctor output.${port}.enable output.${port}.mode.${mode} output.${port}.rotation.right output.${port}.scale.2 output.${port}.position.${x2},${y2}
else
	kscreen-doctor output.${port}.disable
fi

