{ owner, repo, prs, refs, hacl-ci, ... }:
(import (hacl-ci + "/hydra-helpers/default.nix")).lib.${builtins.currentSystem}.makeGitHubJobsets
  {inherit owner repo;}
  {inherit prs refs;}
