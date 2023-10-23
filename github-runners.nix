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
    url = "https://github.com/inria-prosecco/starmalloc";
    user = "github-runner";
    tokenFile = config.age.secrets.github-runner-starmalloc-ci-token.path;
    nodeRuntimes = ["node16" "node20"];
    extraLabels = ["nix"];
  };

  age.secrets.github-runner-charon-ci-token = {
    file = ./secrets/github-runner-charon-ci-token.age;
    owner = "github-runner";
    mode = "0440";
  };
  services.github-runners."charon-ci" = {
    enable = true;
    url = "https://github.com/aeneasverif/charon";
    user = "github-runner";
    tokenFile = config.age.secrets.github-runner-charon-ci-token.path;
    nodeRuntimes = ["node16" "node20"];
    extraLabels = ["nix"];
  };

  age.secrets.github-runner-aeneas-ci-token = {
    file = ./secrets/github-runner-aeneas-ci-token.age;
    owner = "github-runner";
    mode = "0440";
  };
  services.github-runners."aeneas-ci" = {
    enable = true;
    url = "https://github.com/aeneasverif/aeneas";
    user = "github-runner";
    tokenFile = config.age.secrets.github-runner-aeneas-ci-token.path;
    nodeRuntimes = ["node16" "node20"];
    extraLabels = ["nix"];
  };

  age.secrets.github-runner-mls-star-ci-token = {
    file = ./secrets/github-runner-mls-star-ci-token.age;
    owner = "github-runner";
    mode = "0440";
  };
  services.github-runners."mls-star-ci" = {
    enable = true;
    url = "https://github.com/inria-prosecco/mls-star";
    user = "github-runner";
    tokenFile = config.age.secrets.github-runner-mls-star-ci-token.path;
    nodeRuntimes = ["node16" "node20"];
    extraLabels = ["nix"];
  };

  age.secrets.github-runner-comparse-ci-token = {
    file = ./secrets/github-runner-comparse-ci-token.age;
    owner = "github-runner";
    mode = "0440";
  };
  services.github-runners."comparse-ci" = {
    enable = true;
    url = "https://github.com/twal/comparse";
    user = "github-runner";
    tokenFile = config.age.secrets.github-runner-comparse-ci-token.path;
    nodeRuntimes = ["node16" "node20"];
    extraLabels = ["nix"];
  };

  nixpkgs.config.permittedInsecurePackages = ["nodejs-16.20.2"];
}
