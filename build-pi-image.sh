#!/usr/bin/env bash

nix build .#nixosConfigurations.UnknownPi4Img.config.system.build.sdImage

if [ "$#" = 1 ]; then 
    device="$1"
    dir=$(dirname "$0")
    path=$(realpath -e "$dir")
    file=$(ls "$path/result/sd-image")
    sudo dd if="$path/result/sd-image/$file" of="$device" bs=4096 conv=fsync status=progress
    sudo parted "$device" resizepart 2 100%
    if [[ $device == /dev/sd* ]]; then # partitions of /dev/sdx devices are denoted differently to other devices (sd cards, nvme, etc...)
        sudo resize2fs "$device"2
    else
        sudo resize2fs "$device"p2
    fi 
fi 