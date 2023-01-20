{
  description = "Everest CI";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    hydra.url = "github:nixos/hydra";
  };

  outputs = inputs@{ self, nixpkgs, agenix, hydra, }:
    let system = "x86_64-linux";
    in {
      nixosConfigurations = {
        everest-ci = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            { nixpkgs.overlays = [ hydra.overlays.default ]; }
            agenix.nixosModules.age
            ./base.nix
            ./hardware.nix
            ./fusion-inventory.nix
            ./declarative-hydra.nix
            ./hydra.nix
            ./catala.nix
            #./cache.nix
          ];
        };
      };
    };
}
