{
  description = "Everest CI";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    hydra.url = "github:nixos/hydra";
    #"github:nixos/hydra?rev=222a8047e4d29329d568207469fd8b30581843c0";
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
          ];
        };
      };
    };
}
