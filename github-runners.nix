{
  config,
  lib,
  pkgs,
  ...
}: {
  users.groups."github-runner" = {};
  users.users."github-runner" = {
    isSystemUser = true;
    group = "github-runner";
  };

  age.secrets.github-runner-hacl-ci-token = {
    file = ./secrets/github-runner-hacl-ci-token.age;
    owner = "github-runner";
    mode = "0440";
  };
  services.github-runners."hacl-ci" = {
    enable = true;
    url = "https://github.com/hacl-star/hacl-star";
    user = "github-runner";
    tokenFile = config.age.secrets.github-runner-hacl-ci-token.path;
    nodeRuntimes = ["node16" "node20"];
    extraLabels = ["nix"];
  };

  age.secrets.github-runner-hacl-nix-ci-token = {
    file = ./secrets/github-runner-hacl-nix-ci-token.age;
    owner = "github-runner";
    mode = "0440";
  };
  services.github-runners."hacl-nix-ci" = {
    enable = true;
    url = "https://github.com/hacl-star/hacl-nix";
    user = "github-runner";
    tokenFile = config.age.secrets.github-runner-hacl-nix-ci-token.path;
    nodeRuntimes = ["node16" "node20"];
    extraLabels = ["nix"];
  };

  age.secrets.github-runner-starmalloc-ci-token = {
    file = ./secrets/github-runner-starmalloc-ci-token.age;
    owner = "github-runner";
    mode = "0440";
  };
  services.github-runners."starmalloc-ci" = {
    enable = true;
    url = "https://github.com/cmovcc/starmalloc";
    user = "github-runner";
    tokenFile = config.age.secrets.github-runner-starmalloc-ci-token.path;
    nodeRuntimes = ["node16" "node20"];
    extraLabels = ["nix"];
  };

  nixpkgs.config.permittedInsecurePackages = ["nodejs-16.20.2"];
}
