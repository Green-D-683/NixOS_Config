#! /usr/bin/env bash

sudo nixos-rebuild switch --flake .#"$NIXOS_SYSTEM_NAME" --option tarball-ttl 0 --show-trace --impure
