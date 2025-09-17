#!/usr/bin/env bash

Help()
{
    printf "Build a disk image of a nixos system, and optionally write this disk image to a storage device\n\n"
    printf "Syntax: $0 [-h|s|d]\n"
    echo "-h  Print this help message"
    echo "-s  The system configuration to build, e.g \`UnknownPi4\`"
    echo "-d  The storage device to write the built disk image to, e.g \`/dev/sda\`"
    printf "\nExample:\n$0 -s UnknownPi4 -d /dev/sdb\n"
}

while getopts s:d:h OPTION
do
  case $OPTION in
    s)
        sflag=1
        system="$OPTARG"
        ;;
    d)
        dflag=1
        device="$OPTARG"
        ;;
    h)
        Help
        exit 0
        ;;
    :)
        echo "Option -{$OPTARG} requires an argument."
        exit 1
        ;;
    \?)
        # Invalid Options - wildcard catch
        echo "Error: Invalid option: $option"
        exit 1
        ;;
  esac
done

# system="UnknownPi4"

if [ $sflag ]; then
    printf "\nBuilding configuration for $system as a disk image\n\n"

    nix build .#nixosImages."$system"

    if [ $? = 0 ]; then
        printf "\nBuild Succeeded!\n"
    else
        printf "\nBuild failed\n"
        exit 2
    fi

    if [ $dflag ]; then
        printf "\nAttempting to write build to $device\n\n"
        dir=$(dirname "$0")
        path=$(realpath -e "$dir")
        file=$(ls "$path/result/sd-image")
        sudo dd if="$path/result/sd-image/$file" of="$device" bs=4096 conv=fsync status=progress
        if [ $? = 0 ]; then
            printf "\nBuild written to $device, I hope you specified the correct drive...\n\nAttempting to resize partitions to fill device\n\n"
        else
            printf "\nFailed to write build.img to drive"
            exit 3
        fi

        sudo parted "$device" resizepart 2 100%
        if [ $? = 0 ]; then
            printf "Main Partition resized\nResizing Filesystem to match\n\n"
        else
            printf "\nFailed to resize Main Partition"
            exit 4
        fi

        if [[ $device == /dev/sd* ]]; then # partitions of /dev/sdx devices are denoted differently to other devices (sd cards, nvme, etc...)
            sudo resize2fs "$device"2
        else
            sudo resize2fs "$device"p2
        fi

        if [ $? = 0 ]; then
            printf "Filesystem Resized\nDrive can be removed freely!\n"
            exit 0
        else
            printf "Failed to resize filesystem\n"
            exit 5
        fi


    else
        printf "\nNot writing to drive, drive location not provided: \n - for usage, see `$0 -h`\n"
        exit 0
    fi

else
    printf "\nSystem Configuration to build not provided, see `$0 -h` for usage\n"
fi
