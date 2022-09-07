#!/bin/sh
NIX_SSHOPTS=-t nixos-rebuild switch --flake .#everest-ci --target-host everest@everest-ci.paris.inria.fr --use-remote-sudo
