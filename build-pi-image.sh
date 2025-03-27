#!/usr/bin/env bash

nix build .#nixosConfigurations.UnknownPi4Img.config.system.build.sdImage