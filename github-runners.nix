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

  age.secrets.github-runner-everest-ci-token = {
    file = ./secrets/github-runner-everest-ci-token.age;
    owner = "github-runner";
    mode = "0440";
  };
  services.github-runners."everest-ci" = {
    enable = true;
    url = "https://github.com/hacl-star";
    user = "github-runner";
    tokenFile = config.age.secrets.github-runner-everest-ci-token.path;
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
