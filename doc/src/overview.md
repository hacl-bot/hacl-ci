# Overview

The main machine used for CI is
[everest-ci.paris.inria.fr](https://everest-ci.paris.inria.fr/).

`everest-ci` runs on NixOS and is home to self-hosted GitHub runners. It is
mainly used by HACL*. To mitigate threats caused by the use of a self-hosted
runner on public repositories, we require approval to run workfows on pull
requests from first time contributors.

[hacl-star](https://github.com/hacl-star/hacl-star) is a Nix flake. It
deliberately does not contain a lock file, so that CI always generates it at
build time and retrieves the most recent versions of F* and Karamel.

[hacl-nix](https://github.com/hacl-star/hacl-nix) on the other hand is a Nix
flake with a lock file, which is updated daily (if hacl builds). It can be used
to retrieve the most recent working set of dependencies for HACL*.

[hacl-ci](https://github.com/hacl-bot/hacl-ci) holds the NixOS configuration
for `everest-ci`, as well as the source code for this documentation. All
modifications to the configuration of the self-hosted runners should be done
through this repository and deployed using the `switch.sh` script.
[agenix](https://github.com/ryantm/agenix) is used to store secrets in the
repository, like tokens or https certificates.
