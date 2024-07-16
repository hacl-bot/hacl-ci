{ config, lib, ... }:
let
  user = "cachix-watch-store";
in
{
  users.groups.${user} = { };
  users.users.${user} = {
    isSystemUser = true;
    group = user;
  };

  age.secrets.cachix-hacl-token = {
    file = ./secrets/cachix-hacl-token.age;
    owner = user;
    mode = "0440";
  };

  nix.settings = {
    substituters = [ "https://hacl.cachix.org/" ];
    trusted-public-keys = [ "hacl.cachix.org-1:FzsZ2xsByOwKwIWNPII7yMOelJNDZ12mDAj3d1eGX0c=" ];
  };

  services.cachix-watch-store = {
    enable = true;
    cacheName = "hacl";
    cachixTokenFile = config.age.secrets.cachix-hacl-token.path;
  };

  systemd.services.cachix-watch-store-aget.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = user;
    Group = user;
  };
}
