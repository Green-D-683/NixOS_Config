#! /usr/bin/env bash
case "$(uname)" in
    "Darwin")
        sudo darwin-rebuild switch --flake .#"$DARWIN_SYSTEM_NAME" --option tarball-ttl 0 --show-trace --impure
        ;;
    *)
        sudo nixos-rebuild switch --flake .#"$NIXOS_SYSTEM_NAME" --option tarball-ttl 0 --show-trace --impure
        ;;
esac
