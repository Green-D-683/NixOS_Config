#!/usr/bin/env sh

nix-collect-garbage -d
sudo nix-collect-garbage -d
sudo /run/current-system/bin/switch-to-configuration boot