#! /usr/bin/env bash

nixos-rebuild --install-bootloader boot --flake .#"$NIXOS_SYSTEM_NAME" --option tarball-ttl 0 --show-trace --impure

# See https://www.adyxax.org/blog/2023/11/13/recovering-a-nixos-installation-from-a-linux-rescue-image/ for how to chroot into a nix system, if you can chroot in, get to this repo and run this script, you should be able to repair a corrupted bootloader...