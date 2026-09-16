#!/usr/bin/env bash

SOPS_AGE_KEY_FILE=~/.config/sops/age/NixOS_Config.txt sops $@
