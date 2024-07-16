{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.nginx.virtualHosts."everest-ci.paris.inria.fr".root = pkgs.callPackage ./doc { };
}
