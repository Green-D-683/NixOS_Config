#!/usr/bin/env bash

system="UnknownPi"

printf "\nBuilding configuration for $system as a disk image\n"

nix build .#nixosConfigurations."$system"Img.config.system.build.sdImage

if [ $? -eq 0 ]; then
    printf "\nBuild Succeeded!\n"
    if [ "$#" = 1 ]; then 
        device="$1"
        printf "\nAttempting to write build to $device\n\n"
        dir=$(dirname "$0")
        path=$(realpath -e "$dir")
        file=$(ls "$path/result/sd-image")
        sudo dd if="$path/result/sd-image/$file" of="$device" bs=4096 conv=fsync status=progress
        if [ "$?" = 0 ]; then
            printf "\nBuild written to $device, I hope you specified the correct drive...\n\nAttempting to resize partitions to fill device\n\n"
            sudo parted "$device" resizepart 2 100%
            if [ "$?" = 0 ]; then 
                printf "\nMain Partition resized\nResizing Filesystem to match\n"
                if [[ $device == /dev/sd* ]]; then # partitions of /dev/sdx devices are denoted differently to other devices (sd cards, nvme, etc...)
                    sudo resize2fs "$device"2
                else
                    sudo resize2fs "$device"p2
                fi
                if [ "$?" = 0 ]; then
                    printf "\nFilesystem Resized\nDrive can be removed freely!"
                    exit 0
                else 
                    printf "\nFailed to resize filesystem"
                    exit 4
                fi
            else 
                printf "\nFailed to resize Main Partition"
                exit 3
            fi
        else 
            printf "\nFailed to write build.img to drive"
            exit 2
        fi
    else
        printf "Not writing to drive, drive location not provided: \n\n - Usage: `build-pi-image.sh [drive/path]`"
        exit 0
    fi
else 
    printf "Build failed"
    exit 1
fi 