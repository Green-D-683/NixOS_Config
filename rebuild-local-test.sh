#! /usr/bin/env bash

sudo nixos-rebuild test --flake .#UnknownDevice_ux535 --option tarball-ttl 0 --show-trace --impure