#!/usr/bin/env bash

scriptDir=$(dirname "$0")
if [ -f $scriptDir/get-config-root.sh ]; then
    gitDir=$($scriptDir/get-config-root.sh)
else
    gitDir=$(get-config-root)
fi

# Requires Git-Crypt Unlocked
if [ -z "$(git-crypt status | grep '    encrypted:')" ]; then
    sudo mkdir -p /etc/sops

    sudo chown root:root /etc/sops
    sudo chmod 770 /etc/sops

    if [ -f $gitDir/sops/crypt/system-keys/${NIXOS_SYSTEM_NAME}.txt ]; then
        sudo cp $gitDir/sops/crypt/system-keys/${NIXOS_SYSTEM_NAME}-key.txt /etc/sops/system-key.txt
    else
        sudo cp $gitDir/sops/crypt/system-key.txt /etc/sops/system-key.txt
    fi
    sudo chmod -R 770 /etc/sops
else
    echo "Cannot Deploy SOPS Master Key - Git-Crypt is locked" >&2
    exit 1
fi
