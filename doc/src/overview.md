# Overview

The main machine used for CI is
[everest-ci.paris.inria.fr](https://everest-ci.paris.inria.fr/).
It is hosted in room C220 at Inria's parisian office.

`everest-ci` runs on NixOS and hosts a self-hosted GitHub runner, which is
connected to the [hacl-star](https://github.com/hacl-star) organization. It is
used by the [hacl-star](https://github.com/hacl-star/hacl-star) and
[hacl-nix](https://github.com/hacl-star/hacl-nix) repositories. To mitigate
threats caused by the use of a self-hosted runner on public repositories, we
require approval to run workfows on pull requests from first time contributors.

[hacl-star](https://github.com/hacl-star/hacl-star) is a Nix flake. It
deliberately does not contain a lock file, so that CI always generates it at
build time and retrieves the most recent version of F* and Karamel.

[hacl-nix](https://github.com/hacl-star/hacl-nix) on the other hand is a Nix
flake with a lock file, which is updated daily (if hacl builds). It can be used
to retrieve the most recent working set of dependencies for Hacl*.

[hacl-ci](https://github.com/hacl-bot/hacl-ci) holds the NixOS configurations
for `everest-ci`, as well as the source code for this documentation. All
modifications to the configuration of the self-hosted runner should be done
through this repository and deployed using the `switch.sh` script.
[agenix](https://github.com/ryantm/agenix) is used to store secrets in the
repository, like tokens or https certificates.
