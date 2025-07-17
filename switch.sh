#!/bin/sh
nixos-rebuild switch -v --flake .#hacl-ci --build-host hacl@128.93.101.164 --target-host hacl@128.93.101.164 --sudo
