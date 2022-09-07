{
  description = "Everest CI";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs@{ self, nixpkgs, agenix, }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      availableModules = { inherit (agenix.nixosModules) age; };
    in {
      nixosConfigurations = {
        everest-ci = lib.nixosSystem {
          inherit system;
          modules = (builtins.attrValues availableModules)
            ++ [ ./hardware.nix ./base.nix ./fusion-inventory.nix ./hydra.nix ];
        };
      };
    };
}
