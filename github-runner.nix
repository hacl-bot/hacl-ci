{ config, lib, pkgs, ... }:

{
  age.secrets.github-runner-token = {
    file = ./secrets/github-runner-token.age;
    owner = config.services.github-runner.user;
    mode = "0440";
  };

  users.groups."github-runner" = { };
  users.users."github-runner" = {
    isSystemUser = true;
    group = "github-runner";
  };

  services.github-runner = {
    enable = true;
    url = "https://github.com/hacl-star";
    user = "github-runner";
    tokenFile = config.age.secrets.github-runner-token.path;
    nodeRuntimes = [ "node16" "node20" ];
  };

  nixpkgs.config.permittedInsecurePackages = [ "nodejs-16.20.2" ];
}
