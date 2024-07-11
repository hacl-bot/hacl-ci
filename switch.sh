#!/bin/sh
NIX_SSHOPTS=-t nixos-rebuild switch --flake .#everest-ci --target-host everest@128.93.101.164 --use-remote-sudo
