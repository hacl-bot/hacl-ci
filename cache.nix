{ config, ... }:
{
  age.secrets."cache-priv-key.pem" = {
    file = ./secrets/cache-priv-key.age;
  };
  services.nix-serve = {
    enable = true;
    secretKeyFile = config.age.secrets."cache-priv-key.pem".path;
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "everest-ci.paris.inria.fr" = {
        locations."/cache/".extraConfig = ''
          proxy_pass http://localhost:${toString config.services.nix-serve.port}/;
        '';
      };
    };
  };
}
