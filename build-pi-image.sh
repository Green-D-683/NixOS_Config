#!/usr/bin/env bash

nix build .#nixosConfigurations.UnknownPi4Img.config.system.build.sdImage

if [ "$#" = 1 ]; then 
    device="$1"
    dir=$(dirname "$0")
    path=$(realpath -e "$dir")
    file=$(ls "$path/result/sd-image")
    dd if="$path/result/sd-image/$file" of="$device" bs=4096 conv=fsnc status=progress
    sudo parted "$device" resizepart 2 100%
    sudo resize2fs "$device"2
fi 