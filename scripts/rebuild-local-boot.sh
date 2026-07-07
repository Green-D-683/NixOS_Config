#! /usr/bin/env bash
case "$(uname)" in
    "Darwin")
        nice -n 5 sudo darwin-rebuild boot --flake .#"$DARWIN_SYSTEM_NAME" --option tarball-ttl 0 --show-trace --impure
        ;;
    *)
        nice -n 5 sudo nixos-rebuild boot --flake .#"$NIXOS_SYSTEM_NAME" --option tarball-ttl 0 --show-trace --impure
        ;;
esac
