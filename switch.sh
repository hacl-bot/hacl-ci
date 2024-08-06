#!/bin/sh
NIX_SSHOPTS=-t nixos-rebuild switch --flake .#hacl-ci --target-host hacl@128.93.101.164 --use-remote-sudo
